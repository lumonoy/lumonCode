/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 03-22-2024
 * @last modified by  : Henk Reynders
**/
public class VisualContainerController {
	@AuraEnabled
	public static Boolean checkContractStatus(String recordId) {
		return [SELECT Contract_Signed__c FROM Opportunity WHERE Id =: recordId]?.Contract_Signed__c;
	}

	@AuraEnabled
	public static Boolean checkContractStatusFromConfiguration(String recordId) {
		Id oppId = [SELECT Opportunity__c FROM Configuration__c WHERE Id =: recordId]?.Opportunity__c;
		if (oppId != null) {
			return false;//[SELECT Contract_Signed__c FROM Opportunity WHERE Id =: oppId].Contract_Signed__c;
		} else {
			return false;
		}
	}

	@AuraEnabled
	public static String getStartupParams(String recordId) {
		return getStartupParamsFromOpportunity(recordId, '');
	}

	public static String getStartupParamsFromOpportunity(String recordId, String orderType) {
		User user = [SELECT Name,Profile.Name, Country_Attribute__c,Country_Code_Attribute__c,LanguageLocaleKey FROM User WHERE Id =: UserInfo.getUserId()];
		System.debug('--- user: '+user);
		Opportunity opp = [SELECT  	Opportunity_Number__c,
							Owner.LanguageLocaleKey,
							StageName, 
							Country_Attribute__c,
							Order_type__c, 
							Building__r.Structural_Analysis__r.Wind_Pressure__c, 
							Building__r.Structural_Analysis__r.Wind_Speed__c, 
							Building__r.Structural_Analysis__r.Terrain_Type__c, 
							Building__r.Structural_Analysis__r.On_a_Hill_or_Slope__c, 								
							Building__r.Structural_Analysis__r.Snowload__c,
							Building__r.Structural_Analysis__r.Building_Height__c, 
							Building__r.Structural_Analysis__r.Seals_between_panes__c, 
							Building__r.Structural_Analysis__r.Drainage_holes__c, 
							Building__r.Structural_Analysis__r.Combined_load__c
					FROM Opportunity WHERE Id =: recordId];
		VisualWrapper wrapper = new VisualWrapper();
		VisualDef visual = new VisualDef();
		BaseInfo baseInfo = new BaseInfo();
		baseInfo.configId = '';
		baseInfo.baseConfigId = '';
        //System.Debug('--- VisualContainerController - User language key: '+user.LanguageLocaleKey);
        String userLocale = user.LanguageLocaleKey;
		baseInfo.lan = userLocale.length()> 2? userLocale : userLocale.toLowerCase()+'-'+userLocale.toUpperCase();
		baseInfo.lumonPlanName = '';
		baseInfo.lumonPlanLine = '';
		baseInfo.lumonPlanFloor = '';
		baseInfo.lumonPlanApartment = '';

		if(String.isBlank(orderType)) {
			if (opp.Order_type__c == 'Normal') {
				orderType = 'default';
			} else if (opp.Order_type__c == 'Reclamation') {
				orderType = 'reclamation';
			}
		}
		String terrainClass = opp.Building__r.Structural_Analysis__r.Terrain_Type__c;
		Integer terrainValue = new Map<String, Integer> {
            'Terrain Class 0' => 0,
            'Terrain Class I' => 1,
            'Terrain Class II' => 2,
            'Terrain Class III' => 3,
            'Terrain Class IV' => 4,
            'Terrain Class V' => 5
		}.get(terrainClass);
		baseInfo.initMode = orderType;
		List<String> statusesToLockPlan = new List<String>{'Contract Signed', 'Closed Won', 'Closed Lost'};
		System.debug('statusesToLockPlan'+statusesToLockPlan);
		baseInfo.lockedPlan = statusesToLockPlan.contains(opp.StageName);
		System.debug('baseInfo.lockedPlan'+baseInfo.lockedPlan);
		baseInfo.offerId = opp.Id;

		StartupParam stParam = new StartupParam();
		stParam.sfdcConfigId = '';
        //stParam.WindSpeed = Integer.valueOf(opp.Wind_Speed__c);
		stParam.WindSpeed = opp.Building__r.Structural_Analysis__r.Wind_Speed__c != null ? opp.Building__r.Structural_Analysis__r.Wind_Speed__c.setScale(2) : 10;
		stParam.WindPressure = opp.Building__r.Structural_Analysis__r.Wind_Pressure__c != null ? opp.Building__r.Structural_Analysis__r.Wind_Pressure__c: 0;
        //System.debug('*** stParam.WindSpeed ***'+stParam.WindSpeed);
		stParam.TerrainType = terrainValue;
		stParam.IsHill = opp.Building__r.Structural_Analysis__r.On_a_Hill_or_Slope__c;
		stParam.SnowLoading = opp.Building__r.Structural_Analysis__r.Snowload__c;
		stParam.RoofHeight = opp.Building__r.Structural_Analysis__r.Building_Height__c;
		stParam.Seal = opp.Building__r.Structural_Analysis__r.Seals_between_panes__c;
		stParam.WaterHoles = opp.Building__r.Structural_Analysis__r.Drainage_holes__c;
		stParam.CountryCode = opp.Country_Attribute__c;
//		stParam.IncludeBlinds
//		stParam.offerBlindsIncluded
		stParam.CombinedLoad = opp.Building__r.Structural_Analysis__r.Combined_load__c;
		stParam.OrderNumber = opp.Opportunity_Number__c;
		stParam.LockRVN = false;
//		stParam.SplitPlan
		System.debug('*** stParam ***'+stParam);
		baseInfo.startupParameters = stParam;
		visual.baseInfo = baseInfo;
		wrapper.visual = visual;
		System.Debug('--- VisualContainerController - Wrapper: '+JSON.serializePretty(wrapper));
		return JSON.serialize(wrapper);
	}

