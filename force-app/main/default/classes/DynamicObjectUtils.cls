/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
public class DynamicObjectUtils {
    @AuraEnabled(cacheable=true)
    public static String getObjectType(String IdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            String recordIdPrefix = String.valueOf(IdOrPrefix).substring(0,3);     
            System.debug('--- Dynamic Object Utils - Prefix from Input ' + recordIdPrefix);           
            //Get schema information
            Map<String, Schema.SObjectType> sObjectDescribeSchema =  Schema.getGlobalDescribe(); 
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType sObjType : sObjectDescribeSchema.values()){
                //if (!sObjType.contains('__')) to exclude managed package objects
                Schema.DescribeSObjectResult sObjectDescribeResult = sObjType.getDescribe();

                String objectTypePrefix = sObjectDescribeResult.getKeyPrefix();
                //System.debug('--- Dynamic Object Utils - ObjectType '+sObjectDescribeResult.getName()+' has prefix ' + objectTypePrefix);    
                //Check if the prefix matches with requested prefix
                if(objectTypePrefix!=null && objectTypePrefix.equals(recordIdPrefix)){
                    objectName = sObjectDescribeResult.getName();
                    System.debug('--- Dynamic Object Utils - Object Name ' + objectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }
    //@AuraEnabled(cacheable=true)
    public static Map<String,Schema.SObjectField> getObjectFields(String sObjectName) {
        System.Debug ('--- Dynamic Object Utils - Get '+sObjectName+ ' Fields');
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(sObjectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> describeSObjectfieldsMap = describeSObjectResultObj.fields.getMap();
        // Loop Through FieldSet Keys
        for (String fieldKey : describeSObjectfieldsMap.keySet()) {
            System.debug('--- Dynamic Object Utils - Field: '+ fieldKey);          
        }
        System.debug('--- Dynamic Object Utils - Map : '+ describeSObjectfieldsMap);    
        System.debug('--- Dynamic Object Utils - Fields Map size: '+ describeSObjectfieldsMap.size());
        System.debug('--- Dynamic Object Utils - getObjectFields CPU TIME: '+LIMITS.getCpuTime());     
        return describeSObjectfieldsMap;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getObjectFieldLabels(String sObjectName) {
        System.Debug ('--- Dynamic Object Utils - Get '+sObjectName+ ' Fields');
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(sObjectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> describeSObjectfieldsMap = describeSObjectResultObj.fields.getMap();
        
        Map<String, Schema.FieldSetMember> fieldSetSchema = new Map<String, Schema.FieldSetMember>();
        Map<String,String> fieldsMap=new Map<String,String>();
        // Loop Through FieldSet Keys
        for (String fieldKey : describeSObjectfieldsMap.keySet()) {
            String fieldLabel= describeSObjectfieldsMap.get(fieldKey).getDescribe().getLabel();
            System.debug('--- Dynamic Object Utils - Field: '+ fieldKey);
            System.debug('--- Dynamic Object Utils - Label : '+ fieldLabel);
            fieldsMap.put(fieldKey, fieldLabel);       
        }     
        System.debug('--- Dynamic Object Utils - Fields Map size: '+ fieldsMap.size());
        System.debug('--- Dynamic Object Utils - getObjectFieldLabels CPU TIME: '+LIMITS.getCpuTime());     
        return fieldsMap;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getObjectFieldTypes(String sObjectName) {
        System.Debug ('--- Dynamic Object Utils - Get '+sObjectName+ ' Fields');
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(sObjectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> describeSObjectfieldsMap = describeSObjectResultObj.fields.getMap();
        
        Map<String, Schema.FieldSetMember> fieldSetSchema = new Map<String, Schema.FieldSetMember>();
        Map<String,String> fieldsMap=new Map<String,String>();
        // Loop Through FieldSet Keys
        for (String fieldKey : describeSObjectfieldsMap.keySet()) {
            Schema.DisplayType fieldDisplayType= describeSObjectfieldsMap.get(fieldKey).getDescribe().getType();
            String fieldType =  String.valueOf(fieldDisplayType);
            System.debug('--- Dynamic Object Utils - Field: '+ fieldKey);
            System.debug('--- Dynamic Object Utils - Type : '+ fieldType);
            fieldsMap.put(fieldKey, fieldType);       
        }     
        System.debug('--- Dynamic Object Utils - Fields Map size: '+ fieldsMap.size());
        System.debug('--- --- Dynamic Object Utils - getObjectFieldTypes CPU TIME: '+LIMITS.getCpuTime());     
        return fieldsMap;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getObjectFieldSets(String sObjectName) {
        System.Debug ('--- Dynamic Object Utils - Get '+sObjectName+ ' Fieldsets');
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
    	Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(sObjectName);
    	Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.FieldSet> describeSObjectfieldSetMap = describeSObjectResultObj.fieldSets.getMap();
        Map<String, Schema.FieldSetMember> fieldSetSchema = new Map<String, Schema.FieldSetMember>();
        Map<String,String> fieldSetsMap=new Map<String,String>();
        // Loop Through FieldSet Keys
        for (String fieldSetKey : DescribeSObjectfieldSetMap.keySet()) {
            Schema.FieldSet describeSObjectfieldSetObj = describeSObjectfieldSetMap.get(fieldSetKey); 
            Schema.FieldSet fieldSetValue = describeSObjectfieldSetMap.get(fieldSetKey);
            String fieldSetName= describeSObjectfieldSetObj.getName();
            String fieldSetLabel= describeSObjectfieldSetObj.getLabel();
            fieldSetsMap.put(fieldSetKey, fieldSetLabel);       
        }     
        System.debug('--- Dynamic Object Utils - Fieldsets Map size: '+ fieldSetsMap.size());
        System.debug('--- Dynamic Object Utils - getObjectFieldSets CPU TIME: '+LIMITS.getCpuTime());
        return fieldSetsMap;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getObjectFieldSet(String sObjectName,String matchString) {
        System.Debug ('--- Dynamic Object Utils - Get '+sObjectName+ ' Fieldsets with match to '+matchString);
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
    	Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(sObjectName);
    	Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.FieldSet> describeSObjectfieldSetMap = describeSObjectResultObj.fieldSets.getMap();
        Map<String, Schema.FieldSetMember> fieldSetSchema = new Map<String, Schema.FieldSetMember>();
        Map<String,String> fieldSetsMap=new Map<String,String>();
        // Loop Through FieldSet Keys
        for (String fieldSetKey : DescribeSObjectfieldSetMap.keySet()) {
            Schema.FieldSet describeSObjectFieldSetObj = DescribeSObjectfieldSetMap.get(fieldSetKey); 
            String fieldSetName= DescribeSObjectfieldSetObj.getName();
            String fieldSetLabel= DescribeSObjectfieldSetObj.getLabel();
            If (fieldSetName.toLowercase().contains(matchString.toLowercase())) {  
            	fieldSetsMap.put(fieldSetKey, fieldSetLabel);   
            }
        }     
        System.debug('--- Dynamic Object Utils Fieldsets Map size: '+ fieldSetsMap.size());
        return fieldSetsMap;
    }  
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getObjectFieldSetFields(String sObjectName,String matchString) {
        System.Debug ('--- Dynamic Object Utils - Get '+sObjectName+ ' Fieldset with match to '+matchString);
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
    	Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(sObjectName);
    	Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.FieldSet> describeSObjectfieldSetMap = describeSObjectResultObj.fieldSets.getMap();
        Map<String, Schema.FieldSetMember> fieldSetFieldSchema = new Map<String, Schema.FieldSetMember>();
        Map<String, String> fieldSetFieldMap = New Map<String, String>();

        System.debug('--- Dynamic Object Utils Find Fieldset Match to '+matchString);
        // Loop Through FieldSets using the KeySet
        for (String fieldSetKey : describeSObjectfieldSetMap.keySet()) {
            Schema.FieldSet describeSObjectFieldSetObj = DescribeSObjectfieldSetMap.get(fieldSetKey); 
            String fieldSetName= DescribeSObjectfieldSetObj.getName();
            String fieldSetLabel= DescribeSObjectfieldSetObj.getLabel();

            If (fieldSetName.toLowercase().contains(matchString.toLowercase())) {  
                for(Schema.FieldSetMember f : describeSObjectFieldSetObj.getFields()) {
                    // add to FieldSetsMemberMap
                    fieldSetFieldSchema.put(fieldSetKey, f);                 
                    String fieldSetFieldPath = f.getFieldPath();
                    String fieldSetFieldLabel = f.getLabel();   
                    fieldSetFieldMap.put(fieldSetFieldPath, fieldSetFieldLabel);         
                }
            }            
        }
        System.debug('--- Dynamic Object Utils matching Fieldset Field Count: '+fieldSetFieldMap.size());  
        return fieldSetFieldMap;
    }//OK, has Test
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getAddressFields(String sObjectName) {
        System.Debug ('--- Dynamic Object Utils Get '+sObjectName+ ' Address Fields');
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(sObjectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> describeSObjectfieldsMap = describeSObjectResultObj.fields.getMap();
        
        Map<String, Schema.FieldSetMember> fieldSetSchema = new Map<String, Schema.FieldSetMember>();
        Map<String,String> addressFieldsMap=new Map<String,String>();
        // Loop Through FieldSet Keys
        for (String fieldKey : describeSObjectfieldsMap.keySet()) {
            Schema.DisplayType fieldDisplayType= describeSObjectfieldsMap.get(fieldKey).getDescribe().getType();
            String fieldType =  String.valueOf(fieldDisplayType);
            if (fieldType == 'Address') {
                String fieldLabel= describeSObjectfieldsMap.get(fieldKey).getDescribe().getLabel();
                System.debug('--- Dynamic Object Utils - Address Field: '+ fieldKey);
                System.debug('--- Dynamic Object Utils - Editable Field Label : '+ fieldLabel);        
                addressFieldsMap.put(fieldKey, fieldLabel);     
            }  
        }        
        System.debug('--- Dynamic Object Utils - Address Fields Map size: '+ addressFieldsMap.size());
        System.debug('--- Dynamic Object Utils - getAddressFields CPU TIME: '+LIMITS.getCpuTime());     
        return addressFieldsMap;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getRequiredFields(String sObjectName) {
        System.Debug ('--- Get '+sObjectName+ ' Fields');
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(sObjectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> describeSObjectfieldsMap = describeSObjectResultObj.fields.getMap();
        
        Map<String, Schema.FieldSetMember> fieldSetSchema = new Map<String, Schema.FieldSetMember>();
        Map<String,String> requiredFieldsMap=new Map<String,String>();
        // Loop Through FieldSet Keys
        for (String fieldKey : describeSObjectfieldsMap.keySet()) {
            Boolean isRequiredField = describeSObjectfieldsMap.get(fieldKey).getDescribe().isUpdateable();
            String fieldLabel= describeSObjectfieldsMap.get(fieldKey).getDescribe().getLabel();
            if (isRequiredField) { // IsRequired is NOT nillable
            System.debug('--- Dynamic Object Utils - Required Field: '+ fieldKey);
            System.debug('--- Dynamic Object Utils - Required Field Label : '+ fieldLabel);
            requiredFieldsMap.put(fieldKey, fieldLabel);     
            }  
        }     
        System.debug('--- Dynamic Object Utils - Required Fields Map size: '+ requiredFieldsMap.size());
        System.debug('--- Dynamic Object Utils - getRequiredFields CPU TIME: '+LIMITS.getCpuTime());     
        return requiredFieldsMap;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getUniqueFields(String sObjectName) {
        System.Debug ('--- Get '+sObjectName+ ' Unique Fields');
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(sObjectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> describeSObjectfieldsMap = describeSObjectResultObj.fields.getMap();
        System.Debug ('--- Found '+describeSObjectfieldsMap.size()+ ' Fields');        
        Map<String, Schema.FieldSetMember> fieldSetSchema = new Map<String, Schema.FieldSetMember>();
        Map<String,String> uniqueFieldsMap=new Map<String,String>();
        System.Debug ('--- Found '+uniqueFieldsMap.size()+ ' Unique Fields');
        System.Debug ('--- Found '+uniqueFieldsMap.size()+ ' Unique Fields');
        // Loop Through FieldSet Keys
        for (String fieldKey : describeSObjectfieldsMap.keySet()) {
            Boolean isIdentierField = describeSObjectfieldsMap.get(fieldKey).getDescribe().isUnique();
            String fieldLabel= describeSObjectfieldsMap.get(fieldKey).getDescribe().getLabel();
            if (isIdentierField) { // Unique Fields can be used as Identifiers
            System.debug('--- Dynamic Object Utils -  Identifier Field: '+ fieldKey);
            System.debug('--- Dynamic Object Utils -  Identifier Field Label : '+ fieldLabel);
            uniqueFieldsMap.put(fieldKey, fieldLabel);     
            }  
        }     
        System.debug('--- Dynamic Object Utils -  Identifier Fields Map size: '+ uniqueFieldsMap.size());
        System.debug('--- Dynamic Object Utils -  getIdentifierFields CPU TIME: '+LIMITS.getCpuTime());     
        return uniqueFieldsMap;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getEditableFields(String sObjectName) {
        System.Debug ('--- Dynamic Object Utils Get '+sObjectName+ ' Fields');
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(sObjectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> describeSObjectfieldsMap = describeSObjectResultObj.fields.getMap();
        
        Map<String, Schema.FieldSetMember> fieldSetSchema = new Map<String, Schema.FieldSetMember>();
        Map<String,String> editableFieldsMap=new Map<String,String>();
        // Loop Through FieldSet Keys
        for (String fieldKey : describeSObjectfieldsMap.keySet()) {
            Boolean isEditableField = describeSObjectfieldsMap.get(fieldKey).getDescribe().isUpdateable();
            String fieldLabel= describeSObjectfieldsMap.get(fieldKey).getDescribe().getLabel();
            if (isEditableField) { 
            System.debug('--- Dynamic Object Utils - Editable Field: '+ fieldKey);
            System.debug('--- Dynamic Object Utils - Editable Field Label : '+ fieldLabel);
            editableFieldsMap.put(fieldKey, fieldLabel);     
            }  
        }     
        System.debug('--- Dynamic Object Utils - Editable Fields Map size: '+ editableFieldsMap.size());
        System.debug('--- Dynamic Object Utils - getEditableFields CPU TIME: '+LIMITS.getCpuTime());     
        return editableFieldsMap;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getLookupFields(String sObjectName) {
        System.Debug ('--- Dynamic Object Utils - Get '+sObjectName+ ' Fields');
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(sObjectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> describeSObjectfieldsMap = describeSObjectResultObj.fields.getMap();
        
        Map<String, Schema.FieldSetMember> fieldSetSchema = new Map<String, Schema.FieldSetMember>();
        Map<String,String> lookupFieldsMap=new Map<String,String>();
        // Loop Through FieldSet Keys
        for (String fieldKey : describeSObjectfieldsMap.keySet()) {
            Boolean isLookupField = describeSObjectfieldsMap.get(fieldKey).getDescribe().isIdLookup();
            String fieldLabel= describeSObjectfieldsMap.get(fieldKey).getDescribe().getLabel();
            if (isLookupField) { // Unique Fields can be used as Identifiers
            System.debug('--- Dynamic Object Utils - Lookup Field: '+ fieldKey);
            System.debug('--- Dynamic Object Utils - Lookup Field Label : '+ fieldLabel);
            lookupFieldsMap.put(fieldKey, fieldLabel);     
            }  
        }     
        System.debug('--- Dynamic Object Utils - Lookup Fields Map size: '+ lookupFieldsMap.size());
        System.debug('--- Dynamic Object Utils - getLookupFields CPU TIME: '+LIMITS.getCpuTime());     
        return lookupFieldsMap;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getObjectRelations(String sObjectName) {
        System.Debug ('--- Dynamic Object Utils - Get '+sObjectName+ ' Relationships');
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
    	Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(sObjectName);
    	Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        List<Schema.ChildRelationship> childRelations = describeSObjectResultObj.getChildRelationships();
        Map<String, Schema.ChildRelationship> describeSObjectRelationsMap = new Map<String, Schema.ChildRelationship>();
        Map<String,String> childRelationsMap = new Map<String,String>();
        // Loop Through FieldSet Keys
        for (Schema.ChildRelationship childRelation : childRelations) {
            System.debug('--- Dynamic Object Utils - childRelation: '+ childRelation);
            String childObject = String.valueOf( childRelation.getChildSObject());  
            System.debug('--- Dynamic Object Utils - childObject: '+ childObject);
            childRelationsMap.put(childObject, childObject);   
        }     
        System.debug('--- Dynamic Object Utils - childRelations size: '+ childRelations.size());
        System.debug('--- Dynamic Object Utils - getObjectRelations CPU TIME: '+LIMITS.getCpuTime());
        return childRelationsMap;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getObjectRelationType(String sObjectName1, String sObjectName2) {
        System.Debug ('--- Dynamic Object Utils - Get '+sObjectName1+ ' and '+sObjectName2+' Relationship');

        Schema.SObjectType sObjectTypeObj1 = Schema.getGlobalDescribe().get(sObjectName1);
        Schema.SObjectType sObjectTypeObj2 = Schema.getGlobalDescribe().get(sObjectName2);
        Map<String,String> parentChildMap=new Map<String,String>();
        for(Schema.ChildRelationship child1 : sObjectTypeObj1.getDescribe().getChildRelationships()) 
        {   String childName = child1.getChildSObject().getDescribe().getName();
            System.debug('--- Dynamic Object Utils - Child1: '+childName);
            String childRelation = child1.getRelationshipName();
            System.debug('--- Dynamic Object Utils - Relation: '+childRelation);             
            String parentName = sObjectTypeObj2.getDescribe().getName();
            System.debug('--- Dynamic Object Utils - Parent: '+parentName);
            if (childName == parentName && childRelation != null) {
                System.debug('--- Dynamic Object Utils - Object1 '+ sObjectName1+' relates to Object2 '+ sObjectName2);
                parentChildMap.put('parent', sObjectName1); 
                parentChildMap.put('child', sObjectName2); 
            } 
        }
        System.debug('--- Dynamic Object Utils - ParentChildMap Size: '+parentChildMap.size());
        if (parentChildMap.size() > 0) {
            for(Schema.ChildRelationship child2 : sObjectTypeObj2.getDescribe().getChildRelationships()) {
                String childName = child2.getChildSObject().getDescribe().getName();
                System.debug('--- Dynamic Object Utils - Child1: '+childName);
                String childRelation = child2.getRelationshipName();
                System.debug('--- Dynamic Object Utils - Relation: '+childRelation);             
                String parentName = sObjectTypeObj2.getDescribe().getName();
                System.debug('--- Dynamic Object Utils - Parent: '+parentName);
                if (childName == parentName && childRelation != null) {
                    System.debug('--- Dynamic Object Utils - Object1 '+ sObjectName1+' relates to Object2 '+ sObjectName2);
                    System.debug('--- Dynamic Object Utils - Parent '+ sObjectName2);
                    System.debug('--- Dynamic Object Utils - Child '+ sObjectName1);
                    parentChildMap.put('parent', sObjectName2); 
                    parentChildMap.put('child', sObjectName1); 
                } 
           }
        }
        System.debug('--- Dynamic Object Utils - parentChildMap size: '+ parentChildMap.size());
        System.debug('--- Dynamic Object Utils - getObjectRelations CPU TIME: '+LIMITS.getCpuTime());
        return parentChildMap;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getRelatedObjects(String sObjectName) {
        System.debug('---  Get '+sObjectName+ ' Reference Objects');
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(sObjectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> describeSObjectfieldsMap = describeSObjectResultObj.fields.getMap();
        Map<String,String> relatedObjectsMap=new Map<String,String>();
        // Loop Through Field Keys
        for (String fieldKey : describeSObjectfieldsMap.keySet()) {
            Schema.DisplayType fieldType = describeSObjectfieldsMap.get(fieldKey).getDescribe().getType();
            if (fieldType == Schema.DisplayType.Reference) {
            // describe of your lookup field
                Schema.DescribeFieldResult describeFieldResultObj = describeSObjectfieldsMap.get(fieldKey).getDescribe();
                String relatedFieldName = describeFieldResultObj.getName();
                String relatedFieldLabel = describeFieldResultObj.getLabel();
                List<Schema.SObjectType> objectReferences = describeFieldResultObj.getReferenceTo();
                for (Schema.SObjectType objectReference : objectReferences){
                    String relatedObjectName = objectReference.getDescribe().getName();
                    String relatedObjectLabel = objectReference.getDescribe().getLabel();
                    relatedObjectsMap.put(relatedObjectName, relatedFieldName);
                }
            }
        }
        return relatedObjectsMap;
    }
}