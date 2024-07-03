@isTest
private class BatchObjectApiControllerTest {

    @isTest
    static void testGetBatchRecords() {
      
        Course__c testCourses = new Course__c();
        
           testCourses.Name = 'TestCourse1';
           testCourses.Course_Code__c = '12345';
        
        insert testCourses;

        
        List<Batch__c> testRecords = new List<Batch__c>();
        for (Integer i = 0; i < 5; i++) {
            testRecords.add(new Batch__c(Name='Test Batch ' + i, Course__c = testCourses.Id));
        }
        insert testRecords;

        
        Test.startTest();
        List<Batch__c> result = BatchObjectApiController.GetBatchRecords();
        Test.stopTest();

        
       
        
    }
}