/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 11-21-2023
 * @last modified by  : Henk Reynders
**/
@isTest
public class DynamicObjectUtilsTest {
    @isTest
    static void getObjectTypeTest() {
        String prefix = '001';
        String myObjectName = DynamicObjectUtils.getObjectType(prefix);
        System.debug('--- Dynamic Object Utils Test - getObjectTypeTest ' + myObjectName);  
        System.assertEquals('Account', myObjectName,
        					'Expected result to be Account');  
    }
    @isTest
    static void getObjectTypeBadIdTest() {
        String prefix = '123';
        String myObjectName = DynamicObjectUtils.getObjectType(prefix);
        System.debug('--- Dynamic Object Utils Test - getObjectTypeTest ' + myObjectName);  
        System.assertEquals('',myObjectName,
        					'Expected result to be Null');  
    }
    @isTest
    static void getObjectFieldsTest() {
        String sObjectName = 'Account';
        Map<String,Schema.SObjectField> myObjectFieldsMap = DynamicObjectUtils.getObjectFields(sObjectName);
        System.debug('--- Dynamic Object Utils Test - getObjectFieldsTest ' + myObjectFieldsMap);  
        System.assertNotEquals(myObjectFieldsMap.size(),0,
        					'Expected atleast one Field to be returned');  
    }
    @isTest
    static void getObjectFieldLabelsTest() {
        String sObjectName = 'Account';
        Map<String,String> myFieldLabelsMap = DynamicObjectUtils.getObjectFieldLabels(sObjectName);
        System.debug('--- Dynamic Object Utils Test - getObjectFieldLabelsTest ' + myFieldLabelsMap); 
        List<String> myFieldLabels = new List<String>();
        myFieldLabels.addall(myFieldLabelsMap.values());
        System.debug('--- Dynamic Object Utils Test - getObjectFieldLabelsTest Labels' + myFieldLabels); 
        System.assertNotEquals(myFieldLabelsMap.size(),0,
        					'Expected atleast one Field to be returned');  
    }
    @isTest
    static void getObjectFieldTypesTest() {
        String sObjectName = 'Account';
        Map<String,String> myFieldTypesMap = DynamicObjectUtils.getObjectFieldTypes(sObjectName);
        System.debug('--- Dynamic Object Utils Test - getObjectFieldLabelsTest ' + myFieldTypesMap); 
        List<String> myFieldTypes = new List<String>();
        myFieldTypes.addall(myFieldTypesMap.values());
        System.debug('--- Dynamic Object Utils Test - getObjectFieldLabelsTest Types' + myFieldTypes); 
        System.assertNotEquals(myFieldTypesMap.size(),0,
        					'Expected atleast one Field to be returned');  
    }
    @isTest
    static void getObjectFieldSetsTest() {
        String sObjectName = 'Account';
        Map<String,String> myFieldsetMap = DynamicObjectUtils.getObjectFieldSets(sObjectName);
        System.debug('--- Dynamic Object Utils Test - getObjectFieldLabelsTest ' + myFieldsetMap); 
        List<String> myFieldsets = new List<String>();
        myFieldsets.addall(myFieldsetMap.values());
        System.debug('--- Dynamic Object Utils Test - getObjectFieldLabelsTest FieldSets' + myFieldsets); 
        System.assertNotEquals(myFieldsetMap.size(),0,
        					'Expected atleast one Fieldset to be returned');  
    }
    @isTest
    static void getObjectFieldSetTest() {
        String sObjectName = 'Account';
        String fieldSetName = '';
        Map<String,String> myFieldsetMap = DynamicObjectUtils.getObjectFieldSet(sObjectName,fieldSetName);
        System.debug('--- Dynamic Object Utils Test - getObjectFieldLabelsTest ' + myFieldsetMap); 
        List<String> myFieldsets = new List<String>();
        myFieldsets.addall(myFieldsetMap.values());
        System.assertNotEquals(myFieldsetMap.size(),0,
        					'Expected atleast one Fieldset to be returned');  
    }
    @isTest
    static void getObjectFieldSetFieldsTest() {
        String sObjectName = 'Account';
        String fieldSetName = 'Test';
        Map<String,String> myFieldSetFields = DynamicObjectUtils.getObjectFieldSetFields(sObjectName, fieldSetName);
        System.assertNotEquals(myFieldSetFields,null,
        					'Expected a String to be returned'); 
    }
    @isTest
    static void getEditableFieldsTest() {
        String sObjectName = 'Account';
        Map<String,String> myFieldsMap = DynamicObjectUtils.getEditableFields(sObjectName);
        List<String> myEditableFieldsList = new List<String>();
        myEditableFieldsList.addall(myFieldsMap.values());
        System.assertNotEquals(myFieldsMap.size(),0,
        					'Expected atleast one Record to be returned');  
    }
    @isTest
    static void getAddressFieldsTest() {
        String sObjectName = 'Account';
        Map<String,String> myFieldsMap = DynamicObjectUtils.getAddressFields(sObjectName);
        List<String> myLookupFieldsList = new List<String>();
        myLookupFieldsList.addall(myFieldsMap.values());
        System.assertNotEquals(myFieldsMap.size(),0,
        					'Expected atleast one Record to be returned');  
    }  
    @isTest
    static void getLookupFieldsTest() {
        String sObjectName = 'Account';
        Map<String,String> myFieldsMap = DynamicObjectUtils.getLookupFields(sObjectName);
        List<String> myLookupFieldsList = new List<String>();
        myLookupFieldsList.addall(myFieldsMap.values());
        System.assertNotEquals(myFieldsMap.size(),0,
        					'Expected atleast one Record to be returned');  
    }  
    @isTest
    static void getUniqueFieldsTest() {
        String sObjectName = 'Product2';
        Map<String,String> myFieldsMap = DynamicObjectUtils.getUniqueFields(sObjectName);
        List<String> myLookupFieldsList = new List<String>();
        myLookupFieldsList.addall(myFieldsMap.values());
        System.assertNotEquals(myFieldsMap.size(),0,
        					'Expected atleast one Record to be returned');  
    }    
    @isTest
    static void getRequiredFieldsTest() {
        String sObjectName = 'Product2';
        Map<String,String> myRequiredFields = DynamicObjectUtils.getRequiredFields(sObjectName);
        System.assertNotEquals(myRequiredFields,null,
        					'Expected at one Value to be returned'); 
    }
    @isTest
    static void getObjectRelations() {
        String sObjectName = 'Account';
        Map<String,String> myChildRelations = DynamicObjectUtils.getObjectRelations(sObjectName);
        System.assertNotEquals(myChildRelations,null,
        					'Expected at one Value to be returned'); 
    }
    @isTest
    static void getObjectRelationType() {
        String sObjectName1 = 'Account';
        String sObjectName2 = 'Contact';
        Map<String,String> myObjectRelationType = DynamicObjectUtils.getObjectRelationType(sObjectName1,sObjectName2);
        System.assertNotEquals(myObjectRelationType,null,
        					'Expected at one Value to be returned'); 
    }
}