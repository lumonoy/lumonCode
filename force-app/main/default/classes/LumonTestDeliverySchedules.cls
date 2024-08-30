/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 04-28-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public class LumonTestDeliverySchedules {
    @TestVisible private static List<Delivery_Schedule__c> deliverySchedules{
        get{
            return [SELECT  Id, Country_Code__c, Postal_Code__c,
                            Delivery_Duration__c, Delivery_Days__c,Cargo_Multiplier__c,
                            Sunday__c, Monday__c,  Tuesday__c, Wednesday__c,Thursday__c, Friday__c,  Saturday__c      
                    FROM Delivery_Schedule__c ];
        }
    }
    public static List<Delivery_Schedule__c> setupDeliverySchedules(){
        // Load the test data from the static resource
        List<Delivery_Schedule__c> deliverySchedules = Test.loadData(Delivery_Schedule__c.sObjectType, 'TestdeliverySchedules');
        upsert deliverySchedules;
        return deliverySchedules;
    }
    public static List<Delivery_Schedule__c> setupDeliverySchedules(List<String> countryCodes){
        // Load the test data from the static resource
        List<Delivery_Schedule__c> deliverySchedules = Test.loadData(Delivery_Schedule__c.sObjectType, 'TestdeliverySchedules');
        List<Delivery_Schedule__c> deliverySchedulesToInsert = new List<Delivery_Schedule__c>();
        if ( deliverySchedules.size()>0){
            deliverySchedulesToInsert = deliverySchedules;
            for (Delivery_Schedule__c schedule : deliverySchedules) {
                if (countryCodes.contains(schedule.Country_Code__c)){
                    deliverySchedulesToInsert.add(Schedule);
                }
            }
        }
        if ( deliverySchedulesToInsert.size()>0){
            insert deliverySchedulesToInsert;
        }
        return deliverySchedulesToInsert;
    }
    public static List<Delivery_Schedule__c> setupDeliverySchedules(List<String> countryCodes, List<String> postalCodes){
        // Load the test data from the static resource
        List<Delivery_Schedule__c> deliverySchedules = Test.loadData(Delivery_Schedule__c.sObjectType, 'TestDeliverySchedules');
        List<Delivery_Schedule__c> deliverySchedulesToInsert = new List<Delivery_Schedule__c>();
        if ( deliverySchedules.size()>0){
            deliverySchedulesToInsert = deliverySchedules;
            for (Delivery_Schedule__c schedule : deliverySchedules) {
                if (countryCodes.contains(schedule.Country_Code__c)){
                    if (postalCodes.contains(schedule.Postal_Code__c)){
                        deliverySchedulesToInsert.add(Schedule);
                    }
                }
            }
        }
        if ( deliverySchedulesToInsert.size()>0){
            insert deliverySchedulesToInsert;
        }
        return deliverySchedulesToInsert;
    }
}