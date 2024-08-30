/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-12-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class VisualStructureTest {
    @IsTest
    static void ParseStructureOnlyTest() {
        String structureJSON = '{'+
        '    \"product_type\": \"Product 1\",'+
        '    \"structure\": 0,'+
        '    \"structure_number\": \"30011112\",'+
        '    \"original_sn\": \"30011111\",'+
        '    \"product_openings\": 1'+
        '  }'; 
        VisualStructure configObject = VisualStructure.parse(structureJSON);
        System.assert(configObject != null);
    }
    @IsTest
    static void ParseAnalysisTest() {
        String structureJSON = '{'+
        '    \"product_type\": \"Product 1\",'+
        '    \"structure\": 0,'+
        '    \"structure_number\": \"30011112\",'+
        '    \"original_sn\": \"30011111\",'+
        '    \"product_openings\": 1,'+
        '    \"terrain_class\": 2,'+
        '    \"building_height\": 0,'+
        '    \"reference_windspeed\": 21,'+
        '    \"slope\": 0,'+
        '    \"wind_pressure\": 100,'+
        '    \"corner_coefficient\": 0'+
        '  }'; 
        VisualStructure configObject = VisualStructure.parse(structureJSON);
        System.assert(configObject != null);
    }
    @IsTest
    static void ParseBuildingTest() {
        String structureJSON = '{'+
        '    \"product_type\": \"Product 1\",'+
        '    \"structure\": 0,'+
        '    \"structure_number\": \"30011112\",'+
        '    \"original_sn\": \"30011111\",'+
        '    \"product_openings\": 1,'+
        '    \"terrain_class\": 2,'+
        '    \"building_height\": 0,'+
        '    \"reference_windspeed\": 21,'+
        '    \"slope\": 0,'+
        '    \"wind_pressure\": 100,'+
        '    \"corner_coefficient\": 0,'+
        '    \"address\": \"Katu 1\",'+
        '    \"country\": \"FI\",'+
        '    \"line\": \"2",'+
        '    \"floor\": \"3",'+
        '    \"Unit\": \"A2"'+
        '  }';   
        VisualStructure configObject = VisualStructure.parse(structureJSON);
        System.assert(configObject != null);
    }
    @IsTest
    static void ParseOrderTypeTest() {
        String structureJSON = '{'+
        '    \"product_type\": \"Product 1\",'+
        '    \"structure\": 0,'+
        '    \"structure_number\": \"30011112\",'+
        '    \"original_sn\": \"30011111\",'+
        '    \"product_openings\": 1,'+
        '    \"terrain_class\": 2,'+
        '    \"building_height\": 0,'+
        '    \"reference_windspeed\": 21,'+
        '    \"slope\": 0,'+
        '    \"wind_pressure\": 100,'+
        '    \"corner_coefficient\": 0,'+
        '    \"address\": \"Katu 1\",'+
        '    \"country\": \"FI\",'+
        '    \"line\": \"2",'+
        '    \"floor\": \"3",'+
        '    \"Unit\": \"A2",'+
        '    \"reclamation\": 1,'+
        '    \"special_order\": 1,'+
        '    \"report\": 1,'+
        '    \"side\": []'+
        '  }';   
        VisualStructure configObject = VisualStructure.parse(structureJSON);
        System.assert(configObject != null);
    }
    @IsTest
    static void ParseOneOpeningTest() {
        String structureJSON = '{'+
        '    \"product_type\": \"Product 1\",'+
        '    \"structure\": 0,'+
        '    \"structure_number\": \"30011112\",'+
        '    \"original_sn\": \"30011111\",'+
        '    \"product_openings\": 1,'+
        '    \"terrain_class\": 2,'+
        '    \"building_height\": 0,'+
        '    \"reference_windspeed\": 21,'+
        '    \"slope\": 0,'+
        '    \"wind_pressure\": 100,'+
        '    \"corner_coefficient\": 0,'+
        '    \"address\": \"Katu 1\",'+
        '    \"country\": \"FI\",'+
        '    \"line\": \"2",'+
        '    \"floor\": \"3",'+
        '    \"Unit\": \"A2",'+
        '    \"reclamation\": 0,'+
        '    \"special_order\": 0,'+
        '    \"report\": 0,'+
        '    \"Product_opening\": ['+
        '      {'+
        '        \"embedded\": 0,'+
        '        \"component_box_reclamation\": 0,'+
        '        \"drain_holes\": 0,'+
        '        \"different_height_sides\": 0,'+
        '        \"lower_milling\": 0,'+
        '        \"installation_method\": 2,'+
        '        \"side_amount\": 0,'+
        '        \"glass_panel_amount\": 0,'+
        '        \"glass_thickness\": 10,'+
        '        \"start_seal\": \"StartSeal\",'+
        '        \"start_seal_color\": \"Green\",'+
        '        \"telescopic_profile\": \"Telescope\",'+
        '        \"upper_profile\": \"UpperProfile\",'+
        '        \"upper_profile_color\": \"Red\",'+
        '        \"upper_fastening_material\": \"UpperFastening\",'+
        '        \"upper_seal\": \"UpperSeal\",'+
        '        \"lower_telescopic_profile\": \"LowerTelescope\",'+
        '        \"lower_profile\": \"LowerProfile\",'+
        '        \"lower_profile_color\": \"Yellow\",'+
        '        \"lower_profile_seal\": \"LowerProfileSeal\",'+
        '        \"lower_fastening_material\": \"LowerFastening\",'+
        '        \"water_flashing_seal\": \"WaterFlashing\",'+
        '        \"soundproofing_seal\": \"SoundProofing\",'+
        '        \"system_angle_seal\": \"SystemAngleSeal\",'+
        '        \"end_seal\": \"EndSeal\",'+
        '        \"end_seal_color\": \"Black\",'+
        '        \"side\": []'+
        '      }'+
        '    ]'+
        '  }'; 
        VisualStructure configObject = VisualStructure.parse(structureJSON);
        System.assert(configObject != null);    
    }
    @IsTest
    static void ParseOneSideTest() {
        String structureJSON = '{'+
        '    \"product_type\": \"Product 1\",'+
        '    \"structure\": 0,'+
        '    \"structure_number\": \"30011112\",'+
        '    \"original_sn\": \"30011111\",'+
        '    \"product_openings\": 1,'+
        '    \"terrain_class\": 2,'+
        '    \"building_height\": 0,'+
        '    \"reference_windspeed\": 21,'+
        '    \"slope\": 0,'+
        '    \"wind_pressure\": 100,'+
        '    \"corner_coefficient\": 0,'+
        '    \"address\": \"Katu 1\",'+
        '    \"country\": \"FI\",'+
        '    \"line\": \"2",'+
        '    \"floor\": \"3",'+
        '    \"Unit\": \"A2",'+
        '    \"reclamation\": 0,'+
        '    \"special_order\": 0,'+
        '    \"report\": 0,'+
        '    \"Product_opening\": ['+
        '      {'+
        '        \"embedded\": 0,'+
        '        \"component_box_reclamation\": 0,'+
        '        \"drain_holes\": 0,'+
        '        \"different_height_sides\": 0,'+
        '        \"lower_milling\": 0,'+
        '        \"installation_method\": 2,'+
        '        \"side_amount\": 1,'+
        '        \"glass_panel_amount\": 0,'+
        '        \"glass_thickness\": 10,'+
        '        \"start_seal\": \"StartSeal\",'+
        '        \"start_seal_color\": \"Green\",'+
        '        \"telescopic_profile\": \"Telescope\",'+
        '        \"upper_profile\": \"UpperProfile\",'+
        '        \"upper_profile_color\": \"Red\",'+
        '        \"upper_fastening_material\": \"UpperFastening\",'+
        '        \"upper_seal\": \"UpperSeal\",'+
        '        \"lower_telescopic_profile\": \"LowerTelescope\",'+
        '        \"lower_profile\": \"LowerProfile\",'+
        '        \"lower_profile_color\": \"Yellow\",'+
        '        \"lower_profile_seal\": \"LowerProfileSeal\",'+
        '        \"lower_fastening_material\": \"LowerFastening\",'+
        '        \"water_flashing_seal\": \"WaterFlashing\",'+
        '        \"soundproofing_seal\": \"SoundProofing\",'+
        '        \"system_angle_seal\": \"SystemAngleSeal\",'+
        '        \"end_seal\": \"EndSeal\",'+
        '        \"end_seal_color\": \"Black\",'+
        '        \"side\": ['+
        '        {'+
        '           \"side_number\": 1,'+
        '           \"length\": 3000,'+
        '           \"height\": 2000,'+
        '           \"product_length\": 0,'+   
        '           \"product_height\": 2000,'+   
        '           \"corner_bypass_left\": 0,'+   
        '           \"corner_bypass_right\": 0,'+   
        '           \"opening_type_left\": \"left\",'+
        '           \"opening_type_right\": \"right\",'+
        '           \"glass_panels_left_second_gate\": 0,'+   
        '           \"glass_panels_right_second_gate\": 0,'+   
        '           \"hinge_relocation_left\": 0,'+   
        '           \"hinge_relocation_right\": 0,'+   
        '           \"profile_sliding_left\": 0,'+   
        '           \"profile_sliding_right\": 0,'+   
        '           \"pull_handle\": 0,'+   
        '           \"stackingdevice_left\": \"left\",'+
        '           \"stackingdevice_right\": null,'+
        '           \"start_reduction\": 10,'+   
        '           \"end_reduction\": 20,'+
        '           \"lower_reduction\": 10,'+   
        '           \"upper_reduction\": 10,'+
        '           \"z_measure\": 50,'+
        '           \"system_angle\": 20,'+
        '           \"prev_system_angle\": null,'+   
        '           \"start_angle\": 90,'+
        '           \"end_angle\": 90,'+
        '           \"embedment_depth\": 0,'+
        '           \"glass_thickness\": 8,'+
        '           \"glass_panels_left\": 1,'+
        '           \"glass_panels_right\": 0,'+
        '           \"upper_bracket\": \"UpperBracket\",'+
        '           \"upper_bracket_color\": \"Grey\",'+
        '           \"lower_bracket\": \"LowerBracket\",'+
        '           \"lower_bracket_color\": \"White\",'+     
        '           \"lower_bracket_width\": 200,'+
        '           \"profile_extension_left\": 0,'+   
        '           \"profile_extension_right\": 0,'+   
        '           \"latch_left\": \"LatchLeft\",'+    
        '           \"latch_right\": \"LatchRight\",'+   
        '           \"latch_height\": 500,'+   
        '           \"additional_lock\": 1,'+
        '           \"obstacles\": [],'+
        '           \"obstacle_outside_edgedistance\": 2,'+   
        '           \"obstacle_outside_height\": 3,'+   
        '           \"cutout_start_position\": 0,'+   
        '           \"cutout_width\": 0,'+   
        '           \"cutout_height\": 0,'+  
        '           \"solar_screen\": 0,'+   
        '           \"solar_screen_length\": 0,'+   
        '           \"solar_sreen_position\": 0,'+  
        '           \"ventilation_cover\": 0,'+  
        '           \"telescopic_profile_reclamation\": 0,'+   
        '           \"lower_telescopic_profile_reclamation\": 0,'+   
        '           \"glass_gap_seal_reclamation\": 0,'+   
        '           \"edge_seal_left_reclamation\": 0,'+   
        '           \"edge_seal_right_reclamation\": 0,'+   
        '           \"lower_profile_reclamation\": 0,'+   
        '           \"upper_profile_reclamation\": 0,'+   
        '           \"upper_bracket_reclamation\": 0,'+   
        '           \"lower_bracket_reclamation\": 0,'+   
        '           \"latch_left_reclamation\": 0,'+   
        '           \"latch_right_reclamation\": 0,'+   
        '           \"solar_screen_reclamation\": 0,'+   
        '           \"pull_handle_reclamation\": 0'+   
        '        }'+
        '        ]'+
        '    }'+
        '    ]'+
        '  }'; 
        VisualStructure configObject = VisualStructure.parse(structureJSON);
        System.assert(configObject != null);
    }
    
    @IsTest
    public static void processVisualStructureJSONTest() {
        String response;
        String jsonBody = '{"country":"FI1","product_type":"LGS","terrain_class":2,"building_height":15000,"reference_windspeed":21,"slope":0,"wind_pressure":0.0,"corner_coefficient":0,"structure":1,"product_openings":3,"report":0,"structure_number":"123","original_sn":"","line":"","floor":"","Unit":"","address":"teststreet","reclamation":0,"special_order":0,"Product_opening":[{"component_box_reclamation":0,"side_amount":1,"glass_panel_amount":3,"glass_thickness":10,"upper_profile_color":"RAL7024","lower_profile_color":"RAL7024","lower_profile_seal":"","water_flashing_seal":"","soundproofing_seal":null,"drain_holes":1,"different_height_sides":0,"lower_milling":0,"upper_seal":"","start_seal":"","start_seal_color":"","end_seal":"","end_seal_color":"","system_angle_seal":"","upper_profile":"11260019","lower_profile":"11260018","upper_fastening_material":"c20","lower_fastening_material":"c20","installation_method":2,"vertical_profiles":"","side":[{"profile_sliding_left":0,"profile_sliding_right":0,"side_number":1,"length":2486,"height":2800,"product_length":2486,"product_height":2800,"start_reduction":0,"end_reduction":0,"upper_reduction":0,"lower_reduction":0,"z_measure":0,"prev_system_angle":null,"start_angle":135,"end_angle":90,"system_angle":null,"glass_thickness":10,"embedment_depth":0,"glass_panels_left":0,"glass_panels_right":3,"upper_bracket":null,"lower_bracket":null,"lower_bracket_width":0,"upper_bracket_color":"","lower_bracket_color":"","additional_lock":null,"connecting_profiles":null,"profile_extension_left":0,"profile_extension_right":0,"latch_height":0,"latch_left":null,"latch_right":"PD9260061","obstacle_outside_edgedistance":0,"obstacle_outside_height":0,"cutout_start_position":0,"cutout_width":0,"cutout_height":0,"solar_screen":null,"solar_screen_length":0,"solar_sreen_position":0,"ventilation_cover":null,"obstacles":[],"lower_profile_reclamation":0,"upper_profile_reclamation":0,"upper_bracket_reclamation":0,"lower_bracket_reclamation":0,"latch_left_reclamation":0,"latch_right_reclamation":0,"solar_screen_reclamation":0,"pull_handle_reclamation":0,"additional_opening_left":"","additional_opening_right":"","blinds":1,"vertical_profiles_reclamation":0,"start_seal_reclamation":0,"end_seal_reclamation":0,"additional_opening_left_reclamation":0,"additional_opening_right_reclamation":0,"blinds_reclamation":0,"glass":[{"glass_number":1,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":2,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":3,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":1,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1}]}]},{"component_box_reclamation":0,"side_amount":1,"glass_panel_amount":5,"glass_thickness":10,"upper_profile_color":"RAL7024","lower_profile_color":"RAL7024","lower_profile_seal":"","water_flashing_seal":"","soundproofing_seal":null,"drain_holes":1,"different_height_sides":0,"lower_milling":0,"upper_seal":"","start_seal":"PD9240181","start_seal_color":"RAL7024","end_seal":"","end_seal_color":"","system_angle_seal":"","upper_profile":"11260021","lower_profile":"11260020","upper_fastening_material":"c20","lower_fastening_material":"c20","installation_method":2,"vertical_profiles":"","side":[{"profile_sliding_left":0,"profile_sliding_right":0,"side_number":2,"length":3600,"height":2800,"product_length":3600,"product_height":2800,"start_reduction":0,"end_reduction":0,"upper_reduction":0,"lower_reduction":0,"z_measure":0,"prev_system_angle":null,"start_angle":90,"end_angle":90,"system_angle":null,"glass_thickness":10,"embedment_depth":0,"glass_panels_left":0,"glass_panels_right":5,"upper_bracket":null,"lower_bracket":null,"lower_bracket_width":0,"upper_bracket_color":"","lower_bracket_color":"","additional_lock":null,"connecting_profiles":null,"profile_extension_left":0,"profile_extension_right":0,"latch_height":1000,"latch_left":null,"latch_right":"PD9260064","obstacle_outside_edgedistance":0,"obstacle_outside_height":0,"cutout_start_position":0,"cutout_width":0,"cutout_height":0,"solar_screen":null,"solar_screen_length":0,"solar_sreen_position":0,"ventilation_cover":null,"obstacles":[],"lower_profile_reclamation":0,"upper_profile_reclamation":0,"upper_bracket_reclamation":0,"lower_bracket_reclamation":0,"latch_left_reclamation":0,"latch_right_reclamation":0,"solar_screen_reclamation":0,"pull_handle_reclamation":0,"additional_opening_left":"","additional_opening_right":"","blinds":1,"vertical_profiles_reclamation":0,"start_seal_reclamation":0,"end_seal_reclamation":0,"additional_opening_left_reclamation":0,"additional_opening_right_reclamation":0,"blinds_reclamation":0,"glass":[{"glass_number":4,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":5,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":6,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":7,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":8,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":1,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1}]}]},{"component_box_reclamation":0,"side_amount":1,"glass_panel_amount":3,"glass_thickness":10,"upper_profile_color":"RAL7024","lower_profile_color":"RAL7024","lower_profile_seal":"","water_flashing_seal":"","soundproofing_seal":null,"drain_holes":1,"different_height_sides":0,"lower_milling":0,"upper_seal":"","start_seal":"","start_seal_color":"","end_seal":"PD9240181","end_seal_color":"RAL7024","system_angle_seal":"","upper_profile":"11260019","lower_profile":"11260018","upper_fastening_material":"c20","lower_fastening_material":"c20","installation_method":2,"vertical_profiles":"","side":[{"profile_sliding_left":0,"profile_sliding_right":0,"side_number":3,"length":2000,"height":2800,"product_length":2000,"product_height":2800,"start_reduction":0,"end_reduction":0,"upper_reduction":0,"lower_reduction":0,"z_measure":0,"prev_system_angle":null,"start_angle":90,"end_angle":90,"system_angle":null,"glass_thickness":10,"embedment_depth":0,"glass_panels_left":3,"glass_panels_right":0,"upper_bracket":null,"lower_bracket":null,"lower_bracket_width":0,"upper_bracket_color":"","lower_bracket_color":"","additional_lock":null,"connecting_profiles":null,"profile_extension_left":0,"profile_extension_right":0,"latch_height":1000,"latch_left":"PD9260064","latch_right":null,"obstacle_outside_edgedistance":0,"obstacle_outside_height":0,"cutout_start_position":0,"cutout_width":0,"cutout_height":0,"solar_screen":null,"solar_screen_length":0,"solar_sreen_position":0,"ventilation_cover":null,"obstacles":[],"lower_profile_reclamation":0,"upper_profile_reclamation":0,"upper_bracket_reclamation":0,"lower_bracket_reclamation":0,"latch_left_reclamation":0,"latch_right_reclamation":0,"solar_screen_reclamation":0,"pull_handle_reclamation":0,"additional_opening_left":"","additional_opening_right":"","blinds":1,"vertical_profiles_reclamation":0,"start_seal_reclamation":0,"end_seal_reclamation":0,"additional_opening_left_reclamation":0,"additional_opening_right_reclamation":0,"blinds_reclamation":0,"glass":[{"glass_number":9,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":1,"fixed":1,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":10,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":1,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":11,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":1,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1}]}]}],"flashings":[],"additionalprofiles":[],"stationaryglasses":[],"stationaryglassproybatch":0}';

  
      VisualStructure wrapper = new VisualStructure();
      wrapper.country = 'FI1';
      wrapper.product_type = 'LGS';
      wrapper.terrain_class = 2;
      wrapper.building_height = 15000;
      wrapper.reference_windspeed = 21;
      wrapper.slope = 0;
      wrapper.wind_pressure = 0;
      wrapper.corner_coefficient = 0;
      wrapper.structure = 1;
      wrapper.product_openings = 3;
      wrapper.report = 0;
      wrapper.structure_number = '123';
      wrapper.original_sn = '';
      wrapper.line = '';
      wrapper.floor = '';
      wrapper.Unit = '';
      wrapper.address = 'test';
      wrapper.reclamation = 0;
      wrapper.special_order = 0;
  
      VisualStructure.Glass glass = new VisualStructure.Glass();
      glass.glass_number = 1;
      glass.glass_reclamation = 0;
      glass.glass_item = '20090018';
      glass.width = 0;
      glass.glass_direction = 2;
      glass.fixed = 0;
      glass.glasspack_index = 0;
      glass.sandblasting = 0;
      glass.sandblasting_height = 0;
      glass.sandblasting_type = '';
      glass.sandblasting_side = 0;
      glass.safety_decals = 0;
      glass.silk_printing = 0;
      glass.silk_printing_type = '';
      glass.silk_printing_color = '';
      glass.silk_printing_side = 0;
      glass.silk_printing_insert_point = '';
      glass.heatsoak = 0;
      glass.cutout = 0;
      glass.blinds = 1;
  
      VisualStructure.Side side = new VisualStructure.Side();
      side.glass = new List<VisualStructure.Glass>{glass};
      side.profile_sliding_left = 0;
      side.profile_sliding_right = 0;
      side.side_number = 1;
      side.length = 2486;
      side.height = 2800;
      side.product_length = 2432;
      side.product_height = 3000;
      side.start_reduction = 0;
      side.end_reduction = 0;
      side.lower_reduction = 0;
      side.upper_reduction = 0;
      side.z_measure = 0;
      side.prev_system_angle = 0;
      side.start_angle = 135;
      side.end_angle = 90;
      side.system_angle = 0;
      side.glass_thickness = 10;
      side.embedment_depth = 0;
      side.glass_panels_left = 0;
      side.glass_panels_right = 3;
      side.upper_bracket = '1';
      side.lower_bracket = '1';
      side.lower_bracket_width = 0;
      side.upper_bracket_color = '';
      side.lower_bracket_color = '';
      side.additional_lock = '';
      side.connecting_profiles = '';
      side.profile_extension_left = 0;
      side.profile_extension_right = 0;
      side.latch_height = 0;
      side.latch_left = '';
      side.latch_right = 'PD9260061';
      side.obstacle_outside_edgedistance = 0;
      side.obstacle_outside_height = 0;
      side.cutout_start_position = 0;
      side.cutout_width = 0;
      side.cutout_height = 0;
      side.solar_screen = 1;
      side.solar_screen_length = 1;
      side.solar_sreen_position = 1;
      side.ventilation_cover = 1;
      side.lower_profile_reclamation = 0;
      side.upper_profile_reclamation = 0;
      side.upper_bracket_reclamation = 1;
      side.lower_bracket_reclamation = 1;
      side.latch_left_reclamation = 0;
      side.latch_right_reclamation = 0;
      side.solar_screen_reclamation = 0;
      side.pull_handle_reclamation = 0;
  
      VisualStructure.Opening prodOpening = new VisualStructure.Opening();
      prodOpening.side = new List<VisualStructure.Side>{side};
      prodOpening.component_box_reclamation = 0;
      prodOpening.side_amount = 1;
      prodOpening.glass_panel_amount = 3;
      prodOpening.glass_thickness = 10;
      prodOpening.upper_profile_color = 'RAL7024';
      prodOpening.lower_profile_color = 'RAL7024';
      prodOpening.lower_profile_seal = '';
      prodOpening.water_flashing_seal = '';
      prodOpening.soundproofing_seal = '';
      prodOpening.drain_holes = 1;
      prodOpening.different_height_sides = 1;
      prodOpening.lower_milling = 1;
      prodOpening.upper_seal = '';
      prodOpening.start_seal = '';
      prodOpening.start_seal_color = '';
      prodOpening.end_seal = '';
      prodOpening.end_seal_color = '';
      prodOpening.system_angle_seal = '';
      prodOpening.upper_profile = '123213';
      prodOpening.lower_profile = '1231232';
      prodOpening.upper_fastening_material = 'c20';
      prodOpening.lower_fastening_material = 'c20';
      wrapper.Product_opening = new List<VisualStructure.Opening>{prodOpening};
  
      String json = JSON.serialize(wrapper);
      Test.startTest();
      VisualStructure configObject = VisualStructure.parse(json);
      Test.stopTest();
    }
}