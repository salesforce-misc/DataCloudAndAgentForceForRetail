**Outfitters**</br> 
=======================
Welcome to Outfitters, a sample retail application. Outfitters is a fictional resort that uses Agentforce, the power of Data Cloud, and the Salesforce Platform to deliver highly personalized guest experiences. Explore ways to bring agents into business workflows, including new smart automation capabilities, Search Property, content generation.

Did you watch the demo? The following are a set of instructions to setup the end to end demo in your own environment. While the end to end demo supports multiple clouds, you have full flexibility to use only the portions relevant to what you want to try out in your own org, additionally once the packages are installed you have the ability to fully customize it based on your needs. 

The Outfitters app showcases how with **Data Cloud** we have a true Customer 360 that then drives the right and best experience with Agentforce **Agents**.

<details><summary>

  ## 1. Pre-Deployment Instructions 
</summary>

 4 step process
### 1. Salesforce Org Setup Requirements for Retail App
 **Option 1:** To support the Retail app, you can either create a new Salesforce Org or use an existing one, provided it includes the following features and licenses: 

  | Requirement | Details |
  | ----- | ----- |
  | Licenses Required | - Data Cloud</br>- Sales Cloud</br>- Service Cloud</br>- Experience</br>- Commerce Cloud</br>- Personalization</br>- Marketing Cloud</br>- MuleSoft (Optional)
  | Features Required | - Service Agent</br>- Einstein Agent</br>- Copilot</br>- Prompt Builder</br>- Agent Force</br>- Real-time(Additional SKU)</br>- Code Builder (Optional) 
  
  Our package is designed to support all these clouds, but you have full flexibility to use only the portions relevant to your business. If you are not using a particular cloud (e.g., Loyalty 
  Cloud), you can simply skip its configuration—the package will still install successfully, but that feature will not be available until you configure it yourself. Additionally, you can customize 
  and enhance the existing package by adding your own features as needed. <br/>
  
 ⚠️ **Important Note:** Existing Trailheads playgrounds cannot be used

   **Option 2:** To ensure a seamless integration and unlock a 360-degree view of customer interactions, we recommend enabling Salesforce Foundations in your org. This free enhancement integrates Sales, Service, Marketing, Commerce, and Data Cloud functionalities, improving efficiency and AI-readiness.

