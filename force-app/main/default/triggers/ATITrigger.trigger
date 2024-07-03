trigger ATITrigger on Account_Training_Information__c (before insert,before update) {
   for(Account_Training_Information__c o:Trigger.new)
    {    
        ICForceUtility.upsertATI(o);
    }
}