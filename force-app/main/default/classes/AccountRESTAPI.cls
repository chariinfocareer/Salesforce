@RestResource(urlMapping='/AccountAPI/*')
global with sharing class AccountRESTAPI {
    
 @HttpGet
    global static Account doGet() {
        RestRequest req = RestContext.request;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        if (String.isBlank(accountId) || accountId == 'AccountAPI') {
            throw new IllegalArgumentException('Account ID is required');
        }
        RestResponse res = RestContext.response;
        Account result = [SELECT Account_Id__c, User_Type__c, Name, Email1_Primary__c, Mobile1_Primary__c,Country_code__c FROM Account WHERE Id = :accountId LIMIT 1];
       	//system.debug('TEST == TEST');
        //String iso8601 = Datetime.now().format('yyyy-MM-dd HH:mm');
        return result;
    }

    @HttpPut
    global static String doPost(String AccountId, String statusType, String statusValue, String remarks,String paymentId,Double paymentAmount,Date paymentDate) {
        if (String.isBlank(AccountId)) {
            throw new IllegalArgumentException('AccountId is required');
        }

        Account existingAccount = [
            SELECT Id, Industry, Account_Id__c, Phone, Login_Status__c,Account_KYC_Status__c
            FROM Account 
            WHERE Account_Id__c = :AccountId 
            LIMIT 1
        ];
        
        Opportunity oppty = [
            SELECT Id, Name, Account_Id__c 
            FROM Opportunity 
            WHERE AccountId = :existingAccount.id 
            LIMIT 1
        ];

        if (existingAccount == null) {
            throw new IllegalArgumentException('Account not found with CustomerId: ' + AccountId);
        }
		boolean updated=false;
        if (statusType.equalsIgnoreCase('LoginStatus')) {
            existingAccount.Login_Status__c=statusValue;
            oppty.Login_Status__c = statusValue;
            updated=true;
        } 
        if (statusType.equalsIgnoreCase('AccountKYCStatus')) {
            existingAccount.Account_KYC_Status__c=statusValue;
            existingAccount.Account_KYC_Remark__c=remarks;
            oppty.Account_KYC_Status__c = statusValue;
           oppty.Account_KYC_Remark__c=remarks;
            system.debug('Remarks == ' + remarks);
                        updated=true;
        }
        if (statusType.equalsIgnoreCase('InvestmentKYCStatus')) {
            oppty.Investment_form_status__c = statusValue;
            oppty.Investment_KYC_Remark__c=remarks;
            system.debug('Remarks == ' + remarks);
                        updated=true;
        }
   
         if (statusType.equalsIgnoreCase('NomineeKYCStatus')) {
            oppty.Nominee_KYC_Status__c = statusValue;
             oppty.Nominee_KYC_Remark__c=remarks;
            system.debug('Remarks == ' + remarks);
                         updated=true;
        }
         if (statusType.equalsIgnoreCase('PaymentStatus')) {
            oppty.Payment_Status__c = statusValue;
             oppty.Payment_Remark__c=remarks;
             oppty.Payment_Amount__c=paymentAmount;
             oppty.Payment_Id__c=paymentId;
             oppty.Payment_Date__c=paymentDate;
            system.debug('Remarks == ' + remarks);
                         updated=true;
        }
       
        
        if(updated==false) {
            throw new IllegalArgumentException('Invalid status type');
        }
        update existingAccount;
        update oppty;
        return 'Account updated successfully for AccountId: ' + AccountId;
    }
}