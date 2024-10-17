/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-02-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public class LumonTestBuildings {
    public class CustomException extends Exception {}
    @TestVisible public static List<Product2> mainProducts = LumonTestProducts.mainProducts;
    @TestVisible public static List<Account> accounts = LumonTestAccounts.accounts;
    @TestVisible public static Id b2cAccountId = LumonTestAccounts.b2cAccountId;
    @TestVisible public static Id b2bAccountId = LumonTestAccounts.b2bAccountId;
    @TestVisible public static List<Building__c> buildings{
        get{
            return [SELECT Id,Name FROM Building__c];
        }
    }
    /********** Building__c Data Setup ***********/
    public static void setupApartmentBuilding(){
        // Create Building__c of Record Type Building
        System.debug('--- LumonTestBuildings - setupBuilding - Building');
        Building__c building = new Building__c( Name='Apartment Building 1',
                                            //StreetAddress__c,
                                            PropertyType__c = 'APA',
                                            BuildingOwnedBy__c = b2cAccountId,
                                            NumberOfFloors__c = 3
                                            /*Building_Address__Street__s, 
                                            Building_Address__City__s, 
                                            Building_Address__PostalCode__s, 
                                            Building_Address__StateCode__s, 
                                            Building_Address__CountryCode__s, 
                                            Building_Address__Latitude__s, 
                                            Building_Address__Longitude__s, 
                                            Building_Address__GeocodeAccuracy__s, 
                                            Building_Address__c, 
                                            Building_Height__c, 
                                            Building_Location__c, 
                                            Number_of_Floors__c, 
                                            On_Hill_or_Slope__c, 
                                            Owned_By__c, 
                                            Property_Type__c,
                                            Terrain_Type__c, */
                                            );
        insert building;
        List<Apartment__c> apartments = new List<Apartment__c>();
        Integer unit = 1;
        for (Integer floor = 1; floor<5; floor++) {
            for (Integer line = 1; line<5; line++) {
                Apartment__c apartment = new Apartment__c( Name='Apartment Building 1',
                                            //StreetAddress__c,
                                            Building__c = building.Id, 
                                            ApartmentOwnedBy__c = b2cAccountId,
                                            Floor__c = String.Valueof(floor),
                                            Door__c = String.Valueof(unit),
                                            Line__c = String.Valueof(line)
                );
                apartments.add(apartment);
                unit++;
            }
        }
        if (apartments.size()>0) {
            insert apartments;
        }
        System.debug('--- LumonTestBuildings - setupApartmentBuilding - '+apartments.size()+ ' Apartments Created');
        System.debug('--- LumonTestBuildings - setupApartmentBuilding - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestBuildings - setupApartmentBuilding - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupSingleHouse(){
        // Create Building__c of Record Type Building
        System.debug('--- LumonTestBuildings - setupSingleHouse - Building');
        Building__c building = new Building__c( Name='Single House 1',
                                            //StreetAddress__c,
                                            PropertyType__c = 'APA',
                                            BuildingOwnedBy__c = b2cAccountId
                                            /*Building_Address__Street__s, 
                                            Building_Address__City__s, 
                                            Building_Address__PostalCode__s, 
                                            Building_Address__StateCode__s, 
                                            Building_Address__CountryCode__s, 
                                            Building_Address__Latitude__s, 
                                            Building_Address__Longitude__s, 
                                            Building_Address__GeocodeAccuracy__s, 
                                            Building_Address__c, 
                                            Building_Height__c, 
                                            Building_Location__c, 
                                            Number_of_Floors__c, 
                                            On_Hill_or_Slope__c, 
                                            Owned_By__c, 
                                            Property_Type__c,
                                            Terrain_Type__c, */
                                            );
        insert building;
        List<Apartment__c> apartments = new List<Apartment__c>();
        Integer unit = 1;
        Integer floor = 1;
        Integer door = 1;
        Integer line = 1;
        Apartment__c apartment = new Apartment__c( Name='Apartment Building 1',
                                            //StreetAddress__c,
                                            Building__c = building.Id, 
                                            ApartmentOwnedBy__c = b2cAccountId,
                                            Floor__c = String.Valueof(floor),
                                            Door__c = String.Valueof(unit),
                                            Line__c = String.Valueof(line)
                );
                apartments.add(apartment);
        if (apartments.size()>0) {
            insert apartments;
        }
        System.debug('--- LumonTestBuildings - setupSingleHouse - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestBuildings - setupSingleHouse - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupBuildingData(){ 
        if (accounts.size()>0) {
        } else {
            LumonTestAccounts.setupAccountData();
        }
        setupSingleHouse();
        setupApartmentBuilding();
        System.debug('--- LumonTestBuildings - Setup Buildings CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestBuildings - Setup Buildings SOQL USED: ' + LIMITS.getQueries());
        System.debug('--- LumonTestBuildings - Inserted '+buildings.size()+' Buildings'); 
    }  
    @TestSetup
    static void prepareData() {
        Test.startTest();
        Test.stopTest();
    }
    @Istest
    public static void setupBuildingDataTest(){
        String testResult;  
        Test.startTest();
        try {
            setupBuildingData();
            testResult = ('Inserted '+buildings?.size()+' Test Buildings');
            System.assertNotEquals(0,buildings?.size(), 'Expected Buildings to be Created');
            
        } catch (exception e){
            testResult =('Error when inserting Buildings: '+e.getMessage());
        }
        System.debug('--- LumonTestBuildings - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- LumonTestBuildings - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
        System.debug('--- LumonTestBuildings - Test Result = '+testResult);
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}