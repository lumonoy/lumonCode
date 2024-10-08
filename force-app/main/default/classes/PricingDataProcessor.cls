/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-15-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class PricingDataProcessor {
    public static PricingData deserialize(String pricingJSON) {  
        PricingData pricingDataMap;
        // Parse the JSON string into a generic Object
        try {
            pricingDataMap = (PricingData) JSON.deserialize(pricingJSON, (PricingData.class));
        } catch (exception e) {
            System.debug('--- PricingDataProcessor - deserializePricingJSON - Exception occured: '+e.getStackTraceString());
        }
        return pricingDataMap;
    }
    public static Map<String, Object> deserializeUnTyped(String pricingJSON) {  
        Map<String, Object> pricingDataMap = new Map<String, Object>();
        // Parse the JSON string into a generic Object
        try {
            pricingDataMap = (Map<String, Object>) JSON.deserializeUnTyped(pricingJSON);
        } catch (exception e) {
            System.debug('--- PricingDataProcessor - deserializePricingJSON - Exception occured: '+e.getStackTraceString());
        }
        return pricingDataMap;
    }  
    @AuraEnabled
    public static Map<String, Object> getColumnsAndData(String sObjectName, 
                                                        List<String> fieldNames, 
                                                        String parentRecordId, String recordId
    ) {
        try{
            Map<String, Schema.SObjectField> fieldsMap = Schema.describeSObjects(sObjectName.split(','))[0].fields.getMap();
            List<Object> columns = new List<Object>();

            for ( String fieldName: fieldNames ) {
                Schema.DescribeFieldResult fieldDescribeResult = fieldsMap.get( fieldName ).getDescribe();
                Map<String, Object> column = new Map<String, Object>{
                    'label' => fieldDescribeResult.getLabel(),
                    'fieldName' => fieldDescribeResult.getName(),
                    'type' => String.valueOf( fieldDescribeResult.getType() ).toLowerCase(),
                    'sortable'=>true
                };
                columns.add(column);
            }
            
            String selectClause = 'SELECT ' + String.join(fieldNames, ', ') + ' FROM ' + sObjectName;
            String whereClause;    
            if(String.isNotBlank(recordId)) {
                whereClause = ' WHERE Id =: recordId ';
            } else if(String.isNotBlank(parentRecordId)) {
                Id parentId = Id.valueOf(parentRecordId); 
                String sObjectParent = parentId.getSObjectType().getDescribe().getName();
                String parentObjectLookup;
                if (sObjectParent.contains('__c')) {
                    parentObjectLookup = sObjectParent.replace('__c','__r');
                } else {
                    parentObjectLookup = sObjectParent;
                }
                whereClause = ' WHERE '+parentObjectLookup+'.Id = :parentId';
            }
            String query = selectClause + whereClause;

            System.debug('*** DynamicQueryUtils - Query : '+query);
            List<SObject> records = Database.query(query );
            Map<String, Object> objectData = new Map<String, Object>{
                'columns' => columns,
                'rows' => records
            };
            System.debug('*** DynamicQueryUtils - Query Result: '+objectData);
            System.debug('*** DynamicQueryUtils - Query Result Columns: '+objectData.get('columns'));
            System.debug('*** DynamicQueryUtils - Query Result Rows: '+objectData.get('rows'));
            return objectData;
            
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static Map<String, Object> getPricingProducts(Map<String, Object> pricingDataMap) {  
        Map<String, Object> productMap = new Map<String, Object>();      
        // Define Lists
        List<Map<String, Object>> products = new List<Map<String, Object>>();
        // Get the list of products
        List<Object> listOfproducts = (List<Object>) pricingDataMap.get('products');
        // Loop through each product in the products list
        for (Object productObject: listOfproducts) {
            System.debug('--- PricingDataProcessor - getPricingProducts - product: '+productObject);
            productMap = (Map<String, Object>) productObject;
            Map<String, Object> cfgProduct = new Map<String, Object>();
            products.add(cfgProduct);    
            for (String fieldKey : productMap.keySet()) {
                Object fieldValue = productMap.get(fieldKey);
                System.debug('--- PricingDataProcessor - getPricingProducts - '+fieldKey+ ' => '+ fieldValue);
            } 
        }   
        return productMap;
    }   
        //List<Map<String, Object>> priceParameters = new List<Map<String, Object>>();
        //List<Map<String, Object>> productInspectMessageKeys = new List<Map<String, Object>>();
        //List<Map<String, Object>> reclaimedFeatureMessageKeys = new List<Map<String, Object>>();       
}