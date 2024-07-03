trigger CourseTrigger on Course__c (before Delete) {
    
    if(Trigger.isBefore && Trigger.isDelete) {
       ICForceUtility.deleteCourse(Trigger.old);
    }
}