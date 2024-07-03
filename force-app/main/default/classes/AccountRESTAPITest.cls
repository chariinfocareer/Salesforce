@isTest
private class AccountRESTAPITest {
    public class CustomTestException extends Exception {}
    @isTest
    static void testDoGet() {
        // Test case 1: Test with valid Account Id
        Account acc = new Account(Name = 'Test Account', Email1_Primary__c = 'test@example.com', Mobile1_Primary__c = '1234567890', 
        User_Type__c = 'RESIDENT INDIAN');
        insert acc;

        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/AccountAPI/' + acc.Id;
        RestContext.request = request;

        Account result = AccountRESTAPI.doGet();

        // Ensure result is not null
        if (result == null) {
            throw new CustomTestException('Result should not be null');
        }

        // Test case 2: Test with invalid Account Id
        request.requestURI = '/services/apexrest/AccountAPI/';
        RestContext.request = request;

        try {
            AccountRESTAPI.doGet();
            throw new CustomTestException('Expected exception not thrown');
        } catch (Exception e) {
            // Ensure correct exception is thrown
            if (!e.getMessage().contains('Account ID is required')) {
                throw new CustomTestException('Unexpected exception message');
            }
        }
    }

    @isTest
    static void testDoPost() {
        Account acc = new Account(Name = 'Test Account', Login_Status__c = 'Registered');
        insert acc;

        Opportunity o=new Opportunity();
        o.name='Test Oppty';
        o.AccountId=acc.Id;
        o.closeDate=System.today() + 5;
        o.StageName='Deck';
        insert o;

        Account acc1=[select id,Account_Id__c from account where Id=:acc.Id];
        // Test case 1: Test with valid parameters for updating Login Status
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/AccountAPI/';
        RestContext.request = request;
        RestContext.response = response;

        String result1 = AccountRESTAPI.doPost(acc1.Account_Id__c, 'LoginStatus', 'Registered', '','',null,null);
        String result2 = AccountRESTAPI.doPost(acc1.Account_Id__c, 'AccountKYCStatus', 'Approved', '','',null,null);
        String result3 = AccountRESTAPI.doPost(acc1.Account_Id__c, 'InvestmentKYCStatus', 'Approved', '','',null,null);
       // String result4 = AccountRESTAPI.doPost(acc1.Account_Id__c, 'KYCStatus', 'Submitted', '','',null,null);
        String result5 = AccountRESTAPI.doPost(acc1.Account_Id__c, 'NomineeKYCStatus', 'Submitted', '','',null,null);
        String result6 = AccountRESTAPI.doPost(acc1.Account_Id__c, 'PaymentStatus', 'Received', '','',null,null);

        // Ensure result is not null
        if (result1 == null) {
            throw new CustomTestException('Result should not be null');
        }

        // Test case 2: Test with invalid Account Id
        try {
            AccountRESTAPI.doPost('', 'LoginStatus', 'Registered', '','',null,null);
            throw new CustomTestException('Expected exception not thrown');
        } catch (Exception e) {
            // Ensure correct exception is thrown
            if (!e.getMessage().contains('AccountId is required')) {
                throw new CustomTestException('Unexpected exception message');
            }
        }

        // Add more test cases to cover other scenarios for doPost method
    }
}