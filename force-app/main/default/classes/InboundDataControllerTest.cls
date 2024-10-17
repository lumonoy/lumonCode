/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
@isTest
private class InboundDataControllerTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        LumonTestAdmin.setupAdminData();
        LumonTestRoleSettings.setupRoleSettingsForProfiles();
        LumonTestUsers.setupUserData();
        LumonTestPermissions.setupPermissionData();
        Test.stopTest();
    }   
    @TestVisible private static String consumerJson = [SELECT Body FROM StaticResource WHERE Name = 'orderMessage_consumer_batch1' ].Body.toString();
    @TestVisible private static String projectJson = [SELECT Body FROM StaticResource WHERE Name = 'orderMessage_project_batch1' ].Body.toString();

    @TestVisible private static InboundData.OrderMessage orderMessageConsumer {
        get{
            return InboundDataController.getOrderMessage(consumerJson);
        }
    }
    @TestVisible private static InboundData.OrderMessage orderMessageProject {
        get{
            return InboundDataController.getOrderMessage(projectJson);
        }
    }
    @TestVisible private static InboundData.OrderData orderDataConsumer {
        get{
            return orderMessageConsumer.orderData;
        }
    }
    @TestVisible private static InboundData.CustomerData customerDataConsumer {
        get{
            return orderDataConsumer.customerData;
        }
    }
    
    @IsTest
    static void getInboundDataTest(){  
        Test.startTest();
        InboundData inboundData = InboundDataController.getInboundData(consumerJson);
        System.Debug ('--- InboundDataControllerTest - getInboundDataTest '+inboundData);
        System.assertNotEquals(true,inboundData != NULL, ' Expected Data to be returned');
        System.debug('--- InboundDataControllerTest - getInboundDataTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataControllerTest - getInboundDataTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getOrderMessageTest(){  
        Test.startTest();
        InboundData.OrderMessage orderMessage = InboundDataController.getOrderMessage(consumerJson);
        System.Debug ('--- InboundDataControllerTest - getOrderMessageTest '+orderMessage);
        System.assertNotEquals(true,orderMessage != NULL, ' Expected Data to be returned');
        System.debug('--- InboundDataControllerTest - getOrderMessageTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataControllerTest - getOrderMessageTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getOrderDataTest(){ 
        InboundData.OrderMessage orderMessage = InboundDataController.getOrderMessage(consumerJson); 
        Test.startTest();
        InboundData.OrderData orderData = InboundDataController.getOrderData();
        System.Debug ('--- InboundDataControllerTest - getOrderDataTest '+orderData);
        System.assertNotEquals(true,orderData != NULL, ' Expected Data to be returned');
        System.debug('--- InboundDataControllerTest - getOrderDataTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataControllerTest - getOrderDataTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getCustomerDataTest(){  
        InboundData.OrderMessage orderMessage = InboundDataController.getOrderMessage(consumerJson); 
        InboundData.OrderData orderData = InboundDataController.getOrderData();
        Test.startTest();
        InboundData.CustomerData customerData = InboundDataController.getCustomerData();
        System.Debug ('--- InboundDataControllerTest - getCustomerDataTest '+customerData);
        System.assertNotEquals(true,customerData != NULL, ' Expected Data to be returned');
        String customerNumber = InboundDataController.getCustomerNumber();
        System.Debug ('--- InboundDataControllerTest - getCustomerNumberTest '+customerNumber);
        System.assertNotEquals(true,customerNumber != NULL, ' Expected Data to be returned');
        String customerName = InboundDataController.getCustomerName();
        System.Debug ('--- InboundDataControllerTest - getCustomerNameTest '+customerName);
        System.assertNotEquals(true,customerName != NULL, ' Expected Data to be returned');
        String customerId = InboundDataController.getCustomerName();
        System.Debug ('--- InboundDataControllerTest - getCustomerIdTest '+customerId);
        System.assertNotEquals(true,customerId != NULL, ' Expected Data to be returned');
        String customerCountry = InboundDataController.getCustomerCountryCode();
        System.Debug ('--- InboundDataControllerTest - getCustomerCountryCodeTest '+customerCountry);
        System.assertNotEquals(true,customerCountry != NULL, ' Expected Data to be returned');
        System.debug('--- InboundDataControllerTest - getCustomerDataTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataControllerTest - getCustomerDataTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getInvoicingDataTest(){  
        InboundData.OrderMessage orderMessage = InboundDataController.getOrderMessage(consumerJson); 
        InboundData.OrderData orderData = InboundDataController.getOrderData();
        Test.startTest();
        InboundData.InvoicingData invoicingData = InboundDataController.getInvoicingData();
        System.Debug ('--- InboundDataControllerTest - getInvoicingDataTest '+invoicingData);
        System.assertNotEquals(true,invoicingData != NULL, ' Expected Data to be returned');
        
        String customerNumber = InboundDataController.getCustomerNumber();
        System.Debug ('--- InboundDataControllerTest - getCustomerNumberTest '+customerNumber);
        System.assertNotEquals(true,customerNumber != NULL, ' Expected Data to be returned');
        String customerName = InboundDataController.getCustomerName();
        System.Debug ('--- InboundDataControllerTest - getCustomerNameTest '+customerName);
        System.assertNotEquals(true,customerName != NULL, ' Expected Data to be returned');
        String customerId = InboundDataController.getCustomerName();
        System.Debug ('--- InboundDataControllerTest - getCustomerIdTest '+customerId);
        System.assertNotEquals(true,customerId != NULL, ' Expected Data to be returned');
        String customerCountry = InboundDataController.getCustomerCountryCode();
        System.Debug ('--- InboundDataControllerTest - getCustomerCountryCodeTest '+customerCountry);
        System.assertNotEquals(true,customerCountry != NULL, ' Expected Data to be returned');
        System.debug('--- InboundDataControllerTest - getCustomerDataTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataControllerTest - getCustomerDataTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getCountryLookupTest(){  
        Test.startTest();
        Map<String,String> countryLookup = InboundDataController.getCountryLookup();
        System.Debug ('--- InboundDataControllerTest - getCountryLookupTest countryLookup '+countryLookup);
        System.assertNotEquals(true,countryLookup.isEmpty(), ' Expected Data to be returned');
        System.debug('--- InboundDataControllerTest - getCountryLookupTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataControllerTest - getCountryLookupTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getUserTest(){  
        String shortname = '';
        Test.startTest();
        User sfUser = InboundDataController.getUser(shortName);
        System.Debug ('--- InboundDataControllerTest - getUserTest sfUser '+sfUser);
        System.assertNotEquals(null,sfUser.Id, ' Expected Data to be returned');
        System.debug('--- InboundDataControllerTest - getUserTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataControllerTest - getUserTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getUserDataTest(){  
        InboundData.OrderMessage orderMessage = InboundDataController.getOrderMessage(consumerJson); 
        InboundData.OrderData orderData = InboundDataController.getOrderData();
        Test.startTest();
        InboundData.UserData userData = InboundDataController.getUserData();
        System.Debug ('--- InboundDataControllerTest - getUserDataTest '+userData);
        System.assertNotEquals(true,userData != NULL, ' Expected Data to be returned');
        User salesUser = InboundDataController.getSalesUser();
        System.Debug ('--- InboundDataControllerTest - getSalesUserTest salesUser '+salesUser);
        System.assertNotEquals(null,salesUser.Id, ' Expected Data to be returned');
        User servicesUser = InboundDataController.getServicesUser();
        System.Debug ('--- InboundDataControllerTest - getServicesUserTest servicesUser '+servicesUser);
        System.assertNotEquals(null,servicesUser.Id, ' Expected Data to be returned');
        Test.startTest();
        String userCountry = InboundDataController.getUserCountry();
        System.Debug ('--- InboundDataControllerTest - getUserCountryTest userCountry '+userCountry);
        System.assertNotEquals(null,userCountry, ' Expected Data to be returned');
        String userProfitCenter = InboundDataController.getUserProfitCenter();
        System.Debug ('--- InboundDataControllerTest - getUserProfitCenterTest userProfitCenter '+userProfitCenter);
        System.assertNotEquals(null,userProfitCenter, ' Expected Data to be returned');
        String userOffice = InboundDataController.getUserOffice();
        System.Debug ('--- InboundDataControllerTest - getUserOfficeTest userOffice '+userOffice);
        System.assertNotEquals(null,userOffice, ' Expected Data to be returned');
        System.debug('--- InboundDataControllerTest - getUserDataTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataControllerTest - getUserDataTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getCountryCodeTest(){  
        Test.startTest();
        String countryCode = InboundDataController.getCountryCode();
        System.Debug ('--- InboundDataControllerTest - getCountryCodeTest countryCode '+countryCode);
        System.assertNotEquals(null,countryCode, ' Expected Data to be returned');
        System.debug('--- InboundDataControllerTest - getCountryCodeTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataControllerTest - getCountryCodeTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }    
    @IsTest
    static void getCustomerTest(){
        InboundData.OrderMessage orderMessage = InboundDataController.getOrderMessage(consumerJson);
        InboundData.OrderData orderData = InboundDataController.getOrderData();
        System.Debug ('--- InboundDataControllerTest - getCustomerDataTest OrderData '+orderData);
        InboundData.CustomerData customerData = InboundDataController.getCustomerData();
        System.Debug ('--- InboundDataControllerTest - getCustomerDataTest customerData '+customerData);       
        String customerNumber = InboundDataController.getCustomerNumber();
        System.Debug ('--- InboundDataControllerTest - getCustomerTest customerNumber '+customerNumber);
        String customerName = InboundDataController.getCustomerName();
        System.Debug ('--- InboundDataControllerTest - getCustomerTest customerName '+customerName);   
        String customerId = InboundDataController.getCustomerId(); 
        System.Debug ('--- InboundDataControllerTest - getCustomerTest customerId '+customerId);
        String businessCode = InboundDataController.getBusinessType(); 
        System.Debug ('--- InboundDataControllerTest - getCustomerTest customer Segment '+businessCode);
        String customerCountryCode = InboundDataController.getCustomerCountryCode(); 
        System.Debug ('--- InboundDataControllerTest - getCustomerTest customer Country '+customerCountryCode);
        String customerSegment = InboundDataController.getCustomerSegment(); 
        System.Debug ('--- InboundDataControllerTest - getCustomerTest customer Business Code '+customerId);
        Test.startTest();

        Account customer = InboundDataController.getCustomerAccount();      
        System.Debug ('--- InboundDataControllerTest - getCustomerTest Account '+ customer);
        System.assertNotEquals(null,customer, ' Expected an Account to be returned');
        System.debug('--- InboundDataControllerTest - getCustomerTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataControllerTest - getCustomerTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getExistingAccountTest(){
        System.debug('--- InboundDataController - setCustomerAccount - Preparing B2B Account'); 
        Id B2BAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('B2B_Account').getRecordTypeId();
        Account existingAccountB2B = new Account(
                                            RecordTypeId = B2BAccountRecordTypeId,
                                            Name = 'Test B2B Customer 1',                                           
                                            AccountSource = 'Event',
                                            LanguagePreference__c = 'fi-FI',
                                            //CurrencyIsoCode = 'EUR',
                                            //OwnerId = ownerId,                                            
                                            BillingStreet = 'Street 1a',
                                            BillingPostalCode = '12345',
                                            BillingCity = 'Town',
                                            BillingCountryCode = 'FI',
                                            BillingState = '',
                                            BillingToShipping__c = true
                                            //ShippingCity= customerData.city;
                                            //ShippingCountryCode = countryCode;
                                            //ShippingPostalCode = customerData.postalCode;
                                            //ShippingStreet = customerData.street;
                                            );
        insert existingAccountB2B;
        System.Debug ('--- InboundDataControllerTest - getCustomerDataTest Existing B2B '+existingAccountB2B);
        Contact existingContactB2B = new Contact( 
                                            // Account Contact
                                            AccountId = existingAccountB2B?.Id,
                                            Firstname = 'Test',
                                            Lastname = 'Contact 1',
                                            Email = 'b2b.contact1@test.me',
                                            Phone = '000-1111111',
                                            Fax = '');
        insert existingContactB2B;
        System.Debug ('--- InboundDataControllerTest - getCustomerDataTest Existing B2B '+existingContactB2B);          
        InboundData.OrderMessage orderMessage = InboundDataController.getOrderMessage(projectJson);
        InboundData.OrderData orderData = InboundDataController.getOrderData();
        System.Debug ('--- InboundDataControllerTest - getCustomerDataTest OrderData '+orderData);
        InboundData.CustomerData customerData = InboundDataController.getCustomerData();
        System.Debug ('--- InboundDataControllerTest - getCustomerDataTest OrderData '+customerData);       
        String customerNumber = InboundDataController.getCustomerNumber();
        System.Debug ('--- InboundDataControllerTest - getCustomerTest customerNumber '+customerNumber);
        String customerName = InboundDataController.getCustomerName();
        System.Debug ('--- InboundDataControllerTest - getCustomerTest customerName '+customerName);   
        String customerId = InboundDataController.getCustomerId(); 
        System.Debug ('--- InboundDataControllerTest - getCustomerTest customerId '+customerId);
        String businessCode = InboundDataController.getBusinessType(); 
        System.Debug ('--- InboundDataControllerTest - getCustomerTest customer Segment '+businessCode);
        String customerCountryCode = InboundDataController.getCustomerCountryCode(); 
        System.Debug ('--- InboundDataControllerTest - getCustomerTest customer Country '+customerCountryCode);
        String customerSegment = InboundDataController.getCustomerSegment(); 
        System.Debug ('--- InboundDataControllerTest - getCustomerTest customer Business Coded '+customerId);
        Test.startTest();

        Account customer = InboundDataController.getCustomerAccount();      
        System.Debug ('--- InboundDataControllerTest - getCustomerTest Account '+ customer);
        System.assertNotEquals(null,customer, ' Expected an Account to be returned');
        System.debug('--- InboundDataControllerTest - getCustomerTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataControllerTest - getCustomerTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getProductDataTest(){  
        InboundData.OrderMessage orderMessage = InboundDataController.getOrderMessage(projectJson);
        InboundData.OrderData orderData = InboundDataController.getOrderData();
        Test.startTest();
        InboundData.ProductData productData = InboundDataController.getProductData();
        System.Debug ('--- InboundDataControllerTest - getProductDataTest '+productData);
        System.assertNotEquals(true,productData != NULL, ' Expected Data to be returned');
        System.debug('--- InboundDataControllerTest - getProductDataTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataControllerTest - getProductDataTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getProductsTest(){  
        InboundData.OrderMessage orderMessage = InboundDataController.getOrderMessage(projectJson);
        InboundData.OrderData orderData = InboundDataController.getOrderData();
        InboundData.ProductData productData = InboundDataController.getProductData();
        Test.startTest();
        List<InboundData.Product> products = InboundDataController.getProducts();
        System.Debug ('--- InboundDataControllerTest - getProductsTest '+products);
        System.assertNotEquals(0,products.size(), ' Expected Data to be returned');
        System.debug('--- InboundDataControllerTest - getProductsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataControllerTest - getProductsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }   
    @IsTest
    static void setProductAssetsTest(){
        InboundData.OrderMessage orderMessage = InboundDataController.getOrderMessage(projectJson);
        InboundData.OrderData orderData = InboundDataController.getOrderData();
        InboundData.CustomerData customerData = InboundDataController.getCustomerData();
        Test.startTest();
        List<Asset> productAssets = InboundDataController.setProductAssets();
        System.Debug ('--- InboundDataControllerTest - getCustomerDataTest OrderData '+orderData);
        System.assertNotEquals(0,productAssets.size(), ' Expected an Assets to be returned');
        System.debug('--- InboundDataControllerTest - setProductAssetsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataControllerTest - setProductAssetsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}