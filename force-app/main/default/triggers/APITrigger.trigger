trigger APITrigger on Account_Payment_Information__c (before insert,before update) {
    for(Account_Payment_Information__c o:Trigger.new)
    {    
        ICForceUtility.upsertAPI(o);
    }
}