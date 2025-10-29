import { LightningElement, track, api, wire } from "lwc";
import fetch from "@salesforce/apex/RetailRTService.fetch";
import lookupObjectValues from "@salesforce/apex/RetailRTDBService.lookupObjectValues";
const findValueByKey = (obj, targetKey) => {
    const search = (currentObj) => {
      let values = [];
      if (currentObj && typeof currentObj === 'object') {
        for (const [key, value] of Object.entries(currentObj)) {
          if (key === targetKey) {
            values = values.concat(value);
          }
          const result = search(value);
          if (result.length > 0) {
            values = values.concat(result);
          }
        }
      }
      return values;
    };
    return search(obj);
  };

export default class RealTimeRetailActivity extends LightningElement {

    @api recordId; 
    @track data;
    @track error;
    @track res;
    @track err;
    @track isLookupProcessingCompleted = false;
   
    @api widgetTitle = "Real Time Vehicle Activity";
    @api personalizationPoint = undefined;
    @api graph = "Web_Engagement_RT_Profile";
    @api space = "default";
    @api lookup = "UnifiedLinkssotIndividualReal__dlm";
    @api dmoConfigString = "";
    @api lookupEntry = undefined;
    @api lookupValueField = undefined;
   
    dmoData = new Map();
   
    connectedCallback() {
      console.log('Record ID:', this.recordId);
      this.parseDmoConfigString();
      this.handleRefreshClick();
    }
   
    parseDmoConfigString() {
      console.log('## dmoConfigString = '+this.dmoConfigString);
      if (!this.dmoConfigString) return;
      if (this.dmoConfigString.endsWith(';')) {
        this.dmoConfigString = this.dmoConfigString.slice(0, -1);
      }
      console.log('## dmoConfigString 1 = '+this.dmoConfigString);
      const configs = this.dmoConfigString.split(';');
      console.log('## configs = '+configs);
      this.dmoConfigs = configs.map(config => {
        const parts = config.split(',').map(part => part.trim());
        const dmoConfig = {};
        parts.forEach(part => {
          const [key, value] = part.split('=').map(p => p.trim());
          if (key === 'field') {
            if (!dmoConfig.fields) {
              dmoConfig.fields = [];
            }
            dmoConfig.fields.push(value);
          } else {
            dmoConfig[key] = value;
          }
        });
        return dmoConfig;
      });
      console.log('## parseDmoConfigString this.dmoConfigs = '+this.dmoConfigs);
      console.log('## parseDmoConfigString this.dmoConfigs stringify = '+JSON.stringify(this.dmoConfigs));
    }
   
    processData(dataBlock) {
      const parsedResponse = JSON.parse(dataBlock);
   
      let jsonBlob = parsedResponse && parsedResponse.data;
      let largestJsonBlob = "";
   
      if (!parsedResponse || !parsedResponse.data) {
        console.log("No data was returned for the target profile, but no error occurred on the call.");
        this.data = undefined;
        return;
      }
   
      let allLengths = [];
      let longestBlobIndex = 0;
      for (let blobCounter = 0; blobCounter < jsonBlob.length; blobCounter++) {
        if (jsonBlob[blobCounter].json_blob__c) {
          allLengths.push(jsonBlob[blobCounter].json_blob__c.length)
          if (jsonBlob[blobCounter].json_blob__c.length > jsonBlob[longestBlobIndex].json_blob__c) {
            longestBlobIndex = blobCounter;
          }
        }
        else {
          allLengths.push(0);
        }
      }
   
      if (allLengths.length === 0) {
        console.log("No entries exist within the resultant data block; no data to display.");
        return;
      }
   
      console.log("Longest profile document found at index " + longestBlobIndex + ".  All lengths (" + allLengths.length + "): " + allLengths.join(', '));
      largestJsonBlob = jsonBlob[longestBlobIndex].json_blob__c;
   
      // Reassign the largest json blob back to jsonBlob variable
      jsonBlob = largestJsonBlob;
   
      // Decode the HTML entities in the json_blob__c field
      const decodedJsonBlob = (jsonBlob || "").replace(/&quot;/g, '"');
      console.log("Realtime Profile Selected:\n" + decodedJsonBlob);
   
      // Parse the decoded JSON blob to a JavaScript object
      const jsonBlobObject = decodedJsonBlob && JSON.parse(decodedJsonBlob);
   
      this.data = jsonBlobObject;
      console.log('## this.data = '+this.data);
      console.log('## this.data stringify = '+JSON.stringify(this.data));
   
      this.filterDmoData();
      this.processLookupsInCurrentDmoData();
      this.error = undefined;
    }
   