	@AuraEnabled
	public static String getStartupParamsFromCase(String recordId) {
		return getStartupParamsFromOpportunity(
			[SELECT Opportunity__c FROM Case WHERE Id = :recordId]?.Opportunity__c,
			'reclamation'
		);
	}

	@AuraEnabled
	public static String getStartupParamsFromConfiguration(String recordId) {
		User user = [SELECT Name,Profile.Name,Country_Attribute__c,Country_Code_Attribute__c,LanguageLocaleKey FROM User WHERE Id =: UserInfo.getUserId()];
		Configuration__c config = [SELECT Opportunity__c, Plan_Name__c, Plan_Line__c, Visual_Id__c, 
										//Plan_Floor__c, 
										Plan_Apartment__c, LockPlan__c, Lock_RVN__c
		FROM Configuration__c WHERE Id =: recordId];
		System.debug('--- user: '+user);
		Opportunity opp = [SELECT  	Opportunity_Number__c,
									Owner.LanguageLocaleKey,
									StageName, 
									Country_Attribute__c,
									Order_type__c, 
									Building__r.Structural_Analysis__r.Wind_Pressure__c, 
									Building__r.Structural_Analysis__r.Wind_Speed__c, 
									Building__r.Structural_Analysis__r.Terrain_Type__c, 
									Building__r.Structural_Analysis__r.On_a_Hill_or_Slope__c, 								
									Building__r.Structural_Analysis__r.Snowload__c,
									Building__r.Structural_Analysis__r.Building_Height__c, 
									Building__r.Structural_Analysis__r.Seals_between_panes__c, 
									Building__r.Structural_Analysis__r.Drainage_holes__c, 
									Building__r.Structural_Analysis__r.Combined_load__c
							FROM Opportunity WHERE Id =: config.Opportunity__c];
		String terrainClass = opp.Building__r.Structural_Analysis__r.Terrain_Type__c;
		Integer terrainValue = new Map<String, Integer> {
								'Terrain Class 0' => 0,
								'Terrain Class I' => 1,
								'Terrain Class II' => 2,
								'Terrain Class III' => 3,
								'Terrain Class IV' => 4,
								'Terrain Class V' => 5
					}.get(terrainClass);
		VisualWrapper wrapper = new VisualWrapper();
		VisualDef visual = new VisualDef();
		BaseInfo baseInfo = new BaseInfo();
		baseInfo.configId = config.Visual_Id__c;
		baseInfo.baseConfigId = ''; // needed when creating a new plan from template
        //System.Debug('--- VisualContainerController - User language key: '+user.LanguageLocaleKey);
        String userLocale = user.LanguageLocaleKey;
		baseInfo.lan = userLocale.length()> 2? userLocale : userLocale.toLowerCase()+'-'+userLocale.toUpperCase();
		baseInfo.lumonPlanName = config.Plan_Name__c;
		baseInfo.lumonPlanLine = config.Plan_Line__c;
		//baseInfo.lumonPlanFloor = config.Plan_Floor__c;
		baseInfo.lumonPlanApartment = config.Plan_Apartment__c;
		String orderType = '';
		if (opp.Order_type__c == 'Normal') {
			orderType = 'default';
		} else if (opp.Order_type__c == 'Reclamation') {
			orderType = 'reclamation';
		}
		baseInfo.initMode = orderType;
		baseInfo.lockedPlan = config.LockPlan__c;
		baseInfo.offerId = opp.Id;

		StartupParam stParam = new StartupParam();
		stParam.sfdcConfigId = config.Id;
        //stParam.WindSpeed = String.valueOf(opp.Wind_Speed__c);
		stParam.WindSpeed = opp.Building__r.Structural_Analysis__r.Wind_Speed__c != null ? opp.Building__r.Structural_Analysis__r.Wind_Speed__c.setScale(2) : 10;
		stParam.WindPressure = opp.Building__r.Structural_Analysis__r.Wind_Pressure__c != null ? opp.Building__r.Structural_Analysis__r.Wind_Pressure__c: 0;
        //System.debug('*** stParam.WindSpeed ***'+stParam.WindSpeed);
		stParam.TerrainType = terrainValue;
		stParam.IsHill = opp.Building__r.Structural_Analysis__r.On_a_Hill_or_Slope__c;
		stParam.SnowLoading = opp.Building__r.Structural_Analysis__r.Snowload__c;
		stParam.RoofHeight = opp.Building__r.Structural_Analysis__r.Building_Height__c;
		stParam.Seal = opp.Building__r.Structural_Analysis__r.Seals_between_panes__c;
		stParam.WaterHoles = opp.Building__r.Structural_Analysis__r.Drainage_holes__c;
		stParam.CountryCode = opp.Country_Attribute__c;
//		stParam.IncludeBlinds
//		stParam.offerBlindsIncluded
		stParam.CombinedLoad = opp.Building__r.Structural_Analysis__r.Combined_load__c;
		stParam.OrderNumber = opp.Opportunity_Number__c;
		stParam.LockRVN = config.Lock_RVN__c;
//		stParam.SplitPlan
		System.debug('*** stParam 2 ***'+stParam);
		baseInfo.startupParameters = stParam;
		visual.baseInfo = baseInfo;
		wrapper.visual = visual;

		return JSON.serialize(wrapper);
	}

