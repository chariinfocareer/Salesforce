trigger OpptyTrigger on Opportunity (before insert,before update,before delete) {
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Opportunity o:Trigger.new)
        {
            ICForceUtility.upsertOppty(o);
        } 
    }
    else if(Trigger.isBefore && Trigger.isDelete){
        for(Opportunity o:Trigger.old)
        {
            ICForceUtility.deleteOppty(o);
        }   
    }
}