    handleRefreshClick() {
      //this.parseDmoConfigString();
      this.dmoConfigString = "";
      this.dmoData = new Map();
      const uniqueParam = new Date().getTime();
      console.log('## uniqueParam = '+uniqueParam);
   
      fetch({ recordId: this.recordId, dataGraphName: this.graph})
        .then(result => this.processData(result));
    }
   
    // CHANGED: fixed accumulation (no Array.push() return)
    filterDmoData() {
      if (!this.dmoConfigs) {
        return;
      }
      this.dmoConfigs.forEach(config => {
        const dmoName = config.dmo;
        console.log('## dmoName = '+dmoName);
        console.log('## this.dmoData = '+this.dmoData);
        const found = findValueByKey(this.data, dmoName) || [];
        if (this.dmoData.has(dmoName)) {
          const existing = this.dmoData.get(dmoName) || [];
          this.dmoData.set(dmoName, [...existing, ...found]);
        } else {
          this.dmoData.set(dmoName, found);
        }
      });
      console.log('## this.dmoConfigs = '+this.dmoConfigs);
      console.log('## this.dmoConfigs stringify = '+JSON.stringify(this.dmoConfigs));
    }
   
    processLookupsInCurrentDmoData() {
      console.log('## Coming insdie processLookupsInCurrentDmoData');
      console.log('## this.lookupEntry = '+this.lookupEntry);
      console.log('## this.dmoConfigs = '+this.dmoConfigs);
      if (!this.lookupEntry || !this.dmoConfigs) {
        this.isLookupProcessingCompleted = true;
        return;
      }
      console.log('## this.isLookupProcessingCompleted = '+this.isLookupProcessingCompleted);
      let dmosWithLookups = [];
      this.dmoConfigs.forEach((configData) => {
        if (configData["lookupEntryFlag"]) {
          dmosWithLookups.push(configData.dmo);
        }
      });
      console.log('## dmosWithLookups = '+dmosWithLookups);
      if (!dmosWithLookups || dmosWithLookups.length === 0) {
        this.isLookupProcessingCompleted = true;
        return;
      }
   
      let lookupEntrySplit = this.lookupEntry.split(',');
      console.log('## lookupEntrySplit = '+this.lookupEntrySplit);
      console.log('## lookupEntrySplit stringify = '+JSON.stringify(this.lookupEntrySplit));
      let objectToFetch = lookupEntrySplit[0].trim();
      let fieldToFetch = lookupEntrySplit[1].trim();
      let fieldToReplace = lookupEntrySplit[2].trim();
   
      let valuesToLookupSet = new Set();
      dmosWithLookups.forEach((currentDmoName) => {
        let valuesArray = this.dmoData.get(currentDmoName);
        for (const currentDmoRow of valuesArray) {
          if (currentDmoRow[fieldToReplace]) {
            let itemToAdd = currentDmoRow[fieldToReplace]
            valuesToLookupSet.add(itemToAdd);
          }
        }
      });
      console.log('## valuesToLookupSet = '+valuesToLookupSet);
      let valuesToLookupArray = Array.from(valuesToLookupSet);
   
      try {
        console.log("Attempting to look up the following identifier values (" + valuesToLookupArray.length + "): " + valuesToLookupArray.join(','));
        lookupObjectValues({ objectName: objectToFetch, fieldName: fieldToFetch, objectIds: valuesToLookupArray }).then((lookupResults) => {
          console.log('## dmosWithLookups = '+dmosWithLookups);
          console.log('## lookupResults = '+lookupResults);
          console.log('## this.dmoData = '+JSON.stringify(this.dmoData));
          dmosWithLookups.forEach((currentDmoName) => {
            let valuesArray = this.dmoData.get(currentDmoName);
            console.log('## valuesArray = '+JSON.stringify(valuesArray));
            for (const currentDmoRow of valuesArray) {
              if (currentDmoRow[fieldToReplace]) {
                let valueToBeReplaced = currentDmoRow[fieldToReplace];
                let replacementValue = lookupResults[valueToBeReplaced];
                if (replacementValue) {
                  currentDmoRow[fieldToReplace] = replacementValue;
                }
              }
            }
          });
          this.isLookupProcessingCompleted = true;
        });
      }
      catch (error) {
        console.log("Processing lookups failed! " + error);
      }
    }
   