	public class VisualWrapper {
		public VisualDef visual {public get; public set;}
	}

	public class VisualDef {
		public BaseInfo baseInfo {public get; public set;}
	}

	public class BaseInfo {
		public String configId {public get; public set;}
		public String baseConfigId {public get; public set;}
		public String lan {public get; public set;}
		public String lumonPlanName {public get; public set;}
		public String lumonPlanLine {public get; public set;}
		public String lumonPlanFloor {public get; public set;}
		public String lumonPlanApartment {public get; public set;}
		public String initMode {public get; public set;}
		public Boolean lockedPlan {public get; public set;}
		public String offerId {public get; public set;}
		public StartupParam startupParameters {public get; public set;}
	}

	public class StartupParam {
		public List<Product> Products {public get; public set;}
		public String sfdcConfigId {public get; public set;}
		public Double WindSpeed {public get; public set;}
		public Double WindPressure {public get; public set;}
		public Integer TerrainType {public get; public set;}
		public Boolean IsHill {public get; public set;}
		public Double SnowLoading {public get; public set;}
		public Double RoofHeight {public get; public set;}
		public Boolean Seal {public get; public set;}
		public Boolean WaterHoles {public get; public set;}
		public String CountryCode {public get; public set;}
	//	public Boolean IncludeBlinds {public get; public set;}
	//	public Boolean offerBlindsIncluded {public get; public set;}
		public Double CombinedLoad {public get; public set;}
		public String OrderNumber {public get; public set;}
		public Boolean LockRVN {public get; public set;}
		public Boolean SplitPlan {public get; public set;}
	}

	public class Product {
		public String ProductCode {public get; public set;}
		public String CostType {public get; public set;}
	}
}