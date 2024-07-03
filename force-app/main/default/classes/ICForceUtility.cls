public class ICForceUtility {
    
    public static void upsertOppty(Opportunity o)
    {
        List<Opportunity> opties=new List<Opportunity>();
        List<Account_Payment_Information__c> apiLst= new List<Account_Payment_Information__c>();
        List<Account_Training_Information__c> atiLst= new List<Account_Training_Information__c>();   
        opties=[select Id from Opportunity where Batch__c=: o.Batch__c and AccountId=:o.AccountId and Course__c=:o.Course__c and Id!=: o.Id and Course__c!=null and Batch__c!=null];
        apiLst=[select Id from Account_Payment_Information__c where Batch__c=: o.Batch__c and Account__c=:o.AccountId and Course__c=:o.Course__c and Opportunity__c!=: o.Id and Course__c!=null and Batch__c!=null];
        atiLst=[select Id from Account_Training_Information__c where Batch__c=: o.Batch__c and Account__c=:o.AccountId and Course__c=:o.Course__c and Course__c!=null and Batch__c!=null];
        if(opties.size()>0 || apiLst.size()>0 || atiLst.size()>1 ){
            o.Name.addError('Error:Duplicate record exists for same Account,Course and Batch!!');
        }
        
    }
    public static void upsertAPI(Account_Payment_Information__c o)
    {
        List<Opportunity> opties=new List<Opportunity>();
        List<Account_Payment_Information__c> apiLst= new List<Account_Payment_Information__c>();
        List<Account_Training_Information__c> atiLst= new List<Account_Training_Information__c>();
        opties=[select Id from Opportunity where Batch__c=: o.Batch__c and AccountId=:o.Account__c and Course__c=:o.Course__c and Id!=: o.Opportunity__c and Course__c!=null and Batch__c!=null];
        apiLst=[select Id from Account_Payment_Information__c where Batch__c=: o.Batch__c and Account__c=:o.Account__c and Course__c=:o.Course__c and Opportunity__c=:o.Opportunity__c and Id!=:o.Id and Course__c!=null and Batch__c!=null];
        atiLst=[select Id from Account_Training_Information__c where Batch__c=: o.Batch__c and Account__c=:o.Account__c and Course__c=:o.Course__c and Course__c!=null and Batch__c!=null];
        if(opties.size()>0 || apiLst.size()>0 || atiLst.size()>1 ){
            o.Name.addError('Error:Duplicate record exists for same Account,Course,Batch and Opportunity!!');
        }
        
        else{
            //Create a map of all updating contact IDs and their related event IDs
            Map<Id, List<Event>> apiEvents = new Map<Id, List<Event>>();
            
            for(Event ev : [SELECT  WhatId, StartDateTime FROM Event WHERE  WhatId=:o.Id]) {
                //System.debug('Line 13: '+contactEvents.size()); This will always be 0 because we aren't adding anything to contactEvents before this..
                if(apiEvents.containsKey(ev.WhatId)) {
                    List<Event> eventId = apiEvents.get(ev.WhatId);
                    eventId.add(ev);
                    apiEvents.put(ev.WhatId, eventId);
                }
                else {
                    apiEvents.put(ev.WhatId, new List<Event> {ev});
                }
            }
            //Update this list at the end.
            List<Event> eventChanges = new List<Event>();
            
            // for(Account_Payment_Information__c api1 : apiLst) {
            // Account_Payment_Information__c oldapi1 = Trigger.oldMap.get(api1.Id);
            if(o.Next_Payment_Date__c == null) {
                if(apiEvents.containsKey(o.Id)) {
                    for(Event ev : apiEvents.get(o.Id)) {
                        eventChanges.add(ev);
                    }
                    for(Event ev : eventChanges) {
                        ev.StartDateTime = o.Next_Payment_Date__c;
                    }
                }
                delete eventChanges;
            }
            else{
                if(apiEvents.containsKey(o.Id)) {
                    for(Event ev : apiEvents.get(o.Id)) {
                        eventChanges.add(ev);
                    }
                    for(Event ev : eventChanges) {
                        ev.StartDateTime = o.Next_Payment_Date__c;
                    }
                }
                update eventChanges;
            }
            
            // }
        }
    }
    public static void upsertATI(Account_Training_Information__c o)
    {
        List<Opportunity> opties=new List<Opportunity>();
        List<Account_Payment_Information__c> apiLst= new List<Account_Payment_Information__c>();
        List<Account_Training_Information__c> atiLst= new List<Account_Training_Information__c>(); 
        opties=[select Id from Opportunity where Batch__c=: o.Batch__c and AccountId=:o.Account__c and Course__c=:o.Course__c and Course__c!=null and Batch__c!=null];
        apiLst=[select Id from Account_Payment_Information__c where Batch__c=: o.Batch__c and Account__c=:o.Account__c and Course__c=:o.Course__c and Course__c!=null and Batch__c!=null];
        atiLst=[select Id from Account_Training_Information__c where Batch__c=: o.Batch__c and Account__c=:o.Account__c and Course__c=:o.Course__c and Id!=:o.Id and Course__c!=null and Batch__c!=null];
        if(opties.size()>1 || apiLst.size()>1 || atiLst.size()>0 ){
            o.Name.addError('Error:Duplicate record exists for same Account,Course and Batch!!');
        }
    }
    public static void deleteOppty(Opportunity o){
        List<Account_Payment_Information__c> apiLst=[select Id from Account_Payment_Information__c where Opportunity__c=:o.Id];
        if(apiLst.size()>0){
            o.adderror('Opportunity cannot be deleted as it has related payment information');
        }
    }
    
    public static void deleteBatch(List<Batch__c> batchLst){
        Set<Id> batId = new Set<Id>();
        for(Batch__c bat : batchLst) {
            batId.add(bat.id);
        }
        
        Map<Id, Batch__c> mapPayment = new Map<Id, Batch__c>([Select Id, (select id, name from Opportunities__r), (Select Id, Name From Account_Payment_Information__r),(Select Id, Name From Account_Training_Information__r) from Batch__c where Id IN : batId]);
        for(Batch__c bat : batchLst) {
            System.debug('Batch == ' + mapPayment.get(bat.id));
            System.debug('Batch OPPTY == ' + mapPayment.get(bat.id).Opportunities__r.size());
            System.debug('Batch API == ' + mapPayment.get(bat.id).Account_Payment_Information__r.size());
            System.debug('Batch ATI == ' + mapPayment.get(bat.id).Account_Training_Information__r.size());
            if((mapPayment.get(bat.id).Opportunities__r.size() > 0)||(mapPayment.get(bat.id).Account_Payment_Information__r.size() > 0)||(mapPayment.get(bat.id).Account_Training_Information__r.size() > 0)) {
                bat.adderror('Batch cannot be deleted as it has related payment information or training information or opportunity');
            }
        }
    }
    
    public static void deleteCourse(List<Course__c> courseLst){
        Set<Id> couId = new Set<Id>();
        for(Course__c cou : courseLst) {
            couId.add(cou.id);
        }        
        Map<Id, Course__c> mapPayment = new Map<Id, Course__c>([Select Id, (Select Id, Name From Batch__r) from Course__c where Id IN : couId]);
        for(Course__c cou : courseLst) {
            if(mapPayment.get(cou.id).Batch__r.size() > 0) {
                cou.adderror('Course cannot be deleted as it has related Batches');
            }
        }
    }
}