    getTimestamp(item, dateField) {
      if (!item[dateField]) return "";
      const date = item[dateField];
      const now = new Date();
      const timeDiff = Math.floor((now - new Date(date)) / 1000);
      if (timeDiff < 60) {
        return `${timeDiff} second(s) ago`;
      } else if (timeDiff < 3600) {
        return `${Math.floor(timeDiff / 60)} minute(s) ago`;
      } else if (timeDiff < 86400) {
        return `${Math.floor(timeDiff / 3600)} hour(s) ago`;
      } else {
        return `${Math.floor(timeDiff / 86400)} day(s) ago`;
      }
    }
   
    get transformedData() {
      console.log('## Coming inside transformedData');
      if (!this.data || !this.dmoConfigs || !this.isLookupProcessingCompleted) {
        return [];
      }
      let combinedData = [];
      this.dmoConfigs.forEach(config => {
        const dmoName = config.dmo;
        if (dmoName && this.dmoData.has(dmoName)) {
          const data = this.dmoData.get(dmoName);
          if (data && data.length > 0) {
            combinedData = combinedData.concat(data.map(item => ({
              ...item,
              dmoName: dmoName
            })));
          }
        }
      });
      let key = 0;
      const transformedData = combinedData.map(item => {
        console.log('items',JSON.parse(JSON.stringify(item)))
        const config = this.dmoConfigs.find(conf => item.dmoName === conf.dmo);
        const fields = config.fields || [];
        const timestampField = config.timestamp;
        const icon = config.icon || "";
        const transformedItem = {
          key: key++,
          dmoName: item.dmoName,
          icon: icon,
          timestamp: timestampField ? this.getTimestamp(item, timestampField) : "",
          timestampFieldValue: item[timestampField],
          productId:item.ssot__ProductId__c
        };
        fields.forEach((field, index) => {
          transformedItem[`field${index + 1}`] = item[field] || "";
        });
        return transformedItem;
      });

      // CHANGED: Dedupe — keep only one entry per product or per (icon+name) visual row
      const pickKey = (row) => {
        // Prefer ProductId; fallback to icon+field1 (name) so same icon+name is unique on UI
        if (row.productId) return `PID:${row.productId}`;
        const name = row.field1 || ""; // field1 is usually the "name"/primary label in your template
        return `ICONNAME:${row.icon}::${name}`;
      };

      const latestByKey = new Map();
      for (const row of transformedData) {
        const k = pickKey(row);
        const existing = latestByKey.get(k);
        if (!existing || new Date(row.timestampFieldValue) > new Date(existing.timestampFieldValue)) {
          latestByKey.set(k, row);
        }
      }

      const newTransformedData = Array.from(latestByKey.values())
        .sort((a, b) => new Date(b.timestampFieldValue) - new Date(a.timestampFieldValue))
        .slice(0, 100);

      console.log('## newTransformedData = '+newTransformedData);
      console.log('## newTransformedData stringify = '+JSON.stringify(newTransformedData));
      return newTransformedData;
    }
}