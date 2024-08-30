public without sharing class DynamicQueryUtils {  
    // Get the Object Data using a Dynamic Query
    @AuraEnabled(cacheable=true)
    public static List<sObject> getObjectRecords(String sObjectName, List<String> fieldNameList, 
                                                  Integer limitSize, String recordId, 
                                                  String orderBy, String orderDir) {
        System.Debug('*** Dynamic Query Object: '+sObjectName);                                               
        System.Debug('*** Dynamic Query FieldNameList: '+fieldNameList);
        System.Debug('*** Dynamic Query RecordId: '+recordId); 
        OrderDir = String.isBlank(orderDir) ? 'asc' : orderDir;
        String fieldNameString = String.join(fieldNameList, ',');
        String queryString = ('SELECT '+fieldNameString+' FROM '+sObjectName);                                               
        if(String.isNotBlank(recordId)) {
            queryString += ' WHERE Id =: recordId ';
        }    
        if(String.isNotBlank(orderBy)) { 
            queryString += ' ORDER BY '+Orderby+' '+OrderDir+' NULLS LAST';  
        }                                             
        if(LimitSize != null && Integer.valueOf(LimitSize) > 0) {
            LimitSize = Integer.valueOf(LimitSize);
            queryString += ' LIMIT '+LimitSize;
        }
        System.Debug('*** Dynamic Query String '+queryString);
        List<sObject> queryResult =  Database.query(String.escapeSingleQuotes(queryString));  
        System.Debug('*** Dynamic Query Result: '+queryResult);  
        return queryResult;
    }
    @AuraEnabled(cacheable=true)
    public static List<sObject> getChildObjectRecords(String sObjectName, List<String> fieldNameList, 
                                                  Integer limitSize, String recordId, 
                                                  String orderBy, String orderDir) {
        System.Debug('*** Dynamic Query Object: '+sObjectName);                                               
        System.Debug('*** Dynamic Query FieldNameList: '+fieldNameList);
        System.Debug('*** Dynamic Query RecordId: '+recordId); 
        OrderDir = String.isBlank(orderDir) ? 'asc' : orderDir;
        String fieldNameString = String.join(fieldNameList, ',');
        String queryString = ('SELECT '+fieldNameString+' FROM '+sObjectName);                                               
        if(String.isNotBlank(recordId)) {
            Id parentRecordId = Id.valueOf(recordId); 
            String sObjectParent = parentRecordId.getSObjectType().getDescribe().getName();
            String parentObjectLookup;
            if (sObjectParent.contains('__c')) {
                parentObjectLookup = sObjectParent.replace('__c','__r');
            } else {
                parentObjectLookup = sObjectParent;
            }
            queryString += ' WHERE '+parentObjectLookup+'.Id =: recordId ';
        }    
        if(String.isNotBlank(orderBy)) { 
            queryString += ' ORDER BY '+Orderby+' '+OrderDir+' NULLS LAST';  
        }                                             
        if(LimitSize != null && Integer.valueOf(LimitSize) > 0) {
            LimitSize = Integer.valueOf(LimitSize);
            queryString += ' LIMIT '+LimitSize; 
        }
        System.Debug('*** Dynamic Query String '+queryString);
        List<sObject> queryResult =  Database.query(String.escapeSingleQuotes(queryString));  
        System.Debug('*** Dynamic Query Result: '+queryResult);  
        return queryResult;
    }
    @AuraEnabled(cacheable=true)
    public static List<sObject> getAllObjectRecords(String sObjectName, List<String> fieldNameList, 
                                                  Integer limitSize,
                                                  String orderBy, String orderDir) {
        System.Debug('*** Dynamic Query Object: '+sObjectName);                                               
        System.Debug('*** Dynamic Query FieldNameList: '+fieldNameList);
        OrderDir = String.isBlank(orderDir) ? 'asc' : orderDir;
        String fieldNameString = String.join(fieldNameList, ',');
        String queryString = ('SELECT '+fieldNameString+' FROM '+sObjectName);                                               
        if(String.isNotBlank(orderBy)) { 
            queryString += ' ORDER BY '+Orderby+' '+OrderDir+' NULLS LAST';  
        }                                             
        if(LimitSize != null && Integer.valueOf(LimitSize) > 0) {
            LimitSize = Integer.valueOf(LimitSize);
            queryString += ' LIMIT '+LimitSize;
        }
        System.Debug('*** Dynamic Query String '+queryString);
        List<sObject> queryResult =  Database.query(String.escapeSingleQuotes(queryString));  
        System.Debug('*** Dynamic Query Result: '+queryResult);  
        return queryResult;
    }
    @AuraEnabled(cacheable=true)
    public static List<sObject> getAllObjectRecordsGrouped(String sObjectName, List<String> fieldNameList, 
                                                  Integer limitSize, String groupBy,
                                                  String orderBy, String orderDir) {
        System.Debug('*** Dynamic Query Object: '+sObjectName);                                               
        System.Debug('*** Dynamic Query FieldNameList: '+fieldNameList);
        OrderDir = String.isBlank(orderDir) ? 'asc' : orderDir;
        String fieldNameString = String.join(fieldNameList, ',');
        String queryString = ('SELECT '+fieldNameString+' FROM '+sObjectName);                                               
        if(String.isNotBlank(groupBy)) { 
            queryString += ' GROUP BY '+fieldNameString;  
        }                              
        if(String.isNotBlank(orderBy)) { 
            queryString += ' ORDER BY '+Orderby+' '+OrderDir+' NULLS LAST';  
        }                        
        if(LimitSize != null && Integer.valueOf(LimitSize) > 0) {
            LimitSize = Integer.valueOf(LimitSize);
            queryString += ' LIMIT '+LimitSize;
        }
        System.Debug('*** Dynamic Query String '+queryString);
        List<sObject> queryResult =  Database.query(String.escapeSingleQuotes(queryString));  
        System.Debug('*** Dynamic Query Result: '+queryResult);  
        return queryResult;
    }
    @AuraEnabled(cacheable=true)
    public static List<sObject> getObjectRecordsCountedByRollup(String sObjectName, List<String> fieldNameList, 
                                                  Integer limitSize, String countField,String counter, String rollupGroup){
        System.Debug('*** Dynamic Query Object: '+sObjectName);                                               
        System.Debug('*** Dynamic Query FieldNameList: '+fieldNameList);
        String fieldNameString = String.join(fieldNameList, ',');
        String countString = 'Count('+countField+') '+counter;
        fieldNameString += ','+countString;
        String queryString = ('SELECT '+fieldNameString+' FROM '+sObjectName);                                               
        if(String.isNotBlank(rollupGroup)) { 
            queryString += ' GROUP BY ROLLUP ('+rollupGroup+')';  
        }                                                     
        if(LimitSize != null && Integer.valueOf(LimitSize) > 0) {
            LimitSize = Integer.valueOf(LimitSize);
            queryString += ' LIMIT '+LimitSize;
        }
        System.Debug('*** Dynamic Query String '+queryString);
        List<sObject> queryResult =  Database.query(String.escapeSingleQuotes(queryString));  
        System.Debug('*** Dynamic Query Result: '+queryResult);  
        return queryResult;
    }
}