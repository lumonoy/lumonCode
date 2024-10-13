/**
 * @description       : NOT IN USE ContentDocumentLinkTriggerHandler commented Out
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
private class ContentDocumentLinkTriggerHandlerTest {
    // Disabled 01.10.2024
    /*@IsTest
    static void testBehavior() {
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();

        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String uid = h.SubString(0,6);

        Account acc = new Account();
        acc.RecordTypeId = recordTypeId;
        acc.FirstName = 'Peter';
        acc.LastName = 'Griffin';
        acc.PersonEmail = uid + '@gmail.com';
        acc.PersonMailingCity = 'Helsinki';
        acc.PersonMailingCountry = 'Finland';
        acc.PersonMailingStreet = 'Spooner St. 31';
        acc.PersonMailingPostalCode = '00100';
        acc.BillingCountry ='Finland';
        acc.BillingCity='Helsinki';
        acc.BillingPostalCode = '00100';
        acc.BillingStreet = 'Spooner St. 31';
        insert acc;

        Id b2cRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('B2C_Opportunity').getRecordTypeId();

        Opportunity opp = new Opportunity();
        opp.RecordTypeId = b2cRecordTypeId;
        opp.AccountId = acc.Id;
        opp.Name = 'McTesterson OPPO';
        opp.StageName = 'Contract Signed';
        opp.Property_Type__c = 'APA';
        opp.LeadSource = 'Shows';
        opp.CloseDate = System.today() + 30;
        insert opp;

        ContentVersion contentVersion_1 = new ContentVersion(
                Title='contract_signed',
                PathOnClient ='contract_signed.pdf',
                versionData = Blob.valueOf('test file body')
        );
        insert contentVersion_1;
        ContentVersion contentVersion_2 = [
                SELECT
                    Id,
                    Title,
                    ContentDocumentId
                FROM ContentVersion
                WHERE Id = :contentVersion_1.Id
                LIMIT 1
        ];
        ContentDocumentLink contentLink = new ContentDocumentLink();
        contentLink.LinkedEntityId = opp.Id;
        contentLink.contentDocumentId = contentVersion_2.contentDocumentId;
        contentLink.ShareType = 'V';
        insert contentLink;
    }*/
}