**How to Enable Salesforce Foundations:**
- Log in to your Salesforce instance.
- Navigate to Setup → Search for Salesforce Foundations.
- Click "Add to My Contract" (It's free).
- Select the Foundations products and proceed with checkout.
- Return to Setup and follow the on-screen instructions to complete the configuration.<br/>
🔗 More details: [Salesforce Foundations](https://www.salesforce.com/crm/foundations)

**External Connections:** The app showcases the use of structured and unstructured data ingested from AWS and the use of zero-copy with Snowflake. This section talks about the connectivtity you would need for those use cases.
| **Connection** | **Details** |
|----------------|-------------|
| **Amazon S3** $${\color{blue} Optional}$$ <br> Used to bring in structured and unstructured data. Unstructured data powers Agent conversations in this setup. | **NOTE:** If you do not have an existing Amazon S3 instance, [register for the free tier](https://aws.amazon.com/free/) and follow [this guide](https://developer.salesforce.com/blogs/2023/10/how-to-use-the-amazon-s3-storage-connector-in-data-cloud) to create a dedicated user with required permissions. <br><br>Already have an S3 instance? No need to sign up again. <br><br>Before proceeding, note your [programmatic credentials](https://docs.aws.amazon.com/IAM/latest/UserGuide/security-creds.html#access-keys-and-secret-access-keys) (Access Key ID and Secret Access Key). |
| **Snowflake** $${\color{blue}Optional}$$ <br> Used to showcase Data Cloud’s Zero Copy capabilities. | **NOTE:** If you do not have access to a Snowflake instance, follow [this article](https://developer.salesforce.com/blogs/2024/08/zero-copy-data-federation-with-snowflake-and-salesforce-data-cloud) to create a Warehouse, Integration User, and configure and note public/private keys that you will use with Salesforce Data Cloud.<br><br> |


### 2. Enable Features on the Org (20 minutes)

  | Step | Action and Details | Images |
  | ----- | ----- | ----- |
  | Enable Commerce Cloud | - From Setup, enter ‘Commerce’ in the Quick Find box.</br>- Select ‘Settings’ under ‘Commerce’.</br>- Turn on ‘Enable Commerce’. |![image](https://github.com/user-attachments/assets/2175d205-8c62-423f-9fc1-678d77e974d2)|
  | Enable Promotion Attribute |-Go to Setup</br>-Search Global Promotion Management Setting</br>-Enable the "Global Promotions Management"</br>-Enable the "Product Catalog Management"|  |
  | Create a Basic Experience Builder Site | - From Setup, enter ‘Digital Experiences’ in the Quick Find box.</br>- Select ‘All Sites’ under ‘Digital Experiences’.</br>- Click New to open the Creation wizard with template options.</br>- Select the ‘D2C Commerce (LWR)’ template.</br>- Click Get Started. |![image](https://github.com/user-attachments/assets/6c89e37f-d61c-4333-8587-58a53504fbb7)|
  | Site Name and URL | - After selecting the template, enter a site name and URL.</br>- Name the site ‘Outfitters’ and ensure the URL ends with /Outfitters</br>- Click Create. Your site will be created in Preview status. |![image](https://github.com/user-attachments/assets/8f2226c0-8c2d-4e59-8734-983cd7f8c856)|
  | Activate Site | - From Setup, enter ‘Digital Experiences’ and select ‘All Sites’ under ‘Digital Experiences’.</br>- Click Workspaces next to Sunshine Resorts.</br>- Select Administration, then Emails. </br>- Under ‘Email Tabs,’ uncheck ‘Send welcome email’ and click Save.</br>- In Settings, click Activate and confirm by clicking OK.</br>- Your site will now be live and fully set up.|![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Pre-Deployment%20Instructions%20Images/SiteName.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Pre-Deployment%20Instructions%20Images/SiteEmail.png)|

### 3. Install Pre-Deployment Package (10 minutes)

  | Step | Action and Details | Images |
  | ----- | ----- | ----- |
  | Install package | - Click on this Package Installation [Link ](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4W000002V5WS)</br>- Sign-in to the Org with your credentials.</br>- Choose Install for Admins Only option</br>- Choose “Rename conflicting components in package” and click the Install button.</br>- Wait until installation is completed, you will receive a confirmation on logged in user’s email |![image](https://github.com/user-attachments/assets/316f4e48-b9b2-4169-b362-fc3ecd9cd1b3) ![image](https://github.com/user-attachments/assets/0da1a771-abcc-4caa-b248-1b768905de60)|
  | Verify Package installation | - Click Setup</br>- Search for package</br>- Click on 'Installed PAckage' </br>- Search for 'RetailConfigPackage' is installed  |![image](https://github.com/user-attachments/assets/8b76cd89-abec-4586-91cc-6b4b430dc68c)|

  | Step | Action and Details | Images |
  | ----- | ----- | ----- |
  | Setup Data Cloud| - Enter “Data Cloud” in Quick Find box.</br>- Click on “Data Cloud Setup Home”.</br>- Click on “Get Started” if the Data Cloud instance is not set up.</br>- If already Data Cloud setup is done then you will not see Get Started option.</br>- Once the process is complete, the Data cloud instance is ready to use.</br>||
  | Verify Experience Delivery is Disabled | - Go to Setup → Digital Experiences → All Sites.</br>- Click Workspaces for ‘Outfitters’.</br>- Click Administration.</br>- Click on Settings.</br>- Experience Delivery should be disabled. If it’s enabled, please raise a Salesforce Case with the Support team to disable this feature.</br>||
  | Enable Data Cloud on Experience Site | - Go to Setup → Digital Experiences → All Sites.</br>- Click Builder for ‘Outfitters’.</br>- Click Settings → Integrations.</br>- Click Add to Site for Data Cloud.</br>- Enable “Share site data with Data Cloud” and click Save.</br>- Once enabled, a green box will appear</br>- Click Publish in the top-right corner | ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Pre-Deployment%20Instructions%20Images/SiteIntegration.png)|
  | Verify Data Stream  | - Go to App Launcher → Data Cloud → Data Stream.</br>- Change List View to All Data Streams.</br>- Search for Experience\_Cloud.</br>- 6 total Data Streams should appear |![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Pre-Deployment%20Instructions%20Images/ExperinceDataStreams.png)|
  | Create a Record on Custom Metadata | - Go to Setup \-\> Search for Metadata type \-\> Click on ‘Install Package Settings Enabled’ \-\>   Click on **Manage Install Package Settings Enabled** \-\>Click on ‘New’ \-\> Give Label as  **Package Settings Enabled** and **Check Checkbox of Installation Settings Enabled Field.** Click Save|![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Pre-Deployment%20Instructions%20Images/CustomMetdata.png)|
  | Enable Personalization Setup Home | - Go to Personalization Setup </br>- In Quick find search Data Cloud Setup Home </br>- From the Setup Home, In the Personalization Setup Status click on ‘Start Setup’ button </br>- In the Deploy Foundation Data, under the dataspace select as default and Click on Deploy | ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Pre-Deployment%20Instructions%20Images/PersonalizationSetup.png)  |


### 4. Setup the Salesforce Org (20 minutes)

  | Step | Action and Details | Images |
  | ----- | ----- | ----- |
  | Assign Data Cloud Permissions to Objects & Custom Fields | - Click on App Launcher, search for Retail and click on **Retail Setup** App</br>- Click on **“Assign Permissions for Objects”** button (highlighted in the screenshot below) and wait for a confirmation message before proceeding further |![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Pre-Deployment%20Instructions%20Images/AssignPermissionButton.png)|
  | Modify the Data Cloud Admin Permission Set | - Open the Setup Menu and click Setup</br>- In the Quick Find, search for ‘Permission Sets’ and click ‘Permission Sets’</br>- Click the ‘Data Cloud Admin’ permission set</br>- In the Apps section, click ‘Data Cloud Data Space Management’</br>- In the Data Spaces panel, click Edit.</br>- Check the ‘Enabled’ checkbox for the default data space and click Save</br>- Click OK in the confirmation dialog |![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Pre-Deployment%20Instructions%20Images/DataClouDefaultPerm.png)|
| Install Standard Data Bundles | Click on Data Cloud Setup </br>- Click on ‘Salesforce CRM’</br>- Under ‘Standard CRM Data Bundles’</br>- Click on ‘Arrow’ icon and click on ‘install’ of ‘Sales Cloud’</br>- it will open on new page -> click on Install |![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Pre-Deployment%20Instructions%20Images/SalesforceCRMSAlesInstall.png)![image](https://github.com/user-attachments/assets/6f4a17f5-211b-4eef-a0d2-b5b993cad3a2)|
| Turn On Einstein Setup | - Navigate to Setup</br>- Search and Select ‘Einstein Setup’</br>- Turn on Einstein Setup | ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Pre-Deployment%20Instructions%20Images/EinsteinSetup.png) |
| Turn On Agentforce | - Navigate to Setup</br>- Search and Select ‘Agent’</br>- Turn on Agentforce |  |
|Commerce Categories Setup |-Go to app launcher and search Commerce. </br>-Toggle the Merchandising And click on Categories. </br></br>**Note: - If Categories Footwear and Gear are already present, then skip it below steps.**</br>-Note: - If Categories Footwear and Gear are already present, then skip it below steps.  </br>Give the Name “Footwear” And Select Checkbox for “Show In Menu”, For Sort Order enter 1, For Code CAT_FOOTWEAR.</br>Repeat the above steps for “Gear”. And In sort order enter 2. | |
| If Propensity To Churn (Propensity_To_Churn__c)  field is not visible |-Go to Setup>> Object Manager>> Search for Contact and Click on it.</br>-Click on Field and Relationship>>Search for Propensity To Churn and click on it</br>-Click on Set Field-Level Security>> check the Visible checkbox and click on Save button.| ![](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Pre-Deployment%20Instructions%20Images/Propensity_To_Churn.png) |
</details>

<details><summary>

 ## 2. Salesforce Package Installation
</summary>
1 step process

### 1. Install Outfitters Base Package (10 minutes)

 | Step | Action and Details | Images |
  | ----- | ----- | ----- |
  | Install Outfitters Base Package | - Click on this Package Installation [Link ](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4W000002V5Wc)</br>- Sign-in to the Org with your credentials.</br>- Choose Install for Admins Only option</br>- Choose “Rename conflicting components in package” and click the Install button.</br>- Click Done when installation is complete. |![image](https://github.com/user-attachments/assets/29af9d66-482c-42e1-9210-b0f803429b5d)|
  | Verify Package installation | - Click Setup</br>- Search for ‘Installed Package’</br>- Search for ‘RetailDataKitPackage’ is installed  |![image](https://github.com/user-attachments/assets/8669e29c-a7e9-4fdd-8829-67899fccc608)|

</details>

<details><summary>
  
  ## 3. Data Cloud Configuration
</summary>
8 step process

### 1. Setup Data Streams 
The Data Kit is installed as a part of the Package installation. Follow the steps below to create data streams.

### Setup Salesforce Data Streams (15 minutes)
 | Step | Action and Details | Images |
  | ----- | ----- | ----- |
  | Verify Salesforce CRM is Active or Not | In Data Cloud, select the Setup icon and then Data Cloud Setup.</br> - Select Salesforce CRM.</br>- If connection status is “Inactive”</br>- then click on drop down to “Active” </br>- Click on “Active”| ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Data%20Cloud%20Configuration%20Images/DataStream.png)|
  | Create Data Streams from Data Bundle | - Logged into the environment where you installed the data kit</br>- Go to Data Cloud app and the Data Streams tab.</br>- Click New to create a Data Stream</br>- Select Salesforce CRM and click Next.</br>- Under Custom Data Bundles, select the Salesforce_CRM_Bundle.</br>- Select your Salesforce Org.</br>- Click Next.</br>- Select the data space as ‘Default’, review the fields in your data stream, and click Next.</br>- Review details and click “Deploy.|![image](https://github.com/user-attachments/assets/901db59e-4a4f-4bf5-8129-cd2894af7dd9)|
  | Create Website_Mobile_apps Data Stream from Data Kit |- Click on Data Stream</br>- Click on New</br>- Select ‘Installed Data Kits Package’</br>- Select ‘RetailDataKitPackage ’ Data Kits</br>- Select checkbox under ‘Websites_Mobile_Apps’ click on ‘Next’</br> -Select Connector type ="website" & connector name "Experience_Cloud_Event_Connector".</br>- Click Next.</br> - Click on Deploy|![image](https://github.com/user-attachments/assets/9869df31-0549-4b4f-b74d-d44ad95d60ce) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Data%20Cloud%20Configuration%20Images/DatakitPackage.png)![image](https://github.com/user-attachments/assets/6a9ed53c-f351-46c2-844e-dbaca371735e)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Data%20Cloud%20Configuration%20Images/DataStreamForWebsiteAndMobileApps.png)|  
### 1a. Create Data Steam for Amazon S3 (10 minutes) $${\color{blue} S3 \space Optional: \space Please \space note \space that \space some \space functionality \space in \space Experience \space Cloud \space and \space in \space the \space C360 \space will \space no\space longer \space function\space as \space expected \space if \space not \space installed. }$$
  | Step | Action and Details | Images |
  | ----- | ----- | ----- |
  | Upload Unstructured data to the S3 Bucket | Before you continue, upload the below test files to your AWS instance, create a bucket called "hosporgfarm" or the bucket you wish to use for this demo </br></br> [AWS UnStructured Data](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/AWS%20Unstructured%20Data/Return_Policy_FAQs.pdf) | |
  | Create a Connection to Amazon S3 in Salesforce|Navigate to Data Cloud Setup</br>In the menu, under EXTERNAL INTEGRATIONS, click on Other Connections</br> - Click New, choose Data Kits as the source and click Next. Select RetailDataKitPackage</br>-Select hosporgfarm</br>-Change the name & API name of the connection "hosporgfarm". </br>-Put the bucket name “hosporgfarm” please feel free to change the bucket name based on your existing AWS bucket</br> -Fill the credentials and save.|
  
  ### 1b. Create Data Stream for Snowflake (5 minutes) $${\color{blue} Snowflake \space Optional: \space Please \space note \space that \space some \space functionality \space in \space the \space C360 \space will \space no\space longer \space function\space as \space expected \space if \space not \space installed. }$$
  | Step | Action and Details | Images |
  | ----- | ----- | ----- |
  |Create a connection to snowflake in Salesforce |Navigate to Data Cloud Setup</br>-In the menu, search SnowFlake,</br> - Click New, choose Data Kits as the source and click Next. Select RetailDataKitPackage</br>-Select SnowflakeDataFederation. </br>-Please feel free to change the connection name based on your existing snowflake connection </br> -Don’t change the API name </br>Fill the Account URL, Username, and Private Key and click next and save.|
  A Create Data Stream for Snowflake from data kit | - While logged into the environment where you installed the data kit</br>- Go to Data Cloud app and the Data Streams tab.</br>- Click New to create a Data Stream</br>- Under "Other Sources", select "Installed Data Kits & Packages" and click Next</br>- Select "RetailDataKitPackage" Data Kit</br>- Select Snowflake_01 Bundle and click Next.</br>- Under Data Streams choose "Sales_Order","Sales_Order_Item","Return_Order" and "Return_Order_Item" and click Next.</br>- Review the Data Stream fields and click Next</br>- Click Deploy to create the Data Streams| ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Data%20Cloud%20Configuration%20Images/DatakitPackage.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Data%20Cloud%20Configuration%20Images/SnowflakeDataBundle.png)|
  ### 1c. Create Return_Policy_FAQs DLO Creation for Unstructured Data(10 minutes)
  Complete this step only if you have setup a connection and the file notification process in AWS
  | Step | Action and Details | Images |
  | ----- | ----- | ----- |
  | Create Return_Policy_FAQs DLO Creation | - Click on Data Lake Object Click on New </br>- Click on Create from Data Kits, Click on Next </br>- Select Return_Policy_FAQs, select “hosporgfarm’ connection. Click on Next </br>- Click on Deploy.|

   ### 1e. Create Party Identification Collection Data Lake (5 minutes)(CHECK)
  | Step | Action and Details | Images |
  | ----- | ----- | ----- |
  | Create Party Identification Collection DLO Creation  | - Click on Data Lake Objects Tab </br>- Click on New</br>- Click on “Create from Data Kits”, Click on Next  and select “RetailDataKitPackage” package </br>- Select Party Identification Collection.</br>- Click on Next </br> - Click on Save. |

  ### 2. Create Data Transforms from Data Kit (5 minutes)
  Proceed with this step only if you have setup a connection to snowflake
  | Step | Action and Details | Images |
  | ----- | ----- | ----- |
  | Create Order Data Transform $${\color{blue} Snowflake \space Optional}$$ | -Click on Data Transforms Tab </br>- Click on New</br>- Click on Create from Data Kits, Click on Next</br>- Select Extract Party Identifiers from Orders</br>- Click on Next . Click on Save, Copy the Name , Remove the Name then Paste the same Name Again</br>- Click on Save|![image](https://github.com/user-attachments/assets/79d6f605-c8e5-4c3d-ac6a-f34f39cc29e2)![image](https://github.com/user-attachments/assets/1c84c981-9a03-4b05-9a3a-cf2137d45425)![image](https://github.com/user-attachments/assets/e1e24730-f55a-42de-9a4f-5ab5af27b04b)![image](https://github.com/user-attachments/assets/c3231d58-e1fd-4653-9981-02f152451f61)
 
  ### 3. Cross Verify CRM Data (5 minutes)
  Proceed with this step only if you have the Real-Time SKU enabled in your org
  | Step | Action and Details | Images |
  | ----- | ----- | ----- |
  | **NOTE**|- Before proceeding further, please ensure that the CRM data is available in the DMO. You can verify this by following these steps:</br>- Navigate to Data Explore </br>- Set Data Space to Default.</br>- Select the Data Model Object (DMO).</br>- From the dropdown, choose Account Contact.</br>- You should see Salesforce_Home listed under the Data Source column.</br> If you don't see the data then wait until the data is refreshed before proceeding to the next step.</br>|![image](https://github.com/user-attachments/assets/396732a3-89cb-455d-9a0c-b6c015b272cb)|
 
### 4. Create Identity Resolution Ruleset from Data Kit (5 minutes)
  | Step | Action and Details | Images |
  | ----- | ----- | ----- |
  | Create Identity Resolutions| -Go to Data Cloud app</br> - Click on the Identity Resolutions tab </br> - Click New</br> - Select Installed from Data Kit</b>- Choose RetailDatalkitpackage </br>- Click on Next</br>- Choose ‘Customer Profile’. Click on Next </br>- Click on Save.</br>  Repeat the steps for the following metrics: ‘Party Identification Match’|![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Data%20Cloud%20Configuration%20Images/IdentityResolution1.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Data%20Cloud%20Configuration%20Images/IdentityResolution2.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Data%20Cloud%20Configuration%20Images/IdentityResolution3.png)|


 ### 5. Create Calculated Insights (5 minutes)
  | Step | Action and Details | Images |
  | ----- | ----- | ----- |
  |  Create Calculated Insights|- Go to Data Cloud ap </br>- Click on Calculated Insights tab</br>- Click New</br>- Select "Create from a Data Kit" and click  Next</br>- Select ‘Customer Lifespan’</br>- Click on Next </br>- Click on ‘Check Syntax’</br>- Click on ‘Activate’</br>- Click Activate</br>- Select Schedule as ‘Every 1 hour’ Select Start Date and Time As default.</br>- Click on ‘Enable’</br>- Repeat the steps for the following metrics: ‘Average Purchase Value’, ‘Average Purchase Frequency’, ‘Customer Lifetime Value, ‘Product Cobrowse Ranked’, ‘Product Cobuy’,‘Engagement Score ’ |![image](https://github.com/user-attachments/assets/9f178c36-06c1-405e-b19c-679ef5830c22)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Data%20Cloud%20Configuration%20Images/CustomerLifeSpan.png)|

### 6. Create Data Graph (5 minutes)
| Step | Action and Details | Images |
  | ----- | ----- | ----- |
  |  Create Data Graph |- Click on Data Graph Tab</br>- Click on New</br>- Select Create from Data Kits</br>- Select RetailDataKitPackage DK </br>- Select **Web Engagement RT Profile**. </br>- Select primary Data model object as “Unified Individual real”.</br>- Click on Individual and go to the right side where the error is showing and uncheck the check box.</br>- Now click on Save & Build.</br>-Repeat the above steps to select **Item Non-Real Data Graph** <br/>-Now CLick on Save & Build|![image](https://github.com/user-attachments/assets/f626912f-01b4-43eb-8efc-47d7a24bc615)![image](https://github.com/user-attachments/assets/5184c52c-e00b-4b00-83fe-fd0a9d47ad14)![image](https://github.com/user-attachments/assets/675c7904-9483-4079-86d1-3e15f9b00915)![image](https://github.com/user-attachments/assets/808709b3-49fd-4a9e-acd0-518dae4ae389)![image](https://github.com/user-attachments/assets/738b3c7e-143f-4492-8fe4-7b49d625c541)![image](https://github.com/user-attachments/assets/3648af20-e879-457d-b952-1f73c55792b6)![image](https://github.com/user-attachments/assets/e288cc79-caa7-4163-bcef-563d1e0cf111)|


### 7. Create Data Cloud Copy Field Enrichment (15 minutes)
| Step | Action and Details | Images |
  | ----- | ----- | ----- |
| Create Data Cloud Field Enrichment of ‘Average Purchase Value’ |- Go to Object Manager</br>- Search for Contact.</br>- Click on Contact</br>- Click on Data cloud Copy Field.</br>-Click on New.</br>- Select data space as ‘default’ > Select Data Cloud Object as ‘Average_Purchase_Value__cio’ </br>- Click on ‘Next </br> - Select Field APV </br> - Click on Next </br>- Give Label as ‘Average Purchase Value default’</br> - Click on Finish </br> - On Contact Select AveragePurchaseValue__c </br>- Save and Start Sync.|![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Data%20Cloud%20Configuration%20Images/AveragePurchaseValue1.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Data%20Cloud%20Configuration%20Images/AveragePurchaseValue2.png)|
| Create Data Cloud Field Enrichment of ‘Customer Lifetime Value’ |- Go to Object Manager</br>- Search for Contact.</br>- Click on Contact</br>- Click on Data cloud Copy Field.</br>-Click on New.</br>- Select data space as ‘default’ > Select Data Cloud Object as ‘Customer_Lifetime_Value__cio’ </br>-  Click on ‘Next </br> - Select Field CLV </br> - Click on Next </br>- Give Label as ‘Customer Lifetime Value default’</br> - Click on Finish </br> - On Contact Select LifetimeValue__c </br>- Save and Start Sync.|![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Data%20Cloud%20Configuration%20Images/Customer%20Lifetime%20Value1.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Data%20Cloud%20Configuration%20Images/Customer%20Lifetime%20Value2.png)|
| Create Data Cloud Field Enrichment of ‘Engagement Score’ |-> Go to Object Manager.</br>- Search for Contact.</br>- Click on Contact</br>- Click on Data cloud Copy Field.</br>-  Click on New.</br>- Select data space as ‘default’</br>- Select Data Cloud Object as ‘Engagement_Score__cio’</br>- Click on Next</br>- Select Field As ‘Engagement_Score’</br> - Click on Next </br>- Give Label as ‘Engagement Score default’</br>- Click on Finish </br>- On Contact Select EngagementScore__c </br>- Save and Start Sync.|![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Data%20Cloud%20Configuration%20Images/Engagement%20Score1.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Data%20Cloud%20Configuration%20Images/Engagement%20Score2.png)|
|Create Variation Attribute Set |Go to App launcher>> Search for Commerce>> Open it </br>Select the "Outfitters" store </br>From the left navigation bar, choose "Settings", then "Product", and finally "Variation Attribute Set". </br>From the left navigation bar, choose "Settings", then "Product", and finally "Variation Attribute Set". </br>Repeat this process to create another Variation set attribute named "Tents and Sleeping bags" attribute set,but only add the "Size" attribute. | |

### 8a. Create Activation Targets
| Step | Action and Details | Images |
| ----- | ----- | ----- |
| Create Data Cloud Activation Target | Go to Data Cloud app </br> - Click on Activation Target </br> - Click on New </br> - Select ‘Data Cloud’ under targets. </br> - Click on Next. </br> -In Activation Target name provide ‘Data Cloud Target’ </br> - Under dataspace, select as ‘default’ </br> - Click on Save| |

### 8b. Create Segment from Data Kit
| Step | Action and Details | Images |
| ----- | ----- | ----- |
| Create Segment | Go to Data Cloud app </br> - Click on the Segment tab  </br> - Click New </br> - Select "Installed from Data Kit” </br> - Choose "RetailDataKitPackage" </br> - Click on Next </br> -  Select Segment as Individual and provide Segment name as Get Customers. </br> - Select Standard Publish </br> - Select Publish Schedule to 4 hrs and select the start and end date. </br> - Click on Save. </br> - Click on Publish now button. | |

### 8c. Create Activations 
| Step | Action and Details | Images |
| ----- | ----- | ----- |
| Create Activations | By default, space is default </br> - Need to select the Get Customer segment and activation target as data cloud  </br> - Click on continue </br> - Select Email.</br> -Click on Continue </br> - Click on add attributes  </br> - And from individual select the following attributes </br> - Sold to Customer,Order Number, Product Id, Recall and Product Name </br> - Click on Save with name as Get Recalled Customers.| |

### 8d. Create Variation Attribute Set
| Step | Action and Details | Images |
| ----- | ----- | ----- |
| Create Variation Attribute Set | Go to App launcher>> Search for Commerce>> Open it </br> - Select the "Outfitters" store  </br> - From the left navigation bar, choose "Settings", then "Product", and finally "Variation Attribute Set".  </br> - Click on “New” and set the name “Shoe Variations” and add the attributes "star", "Durability", "Ventilation", and "Category" to the "Selected field" section.  </br> - Repeat this process to create another Variation set attribute named "Tents and Sleeping bags" attribute set,but only add the "Size" attribute. | |

### 9. Create Search Fields
| Step | Action and Details | Images |
| ----- | ----- | ----- |
| Create Search Fields | Go to App launcher>> Search for Commerce>> Open it </br> - Select the "Outfitters" store  </br> - From the left navigation bar, choose "Settings",then "Search", and finally "Search Fields".  </br> - Click on Manage Searcheable Fields </br> - Add Variation Attribute Fields and Product - Standard Fields that are required. ||

</details>

<details><summary>

 
  ## 4. Commerce Cloud Configuration
</summary>

8 step process

### 1. Verify Organization Wide Address (5 minutes)
  | Step  | Action and Details  |  Images |
  | ----- | ----- | ----- |
  | Verify Organization-Wide Address Exists or not |- Go to Setup \-\> Search for Organization-Wide Address \-\> Click on Organization-Wide Addresses</br>-  Verify if there is an organization-wide address with the name ‘Default Email’ created and verified.</br>- If there is none, then please create an organization-wide address by following below steps</br>- Click on **Add** button \-\> On the Display Name Add **‘Default Email’.** On the Email Address \<Add your email address\> Select ‘Default No-Reply Address’ on Purpose field \-\> click check box **‘allow all profiles to use this from address’**   |![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/OrgWideEMailAddrs1.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/OrgWideEmailAddress2.png)|


### 2. Install Agent and Experience Site Package (1 hour 30 minutes)
  | Step  | Action and Details  |  Images |
  | ----- | ----- | ----- |
 | Install Agent & Exp Site Package |</br>- Install VSCode [Download](https://code.visualstudio.com/download) </br>- Setup CLI a. Install the Salesforce CLI  https://developer.salesforce.com/tools/salesforcecli or check that your installed CLI version is greater than 2.56.7 by running sf \-v in a terminal.</br>- If you need to update the Salesforce CLI, either run sf update or npm install \--global @salesforce/cli depending on how you installed the CLI.</br>- Install Extension</br>- Open VSCode \> Go To\> Extensions-\>Salesforce Extension Pack\>Install</br>- Open Terminal Clone git Repository by using below command </br> ```git clone https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo.git``` </br>- Open the Project </br>- Authorize an Org</br>- Type Ctrl+Shift+P Select SFDX:Authorize an Org</br>- Select Project Default</br>- Enter the Org alias</br>- Authorize the Org </br>- Open terminal and run the command **sf project deploy start --source-dir force-app** </br></br> **NOTE:** $${\color{red}Skip \space below\space steps \space 4, \space 5, \space 6, \space and \space 7 \space if \space you \space wish \space to \space bring \space in \space your \space own \space Product \space data}$$ |![image](https://github.com/user-attachments/assets/293fd406-72fc-4be3-9008-0a9926461586)![image](https://github.com/user-attachments/assets/6d3a14ee-3c65-4f47-99a6-39066b68a9aa)![image](https://github.com/user-attachments/assets/71751813-f4b9-437f-b355-9feb770c0c2d)![image](https://github.com/user-attachments/assets/b50fb406-2ae7-475a-a8c6-939d486dd9fd)![image](https://github.com/user-attachments/assets/5b4efb69-3f1a-4a1a-8ecb-be4e17344098)![image](https://github.com/user-attachments/assets/403c5a8f-ef31-4220-8062-60ae71453008)![image](https://github.com/user-attachments/assets/9a2ff9e1-75f2-4c13-a7d1-1a1ef5c2bc51)|

**NOTE:** $${\color{red} Skip \space the \space below \space steps \space if \space you \space wish \space to \space bring \space in \space your \space own \space Product \space data}$$
$${\color{red} 3.\space Create Commerce Data}$$
$${\color{red} 4.\space Search Update}$$
$${\color{red} 5.\space Upload CMS Images into the Store and}$$
$${\color{red} 6.\space Add CMS Product Images}$$

### 3. Create Commerce Data (5 minutes)
  | Step  | Action and Details  |  Images |
  | ----- | ----- | ----- |
  | Create Data  | - Click on App Launcher, search for Retail Setup and click on Retail Setup App</br>- Click on the **“Create Commerce Data”** button (highlighted in the screenshot to the right) and wait for a confirmation message before proceeding further. |![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/CreateCommerceData.png)|

### 4. Search Update (5 minutes)
  | Step  | Action and Details  |  Images |
  | ----- | ----- | ----- |
  | Search Update |**Enable Commerce App** </br>- Click Setup and search for Commerce</br>- Click Settings under Feature Settings --> Commerce</br>- Use the toggle to switch on the Enable the Refreshed Commerce App</br></br>**Enable Search Index**</br>- Click on App Launcher, search for Commerce and select Commerce application</br>- In the Store dropdown, choose Outfitters Store</br>- Scroll down to Setting and expand it</br>- Click on Search</br>- Use the toggle to turn on Automatic Updates | ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/EnableComerceSetup.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/EnableSearchIndex.png)|

### 5. Upload CMS Images into the Store (15 minutes)
  | Step  | Action and Details  |  Images |
  | ----- | ----- | ----- |
  | Upload CMS Images into Store  |- Download Images from [CMS Images](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/tree/master/Retail%20Outfitters%20Store%20Images) </br>- Click on App Launcher\>\> Select commerce application\>\> Click on Store</br>- Open Outfitters Store</br>- Scroll down to Content Manager</br>- Click on Add workspace</br>-  Enter details such as Name "Outfitters Managed Content Space" and select Enhanced CMS Workspace and click on Next</br>- Add Outfitters Channel as Public and Outfitters site and click Next</br>- Keep language as it is and click on Finish</br>-  Click on Add and select Content \>\> select images\>\>Click on Create button\>\> click on upload button\>\>Select Image\>\>Image and Title populated\>\>Enter API name (can be the same as file name)\>\> Save it\>\> Click on Publish button\>\> Keep Details as is\>\> Click on Next\>\> Select Publish Now\>\>click on publish now button </br>- Please repeat the above steps for all the images| ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/CMSWorkspace1.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/CMSWorkspace2.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/CMSWorkspace3.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/CMSWorkspace4.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/CMSWorkspace5.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/CMSWorkspace6.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/CMSWorkspace7.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/CMSWorkspace8.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/CMSWorkspace9.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/CMSWorkspace10.png) |

### 6. Add CMS Product Images (15 minutes)
  | Step  | Action and Details  |  Images |
  | ----- | ----- | ----- |
  | Add Image to a Product   |- Click on App Launcher\>\> Select commerce application\>\>Click on Store</br>- Open Outfitters Store </br>- Expand Merchandise\>\> Product\>\> open one by one product</br>- Click on eye icon (it removes Site window) after save button</br>- Confirm that "Products" is selected under categories</br>- Scroll down \>\> click on Go to global product record</br>-  Go to Media\>\> Click on Add image for Product details Image section \>\> Select appropriate image from Commerce Store image\>\> click on Add button</br>- Click on Add image for Product list Image section \>\> Select appropriate image from Outfitters Managed Content Space\>\> click on Add button</br>- Repeat previous steps for each product </br>- Go to store\>\> select Outfitters \>\>Scroll down to Website Design\>\> select product category from dropdown \>\> click on Publish button (this step maybe not be needed if you are commerce console)</br>- Go back to Outfitters Store\>\>Click on Home\>\> click on preview the site and see product is getting displayed | ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/StoreProduct1.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/StoreProduct2.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/StoreProduct3.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/StoreProduct4.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/StoreProduct5.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/StoreProduct6.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/StoreProduct7.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/StoreProduct8.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/StoreProduct9.png)|

### 7. Enable Self Registration (5 minutes)
  | Step  | Action and Details  |  Images |
  | ----- | ----- | ----- |
  | Enable Self Registration   |- Click on App Launcher>> Select commerce application>>Click on Store</br>- Open Outfitters Store</br>- Settings >> Store</br>- Click on Buyer Access Tab</br>- Scroll down to Self Registration (enable if it’s not enabled)</br>- Select Account RecordType to “Person Account” </br>- Select Default Buyers Group to “Outfitters Buyer Group"</br>- Click Save|![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/EnableSelfRegistration.png)|


### 8. Share CMS with Site workspace (5 minutes)   
  | Step  | Action and Details  |  Images |
  | ----- | ----- | ----- |
  | Share CMS with Site workspace   |- Click on App Launcher and search for CMS Workspaces</br>- Select CMS Workspaces</br>- Click on "Outfitters Managed Content Space" (the CMS created in previous step</br>-  Click the gear icon (at the top right) and select "Workspace Sharing" from the dropdown</br>- Move "Content Workspace for Marketing Cloud" and "Outfitters Managed Content Space zSlkk6kP" to the right (under Shared) and click Next </br>- Click Save </br> **Note : If the images was not displaying then Go to App launcher>> Search for Commerce>> Open it </br> - Select the "Outfitters" store  </br> - From the left navigation bar, choose "Website Design".</br> - In the Home Dropdown, select 'Product' and publish</br> - Next select 'Category' and publish</br> - select 'Search' and publish. Then exit.**|![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/PromptFlow1.jpg) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/PromptFlow2.jpg.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Commerce%20Cloud%20Config%20Images/PromptFlow3.png)|

</details>

<details><summary>

  ## 5. Connect and Create Sample Data
</summary>
4 step process

### 1. Create Sample Data (5 minutes) $${\color{blue} Optional: \space These \space steps \space are \space optional \space if \space you \space choose \space to \space use \space your \space own \space data. }$$
| Step | Action and Details  |  Images |
| ----- | ----- | ----- |
| Create Sample Data | - Click on App Launcher, search for Retail Setup App and click on Retail Setup App</br>- Click on the **“Create Test Data”** button (highlighted in the screenshot below) and wait for a confirmation message before proceeding further. |![image](https://github.com/user-attachments/assets/5af44efa-ca6c-4d95-800a-5aec9f477928)
### 2. Create Buyer Group  & Assign Buyer Group for Self-Registration  (10 minutes) $${\color{blue} Optional: \space These \space steps \space are \space optional \space if \space you \space choose \space to \space use \space your \space own \space data. }$$
| Step | Action and Details  |  Images |
| ----- | ----- | ----- |
| Create Buyer Group  & Assign Buyer Group for Self-Registration | - Click on Setup</br>- Search for ‘Commerce’ </br>- Select **Customer** from left-hand section and go to **Buyer Group**. </br>- Click on **New** Button.</br>- For Name use **Outfitters Authenticated Users**.</br>- For Role Select Account-based.</br>- Click on Assign in **Pricebook** section. </br>- Select **Outfitters Pricebook**. </br>- Click on Assign in ‘Commerce Entitlement Policies’ Section.</br>- Assign **All Access for Outfitters**  </br>- Search for ‘Contacts’ and select ‘Duncan Macintosh’. </br>- Select ‘Details’ tab </br>- In the highlights panel, you can see the ‘Enable as buyer’ button. </br>- Click on **Enable as Buyer** </br>- Search for ‘Commerce’ and Select store from the left-hand side section. </br>- Go to ‘Buyer Access’ Tab and now you can see the newly created Buyer Group named **Outfitters Authenticated Users**. </br>- Select **Outfitters Authenticated Users** you can see **Buyer Group Member** Section  </br>- Click on Assign button in the Buyer Group Member section and Add the Contact that we selected **Enable as a Buyer**. </br>- Go back to the **Buyer Access** tab and check for the Self-Registration section to make sure that we have selected Default Buyer Group as the one we created.    |  ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/BuyerGp1.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/BuyerGp2.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/BuyerGp3.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/BuyerGp4.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/BuyerGp5.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/BuyerGp6.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/BuyerGp7.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/BuyerGp8.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/BuyerGp9.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/BuyerGp10.png)|

#### 2a. Assign Buyer Group Member Related List to Buyer Group Layout(5 minutes) 
| Step | Action and Details  |  Images |
| ----- | ----- | ----- |
|Assign Buyer Group Member Related List to Buyer Group Layout  | - Click on Setup and go to Object Manager tab. </br>- n the Quick find search box type Buyer Group.</br>- Click on Buyer Group.  </br>- From the left-hand section select Page Layout.</br>- Select Buyer Group Layout.  </br>- From the left hand section go to Related Lists. </br>- Drag and Drop Buyer Group Members.   </br>- Save the Page Layout. </br>- If you go back to Commerce store and followed by there to Customer section and then select Buyer Group.  </br>- Select the ‘Outfitters Authenticated Users’. </br>-You can find the Buyer Group Members Related list on the Page. |![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/BuyerGp11.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/BuyerGp12.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/BuyerGp13.png)|
### 3. Create Community User and Assign User to Buyer Group (5 minutes)
| Step | Action and Details  |  Images |
| ----- | ----- | ----- |
| Create Community User and Assign Buyer Account to Buyer Group |- Click on App Launcher, search for Retail Setup and click on Retail Setup App</br>- Click on the **"Create Buyer Group Member Data"** button (highlighted in the screenshot on the right) and wait for a confirmation message before proceeding further.</br>- **Note:** If the confirmation message does not appear after 5 minutes, refresh the page and if the **"Create Buyer Group Member Data"** button is disabled, proceed. | ![image](https://github.com/user-attachments/assets/2282a058-02df-45c0-8da2-5e7eb4350d9b)

### 4. Setup Data in Snowflake (15 minutes) $${\color{blue} Snowflake \space Optional: \space Please \space note \space that \space some \space functionality \space in \space the \space C360 \space will \space no\space longer \space function\space as \space expected \space if \space not \space installed. }$$
| Step | Action and Details  |  Images |
| ----- | ----- | ----- |
| Create Table to hold Sales_Order data | - Login to the Snowflake Database/Schema that is connected to Data Cloud and run the below DDL script to create Sales_Order table.  |  |
```
create or replace TABLE <<database_name>>.<<schema_name>>.Sales_Order
( 
    ORDER_NUMBER VARCHAR(15), 
   CUSTOMER_NUMBER VARCHAR(15), 
   ORDER_DATE TIMESTAMP_NTZ(9), 
   STATUS VARCHAR(15) 
)
```

| Step | Action and Details  |  Images |
| ----- | ----- | ----- |
| Load data into Sales_Order table | - Load data in the below csv file into Sales_Order table: [SALES_ORDER_DATA csv](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Snowflake%20Data/SALES_ORDER_DATA.csv)  |  |
| Create Table to hold Sales_Order_Item data | - Login to the Snowflake Database/Schema that is connected to Data Cloud and run the below DDL script to create Sales_Order_Item table.  |  |
```
create or replace TABLE <<database_name>>.<<schema_name>>.Sales_Order_Item_DATA
(
    ORDER_ITEM_NUMBER VARCHAR(30), 
   ORDER_NUMBER VARCHAR(15), 
   PRODUCT VARCHAR(30), 
   QUANTITY NUMBER(3,0), 
   UNIT_PRICE NUMBER(16,2), 
   SUBTOTAL NUMBER(16,2), 
   LINE_NUMBER VARCHAR(3) 
)
```
| Step | Action and Details  |  Images |
| ----- | ----- | ----- |
| Load data into Sales_Order_Item_DATA table | - Load data in the below csv file into Sales_Order_Item\_DATA table: [SALES_ORDER_ITEM_DATA.csv](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Snowflake%20Data/SALES_ORDER_ITEM_DATA.csv)  |  |
| Grant Access to the Tables in the Database/Schema | - While still logged in to Snowflake, execute the following statement  |  |
```
create or replace TABLE <<database_name>>.<<schema_name>>.Return_Order_DATA
(
    ORDER_NUMBER VARCHAR(15), 
   CUSTOMER_NUMBER VARCHAR(15), 
   STORE_NAME VARCHAR(30), 
   ORDER_DATE TIMESTAMP_NTZ(9), 
   TYPE VARCHAR(15), 
   DELIVERY_METHOD VARCHAR(30), 
   STATUS VARCHAR(15), 
   TOTAL_AMOUNT NUMBER(16,2) 
)
```
| Step | Action and Details  |  Images |
| ----- | ----- | ----- |
| Load data into Return_Order table | - Load data in the below csv file into Return_Order\_DATA table: [RETURN_ORDER_DATA.csv](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/Snowflake%20Data/RETURN_ORDER_DATA.csv)  |  |
| Grant Access to the Tables in the Database/Schema | - While still logged in to Snowflake, execute the following statement  |  |
```
create or replace TABLE <<database_name>>.<<schema_name>>.RETURN_ORDER_ITEM
(
    ORDER_ITEM_NUMBER VARCHAR(30), 
   ORDER_NUMBER VARCHAR(15), 
   LINE_NUMBER VARCHAR(3), 
   PRODUCT VARCHAR(30), 
   QUANTITY NUMBER(3,0), 
   UNIT_PRICE NUMBER(16,2), 
   SUBTOTAL NUMBER(16,2), 
   RETURN_REASON VARCHAR(255)
)
```
| Step | Action and Details  |  Images |
| ----- | ----- | ----- |
| Load data into RETURN_ORDER_ITEM table | - Load data in the below csv file into RETURN_ORDER_ITEM table: [RETURN_ORDER_ITEM_DATA.csv](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Snowflake%20Data/RETURN_ORDER_ITEM_DATA.csv)  |  |
| Grant Access to the Tables in the Database/Schema | - While still logged in to Snowflake, execute the following statement  |  |
```
grant select on tables in <<database_name>>.<<schema>> to role sysadmin
```

**Note:** Before Creating ML Model, Go to Data Cloud>> Data Stream>> Account_Home>>Click on Refresh Now button and Wait till it get into success status Also Go to Data Stream>>Contact_Home>> Click on Refresh Now Button and Wait till it get into success status Go to Data Explorer>>Under Object select Data Model Object >> Then Select Account Contact>>Verify your Data their You can modify columns as well by click on Edit Columns.

### 5.Create ML Model For Propensity to Purchase (5 minutes)
| Step | Action and Details  |  Images |
| ----- | ----- | ----- |
| Create ML Model For Propensity to Purchase | - Click on App launcher and search for Einstein Studio </br>- Click on Add Predictive Model button </br>- Select create a model from scratch </br>- Click on Next</br>-Select data space as Default and select Account Contact DMO for data option and click next </br>- For training select **Filter Set of Records option** </br>- Specify the condition to filter the records and select field as **Days since the last order** and select operator as Is Not Null. </br>- Click on Next. </br>- For Set goal option select field name as  **Ordered In Last 30 Days** and Select **Maximize** option. </br>- Select **TRUE** and Click on Next. </br>-For Prepare Variable select disable Autopilot and select the follow fields like. **Maximum order value, Total Amount Spent (LTV), Number of Unique Products Purchased, Average Quantity per Order, Days since the last order, Average order value, Most Frequently Purchased Product, Last Purchased Product Categories, Number of orders period, Average time between orders, Total amount spent period** </br>- For select Algorithm option Enable Automatic Selection. </br>- Click Next. </br>- Review all the things and Click on **Save and Train** and specify ML Model name as **Propensity To Purchase Prediction**. </br>- Lets wait the model to train it successfully. </br>- Click on Activate button. | ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/MLModel1.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/MLModel2.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/MLModel3.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/MLModel4.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/MLModel5.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/MLModel6.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/MLModel7.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/MLModel8.png) |

#### 5a. Add Propensity To Purchase Prediction ML Model into Flow (5 minutes) 
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
|  Add Propensity To Purchase Prediction ML Model into Flow | - Click on Setup >> Enter Flows in quick find box>> click on flows  </br>- Search for Data Cloud - Propensity To Purchase Prediction  and open the flow  <br>-Below Data Cloud-Triggered Flow  there is plus sign>> click on the plus sign. <br>- Select Action >>Enter propensity to purchase prediction and  select the action " Propensity To Purchase Prediction". <br>- Enter label as **Predict Propensity Purchase** , and map the fields  :<br>- click on Triggering **ssot_AccountContact__dlm** >>Select  Average order value. <br>- click on Triggering **ssot_AccountContact__dlm** >>Select  Average  Quanitity per Order <br>- click on Triggering **ssot_AccountContact__dlm** >>Select  Average  time between orders. <br>- click on Triggering **ssot_AccountContact__dlm** >>Select  Days since the last order.  <br>- click on Triggering **ssot_AccountContact__dlm** >>Select  Last Purchased Product Categories. <br>- click on Triggering **ssot_AccountContact__dlm** >>Select  Most Frequenlty Purchased Product. <br>- click on Triggering **ssot_AccountContact__dlm** >>Select  Number of orders period. <br>- click on Triggering **ssot_AccountContact__dlm** >>Select  Total Amount Spent (LTV) <br>- click on Triggering ssot_AccountContact__dlm >>Select Total amount spent period. </br>- Then Go to Update record >> click on it >> for **Propensity to purchase field select value as outputs from Predict Propensity Purchase >>Select Prediction**. </br>- Click on Save As New  Version button>> click on save. </br>- Click Activate button. </br>- Go to applauncher>> enter Contact >> click on it >> Open Mark Smith ,Karen Wells, Duncan Macnitosh, Nicole Grace and edit some value under Purchase ML Data section (eg: Total Amount Spent (LTV). </br>- Go to Data Cloud >>Data Stream>> Open  Contact_Home>> click on Refresh Now button (Wait till Success status). </br>- Go to  contacts >> See Propensity To Purchase  value. </br>- Still its value not populating>> then again refresh the data stream.  | ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/MLModelFlow1.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/MLModelFlow2.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/MLModelFlow3.png)|

#### 5b. Create ML Model For Propensity to Churn into Flow (5 minutes) 
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
|  Create ML Model For Propensity to Churn into Flow | - Click on App launcher and search for **Einstein Studio** </br>- Click on **Add Predictive Model** button </br>- Select create a model from scratch <br>- Click on Next  </br>- Select data space as **Default** and select **Account Contact DMO** for data option <br>- Click on Next . <br>- For training select **Filter Set of Records** option  <br>- Specify the condition to filter the records and select field  **Churn Score** as  and select operator as **Is Not Null**. <br>- click on Next.  <br>- For Set goal option select field name as  ****Churn Score and Select **Minimize** option . <br>- click on Next. <br>- For Prepare Variable select disable Autopilot and select the follow fields like. </br>**Age, Net Promotor Score(NPS),Customer Lifetime Value(CLV), Customer Satisfaction Score(CSAT),Number of Product Return, Number of Complaint, Average Order, Gender, Location, Engagement Frequency, Payment Method, Income Level, Recency Of Purchase **  <br>- click on Next <br>- For select Algorithm option Enable **Automatic Selection** . </br>- Click on Next . </br>- Review all the things and Click on **Save and Train** and specify ML Model name as **Propensity To Churn Prediction** and click on Save button . </br>- Click Activate button. </br>- Lets wait the model to train it successfully . </br>- Click on **Activate** button .   | ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/PropensityToChurn1.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/PropensityToChurn2.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/PropensityToChurn3.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/PropensityToChurn4.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/PropensityToChurn5.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/PropensityToChurn7.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/PropensityToChurn9.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/PropensityToChurn10.png) |

#### 5c. Add Propensity To Churn Prediction ML Model into Flow (5 minutes) 
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
|  Add Propensity To Churn Prediction ML Model | - Click on Setup >> Enter Flows in quick find box>> click on flows  </br>- Search for **Predict Propensity To Churn Score**  and open the flow. </br>- **Below Data Cloud-Triggered Flow**  there is plus sign>> click on the plus sign <br>- Select Action >>Enter Propensity To Churn Prediction and  select the action **" Propensity To Churn Prediction"**.  </br>- Enter label as **" To Predict Propensity Purchase"** , and map the fields  : . </br>- Click on Triggering **ssot_AccountContact__dlm** >>Select  **Age** </br>- click on Triggering **ssot_AccountContact__dlm >>Select  Average  Order** . </br>- click on Triggering ssot_AccountContact__dlm >>Select  **Customer Lifetime Value (CLV)**  .  </br>- click on Triggering **ssot_AccountContact__dlm** >>Select **Customer Satisfaction (CSAT)**  <br>- click on Triggering **ssot_AccountContact__dlm** >>Select   Engagement Frequency . <br>- click on Triggering **ssot_AccountContact__dlm** >>Select  **Gender** </br>- click on Triggering **ssot_AccountContact__dlm** >>Select  Income Level   </br>- click on Triggering ssot_AccountContact__dlm >>Select  Net Promoter Score (NPS)  </br>- click on Triggering **ssot_AccountContact__dlm** >>Select **Number of Complaint**. </br>- click on Triggering **ssot_AccountContact__dlm** >>Select  **Number of Product Return** . </br>- click on Triggering **ssot_AccountContact__dlm** >>Select **Payment Method** . </br>- Then Go to Update Churn Field>> click on it >> for **Propensity to Churn** field select value as **Outputs from Propensity To Churn Predict**>>Select **Prediction**. </br>- Click on Save As New  Version button>> click on save . </br>- Click Activate button. </br>- Go to app launcher>> enter Contact >> click on it >> Open Mark Smith ,Karen Wells, Duncan Macnitosh, Nicole Grace and edit some value under Churm ML Data section  (eg: Engagement Frequency ,Customer Lifetime Value(CLV)). </br>- Go to Data Cloud >>Data Stream>> Open  Contact_Home>> click on Refresh Now button (Wait till Success status). </br>- Go to  contacts >> See Propensity To Churn value. </br>- Still its value not populating>> then again refresh the data stream   | ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/PropensityToChurnFlow1.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/PropensityToChurnFlow2.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/PropensityToChurnFlow3.png) ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/ML%20Images/PropensityToChurnFlow4.png) |

</details>
<details><summary>


 ## 6. Finish Configuration
</summary>
6 step process

### 1. Prepare Data Cloud

#### 1a. Refresh Snowflake Data Streams (5 minutes) $${\color{blue} Snowflake \space Optional: \space Please \space note \space that \space some \space functionality \space in \space the \space C360 \space will \space no\space longer \space function\space as \space expected \space if \space not \space installed. }$$
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
|  Refresh Snowflake Data Streams | - Navigate to Data Cloud app and the Data Streams tab </br>- Query for Sales\_Order data stream</br>- Using drop down control on the right against the data stream select Edit</br>- Select “Enable acceleration”</br>- In frequency select “Every 15 minutes”</br>- Select “Refresh initial file immediately” </br>- Repeat above steps for Sales_Order_Item,Return_Order and Return_Order_Item data stream </br>- Once the data stream is refreshed, the Total Records counts for each Data Stream is not 0. | ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/DataStreamAcceleration.png)|

#### 1b. Refresh Data Graph (5 minutes)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
|   Refresh Data Graph | - Navigate to Data Cloud app and the Data Graph tab </br>- Click on the dropdown of the data graph (Web Engagement RT Profile)</br>- Click Update Status</br>- Once the job completes successfully, this status will be set as Active.</br> Repeat the same steps to update the stauts of (Item Non-Real Data Graph) |![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/DataGraph.png)|

#### 1c. Run Calculated Insights (5 minutes)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
|  Run Calculated Insights | - Navigate to Data Cloud app and the Calculated Insights tab</br>- Query for Customer Lifespan calculated insight</br>- Using the drop down control on the right, click "Publish Now" to refresh the Customer Lifespan calculated insight.</br>- When the Calculated Insight is refreshed successfully, the Last Run Status will show as Success.</br>- Repeat steps b & c for the below Calculated Insights. Ensure all Insights are refreshed successfully.</br>- Average Purchase Value</br>- Average Purchase Frequency</br>- CustomerLifetime Value</br>- Product Cobrowse Ranked </br>-Product Cobuy </br>-Engagement Score   |![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/CalculatedInshightPublish.png)

### 2. Prepare Experience Site

#### 2a. Activate Messaging Setting (5 minutes)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| Activate Messaging Setting | - Navigate to Setup go to messaging setting</br>-  Click on ESA Channel \-\> Click on ‘Activate’</br>- Click on Checkbox then click on Accept  | ![image](https://github.com/user-attachments/assets/76464f8a-76eb-4226-9805-010e439d7a4d)![image](https://github.com/user-attachments/assets/68e08609-1b76-442d-8396-29465b8ce0e7)|

#### 2b. Configure Digital Experience (20 minutes)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| Configure Digital Experience. |- Click on **Setup**, in the Quick Find Box, enter Digital Experiences, and then select **All Sites**</br> -  Click on builder against the Site ***‘Outfitters’*** </br>- Scroll Down and Click on ‘Embedded Messaging ‘and update as per screenshot below</br>- Select **Site End Point** as - ESW_ESA_Web_Deployment_1733127495782 </br> - Select **enhanced Service URL** from dropdown - it should be same as Site URL , refer Screenshot.</br>-We are using default background for Retail. to Large.|![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/DigitalExperience.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/EmbeddedMessagingWebDeployment.png).

#### 2c. Enable Login Access (5 minutes)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| Enable Login Access. | - Go to Setup, in the Quick Find Box, enter Digital Experiences, and then select All Sites</br>- Against the site ‘Outfitters’, click on Workspaces</br>- Under My Workspaces, click on Administration</br>- Click on Login & Registration menu item</br>- Under Login Page Setup, change Login Page Type to Experience Builder Page</br>- For URL, choose Login</br>- Under Password Pages, change Forgot Password to Experience Builder Page</br>- Choose Forgot Password</br>- Under Registration Page Configuration enable "Allow customers and partners to self-register"</br>- Choose Registration Page Type as Experience Builder Page</br>- Choose Register</br>- Assign users to a profile and account, choose Outfitters Community User</br>- Assign Permission Set Group as "Commerce_Shopper"</br>- Click Save |![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/DigitalExperienceSelfregister.png)![image](https://github.com/user-attachments/assets/78acc5d8-8702-41f1-8797-9e0bdab23f13)![image](https://github.com/user-attachments/assets/16f42201-4ba0-4723-91a8-53e644f9c763)![image](https://github.com/user-attachments/assets/ff987bad-504c-4dc4-b5f5-08a86a944e99)

#### 2d. Change the layout of the Login page (5 minutes)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| Change the layout of the Login page. |- Go to Setup, in the Quick Find Box, enter Digital Experiences, and then select All Sites </br>- Against the site ‘Outfitters’, click on Builder</br>- From the Pages dropdown, search for Login, and then select Login </br>-Remove the site logo and add a Text Box component. Enter the text as "Outfitters", make it bold and center</br>- Publish the changes  |![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/LoginPageLayout.png)|

#### 2e. Change the layout of the Register page (5 minutes)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| Change the layout of the Register page |- Go to Setup, search for Digital Experiences, and select All Sites</br>- Against the site 'Outfitters', click on Builder</br>- From the Pages dropdown, search for Register, and select Register</br>- Remove the site logo and add a Text Box component. Enter the text as "Outfitters", make it bold and center (perform this step only if the “Outfitters” text box doesn't exist)</br>- Publish the changes  |![image](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/FinishConfiguration/RegisterPageLayout.png)|

#### 2f. Change the email Address (5 minutes)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| Change the email Address. |- Go to Setup \-\> Open All Sites</br>- Click on Workspaces (the configured Sites) \-\> Click Administrator</br>- Click on Emails</br>- Change Sender email to system admin email</br>- Click on save | ![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/EmailAddressUpdate.png)|


#### 2g. Create Trusted URLS (10 minutes)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| Create Trusted URLS |- Navigate to Setup, in Quick Find search Trusted URLs and click on Trusted URLs (under Security)</br>- Click on New. Key-in 'TrustedSite2' as the API Name</br>- Use https://DOMAINNAME.my.site.co for URL</br>- Replace DOMAINNAME with actual org Domain Name.</br></br> **To find the Domain name please follow the following steps:** </br>- Navigate to Setup, in Quick find search Domain → Please add https://DOMAIN from the below path (please select domain which is related to the experience cloud Sites Domain)</br>- Click on Save</br></br> **Add Trusted URL to Agent Sites** </br>- Click on Setup</br>-  Click on Sites \-\> Check the check box if Domain is not enabled, Click on **'Register My Salesforce Site domain'** button </br>- Click on ‘ESW\_ESA\_Web\_Deployment\_1733127495782’</br>- Click on Add Domain</br>- Add DOMAINNAME with actual org Domain Name.</br></br> **To find the Domain name please follow the following steps:** </br>- Search for Domain in Quick find → Please copy the name which ends with **.my.site.com** (e.g epicorgfarm79.my.site.com) </br>- Navigate to Setup, in Quick Find search All Sites </br>- Click on All Sites (under Digital Experiences) </br>- Click on Builder against Outfitters </br>- Click on Settings and then 'Security & Privacy' </br>- Click on Add Trusted Sites button - Add Name as 'TrustedSite1' and add url as domain name, which you have copied on prev steps (e.g https://e.g epicorgfarm79.my.site.com) </br>- Click Publish |![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/TrustedUrl.png)![image](https://github.com/user-attachments/assets/df140214-535e-490c-8b34-eb168a652b9f)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/TrustedDomainForInlineFrames.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/SecurityAndPrivacyBasicConfig.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/SecurityAndPrivacyTrustedSite.png)|
#### 2h. Create CORS (10 minutes)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| Create CORS |- In the Quick Find\>Type CORS</br>- Click on New\> Paste **https://DOMAINNAME.my.site.com** In Origin URL Pattern </br>- Replace DOMAINNAME with actual org Domain Name.</br>\> Click Save</br></br>-Click on New . </br>- Paste **https://*.develop.vf.force.com** to 'origin URL Pattern'</br>- Click Save</br></br>- Click on New</br>- Paste **https://*.live-preview.salesforce-experience.com.** to ‘origin URL Pattern’ </br>- Click Save</br></br>- Click on New</br>- Paste **https://*.visualforce.com** to ‘origin URL Pattern’ </br>- Click Save</br></br>- Click on New</br>- Paste **https://*.force.com** to ‘origin URL Pattern’ </br>- Click Save</br></br>- Click on New</br>- Paste **https://*.salesforce-scrt.com** to ‘origin URL Pattern’ </br>- Click Save</br></br>- Click on New</br>- Paste **https://*.my.site.com** to ‘origin URL Pattern’</br></br> **To find the Domain name please follow the following steps:** </br></br> \> Search for Domain in Quick find → Please copy the name which ends with .my.site.com (e.g epicorgfarm79.my.site.com) |![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/CORS.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/Domains.png)|

#### 2i. Publish ESA (5 minutes)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| Publish ESA | - Click on Setup </br>- In Quick Find, search Embedded Service Deployments and click on 'Embedded Service Deployments' (under Feature Settings --> Service --> Embedded Service) </br>- Click on ESA Web Deployment </br>- Click on 'Publish' button </br>- Wait for confirmation Message |![image](https://github.com/user-attachments/assets/95efd64a-9709-445a-a62e-414b6e482b84)


### 3. Prepare Agentforce

#### 3a. Add Agent User into Agentforce Service Agent and Activate (5 minutes)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| Add Agent User into Agentforce Service Agent & Activate |- Click on setup, search for Agent</br>- Click on Agentforce Agents (under Einstein --> Einstein Generative AI --> Agentforce Studio)</br>- In the Agent list, click on 'Agentforce Service Agent'</br>- In the Details tab, click on the pencil icon against **"Agent User"**, select 'Agent User' </br>- Check the check box **'Keep a record of conversations with Enhanced Event Logs to review agent behavior.'** </br>- Click on Save then click on Open Builder </br>- Click Activate  |![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/AgentforceServiceAgent.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/AgentforceServiceAgent1.png)|

### 4. Miscellaneous Configuration

#### 4a. Update Einstein Search Retriever (perform only if Amazon S3 Connection has been created ) (10 minutes) $${\color{blue} S3 \space Optional: \space Please \space note \space that \space some \space functionality \space in \space Experience \space Cloud \space and \space in \space the \space C360 \space will \space no\space longer \space function\space as \space expected \space if \space not \space installed. }$$
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| Update Einstein Search Retriever |- Click on **Setup**, in the Quick Find Box, enter Prompt Builder, and then select **Prompt Builder**</br>- Search for the Prompt Template named **Return Policy** and click on the hyperlink</br>- Hover the cursor on text the next to 'Please use the below information to help you answer the question : ', click on Resource, click on Einstein Search, click on 'Return\_FAQ\' and click on 'Return\_FAQ' Retriever </br>- Click on Save As New Version click **Activate** | |

#### 4b. Assign Contact Record Page as Org Default (5 minutes)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| Assign Contact Record Page as Org Default. |- Click on Setup</br>- Click on Object Manager</br>- Click on Contact</br>-  Click on Lightning Record Page</br>-  Click on Contact Record Page (API Name should be 'Contact_Record_Page')</br>- Click on Edit \-\> Click on Activation \-\> Click on 'Assign Org Default' (Desktop and phone) \-\> Click on Save  |![image](https://github.com/user-attachments/assets/57b4b1e1-7ff7-4dea-a34c-d5fc057ac248)![image](https://github.com/user-attachments/assets/09c1297f-1f72-4b90-8b12-1af7c0571733)![image](https://github.com/user-attachments/assets/949c0429-9c77-402d-afe3-6e11340a77f9)

#### 4c. Create a New Version of Omni-Channel Flow (10 minutes)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| Create a New Version of Omni-Channel Flow  |- Click on Setup</br>- Search for flow on Quick Button</br>- Click on Flow</br>- Click on the Flow</br>- Click on **Route To ESA** </br>- Deactivate the flow and click on the **Route To ESA** at the end</br>- Remove the Service channel and select some other option and then select “Live Message” again</br>- In Route To Select "Agentforce Service Agent"</br>- In Agentforce Service Agent Select "Agentforce Service Agent"</br>- Go to the Fallback Queue ID 🡪 Remove the Messaging Queue and add it back (same queue)</br>- Save as new version and activate the flow by clicking on the **Activate** button.  |![image](https://github.com/user-attachments/assets/4a56fa29-0fc7-42c8-9dae-c1ecf574418c)![image](https://github.com/user-attachments/assets/c380d226-9e77-4d4e-bb38-db3b68dcdf60)![image](https://github.com/user-attachments/assets/12ef770d-d575-455d-a179-390778618eca)![image](https://github.com/user-attachments/assets/e11361fd-f53b-4f7b-8713-7c222b379535)|

#### 4d. Access email Deliverability to all email (5 minutes)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
|  Access email Deliverability to all email | Click on Setup </br>- Search for ‘Deliverability’</br>- Change Access Email from ‘System email Only’ to ‘All email’.</br>- Click Save |![image](https://github.com/user-attachments/assets/77507363-6915-40ff-8443-ed89186f811c)


#### 4e. Prepare User (10 minutes) $${\color{blue} Optional: \space These \space steps \space are optional \space if \space you \space choose \space to \space use \space your \space own \space data. }$$
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| Prepare Test User |**Note: These steps apply to both existing and new contacts. Below is an example using Duncan** </br></br>To test Community functionality , please use : **Duncan Macintosh** contact to login as experience user </br> - Navigate to Setup </br>- In the Quick Find box, search for Digital Experiences</br>-Click on Settings under DigitalExperience </br>- Click the ‘Allow users standard external profiles for self-registration, user creation and login checkbox </br>- Click Okay and click Save </br> </br> **Enable Community User** </br> </br>- Click the App Launcher</br>- Select the Outfitters Retail app</br>- Navigate to the Contact of **Duncan Macintosh**</br>- Click the 'Enable as Customer' button (Goto classic page, if the button is not visible)</br>- Update the User License to Customer Community Profile</br>- Update the Profile to Outfitters Customer Profile</br>- Update the Email field to your personal email  </br>- Click Save </br></br> **Optional: Update Duncan’s email address in her contact record if you want to receive notifications. Otherwise, this step is not necessary.** </br></br>- Click the App Launcher </br>- Select the Outfitters Retail Trails app </br>- Navigate to the Contact of **Duncan Macintosh** </br>- Click the Edit button </br>- Update the Email field to your personal email </br>- Click Save  | ![image](https://github.com/user-attachments/assets/d82a699e-631d-4136-9d7f-ede27652e2d2)![image](https://github.com/user-attachments/assets/c009a09e-ed99-4ded-aa53-469c94a05a98)![image](https://github.com/user-attachments/assets/4767196d-0181-42e0-a074-5eebe8403dc8)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/Duncan1.png)![image](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/Duncan2.png)|

### 5. General Notes (30 minutes)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| General Notes for new community User | To test Community functionality , please use : **Duncan Macintosh contact** to login as experience user </br> **Note:** If user self register from experience site sign up page, admin needs to add below permission set to that new community user </br>- **Buyer** </br>- **Customer Community Plus Permissions**|![image (44)](https://github.com/user-attachments/assets/81cdd8a1-ce5a-469d-9004-48722f4caa02)|
|**Enable EPSessionIdHelper Visualforce Page**|</br>&emsp;- Log into Salesforce, click the gear icon in the top-right corner, and select Setup</br>&emsp;- In the Quick Find box, search for Visualforce Pages and select it.</br>&emsp;- Locate EPSessionIdHelper in the list.</br>&emsp;- Click the Security link next to the Visualforce page label</br>&emsp;- In the Available Profiles list, select the following profiles:</br>&emsp;&emsp;Einstein Agent User</br>&emsp;&emsp;Sunshine Resort Profile</br>&emsp;&emsp;System Administrator</br>&emsp;- Move them to the Enabled Profiles list using the arrow button</br>&emsp;- Click Save to apply the changes </br></br> 

### 6. Connected App Configuration (20 min)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
|Connected App Configuration |-In the Top Right, Click on the Profile Icon then Click on the Name of the profile(for e.g OrgFarm Epic), then click on User Details, after you land on User Detail Page, click Edit </br>-Change the Email Address Of Orgfram Epic User to your Email Id </br>-Wait for 5-10 minutes till your Email is Verified  </br>-Go to Setup, search App Manager, Click on App Manager Then, search for ‘GuestUserCometD’ Connected App, scroll to the Right, click on drop-down arrow button, click on View, once you are on Connected App Page, click on ‘Manage Consumer Details’ </br>-Copy the Consumer Key and Consumer Secret and Keep it in Notepad, we will be using them in the steps below. </br>-Perform the below script from anonymous window to get the Secret key and then store in Secret_Key__mdt -->Secret_Key__c Field **‘String secretKey = EncodingUtil.base64Encode(Crypto.generateAesKey(256)); System.debug('Generated Key: ' + secretKey);’** Metadata record name must be Label=HMAC_Secret, Client_Id__c = Consumer Key Client_Secret__c= Consumer Secret </br></br>-Search for the connected app again **‘GuestUserCometD’** </br>-From Setup Go to the connected app again ‘GuestUserCometD’ Scroll to the Right, click on drop-down arrow button, click on View, once you are on Connected App Page, click on ‘Manage’, Scroll down to **‘Client Credentials Flow’ as 'Run as user of Admin profile' Then Add the profiles in profile section of connected app "Einstein agent, system admin, outfitter profile"** and Save </br></br>-Go to Auth Provider Search for ‘GuestUserAuth’ Click on Edit and Paste the Consumer Secret and Consumer key that you have in your notepad, also If you are performing this in Sandbox change the Authorization Endpoint as [](https://test.salesforce.com/services/oauth2/authorize) and Authorization Token[](https://test.salesforce.com/services/oauth2/token ), if Performing in Production add the Authorization Endpoint as [](https://login.salesforce.com/services/oauth2/authorize) and Authorization Token[]( https://login.salesforce.com/services/oauth2/token ).</br>-Save the Auth Provider, from the same Auth Provider Scroll down to Salesforce Configuration Section, Copy the Callback URL  and Paste It in Notepad. </br>Go To Setup , Search App manager, Search for ‘GuestUserCometD’, Scroll to right Click on dropdown arrow and view, once you are in connected app, Click on Edit  Paste the callback URL you copied inThe Callback URL Field and Save the App </br>-Go to Setup Search for Named Credentials </br>-Search for GuestCometDNew1 And Click on Edit </br>-Update the URL to current org domain URL (Go to setup>>search>>MyDomain ) </br>-Save the Named Credentials and you will Get authenticated </br>-If you get an Error Wait for 10 minutes and Save the Named Credentials again. </br></br>-**Connected App Configuration 2** </br>-Go to Setup, search App Manager, Click on App Manager Then, search for ‘Data Cloud API’ Connected App Click on Manage Consumer Details </br>-Copy the Consumer Key, Consumer Secret and Keep it in Notepad, we will be using them in below steps. </br>-Go to Setup, search for Auth. Provider Auth Search for ‘Data_Cloud_Auth ‘Click on Edit and Paste the Consumer Secret and Consumer key that you have in your notepad, If you are performing this in Sandbox change the Authorization Endpoint as https://test.salesforce.com/services/oauth2/authorize and Authorization Token [](https://test.salesforce.com/services/oauth2/token ) </br>-if Performing in Production add the Authorization Endpoint as https://login.salesforce.com/services/oauth2/authorize and Authorization Token [](https://login.salesforce.com/services/oauth2/token) </br>-Save the Auth Provider, from the same Auth Provider Scroll down to Salesforce Configuration Section, Copy the Callback URL  and Paste It in Notepad. </br>-Go To Setup , Search App manager, Search for Data Cloud API, Scroll to right Click on dropdown arrow and view, once you are in connected app, Click on Edit  Paste the callback URL you copied inThe Callback URL Field and Save the App.   |     |

### 7. Named Credentials (10 min)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
|Named Credentials|-Search for Named Credentials </br>-In Named Credentials search for **‘GuestCometDNew1’** </br>-click on edit</br>-Update the URL to current org domain URL (Go to setup>>search>>MyDomain ) </br>-Save the Named Credentials and you will Get authenticated.</br>-If you get an Error Wait for 10 minutes and Save the Named Credentials again. </br></br>-Follow the same steps for named Credentials **DataCloud**|  ![Named Credentials1](https://git.soma.salesforce.com/gdevadoss/DataCloudAutomotiveDemo/blob/master/Finish%20Configuration%20Image/Named%20Credentials1.png)![Named Credentials2](https://git.soma.salesforce.com/gdevadoss/DataCloudAutomotiveDemo/blob/master/Finish%20Configuration%20Image/Named%20Credentials2.png)![Named Credentials3](https://git.soma.salesforce.com/gdevadoss/DataCloudAutomotiveDemo/blob/master/Finish%20Configuration%20Image/Named%20Credentials3.png)|

### 8. Tableau Dashboard 
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| Create Semantic Model |-Go to app launcher</br>-Click on Tableau Next </br>-Create a new folder and name it “Retail” </br>-Add following DMOS(Location Product Inventory, Product,Sales Order, Sales Order Product) </br>-Create Logical Views by joining all the above DMOS. | ![](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/Tableau1.png)  |
| Create Visualizations and Computed fields |-Create new Visualization on Return rate, sales performance and Inventory Dashboards. | ![](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/Tableau2.png) |
| Create Reports and Dashboards |-Create Sales Performance dashboard, Retail dashboard and Inventory Dashboards.| ![](https://git.soma.salesforce.com/gdevadoss/DataCloudRetailDemo/blob/master/Finish%20Configuration/Tableau3.png) |
</details>

<details><summary>

## 7. After Creating Self Registration User
</summary>
### $${\color{blue} \space Below \space Steps \space from \space 1a \space to \space 1c \space only \space need \space to \space perform \space after \space Creating \space self- \space registration \space user }$$

### 1a.  Add Membership into Account/contact as well snowflake after Self Registration Personal Account creation 
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
| Scenario 1: When Existing Membership Number value present in snowflake and user want to use it | - Go to App launcher>> Search for Data Explorer >> Select object type as data model>> Select Return Order </br> - Now Result will show under Customer Complaint column>> copy any of any of the value(eg:  RC-925126791)  </br> - Go to contact tab>> open recently created record via self registration form </br> - Edit Membership Number field and replace with new value. </br> - click on save </br> - Wait for 10 to 15 min so that Contact_Home data stream will refresh. </br> - Log in self registration created user in experience site and run your agentforce scenario| ![image](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/Self%20Registration/SelfRegis1.png)  ![image](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/Self%20Registration/SelfRegis2.png)  ![image](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/Self%20Registration/SelfRegis3.png)|
| Scenario 2: When Existing Membership Number value present in snowflake and user want to use it | - Go to contact tab>> open recently created record via self registration form </br> - Copy the Membership Number field value </br> - Same Membership Number need to present in snow flake : Download the below file, use the same format to create data entries, under And add the membership number from self registration created contact  under  Return Order File Column Customer Account </br> https://infosystechnologies-my.sharepoint.com/:x:/g/personal/sreeram_v01_ad_infosys_com/EX3SFbQeeIhKsI_sSrS8NvIBbmUtEPLsPrp9-Nw5W3QoQw?email=snehal.salve01%40infosys.com&wdOrigin=TEAMS-MAGLEV.p2p_ns.rwc&wdExp=TEAMS-TREATMENT&wdhostclicktime=1747143700048&web=1 </br> - Go to Snowflake>> under table RETURN_ORDER ,upload the file </br> - Download the below file, use the same format to create data entries, for Return Order Line Item </br> https://infosystechnologies-my.sharepoint.com/:x:/g/personal/sreeram_v01_ad_infosys_com/EX3SFbQeeIhKsI_sSrS8NvIBbmUtEPLsPrp9-Nw5W3QoQw?email=snehal.salve01%40infosys.com&wdOrigin=TEAMS-MAGLEV.p2p_ns.rwc&wdExp=TEAMS-TREATMENT&wdhostclicktime=1747143700048&web=1 </br> - Go to Snowflake>> under table RETURN_ORDER_ITEM ,upload the file </br> - Wait for 15 to 20 min to refresh  the data stream named as Third Party Survey. </br> - Go to App launcher>> Search for Data Explorer >> Select object type as data model>> Select Return Order Product>> Result will pop up, verify your new data entry </br> - Go to App launcher>> Search for Data Explorer >> Select object type as data model>> Select Return Order line>> Result will pop up , verify your new data entry </br> - Log in self registration created user in experience site and run your agentforce scenario. </br> Note: Before asking any questions to agentforce and copilot please wait 15 to 30 min for all data stream to be refresh so that you will see the data under contact 360  </br> 2. You can only create 1 self register users because we have only 5 license. | |

### 1b. Publish Segments and Calculated Insights
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
|  Publish Calculated Insights After Self Registration |  Go to App launcher>> Go to Data cloud>> Go to Calculated Insights>> open Average Purchase Value >> click on publish now.</br> - Go to Calculated Insights>> open Average Purchase Frequency >> click on publish now. </br> - Go to Calculated Insights>> open Customer Lifespan> click on publish now. </br> - Go to Calculated Insights>> open Customer Lifetime Value>> click on publish now. </br> - Go to Calculated Insights>> open RFM >> click on publish now. </br> - Go to Calculated Insights>> open Engagement Score >> click on publish now. </br> - Go to Calculated Insights>> open ProductCoBrowse Ranked >> click on publish now. |  ![image](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/Self%20Registration/CalculatedInsight1.png) ![image](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/Self%20Registration/CalculatedInsight2.png) ![image](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/Self%20Registration/CalculatedInsight3.png) ![image](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/Self%20Registration/CalculatedInsight4.png) ![image](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/Self%20Registration/CalculatedInsight5.png) ![image](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/Self%20Registration/CalculatedInsight6.png) ![image](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/Self%20Registration/CalculatedInsight7.png) |
| Publish Segment After Self Registration | Go to App launcher>> Go to Data cloud>> Go to Segments </br> - Click on Get Customers </br> - Click on Publish Now button and wait till Segment Status as Active. | ![image](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/Self%20Registration/Segment.png) |

### 1c.To enable real time for the new contact on Self Registration (5 min)
| Step  | Action and Details  |  Images |
| ----- | ----- | ----- |
|To enable real time for the new contact on Self Registration | Go to App launcher>> Go to Data Cloud>> Go to Identity Resolution </br> - Click on Customer Profile>>click on Run Ruleset button((once Status Succeeded then process with next step ) </br> Repeat the above step for Party Identification Match>> click on Run Ruleset button(Once Status Success then process with next step) </br> - Go to App launcher>> Enter Data Graphs>>Click on it >>Scroll to right of Web Engagement RT Profile data graph>> click on arrow >> click on Refresh Now and wait for Status Active </br> Repeat the above for Item Non – Real Data Graph>> Click on Refresh Now button and wait till get into Success Status. </br> - Go to Experience site>> login with newly created user from self registration form Click on product tab>>select any product  </br> - Go back to salesforce org and open Contact Record page to see the Real Time Product Details. |  ![image](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/Self%20Registration/Realtime1.png) ![image](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/Self%20Registration/Realtime2.png) ![image](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/Self%20Registration/Realtime3.png) ![image](https://github.com/vsreeram-salesforce/DataCloudRetailDemo/blob/main/Self%20Registration/Realtime4.png)|
</details>

<details><summary>
  
  ## Behind the Scenes - how is the agent powered?
</summary>
Curious to see the all the possible utterances  and how they are powered by the Agent. Here is a list of all the possible coversations, the corresponding topics and the components that power them. </br></br>
There are two contacts populated with all the relevant information to drive these conversations - Duncan Macintosh and Mark Smith. You can login to experience cloud as either of these contacts to have these full agent conversations.

$${\color{blue} Using \space the \space Agent \space to \space search \space for \space a \space hotel \space and \space create \space a \space reservation }$$

   | Sl. No. | Utterance | Behind the Scene | Topic | Components |
   | ----- | ----- | ----- | ----- | ----- |
   | 1.  | Greeting saying 'Hi' or 'Hello' | An Apex class accepts a ContactId, retrieves the associated Activation records to check for Recall Products. | First Interaction on Greeting | a. Apex </br>- ActivationAudienceResult. </br></br> b. Activation </br>-Get Recalled Customers |
   | 2.  | I am running a marathon next month can you suggest suitable shoes? | Based on the user's login status, we tailor the experience accordingly. For guest users, we gather preference details through a few questions before providing personalized footwear suggestions. Logged-in users receive direct marathon shoe recommendations based on their query and profile | Footwear Suggestion | a. Apex </br>- GuestUserShoeRecommendation. </br>- DisplayProductList. </br>- GuestORLoggedInUserCheck |
   | 3.  | The marathon is in Mexico | This is where we leverage WeatherAPI to analyze upcoming weather patterns for the next week and deliver tailored product recommendations based on forecast data |Weather Forecast | a. Apex </br>- CheckMexicoWeather </br></br> b. Platform Event </br>- WeatherBasedShoeFlyout__e  |
   | 4.  | How does this compare to my last shoes? | We use real-time browsing behavior and data graphs to identify the product the user is currently viewing. The system also queries the Product DMO and Sales_Order DMO based on the user's Contact ID via the agent. This enables retrieval of relevant product and purchase history. A prompt then generates a product comparison using both real-time and historical data. | Product Comparison | a. Flow </br>- Get Comparison Product Details. </br>- Call RT DG for CURRENT product. </br></br>b. Apex </br>-DisplayComparisonFlyout. </br></br>c. Prompt </br></br>-ShoeComparisonTemplate. </br></br>c.Platform Event </br>-ShoeComparisonPopup__e. |
   | 5.  | I'll  go with this which size should be good for me? | Looks at the Return_Order DMO based on the Contact ID of the user using the agent. | Size Recommendation Assistance | a. Flow </br>- Size Recommended From Return. |
   | 6.  | Are there any discount? | Looks at the Promotion DMO  and Promotion_Product DMO based on the ProductId of the user using the agent from Real-time. | Check for Discounts | a. Flow </br>- Check_For_Discount. </br>- Call RT DG for CURRENT product. |
   | 7.  | What is the Return Policy? | Reads unstructured data from PDFs that has been ingested into Data Cloud where it is chunked, vectorized and indexed for easy retrieval | Return Policy Details | a. Prompt </br>- Return Policy |
   | 8.  | I would like to place an order | The system authenticates the user to verify their validity as a contact before creating a record in the Sales_Order DMO based on the product the user is interested in. | Place New Order | a. Apex </br>- Get Customer Details by Messaging_Session. </br>-Place Order. </br>-Call RT DG for CURRENT product. |
   | 9.  | I am also interested in Homestead Domey 3 Tent | The system checks the ProductItem DMO to verify the availability of the product. If the product is unavailable, it suggests similar product options to the user. | Check Product Stock | a. Flow </br>- Check Product Availability </br></br> b.Apex </br>-GuestORLoggedInUserCheck. </br></br> c.Prompt Action </br>-Up Sell Products |
   | 10. | Where is my Order | Looks at the Sales_Order DMO based on the Contact ID of the user using the agent. | Order Enquiry | a. Flow </br>- Fetch_Recent_Order |
   | 11. | I would like to process a return | The system queries the Sales_Order DMO using the user's Contact ID to check the delivery status of the order. Based on the delivery status, it will prompt the user to generate a return label if applicable. | Return Request Assistance</br>Generate Return Label</br>| a. Flow </br>- Fetch Order Details for Returning. </br></br>b. Apex </br>-ReturnLabelEvent. </br></br>c.Platform Event</br>-returnLabelEvent__e|

</details>
