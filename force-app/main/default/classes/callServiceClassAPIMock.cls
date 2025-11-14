@isTest
global class callServiceClassAPIMock implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        if(req.getEndpoint().contains('segments')){
        	res.setBody('{"data":[{"deltaType":"existing","id":"e4a311d17e1aee320d8f2728e90db08d","snapshotType":"F","timestamp":"2025-11-12T11:03:43.909Z","versionStamp":"2025-11-12T06:55:38.344Z"}],"endTime":"2025-11-13T09:46:04.000Z","filter":"Delta_Type__c in ( new , existing )","limit":100,"offSet":0,"orderBy":"Id__c asc","rowCount":1,"startTime":"2025-11-13T09:46:04.000Z","totalCount":1}');
        }else if(req.getEndpoint().contains('queryv2')){
            res.setBody('{"data":[["{&quot;UnifiedssotIndividualReal-Id&quot;:&quot;e4a311d17e1aee320d8f2728e90db08d&quot;,&quot;EmailAddress&quot;:&quot;msmith@yopmail.com&quot;,&quot;SalesOrder&quot;:[{&quot;OrderNumber&quot;:&quot;00001497&quot;,&quot;SoldToCustomerId&quot;:&quot;0037y00000wOOj3AAG&quot;,&quot;Product&quot;:[{&quot;Recall&quot;:true,&quot;Product-Id&quot;:&quot;01t7y00000EuI0cAAF&quot;,&quot;Name&quot;:&quot;UltraRunBreeze&quot;}]},{&quot;OrderNumber&quot;:&quot;00001500&quot;,&quot;SoldToCustomerId&quot;:&quot;0037y00000wOOj3AAG&quot;,&quot;Product&quot;:[{&quot;Recall&quot;:true,&quot;Product-Id&quot;:&quot;01t7y00000EuIqDAAV&quot;,&quot;Name&quot;:&quot;UltraRunBreeze&quot;}]}],&quot;Segmented_Entity_Id__c&quot;:&quot;e4a311d17e1aee320d8f2728e90db08d&quot;}","e4a311d17e1aee320d8f2728e90db08d"]],"done":true,"endTime":"2025-11-13T09:46:05.490508410Z","metadata":{"Activated_Entity_Id__c":{"placeInOrder":1,"type":"VARCHAR","typeCode":12},"Activation_Record__c":{"placeInOrder":0,"type":"VARCHAR","typeCode":12}},"queryId":"MTAuMjguNTcuMjUxOjc0ODQ_30e037eb-6294-b190-d14f-5040d2dc9f68","rowCount":1,"startTime":"2025-11-13T09:46:05.426666834Z"}');
        }
        
        return res;
    }
}