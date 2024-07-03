@isTest
public class ICForceUtilityTest {
    @isTest static void upsertRecords(){
        Account acct= new Account(Name='Test Account');
        insert acct;
        Course__c course=new Course__c(Name='Test Course',Course_Code__c='TEST');
        insert course;
        Course__c course2=new Course__c(Name='Test Course2',Course_Code__c='TEST2');
        insert course2;
        Course__c course3=new Course__c(Name='Test Course3',Course_Code__c='TEST3');
        insert course3;
        Course__c course4=new Course__c(Name='Test Course4',Course_Code__c='TEST4');
        insert course4;
        Batch__c batch= new Batch__c(Course__c=course.id,Quarter__c='Q1',Batch_Month__c ='April',Batch_Type__c='Virtual',Year__c='2023-2024',Batch_Timing__c='Weekends Morning-WEM');
        insert batch;
        Batch__c batch2= new Batch__c(Course__c=course2.id,Quarter__c='Q4',Batch_Month__c ='March',Batch_Type__c='Virtual',Year__c='2023-2024',Batch_Timing__c='Weekends Morning-WEM');
        insert batch2;
        Batch__c batch3= new Batch__c(Course__c=course3.id,Quarter__c='Q1',Batch_Month__c ='April',Batch_Type__c='Virtual',Year__c='2023-2024',Batch_Timing__c='Weekends Morning-WEM');
        insert batch3;
        Batch__c batch4= new Batch__c(Course__c=course4.id,Quarter__c='Q4',Batch_Month__c ='March',Batch_Type__c='Virtual',Year__c='2023-2024',Batch_Timing__c='Weekends Morning-WEM');
        insert batch4;
        Opportunity oppty = new Opportunity(Name=acct.Name + ' Opportunity',StageName='Prospecting',CloseDate=System.today().addMonths(1),AccountId=acct.Id,Batch__c= batch.Id,Course__c=course.id);
        insert oppty;
        Opportunity oppty2 = new Opportunity(Name=acct.Name + ' Opportunity2',StageName='Prospecting',CloseDate=System.today().addMonths(1),AccountId=acct.Id,Batch__c= batch2.Id,Course__c=course2.id);
        insert oppty2;
        Opportunity oppty3 = new Opportunity(Name=acct.Name + ' Opportunity3',StageName='Prospecting',CloseDate=System.today().addMonths(1),AccountId=acct.Id,Batch__c= batch3.Id,Course__c=course3.id);
        insert oppty3;
        Account_Payment_Information__c api = new Account_Payment_Information__c(Account__c=acct.Id,Batch__c= batch.Id,Course__c=course.id,Opportunity__c=oppty.Id);
        insert api;
        Account_Payment_Information__c api2 = new Account_Payment_Information__c(Account__c=acct.Id,Batch__c= batch2.Id,Course__c=course2.id,Opportunity__c=oppty2.Id,Next_Payment_Date__c=System.today().addMonths(2));
        insert api2;
        Account_Training_Information__c ati = new Account_Training_Information__c(Account__c=acct.Id,Batch__c= batch.Id,Course__c=course.id);
        insert ati;
        Account_Training_Information__c ati2 = new Account_Training_Information__c(Account__c=acct.Id,Batch__c= batch2.Id,Course__c=course2.id);
        insert ati2;
        
        Test.startTest();
        
        ICForceUtility.upsertOppty(oppty);
        oppty2.Batch__c=batch2.Id;
        oppty2.Course__c=course2.Id;
        ICForceUtility.upsertOppty(oppty2);
        
        
        ICForceUtility.upsertAPI(api);
        api2.Batch__c=batch2.Id;
        api2.Course__c=course2.Id;
        ICForceUtility.upsertAPI(api2);
        ICForceUtility.deleteOppty(oppty2);
        delete oppty3;
        
        ICForceUtility.upsertATI(ati);
        ati2.Batch__c=batch2.Id;
        ati2.Course__c=course2.Id;
        ICForceUtility.upsertATI(ati2);
        
        List<Batch__c> batchTestLSt= new List<Batch__c>();
        batchTestLSt.add(batch);
        ICForceUtility.deleteBatch(batchTestLSt);
        
        List<Course__c> courseTestLSt= new List<Course__c>();
        courseTestLSt.add(course);
        ICForceUtility.deleteCourse(courseTestLSt);
        
        api.Next_Payment_Date__c=System.today().addMonths(6);
        ICForceUtility.upsertAPI(api);
       // List<Account_Payment_Information__c> apiLst=new List<Account_Payment_Information__c>();
      //  apiLst.add(api);
        ICForceUtility.upsertAPI(api);
        
        delete batch3;
        delete batch4;
        delete course4;
        
        Test.stopTest();
        
    }
}