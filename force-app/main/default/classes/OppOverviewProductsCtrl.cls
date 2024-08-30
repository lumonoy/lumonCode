/**
 * Created by Filip on 17. 2. 2023.
 * Updated by Sai on 07.06.2023
 */

public with sharing class OppOverviewProductsCtrl {
	public class OverviewProductsData{
		@AuraEnabled public List<ProductDataColumn> productColumns;
		@AuraEnabled public List<ProductDataRow> productRows;
		@AuraEnabled public String orderType;
	}
	public class ProductDataColumn{
		public String label;
		public String apiName;
		public String sortDirection;
		public String cssClass;
		public ProductDataColumn(String label, String apiName, String sortDirection, String cssClass){
			this.label = label;
			this.apiName = apiName;
			this.sortDirection = sortDirection;
			this.cssClass = cssClass;
		}
	}
	public class ProductDataRow{
		public String rowId;
		public String productId;
		public String configurationId;
		public List<ProductField> fields;
		/*public ProductDataRow(String rowId, String productId, List<ProductField> fields){
			this.rowId = rowId;
			this.productId = productId;
			this.fields = fields;
		}*/
	}
	public class ProductField{
		public String label;
		public String apiName;
		public String type;
		public Boolean isEditable;
		public Boolean isVisible;
		public Object value;
		public String id;
		public List<PickList> pickListOptions = new List<PickList>();
	}
	public class PickList{
		public String label;
		public String value;
		public PickList(String label, String value){
			this.label = label;
			this.value = value;
		}
	}
	public static Map<String, String> apiNamesLabelsProduct = createFieldApiLabelTypeMap('Product2', true);
	public static Map<String, String> apiNamesTypesProduct = createFieldApiLabelTypeMap('Product2', false);

	public static Map<String, String> apiNamesLabelsQuote = createFieldApiLabelTypeMap('Quote', true);
	public static Map<String, String> apiNamesTypesQuote = createFieldApiLabelTypeMap('Quote', false);

	public static Map<String, String> apiNamesLabelsConProduct = createFieldApiLabelTypeMap('Configuration_Product__c', true);
	public static Map<String, String> apiNamesTypesConProduct = createFieldApiLabelTypeMap('Configuration_Product__c', false);

	public static Map<String, String> apiNamesLabelsOppo = createFieldApiLabelTypeMap('Opportunity', true);
	public static Map<String, String> apiNamesTypesOppo = createFieldApiLabelTypeMap('Opportunity', false);

	public static Map<String, String> apiNamesLabelsConfiguration = createFieldApiLabelTypeMap('Configuration__c', true);
	public static Map<String, String> apiNamesTypesConfiguration = createFieldApiLabelTypeMap('Configuration__c', false);

	public static final List<String> VISIBLE_FIELDS = new List<String>{
		'RVN_Number__c',
		'Product__r.Name',
		'Configuration__r.Plan_Name__c',
		'Configuration__r.Plan_Line__c',
		'Configuration__r.Plan_Floor__c',
		'Configuration__r.Plan_Apartment__c',
		'Verification__c'
		//'Configuration__r.Quote__r.Status'


		//'Configuration__r.Opportunity__r.Delivery_Date__c',
		//'Configuration__r.Opportunity__r.Confirmed_Delivery_Date__c',
		//'Configuration__r.Opportunity__r.Preliminary_installation_time__c',
		//'Configuration__r.Opportunity__r.Confirmed_installation_time__c',
		/*'Configuration__r.Opportunity__r.StageName',
		'Configuration__r.Visual_Id__c',

		'LastModifiedDate',
		'Quantity__c',
		'Features_Confirmed__c',
		'Measurements_Verified__c',
		'Inspection_Code__c'*/
	};
	public static final List<String> EDITABLE_FIELDS = new List<String>{
		'Configuration__r.Plan_Name__c',
		'Configuration__r.Plan_Line__c',
		'Configuration__r.Plan_Apartment__c',
		'Configuration__r.Plan_Floor__c'
		//'Configuration__r.Opportunity__r.Delivery_Date__c',
		//'Configuration__r.Opportunity__r.Confirmed_Delivery_Date__c',
		//'Configuration__r.Opportunity__r.Preliminary_installation_time__c',
		//'Configuration__r.Opportunity__r.Confirmed_installation_time__c',
		/*'RVN_Number__c',
		'Quantity__c',
		'Features_Confirmed__c',
		'Measurements_Verified__c',
		'Inspection_Code__c'*/
	};
	public static final List<String> CONFIG_PRODUCT_API_NAMES = new List<String>{
			'RVN_Number__c',
			'Product__r.Name',
			'Configuration__r.Plan_Name__c',
			'Configuration__r.Plan_Line__c',
			'Configuration__r.Plan_Floor__c',
			'Configuration__r.Plan_Apartment__c',
			'Verification__c'
			//'Configuration__r.Quote__r.Status'
	};

	@AuraEnabled
	public static Opportunity caseOpportunityId(Id recordId) {
		//return [SELECT Opportunity__c,Opportunity__r.Order_Type__c FROM Case WHERE Id = :recordId LIMIT 1];
		return [SELECT Id,Order_type__c FROM Opportunity WHERE Case__c = :recordId and Order_type__c = 'Reclamation' LIMIT 1];
	}

	@AuraEnabled
	public static Opportunity queryOpportunity(Id recordId) {
		//return [SELECT Opportunity__c,Opportunity__r.Order_Type__c FROM Case WHERE Id = :recordId LIMIT 1];
		return [SELECT Id,Order_type__c FROM Opportunity WHERE Id = :recordId  LIMIT 1];
	}

	@AuraEnabled
	public static String fetchOverviewProducts(Id recordId) {
        System.debug('*** recordId ***'+recordId);
		Opportunity opp = new Opportunity();
		Id opportunityId;
		String orderType = '';
		if(recordId.getSobjectType() == Case.getSObjectType()) {
			/*Case cas = caseOpportunityId(recordId);
			opportunityId = cas.Opportunity__c;
			orderType = cas.Opportunity__r.Order_Type__c;*/

			opp = caseOpportunityId(recordId);
			System.debug('*** opp value ***'+opp.Id);
			opportunityId = opp.Id;
			orderType = opp.Order_type__c;
		}else if(recordId.getSobjectType() == Opportunity.getSObjectType()){
			opp = queryOpportunity(recordId);
			opportunityId = opp.Id;
			orderType = opp.Order_type__c;
		}
		OverviewProductsData opData = new OverviewProductsData();
		List<ProductDataRow> pDataRows = new List<ProductDataRow>();
		List<ProductDataColumn> pDataColumns = new List<ProductDataColumn>();
		Set<String> columnsAddedSet = new Set<String>();
		List<Configuration_Product__c> configurationProducts = queryConfigurationProducts(opportunityId);
		Map<String, String> apiNameValueMap = new Map<String, String>();
		if(!configurationProducts.isEmpty()){
			/*// TODO check other posibilities on how to get id as url for clickable fields
			for(Configuration_Product__c cProduct : configurationProducts){
				for(String apiName : CONFIG_PRODUCT_API_NAMES) {
					String cpValue = extractObjectValue(cProduct, apiName);
					apiNameValueMap.put(apiName, cpValue);
				}
			}*/
			for(Configuration_Product__c cProduct : configurationProducts){
				List<ProductField> productFields = new List<ProductField>();
				//productFields.add(createCheckBoxField());
				System.debug('*** cProduct.Configuration__c ***'+cProduct.Configuration__c);
				productFields.add(createQuickActionField(cProduct.Configuration__c));
				pDataColumns.add(new ProductDataColumn('', 'EditPlanAction', 'DESC', 'table-header'));
				System.debug('*** Added Quick Action Field ***');
				for(String apiName : CONFIG_PRODUCT_API_NAMES){
					String whatObject = checkWhichObject(apiName);
					String apiFlattened = flattenApiName(apiName);
					ProductField pField = new ProductField();
					pField.apiName = apiName;
					pField.id = apiName == 'Product__r.Name' ? String.valueof(cProduct.Product__r.Id) : generateId(cProduct.Product__r.Id);
					pField.type = getLabelOrType(whatObject, apiFlattened, true);
					pField.label = getLabelOrType(whatObject, apiFlattened, false);
					pField.value = extractObjectValue(cProduct, apiName);
					System.debug('*** pField.value ***'+pField.value);
					/*if(pField.type == 'DATE'){
						Date d = date.parse(pField.value);
						pField.value = String.valueOf(d);
					}
					if(pField.type == 'DATETIME'){
						Datetime d = datetime.parse(pField.value);
						pField.value = String.valueOf(d);
					}*/
					pField.isEditable = false;// EDITABLE_FIELDS.contains(pField.apiName);
					pField.isVisible = VISIBLE_FIELDS.contains(pField.apiName);
					if(pField.label != '' && !columnsAddedSet.contains(pField.apiName)  && VISIBLE_FIELDS.contains(pField.apiName)){
						columnsAddedSet.add(pField.apiName);
						pDataColumns.add(new ProductDataColumn(pField.label, pField.apiName, 'DESC', 'table-header'));
					}
					productFields.add(pField);
				}
				//TODO Check if Schema ok in for loops
				for(ProductField pF : productFields){
					if(pF.type.toUpperCase() == 'PICKLIST'){
						String fieldApi = flattenApiName(pF.apiName);
						String objectApiName = checkWhichObject(pF.apiName);
						SObjectType objType = Schema.getGlobalDescribe().get(objectApiName);
						Map<String, Schema.SObjectField> objectFieldsMap = objType.getDescribe().fields.getMap();
						Schema.SObjectField sObjField = objectFieldsMap.get(fieldApi);
						pF.pickListOptions = getPickListValuesIntoList(sObjField);
					}
				}
				ProductDataRow pDataRow = new ProductDataRow();
				pDataRow.rowId = generateId(cProduct.Product__r.Id);
				pDataRow.productId = cProduct.Product__r.Id;
				pDataRow.configurationId = cProduct.Configuration__c;
				pDataRow.fields = productFields;
				pDataRows.add(pDataRow);
			}
			opData.productColumns = pDataColumns;
			opData.productRows = pDataRows;
			opData.orderType = orderType;
		}
		return JSON.serialize(opData);
	}
	/*private static Set<String> extractAllPicklistFields(String objectApiName, List<String> fieldsApiNames){
		Set<String> picklists = new Set<String>();
		SObjectType accountType = Schema.getGlobalDescribe().get(objectApiName);
		Map<String,Schema.SObjectField> objectFieldsMap = accountType.getDescribe().fields.getMap();
		for(String fieldApiName : fieldsApiNames){
			fieldApiName = fieldApiName.replace('*','');
			if(objectFieldsMap.containsKey(fieldApiName)){
				if(String.valueOf(objectFieldsMap.get(fieldApiName).getDescribe().getType()).toUpperCase()=='PICKLIST'){
					picklists.add(fieldApiName);
				}
			}
		}
		return picklists;
	}*/
	private static List<PickList> getPickListValuesIntoList(Schema.SObjectField sObjField){
		List<PickList> picklistValues = new List<PickList>();
		List<Schema.PicklistEntry> values = sObjField.getDescribe().getPickListValues();
		for (Schema.PicklistEntry pe : values){
			PickList pl = new PickList(pe.getLabel(), pe.getValue());
			picklistValues.add(pl);
		}
		return picklistValues;
	}
	private static ProductField createCheckBoxField(){
		ProductField productF = new ProductField();
		productF.label = '';
		productF.apiName = 'RowCheckBox';
		productF.type = 'Boolean';
		productF.isVisible = true;
		return productF;
	}
	// Setup Edit Plan Quick Action Field
	private static ProductField createQuickActionField(String configPlanId){
		System.debug('*** Creating Quick Action Field for Plan '+configPlanId+' ***');
		ProductField productF = new ProductField();
		productF.label = '';
		productF.apiName = 'EditPlanAction';
		System.debug('*** Creating Quick Action Field Name '+productF.apiName+' ***');
		productF.value = configPlanId;
		System.debug('*** Creating Quick Action Field Value '+productF.value+' ***');
		productF.type = 'QuickAction';
		System.debug('*** Creating Quick Action Field Type '+productF.type+' ***');
		productF.isVisible = true;
		System.debug('*** Creating Quick Action Field isVisible '+productF.isVisible+' ***');
		System.debug('*** Created Quick Action Field ***');
		return productF;
	}
	private static String checkWhichObject(String productFieldsApi){
		if(productFieldsApi.contains('Product__r')){
			return 'Product2';
		}
		if(productFieldsApi.contains('Configuration__r.Opportunity__r')){
			return 'Opportunity';
		}
		if(productFieldsApi.contains('Configuration__r.Quote__r')){
			return 'Quote';
		}
		if(productFieldsApi.contains('Configuration__r')){
			return 'Configuration__c';
		}
		return 'Configuration_Product__c';
	}

	private static Map<String, String> createFieldApiLabelTypeMap(String obj, Boolean isLabelMap){
		Map<String, String> fieldsApiLabelTypeMap = new Map<String, String>();
		Map<String, Schema.SObjectType> describeResult = Schema.getGlobalDescribe();
		for(Schema.SObjectField f : describeResult.get(obj).getDescribe().fields.getMap().values()){
			String labelOrType = isLabelMap ? f.getDescribe().getLabel() : String.valueOf(f.getDescribe().getType());
			fieldsApiLabelTypeMap.put(f.getDescribe().getName(), labelOrType);
		}
		return fieldsApiLabelTypeMap;
	}
	private static String getLabelOrType(String obj, String apiName, Boolean mustCheckType){
		if(apiName == 'Verification__c' && mustCheckType){
			return 'ICON';
		}
		// TODO redo to custom metadata
		if(apiName == 'Name' && mustCheckType){
			return 'URL';
		}
		switch on obj {
			when 'Product2' {
				return mustCheckType ? apiNamesTypesProduct.get(apiName) : apiNamesLabelsProduct.get(apiName);
			}
			when 'Quote' {
				return mustCheckType ? apiNamesTypesQuote.get(apiName) : apiNamesLabelsQuote.get(apiName);
			}
			when 'Opportunity' {
				return mustCheckType ? apiNamesTypesOppo.get(apiName) : apiNamesLabelsOppo.get(apiName);
			}
			when 'Configuration__c' {
				return mustCheckType ? apiNamesTypesConfiguration.get(apiName) : apiNamesLabelsConfiguration.get(apiName);
			}
			when else {
				return mustCheckType ? apiNamesTypesConProduct.get(apiName) : apiNamesLabelsConProduct.get(apiName);
			}
		}
	}
	private static String flattenApiName(String productFieldsApi){
		if(productFieldsApi.contains('Product__r') ||
			productFieldsApi.contains('Configuration__r.Opportunity__r') ||
			productFieldsApi.contains('Configuration__r') ||
			productFieldsApi.contains('Configuration__r.Quote__r')) {
			return productFieldsApi.substringAfterLast('.');
		}
		return productFieldsApi;
	}

	private static Object extractObjectValue(SObject o, String fieldApiName){
		if(fieldApiName == 'Verification__c'){
			return getVerificationIcon(String.valueOf(o.get(fieldApiName)));
		}

		SObject sObj = o;
		if(fieldApiName.contains('.')){ // reference field
			List<String> reference = fieldApiName.split('\\.');
			for (Integer i = 0; i < reference.size() - 1; i++) {
				if( sObj != null ) {
					sObj = sObj?.getSObject(reference[i]);
				}
			}
			return sObj?.get(reference[reference.size()-1]);//String.valueOf(sObj?.get(reference[reference.size()-1]));
		}else{
			return o.get(fieldApiName); // String.valueOf(o.get(fieldApiName));
		}
	}
	private static List<Configuration_Product__c> queryConfigurationProducts(String oppId){
		return [
				SELECT
					Product__r.Name,
					Product__r.Id,
					Configuration__r.Plan_Name__c,
					Configuration__r.Plan_Line__c,
					Configuration__r.Plan_Apartment__c,
					Configuration__r.Plan_Floor__c,
					Verification__c,
					Configuration__c,
					//Configuration__r.Opportunity__r.Delivery_Date__c,
					//Configuration__r.Opportunity__r.Confirmed_Delivery_Date__c,
					//Configuration__r.Opportunity__r.Preliminary_installation_time__c,
					//Configuration__r.Opportunity__r.Confirmed_installation_time__c,
					Configuration__r.Opportunity__r.StageName,
					Configuration__r.Quote__r.Status,
					Configuration__r.Visual_Id__c,
					RVN_Number__c,
					LastModifiedDate,

					Quantity__c,
					Features_Confirmed__c,
					Measurements_Verified__c,
					Inspection_Code__c
				FROM Configuration_Product__c
				WHERE  Configuration__r.Opportunity__c = :oppId
				LIMIT 1000
		];
	}
	public static String generateId(String productId) {
		String random1 = productId + String.valueOf(Math.random());
		String random2 = String.valueOf(Math.random()) + productId;
		return (random1.substring(2, 20) + random2.substring(7, 20)).replaceAll(' ', '');
	}
	private static String getLabelFromFieldsApi(String fieldsApi){
		Map<String,Schema.SObjectField> cProductFields = Schema.Configuration_Product__c.SObjectType.getDescribe().fields.getMap();
		Schema.DescribeFieldResult fieldResult = cProductFields.get(fieldsApi).getDescribe();
		return String.valueOf(fieldResult.getLabel());
	}
	private static Object getVerificationIcon(String verification){
		if(verification.contains('error')){
			return 'utility:close';
		}
		if(verification.contains('confirm')){
			return 'utility:check';
		}
		if(verification.contains('info')){
			return 'utilty:warning';
		}
		return null;
	}

	public static String STATUS_SUCCESS = 'success';
	public static String STATUS_ERROR = 'error';
	public class ApexResult {
		@AuraEnabled
		public Object result;
		@AuraEnabled
		public String status;
		@AuraEnabled
		public String errorMessage;

		public ApexResult() {
			this(null, STATUS_SUCCESS, null);
		}
		public ApexResult(Exception e) {
			this(null, STATUS_ERROR, e.getTypeName() == 'System.DmlException' ? e.getDmlMessage(0) : e.getMessage());
		}

		public ApexResult(Object result, String status, String errorMessage) {
			this.result = result;
			this.status = status;
			this.errorMessage = errorMessage;
		}
	}


	@AuraEnabled public static ApexResult updateConfigurations(List<Configuration__c> configurations){
		ApexResult response = new ApexResult();
		try {
			update configurations;
		}catch (Exception e){
			return new ApexResult(e);
		}
		return response;
	}
	/*private static String modifyApiName(String apiName){
	String modifiedApi = '';
	if(apiName.contains('Product__r') || apiName.contains('Configuration__r')){
		modifiedApi = apiName.replace('Product__r', '__c');
	}
	if(apiName.contains('Configuration__r.Opportunity__r')){

	}
	return modifiedApi;
}*/
/*	private static ProductField createProductField(String apiName, Configuration_Product__c cProduct){
		ProductField pField = new ProductField();
		//String apiModified = modifyApiName(apiName);
		pField.value = extractObjectValue(cProduct, apiName);
	}*/
}