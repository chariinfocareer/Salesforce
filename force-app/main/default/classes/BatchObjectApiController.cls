@RestResource(urlMapping='/BatchAPIrecords/*')
global with sharing class BatchObjectApiController {
    @HttpGet
    global static List<Batch__c> GetBatchRecords() {
            List<Batch__c>  records;
              records=  [SELECT Id, Name, Course_Name__c,Batch_AutoNum__c,Quarter__c,Training_Start_Date__c, 
              Training_End_Date__c,Year__c,Batch_Type__c,Batch_Month__c,Batch_Timing__c,Batch_Description__c FROM Batch__c 
              Where Publish__c = true ];
         //RestResponse res = RestContext.response;
 	//res.responseBody = Blob.valueOf(JSON.serialize(records));
 	//Blob b = Blob.valueOf(JSON.serialize(records));
        return records;
    }
}