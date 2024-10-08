/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-26-2024
 * @last modified by  : Henk Reynders
**/
@isTest(isParallel=false)
public with sharing class DocumentationXMLDataTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        
        Test.stopTest();
    }   
    //public static String structureJSON = [SELECT Body FROM StaticResource WHERE Name = 'Example_Structure_LGS' ].Body.toString();
    //public static String documentationXML = [SELECT Body FROM StaticResource WHERE Name = 'TestDocumentationXML' ].Body.toString();
    public static String documentationJSON = [SELECT Body FROM StaticResource WHERE Name = 'Example_Documentation' ].Body.toString();
    //public static String structureXML;// = [SELECT Body FROM StaticResource WHERE Name = 'TestStructureXML' ].Body.toString();
    @IsTest
    static void parseStructureJSONTest(){       
        Test.startTest();
		DocumentationXMLData documentationData = DocumentationXMLData.parse(documentationJSON);
        System.debug('--- DocumentationXMLDataTest - parseStructureJSONTest - documentationData: '+documentationData); 
        System.assertNotEquals(null,documentationData, 'Expected JSON to be parsed');
        System.debug('--- DocumentationXMLDataTest - parseStructureJSONTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- DocumentationXMLDataTest - parseStructureJSONTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'	\"products\": {'+
		'		\"name\": \"LGR 2x2 + 2\",'+
		'		\"space\": {'+
		'			\"corner_multiplier\": \"No\",'+
		'			\"floor_height\": \"2\",'+
		'			\"balcony_plate_height\": \"0\",'+
		'			\"sides\": {'+
		'				\"side\": ['+
		'					{'+
		'						\"number\": \"0\",'+
		'						\"height\": \"2000\",'+
		'						\"width\": \"2000\",'+
		'						\"start_angle\": \"90\",'+
		'						\"system_angle\": \"90\",'+
		'						\"end_angle\": {'+
		'							\"_xsi:nil\": \"true\"'+
		'						},'+
		'						\"products\": \"BalconyGlazing\",'+
		'						\"connecting_profiles_right\": \"Both\"'+
		'					},'+
		'					{'+
		'						\"number\": \"1\",'+
		'						\"height\": \"2000\",'+
		'						\"width\": \"2000\",'+
		'						\"start_angle\": {'+
		'							\"_xsi:nil\": \"true\"'+
		'						},'+
		'						\"system_angle\": {'+
		'							\"_xsi:nil\": \"true\"'+
		'						},'+
		'						\"end_angle\": \"90\",'+
		'						\"products\": \"BalconyGlazing\",'+
		'						\"connecting_profiles_left\": \"Both\"'+
		'					}'+
		'				]'+
		'			}'+
		'		},'+
		'		\"balconyglazing\": {'+
		'			\"product_code\": \"LG\",'+
		'			\"product_code_short\": \"LG\",'+
		'			\"structural_version_number\": \"30014185\",'+
		'			\"unique_system_id\": \"R1a-z_gfO0KV7yb665kk0w\",'+
		'			\"is_reclaimed\": \"false\",'+
		'			\"product_status\": \"1\",'+
		'			\"product_weight\": \"434.5858\",'+
		'			\"order_xml_info\": {'+
		'				\"rivipaino\": \"434.5858\",'+
		'				\"sivut\": {'+
		'					\"sivu\": ['+
		'						{'+
		'							\"numero\": \"1\",'+
		'							\"profiilivari-yla\": \"E6/EV1\",'+
		'							\"profiilivari-ala\": \"E6/EV1\",'+
		'							\"lasi-vahvuus\": \"12\",'+
		'							\"lasi-vari\": \"20090020\",'+
		'							\"lasi-karkaisu\": \"1\",'+
		'							\"muovivari-yla\": \"Tummanharmaa\",'+
		'							\"muovivari-ala\": \"Tummanharmaa\",'+
		'							\"profiili-yla\": \"11222206\",'+
		'							\"profiili-ala\": \"11243001\",'+
		'							\"profiili-saato\": \"11241205\",'+
		'							\"profiilipituus\": \"2000\",'+
		'							\"lasitus-pituus\": \"2000\",'+
		'							\"lasitus-korkeus\": \"2000\",'+
		'							\"lasivasen-kpl\": \"3\",'+
		'							\"lasioikea-kpl\": \"0\",'+
		'							\"kulmanylitys\": \"CORNER_BYPASS_NO\",'+
		'							\"sivun-paino\": \"217.292907714844\",'+
		'							\"alkukulma\": \"90\",'+
		'							\"loppukulma\": \"90\",'+
		'							\"jarjestelmakulma\": \"90\"'+
		'						},'+
		'						{'+
		'							\"numero\": \"2\",'+
		'							\"profiilivari-yla\": \"E6/EV1\",'+
		'							\"profiilivari-ala\": \"E6/EV1\",'+
		'							\"lasi-vahvuus\": \"12\",'+
		'							\"lasi-vari\": \"20090020\",'+
		'							\"lasi-karkaisu\": \"1\",'+
		'							\"muovivari-yla\": \"Tummanharmaa\",'+
		'							\"muovivari-ala\": \"Tummanharmaa\",'+
		'							\"profiili-yla\": \"11222206\",'+
		'							\"profiili-ala\": \"11243001\",'+
		'							\"profiili-saato\": \"11241205\",'+
		'							\"profiilipituus\": \"2000\",'+
		'							\"lasitus-pituus\": \"2000\",'+
		'							\"lasitus-korkeus\": \"2000\",'+
		'							\"lasivasen-kpl\": \"3\",'+
		'							\"lasioikea-kpl\": \"0\",'+
		'							\"kulmanylitys\": \"CORNER_BYPASS_NO\",'+
		'							\"sivun-paino\": \"217.292907714844\",'+
		'							\"alkukulma\": \"90\",'+
		'							\"loppukulma\": \"90\",'+
		'							\"jarjestelmakulma\": \"\"'+
		'						}'+
		'					]'+
		'				}'+
		'			},'+
		'			\"installation_xml_info\": {'+
		'				\"AssemblyDocument\": {'+
		'					\"Chapter\": ['+
		'						{'+
		'							\"Paragraph\": ['+
		'								{'+
		'									\"_name\": \"Tuote\",'+
		'									\"__text\": \"LG , [INST_XML_SIDES]:2\"'+
		'								},'+
		'								{'+
		'									\"_name\": \"Kiinnitystapa\",'+
		'									\"__text\": \"[INST_XML_UPPER]: [INST_XML_TO_ROOF], [INST_XML_LOWER]: [INST_XML_TO_FLOOR]\"'+
		'								},'+
		'								{'+
		'									\"_name\": \"Profiilit\",'+
		'									\"__text\": \"[INST_XML_UPPER]: 11241205 E6/EV1, [INST_XML_LOWER]: 11243001 11243001\"'+
		'								},'+
		'								{'+
		'									\"_name\": \"Varusteet\",'+
		'									\"__text\": \"[INST_XML_PLASTIC_PARTS]: [INST_XML_DARK_GREY], [INST_XML_END_PLUGS]\"'+
		'								}'+
		'							],'+
		'							\"_name\": \"Tuotetiedot\"'+
		'						},'+
		'						{'+
		'							\"Paragraph\": ['+
		'								{'+
		'									\"_name\": \"Sivu1,H3=1873\",'+
		'									\"__text\": \"[INST_XML_START_ANGLE]=90 [INST_XML_END_ANGLE]= [INST_XML_LENGTH]=2000 [INST_XML_ZMEASURE]=0 [INST_XML_HEIGHT]=2000 [INST_XML_LOWER_REDUCTION]=0 [INST_XML_UPPER_REDUCTION]=0 [INST_XML_LEFT_GLASSES]=3 [INST_XML_RIGHT_GLASSES]=0 [INST_XML_SYSTEM_ANGLE]=90 [INST_XML_CORNER_BYPASS]=[INST_XML_VALUE_NO] [INST_XML_ADJUSTMENT_SCREW]= [INST_XML_UPPER_PROFILE]: 11241205 E6/EV1 [INST_XML_LOWER_PROFILE]: 11243001 E6/EV1 [INST_XML_TELESCOPIC_PROFILE]: 11222206 E6/EV1 [INST_XML_GLASS]1: [INST_XML_WIDTH_SHORT]=648 [INST_XML_HEIGHT_SHORT]=1861 [INST_XML_GLASS]2: [INST_XML_WIDTH_SHORT]=648 [INST_XML_HEIGHT_SHORT]=1861 [INST_XML_GLASS]3: [INST_XML_WIDTH_SHORT]=648 [INST_XML_HEIGHT_SHORT]=1861\"'+
		'								},'+
		'								{'+
		'									\"_name\": \"Sivu2,H3=1873\",'+
		'									\"__text\": \"[INST_XML_START_ANGLE]= [INST_XML_END_ANGLE]=90 [INST_XML_LENGTH]=2000 [INST_XML_ZMEASURE]=0 [INST_XML_HEIGHT]=2000 [INST_XML_LOWER_REDUCTION]=0 [INST_XML_UPPER_REDUCTION]=0 [INST_XML_LEFT_GLASSES]=3 [INST_XML_RIGHT_GLASSES]=0 [INST_XML_SYSTEM_ANGLE]= [INST_XML_CORNER_BYPASS]=[INST_XML_VALUE_NO] [INST_XML_ADJUSTMENT_SCREW]= [INST_XML_UPPER_PROFILE]: 11241205 E6/EV1 [INST_XML_LOWER_PROFILE]: 11243001 E6/EV1 [INST_XML_TELESCOPIC_PROFILE]: 11222206 E6/EV1 [INST_XML_GLASS]1: [INST_XML_WIDTH_SHORT]=648 [INST_XML_HEIGHT_SHORT]=1861 [INST_XML_GLASS]2: [INST_XML_WIDTH_SHORT]=648 [INST_XML_HEIGHT_SHORT]=1861 [INST_XML_GLASS]3: [INST_XML_WIDTH_SHORT]=648 [INST_XML_HEIGHT_SHORT]=1861\"'+
		'								}'+
		'							],'+
		'							\"_name\": \"Tuotemitat\"'+
		'						}'+
		'					],'+
		'					\"_name\": \"Asennustiedot\"'+
		'				}'+
		'			},'+
		'			\"start_reduction\": \"0\",'+
		'			\"end_reduction\": \"0\",'+
		'			\"plastic_color\": \"PLASTIC_COLOR_DARK_GREY\",'+
		'			\"heat_soak\": \"LUMON_NO_HEATSOAK\",'+
		'			\"glass_default_width\": {'+
		'				\"_xsi:nil\": \"true\"'+
		'			},'+
		'			\"glass_type\": \"20090020\",'+
		'			\"glass_thickness\": \"12\",'+
		'			\"glass_color\": \"GLASS_COLOR_OF88_CLEAR\",'+
		'			\"external_sill\": \"LG_NoWaterFlashing\",'+
		'			\"external_sill_seal\": \"DOCXML_NO\",'+
		'			\"end_plugs\": \"DOCXML_YES\",'+
		'			\"upper_profile\": \"UPPER_PROFILE_11251205_11222206\",'+
		'			\"upper_profile_color\": \"E6/EV1\",'+
		'			\"upper_profile_connection_material\": \"CrackedConcreteC20\",'+
		'			\"lower_profile\": \"LOWER_PROFILE_11253001\",'+
		'			\"lower_profile_color\": \"E6/EV1\",'+
		'			\"lower_profile_connection_material\": \"CrackedConcreteC20\",'+
		'			\"upper_brackets\": \"NO_UPPER_BRACKET\",'+
		'			\"lower_brackets\": \"LowerBracket_NoBracket\",'+
		'			\"left_edge_seal\": \"LEFT_EDGE_SEAL_54042024\",'+
		'			\"left_edge_seal_color\": \"\",'+
		'			\"right_edge_seal\": \"RIGHT_EDGE_SEAL_54042024\",'+
		'			\"right_edge_seal_color\": \"\",'+
		'			\"watering_holes\": \"YES_DRAINHOLE\",'+
		'			\"glass_seals\": \"NO_H-SEAL\",'+
		'			\"attention_tape\": \"DOCXML_YES\",'+
		'			\"pull_latch\": \"DOCXML_NO\",'+
		'			\"upper_seal\": \"DOCXML_NO\",'+
		'			\"lower_seal\": \"NO_LowerSeal\",'+
		'			\"decibel_sealing\": \"DOCXML_NO\",'+
		'			\"balustrade_seal\": \"NO_LowerSeal\",'+
		'			\"vertical_frame\": \"DOCXML_NO\",'+
		'			\"embedded_feature\": \"LUMON_NO_EMBEDDED_SYSTEM\",'+
		'			\"lower_profile_fastening_holes\": \"NO_MILLING\",'+
		'			\"sides\": {'+
		'				\"side\": ['+
		'					{'+
		'						\"number\": \"0\",'+
		'						\"space_side_number\": \"0\",'+
		'						\"is_reclaimed\": \"false\",'+
		'						\"product_side_status\": \"1\",'+
		'						\"side_weight\": \"217.292907714844\",'+
		'						\"start_angle\": \"90\",'+
		'						\"system_angle\": \"90\",'+
		'						\"end_angle\": \"90\",'+
		'						\"z_measure\": \"0\",'+
		'						\"structural_height\": \"2000\",'+
		'						\"structural_width\": \"2000\",'+
		'						\"product_height\": \"2000\",'+
		'						\"product_width\": \"2000\",'+
		'						\"opening_width\": \"2000\",'+
		'						\"opening_height\": \"2000\",'+
		'						\"lower_reduction\": \"0\",'+
		'						\"upper_reduction\": \"0\",'+
		'						\"start_reduction\": \"0\",'+
		'						\"end_reduction\": \"0\",'+
		'						\"glasses_left\": \"3\",'+
		'						\"glasses_right\": \"0\",'+
		'						\"glasses_left_allowed\": \"DOCXML_NO\",'+
		'						\"glasses_right_allowed\": \"DOCXML_NO\",'+
		'						\"corner_bypass\": \"CORNER_BYPASS_NO\",'+
		'						\"latch\": \"LUMON_PD9240061\",'+
		'						\"adjustment_screw\": \"10\",'+
		'						\"h3\": \"1873\",'+
		'						\"glass_height\": \"1861\",'+
		'						\"connecting_profiles_right\": \"Both\",'+
		'						\"balustrade_width\": \"0\",'+
		'						\"latch_left\": \"LUMON_PD9240061\",'+
		'						\"latch_left_height\": \"0\",'+
		'						\"latch_right\": \"DOCXML_NO\",'+
		'						\"latch_right_height\": \"0\",'+
		'						\"profile\": \"0\",'+
		'						\"profile_extension_left\": \"0\",'+
		'						\"profile_extension_right\": \"0\",'+
		'						\"sliding\": \"DOCXML_NO\",'+
		'						\"bracket_color\": \"Tummanharmaa\",'+
		'						\"differences\": \"\",'+
		'						\"reclaimed_features\": \"\",'+
		'						\"glasses\": {'+
		'							\"glass\": ['+
		'								{'+
		'									\"is_reclaimed\": \"false\",'+
		'									\"number\": \"0\",'+
		'									\"height\": \"1861\",'+
		'									\"width\": \"648\",'+
		'									\"rail\": \"0\",'+
		'									\"blinds\": \"LUMON_BLIND_ONE_PART\",'+
		'									\"sandblasting\": \"DOCXML_NO\",'+
		'									\"differences\": {'+
		'										\"difference\": ['+
		'											{'+
		'												\"feature_name\": \"Blinds\",'+
		'												\"value\": \"LUMON_BLIND_ONE_PART\",'+
		'												\"translation\": \"DOCXML_BLINDS\"'+
		'											},'+
		'											{'+
		'												\"feature_name\": \"BlindsColor\",'+
		'												\"value\": \"LUMON_BLIND_COLOR_1288\",'+
		'												\"translation\": \"DOCXML_BLINDS_COLOR\"'+
		'											},'+
		'											{'+
		'												\"feature_name\": \"BlindsProfileColor\",'+
		'												\"value\": \"LUMON_BLIND_PROFILE_COLOR_RAL9010\",'+
		'												\"translation\": \"DOCXML_BLINDS_PROFILE_COLOR\"'+
		'											},'+
		'											{'+
		'												\"feature_name\": \"MiddleLatchLeft\",'+
		'												\"value\": \"LUMON_PD9240061\",'+
		'												\"translation\": \"DOCXML_MIDDLE_LATCH_LEFT\"'+
		'											},'+
		'											{'+
		'												\"feature_name\": \"MiddleLatchHeightLeft\",'+
		'												\"value\": \"0 mm\",'+
		'												\"translation\": \"DOCXML_MIDDLE_LATCH_HEIGHT_LEFT\"'+
		'											}'+
		'										]'+
		'									},'+
		'									\"reclaimed_features\": \"\"'+
		'								},'+
		'								{'+
		'									\"is_reclaimed\": \"false\",'+
		'									\"number\": \"1\",'+
		'									\"height\": \"1861\",'+
		'									\"width\": \"648\",'+
		'									\"rail\": \"0\",'+
		'									\"blinds\": \"LUMON_BLIND_ONE_PART\",'+
		'									\"sandblasting\": \"DOCXML_NO\",'+
		'									\"differences\": {'+
		'										\"difference\": ['+
		'											{'+
		'												\"feature_name\": \"Blinds\",'+
		'												\"value\": \"LUMON_BLIND_ONE_PART\",'+
		'												\"translation\": \"DOCXML_BLINDS\"'+
		'											},'+
		'											{'+
		'												\"feature_name\": \"BlindsColor\",'+
		'												\"value\": \"LUMON_BLIND_COLOR_1288\",'+
		'												\"translation\": \"DOCXML_BLINDS_COLOR\"'+
		'											},'+
		'											{'+
		'												\"feature_name\": \"BlindsProfileColor\",'+
		'												\"value\": \"LUMON_BLIND_PROFILE_COLOR_RAL9010\",'+
		'												\"translation\": \"DOCXML_BLINDS_PROFILE_COLOR\"'+
		'											}'+
		'										]'+
		'									},'+
		'									\"reclaimed_features\": \"\"'+
		'								},'+
		'								{'+
		'									\"is_reclaimed\": \"false\",'+
		'									\"number\": \"2\",'+
		'									\"height\": \"1861\",'+
		'									\"width\": \"648\",'+
		'									\"rail\": \"0\",'+
		'									\"blinds\": \"LUMON_BLIND_ONE_PART\",'+
		'									\"sandblasting\": \"DOCXML_NO\",'+
		'									\"differences\": {'+
		'										\"difference\": ['+
		'											{'+
		'												\"feature_name\": \"Blinds\",'+
		'												\"value\": \"LUMON_BLIND_ONE_PART\",'+
		'												\"translation\": \"DOCXML_BLINDS\"'+
		'											},'+
		'											{'+
		'												\"feature_name\": \"BlindsColor\",'+
		'												\"value\": \"LUMON_BLIND_COLOR_1288\",'+
		'												\"translation\": \"DOCXML_BLINDS_COLOR\"'+
		'											},'+
		'											{'+
		'												\"feature_name\": \"BlindsProfileColor\",'+
		'												\"value\": \"LUMON_BLIND_PROFILE_COLOR_RAL9010\",'+
		'												\"translation\": \"DOCXML_BLINDS_PROFILE_COLOR\"'+
		'											}'+
		'										]'+
		'									},'+
		'									\"reclaimed_features\": \"\"'+
		'								}'+
		'							]'+
		'						}'+
		'					},'+
		'					{'+
		'						\"number\": \"1\",'+
		'						\"space_side_number\": \"1\",'+
		'						\"is_reclaimed\": \"false\",'+
		'						\"product_side_status\": \"1\",'+
		'						\"side_weight\": \"217.292907714844\",'+
		'						\"start_angle\": \"90\",'+
		'						\"system_angle\": \"0\",'+
		'						\"end_angle\": \"90\",'+
		'						\"z_measure\": \"0\",'+
		'						\"structural_height\": \"2000\",'+
		'						\"structural_width\": \"2000\",'+
		'						\"product_height\": \"2000\",'+
		'						\"product_width\": \"2000\",'+
		'						\"opening_width\": \"2000\",'+
		'						\"opening_height\": \"2000\",'+
		'						\"lower_reduction\": \"0\",'+
		'						\"upper_reduction\": \"0\",'+
		'						\"start_reduction\": \"0\",'+
		'						\"end_reduction\": \"0\",'+
		'						\"glasses_left\": \"3\",'+
		'						\"glasses_right\": \"0\",'+
		'						\"glasses_left_allowed\": \"DOCXML_NO\",'+
		'						\"glasses_right_allowed\": \"DOCXML_NO\",'+
		'						\"corner_bypass\": \"CORNER_BYPASS_NO\",'+
		'						\"latch\": \"LUMON_PD9240061\",'+
		'						\"adjustment_screw\": \"10\",'+
		'						\"h3\": \"1873\",'+
		'						\"glass_height\": \"1861\",'+
		'						\"connecting_profiles_left\": \"Both\",'+
		'						\"balustrade_width\": \"0\",'+
		'						\"latch_left\": \"LUMON_PD9240061\",'+
		'						\"latch_left_height\": \"0\",'+
		'						\"latch_right\": \"DOCXML_NO\",'+
		'						\"latch_right_height\": \"0\",'+
		'						\"profile\": \"0\",'+
		'						\"profile_extension_left\": \"0\",'+
		'						\"profile_extension_right\": \"0\",'+
		'						\"sliding\": \"DOCXML_NO\",'+
		'						\"bracket_color\": \"Tummanharmaa\",'+
		'						\"differences\": \"\",'+
		'						\"reclaimed_features\": \"\",'+
		'						\"glasses\": {'+
		'							\"glass\": ['+
		'								{'+
		'									\"is_reclaimed\": \"false\",'+
		'									\"number\": \"0\",'+
		'									\"height\": \"1861\",'+
		'									\"width\": \"648\",'+
		'									\"rail\": \"0\",'+
		'									\"blinds\": \"LUMON_BLIND_ONE_PART\",'+
		'									\"sandblasting\": \"DOCXML_NO\",'+
		'									\"differences\": {'+
		'										\"difference\": ['+
		'											{'+
		'												\"feature_name\": \"Blinds\",'+
		'												\"value\": \"LUMON_BLIND_ONE_PART\",'+
		'												\"translation\": \"DOCXML_BLINDS\"'+
		'											},'+
		'											{'+
		'												\"feature_name\": \"BlindsColor\",'+
		'												\"value\": \"LUMON_BLIND_COLOR_1288\",'+
		'												\"translation\": \"DOCXML_BLINDS_COLOR\"'+
		'											},'+
		'											{'+
		'												\"feature_name\": \"BlindsProfileColor\",'+
		'												\"value\": \"LUMON_BLIND_PROFILE_COLOR_RAL9010\",'+
		'												\"translation\": \"DOCXML_BLINDS_PROFILE_COLOR\"'+
		'											},'+
		'											{'+
		'												\"feature_name\": \"MiddleLatchLeft\",'+
		'												\"value\": \"LUMON_PD9240061\",'+
		'												\"translation\": \"DOCXML_MIDDLE_LATCH_LEFT\"'+
		'											},'+
		'											{'+
		'												\"feature_name\": \"MiddleLatchHeightLeft\",'+
		'												\"value\": \"0 mm\",'+
		'												\"translation\": \"DOCXML_MIDDLE_LATCH_HEIGHT_LEFT\"'+
		'											}'+
		'										]'+
		'									},'+
		'									\"reclaimed_features\": \"\"'+
		'								},'+
		'								{'+
		'									\"is_reclaimed\": \"false\",'+
		'									\"number\": \"1\",'+
		'									\"height\": \"1861\",'+
		'									\"width\": \"648\",'+
		'									\"rail\": \"0\",'+
		'									\"blinds\": \"LUMON_BLIND_ONE_PART\",'+
		'									\"sandblasting\": \"DOCXML_NO\",'+
		'									\"differences\": {'+
		'										\"difference\": ['+
		'											{'+
		'												\"feature_name\": \"Blinds\",'+
		'												\"value\": \"LUMON_BLIND_ONE_PART\",'+
		'												\"translation\": \"DOCXML_BLINDS\"'+
		'											},'+
		'											{'+
		'												\"feature_name\": \"BlindsColor\",'+
		'												\"value\": \"LUMON_BLIND_COLOR_1288\",'+
		'												\"translation\": \"DOCXML_BLINDS_COLOR\"'+
		'											},'+
		'											{'+
		'												\"feature_name\": \"BlindsProfileColor\",'+
		'												\"value\": \"LUMON_BLIND_PROFILE_COLOR_RAL9010\",'+
		'												\"translation\": \"DOCXML_BLINDS_PROFILE_COLOR\"'+
		'											}'+
		'										]'+
		'									},'+
		'									\"reclaimed_features\": \"\"'+
		'								},'+
		'								{'+
		'									\"is_reclaimed\": \"false\",'+
		'									\"number\": \"2\",'+
		'									\"height\": \"1861\",'+
		'									\"width\": \"648\",'+
		'									\"rail\": \"0\",'+
		'									\"blinds\": \"LUMON_BLIND_ONE_PART\",'+
		'									\"sandblasting\": \"DOCXML_NO\",'+
		'									\"differences\": {'+
		'										\"difference\": ['+
		'											{'+
		'												\"feature_name\": \"Blinds\",'+
		'												\"value\": \"LUMON_BLIND_ONE_PART\",'+
		'												\"translation\": \"DOCXML_BLINDS\"'+
		'											},'+
		'											{'+
		'												\"feature_name\": \"BlindsColor\",'+
		'												\"value\": \"LUMON_BLIND_COLOR_1288\",'+
		'												\"translation\": \"DOCXML_BLINDS_COLOR\"'+
		'											},'+
		'											{'+
		'												\"feature_name\": \"BlindsProfileColor\",'+
		'												\"value\": \"LUMON_BLIND_PROFILE_COLOR_RAL9010\",'+
		'												\"translation\": \"DOCXML_BLINDS_PROFILE_COLOR\"'+
		'											}'+
		'										]'+
		'									},'+
		'									\"reclaimed_features\": \"\"'+
		'								}'+
		'							]'+
		'						}'+
		'					}'+
		'				]'+
		'			},'+
		'			\"other_products\": {'+
		'				\"order_xml_info\": \"\",'+
		'				\"installation_xml_info\": \"\",'+
		'				\"is_reclaimed\": \"false\"'+
		'			}'+
		'		},'+
		'		\"_xmlns:xsd\": \"http://www.w3.org/2001/XMLSchema\",'+
		'		\"_xmlns:xsi\": \"http://www.w3.org/2001/XMLSchema-instance\"'+
		'	}'+
		'}';
		DocumentationXMLData r = DocumentationXMLData.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Space objSpace = new DocumentationXMLData.Space(System.JSON.createParser(json));
		System.assert(objSpace != null);
		System.assert(objSpace.corner_multiplier == null);
		System.assert(objSpace.floor_height == null);
		System.assert(objSpace.balcony_plate_height == null);
		System.assert(objSpace.sides == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Balconyglazing objBalconyglazing = new DocumentationXMLData.Balconyglazing(System.JSON.createParser(json));
		System.assert(objBalconyglazing != null);
		System.assert(objBalconyglazing.product_code == null);
		System.assert(objBalconyglazing.product_code_short == null);
		System.assert(objBalconyglazing.structural_version_number == null);
		System.assert(objBalconyglazing.unique_system_id == null);
		System.assert(objBalconyglazing.is_reclaimed == null);
		System.assert(objBalconyglazing.product_status == null);
		System.assert(objBalconyglazing.product_weight == null);
		System.assert(objBalconyglazing.order_xml_info == null);
		//System.assert(objBalconyglazing.installation_xml_info == null);
		System.assert(objBalconyglazing.start_reduction == null);
		System.assert(objBalconyglazing.end_reduction == null);
		System.assert(objBalconyglazing.plastic_color == null);
		System.assert(objBalconyglazing.heat_soak == null);
		System.assert(objBalconyglazing.glass_default_width == null);
		System.assert(objBalconyglazing.glass_type == null);
		System.assert(objBalconyglazing.glass_thickness == null);
		System.assert(objBalconyglazing.glass_color == null);
		System.assert(objBalconyglazing.external_sill == null);
		System.assert(objBalconyglazing.external_sill_seal == null);
		System.assert(objBalconyglazing.end_plugs == null);
		System.assert(objBalconyglazing.upper_profile == null);
		System.assert(objBalconyglazing.upper_profile_color == null);
		System.assert(objBalconyglazing.upper_profile_connection_material == null);
		System.assert(objBalconyglazing.lower_profile == null);
		System.assert(objBalconyglazing.lower_profile_color == null);
		System.assert(objBalconyglazing.lower_profile_connection_material == null);
		System.assert(objBalconyglazing.upper_brackets == null);
		System.assert(objBalconyglazing.lower_brackets == null);
		System.assert(objBalconyglazing.left_edge_seal == null);
		System.assert(objBalconyglazing.left_edge_seal_color == null);
		System.assert(objBalconyglazing.right_edge_seal == null);
		System.assert(objBalconyglazing.right_edge_seal_color == null);
		System.assert(objBalconyglazing.watering_holes == null);
		System.assert(objBalconyglazing.glass_seals == null);
		System.assert(objBalconyglazing.attention_tape == null);
		System.assert(objBalconyglazing.pull_latch == null);
		System.assert(objBalconyglazing.upper_seal == null);
		System.assert(objBalconyglazing.lower_seal == null);
		System.assert(objBalconyglazing.decibel_sealing == null);
		System.assert(objBalconyglazing.balustrade_seal == null);
		System.assert(objBalconyglazing.vertical_frame == null);
		System.assert(objBalconyglazing.embedded_feature == null);
		System.assert(objBalconyglazing.lower_profile_fastening_holes == null);
		System.assert(objBalconyglazing.sides == null);
		System.assert(objBalconyglazing.other_products == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Products objProducts = new DocumentationXMLData.Products(System.JSON.createParser(json));
		System.assert(objProducts != null);
		System.assert(objProducts.name == null);
		System.assert(objProducts.space == null);
		System.assert(objProducts.balconyglazing == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData objDocumentationXML = new DocumentationXMLData(System.JSON.createParser(json));
		System.assert(objDocumentationXML != null);
		System.assert(objDocumentationXML.products == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Glass objGlass = new DocumentationXMLData.Glass(System.JSON.createParser(json));
		System.assert(objGlass != null);
		System.assert(objGlass.is_reclaimed == null);
		System.assert(objGlass.number_Z == null);
		System.assert(objGlass.height == null);
		System.assert(objGlass.width == null);
		System.assert(objGlass.rail == null);
		System.assert(objGlass.blinds == null);
		System.assert(objGlass.sandblasting == null);
		System.assert(objGlass.differences == null);
		System.assert(objGlass.reclaimed_features == null);
/*
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Chapter objChapter = new DocumentationXMLData.Chapter(System.JSON.createParser(json));
		System.assert(objChapter != null);
		System.assert(objChapter.Paragraph == null);
		System.assert(objChapter.x_name == null);
*/
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Other_products objOther_products = new DocumentationXMLData.Other_products(System.JSON.createParser(json));
		System.assert(objOther_products != null);
		System.assert(objOther_products.order_xml_info == null);
		System.assert(objOther_products.installation_xml_info == null);
		System.assert(objOther_products.is_reclaimed == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Order_xml_info objOrder_xml_info = new DocumentationXMLData.Order_xml_info(System.JSON.createParser(json));
		System.assert(objOrder_xml_info != null);
		System.assert(objOrder_xml_info.rivipaino == null);
		System.assert(objOrder_xml_info.sivut == null);
/*
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.AssemblyDocument objAssemblyDocument = new DocumentationXMLData.AssemblyDocument(System.JSON.createParser(json));
		System.assert(objAssemblyDocument != null);
		System.assert(objAssemblyDocument.Chapter == null);
		System.assert(objAssemblyDocument.x_name == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Installation_xml_info objInstallation_xml_info = new DocumentationXMLData.Installation_xml_info(System.JSON.createParser(json));
		System.assert(objInstallation_xml_info != null);
		System.assert(objInstallation_xml_info.AssemblyDocument == null);
*/
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Side_Z objSide_Z = new DocumentationXMLData.Side_Z(System.JSON.createParser(json));
		System.assert(objSide_Z != null);
		System.assert(objSide_Z.number_Z == null);
		System.assert(objSide_Z.space_side_number == null);
		System.assert(objSide_Z.is_reclaimed == null);
		System.assert(objSide_Z.product_side_status == null);
		System.assert(objSide_Z.side_weight == null);
		System.assert(objSide_Z.start_angle == null);
		System.assert(objSide_Z.system_angle == null);
		System.assert(objSide_Z.end_angle == null);
		System.assert(objSide_Z.z_measure == null);
		System.assert(objSide_Z.structural_height == null);
		System.assert(objSide_Z.structural_width == null);
		System.assert(objSide_Z.product_height == null);
		System.assert(objSide_Z.product_width == null);
		System.assert(objSide_Z.opening_width == null);
		System.assert(objSide_Z.opening_height == null);
		System.assert(objSide_Z.lower_reduction == null);
		System.assert(objSide_Z.upper_reduction == null);
		System.assert(objSide_Z.start_reduction == null);
		System.assert(objSide_Z.end_reduction == null);
		System.assert(objSide_Z.glasses_left == null);
		System.assert(objSide_Z.glasses_right == null);
		System.assert(objSide_Z.glasses_left_allowed == null);
		System.assert(objSide_Z.glasses_right_allowed == null);
		System.assert(objSide_Z.corner_bypass == null);
		System.assert(objSide_Z.latch == null);
		System.assert(objSide_Z.adjustment_screw == null);
		System.assert(objSide_Z.h3 == null);
		System.assert(objSide_Z.glass_height == null);
		System.assert(objSide_Z.connecting_profiles_right == null);
		System.assert(objSide_Z.balustrade_width == null);
		System.assert(objSide_Z.latch_left == null);
		System.assert(objSide_Z.latch_left_height == null);
		System.assert(objSide_Z.latch_right == null);
		System.assert(objSide_Z.latch_right_height == null);
		System.assert(objSide_Z.profile == null);
		System.assert(objSide_Z.profile_extension_left == null);
		System.assert(objSide_Z.profile_extension_right == null);
		System.assert(objSide_Z.sliding == null);
		System.assert(objSide_Z.bracket_color == null);
		System.assert(objSide_Z.differences == null);
		System.assert(objSide_Z.reclaimed_features == null);
		System.assert(objSide_Z.glasses == null);
		System.assert(objSide_Z.connecting_profiles_left == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Difference objDifference = new DocumentationXMLData.Difference(System.JSON.createParser(json));
		System.assert(objDifference != null);
		System.assert(objDifference.feature_name == null);
		System.assert(objDifference.value == null);
		System.assert(objDifference.translation == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Differences objDifferences = new DocumentationXMLData.Differences(System.JSON.createParser(json));
		System.assert(objDifferences != null);
		System.assert(objDifferences.difference == null);
/*
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Paragraph objParagraph = new DocumentationXMLData.Paragraph(System.JSON.createParser(json));
		System.assert(objParagraph != null);
		System.assert(objParagraph.x_name == null);
		System.assert(objParagraph.x__text == null);
*/
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Side objSide = new DocumentationXMLData.Side(System.JSON.createParser(json));
		System.assert(objSide != null);
		System.assert(objSide.number_Z == null);
		System.assert(objSide.height == null);
		System.assert(objSide.width == null);
		System.assert(objSide.start_angle == null);
		System.assert(objSide.system_angle == null);
		System.assert(objSide.end_angle == null);
		System.assert(objSide.products == null);
		System.assert(objSide.connecting_profiles_right == null);
		System.assert(objSide.connecting_profiles_left == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Sivu objSivu = new DocumentationXMLData.Sivu(System.JSON.createParser(json));
		System.assert(objSivu != null);
		System.assert(objSivu.numero == null);
		System.assert(objSivu.profiilivari_yla == null);
		System.assert(objSivu.profiilivari_ala == null);
		System.assert(objSivu.lasi_vahvuus == null);
		System.assert(objSivu.lasi_vari == null);
		System.assert(objSivu.lasi_karkaisu == null);
		System.assert(objSivu.muovivari_yla == null);
		System.assert(objSivu.muovivari_ala == null);
		System.assert(objSivu.profiili_yla == null);
		System.assert(objSivu.profiili_ala == null);
		System.assert(objSivu.profiili_saato == null);
		System.assert(objSivu.profiilipituus == null);
		System.assert(objSivu.lasitus_pituus == null);
		System.assert(objSivu.lasitus_korkeus == null);
		System.assert(objSivu.lasivasen_kpl == null);
		System.assert(objSivu.lasioikea_kpl == null);
		System.assert(objSivu.kulmanylitys == null);
		System.assert(objSivu.sivun_paino == null);
		System.assert(objSivu.alkukulma == null);
		System.assert(objSivu.loppukulma == null);
		System.assert(objSivu.jarjestelmakulma == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Sides_Z objSides_Z = new DocumentationXMLData.Sides_Z(System.JSON.createParser(json));
		System.assert(objSides_Z != null);
		System.assert(objSides_Z.side == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Glasses objGlasses = new DocumentationXMLData.Glasses(System.JSON.createParser(json));
		System.assert(objGlasses != null);
		System.assert(objGlasses.glass == null);
/*
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Floor_height objFloor_height = new DocumentationXMLData.Floor_height(System.JSON.createParser(json));
		System.assert(objFloor_height != null);
		System.assert(objFloor_height.x_xsi:nil == null);
*/
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Sivut objSivut = new DocumentationXMLData.Sivut(System.JSON.createParser(json));
		System.assert(objSivut != null);
		System.assert(objSivut.sivu == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DocumentationXMLData.Sides objSides = new DocumentationXMLData.Sides(System.JSON.createParser(json));
		System.assert(objSides != null);
		System.assert(objSides.side == null);
	}
}