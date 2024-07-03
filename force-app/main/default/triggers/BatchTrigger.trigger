trigger BatchTrigger on Batch__c (before delete) 
{
    if(Trigger.isBefore && Trigger.isDelete) {
        if(Trigger.old.size()==1){
            List<Batch__c> batchLSt=new List<Batch__c>();
            batchLSt.add(Trigger.old[0]);
            ICForceUtility.deleteBatch(batchLSt);
        }
        else{
            ICForceUtility.deleteBatch(Trigger.old);
        }
        
    } 
}