/**
 * Created by Konrad Niewiadomski on 30.11.2022.
 */

@IsTest
public class StructureGeneratorTest {
    
@TestSetup
    static void prepareData(){
        Test.startTest();
        String body = '{"status": "OK","statusCode":"200"}';
        MockResponseGenerator mockResp = new MockResponseGenerator(body, 200);
        Test.setMock(HttpCalloutMock.class, mockResp);
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPrices();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();
        LumonTestDataFactory.setupOrderB2C();
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static Id b2cSyncedQuoteId = LumonTestDataFactory.b2cSyncedQuoteId;
    private static Id b2cOrderId = LumonTestDataFactory.b2cOrderId;
    @IsTest
    public static void processStructureJSONTest() {
        String response;
        String jsonBody = '{"country":"FI1","product_type":"LGS","terrain_class":2,"building_height":15000,"reference_windspeed":21,"slope":0,"wind_pressure":0.0,"corner_coefficient":0,"structure":1,"product_openings":3,"report":0,"structure_number":"123","original_sn":"","line":"","floor":"","Unit":"","address":"teststreet","reclamation":0,"special_order":0,"Product_opening":[{"component_box_reclamation":0,"side_amount":1,"glass_panel_amount":3,"glass_thickness":10,"upper_profile_color":"RAL7024","lower_profile_color":"RAL7024","lower_profile_seal":"","water_flashing_seal":"","soundproofing_seal":null,"drain_holes":1,"different_height_sides":0,"lower_milling":0,"upper_seal":"","start_seal":"","start_seal_color":"","end_seal":"","end_seal_color":"","system_angle_seal":"","upper_profile":"11260019","lower_profile":"11260018","upper_fastening_material":"c20","lower_fastening_material":"c20","installation_method":2,"vertical_profiles":"","side":[{"profile_sliding_left":0,"profile_sliding_right":0,"side_number":1,"length":2486,"height":2800,"product_length":2486,"product_height":2800,"start_reduction":0,"end_reduction":0,"upper_reduction":0,"lower_reduction":0,"z_measure":0,"prev_system_angle":null,"start_angle":135,"end_angle":90,"system_angle":null,"glass_thickness":10,"embedment_depth":0,"glass_panels_left":0,"glass_panels_right":3,"upper_bracket":null,"lower_bracket":null,"lower_bracket_width":0,"upper_bracket_color":"","lower_bracket_color":"","additional_lock":null,"connecting_profiles":null,"profile_extension_left":0,"profile_extension_right":0,"latch_height":0,"latch_left":null,"latch_right":"PD9260061","obstacle_outside_edgedistance":0,"obstacle_outside_height":0,"cutout_start_position":0,"cutout_width":0,"cutout_height":0,"solar_screen":null,"solar_screen_length":0,"solar_sreen_position":0,"ventilation_cover":null,"obstacles":[],"lower_profile_reclamation":0,"upper_profile_reclamation":0,"upper_bracket_reclamation":0,"lower_bracket_reclamation":0,"latch_left_reclamation":0,"latch_right_reclamation":0,"solar_screen_reclamation":0,"pull_handle_reclamation":0,"additional_opening_left":"","additional_opening_right":"","blinds":1,"vertical_profiles_reclamation":0,"start_seal_reclamation":0,"end_seal_reclamation":0,"additional_opening_left_reclamation":0,"additional_opening_right_reclamation":0,"blinds_reclamation":0,"glass":[{"glass_number":1,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":2,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":3,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":1,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1}]}]},{"component_box_reclamation":0,"side_amount":1,"glass_panel_amount":5,"glass_thickness":10,"upper_profile_color":"RAL7024","lower_profile_color":"RAL7024","lower_profile_seal":"","water_flashing_seal":"","soundproofing_seal":null,"drain_holes":1,"different_height_sides":0,"lower_milling":0,"upper_seal":"","start_seal":"PD9240181","start_seal_color":"RAL7024","end_seal":"","end_seal_color":"","system_angle_seal":"","upper_profile":"11260021","lower_profile":"11260020","upper_fastening_material":"c20","lower_fastening_material":"c20","installation_method":2,"vertical_profiles":"","side":[{"profile_sliding_left":0,"profile_sliding_right":0,"side_number":2,"length":3600,"height":2800,"product_length":3600,"product_height":2800,"start_reduction":0,"end_reduction":0,"upper_reduction":0,"lower_reduction":0,"z_measure":0,"prev_system_angle":null,"start_angle":90,"end_angle":90,"system_angle":null,"glass_thickness":10,"embedment_depth":0,"glass_panels_left":0,"glass_panels_right":5,"upper_bracket":null,"lower_bracket":null,"lower_bracket_width":0,"upper_bracket_color":"","lower_bracket_color":"","additional_lock":null,"connecting_profiles":null,"profile_extension_left":0,"profile_extension_right":0,"latch_height":1000,"latch_left":null,"latch_right":"PD9260064","obstacle_outside_edgedistance":0,"obstacle_outside_height":0,"cutout_start_position":0,"cutout_width":0,"cutout_height":0,"solar_screen":null,"solar_screen_length":0,"solar_sreen_position":0,"ventilation_cover":null,"obstacles":[],"lower_profile_reclamation":0,"upper_profile_reclamation":0,"upper_bracket_reclamation":0,"lower_bracket_reclamation":0,"latch_left_reclamation":0,"latch_right_reclamation":0,"solar_screen_reclamation":0,"pull_handle_reclamation":0,"additional_opening_left":"","additional_opening_right":"","blinds":1,"vertical_profiles_reclamation":0,"start_seal_reclamation":0,"end_seal_reclamation":0,"additional_opening_left_reclamation":0,"additional_opening_right_reclamation":0,"blinds_reclamation":0,"glass":[{"glass_number":4,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":5,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":6,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":7,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":8,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":1,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1}]}]},{"component_box_reclamation":0,"side_amount":1,"glass_panel_amount":3,"glass_thickness":10,"upper_profile_color":"RAL7024","lower_profile_color":"RAL7024","lower_profile_seal":"","water_flashing_seal":"","soundproofing_seal":null,"drain_holes":1,"different_height_sides":0,"lower_milling":0,"upper_seal":"","start_seal":"","start_seal_color":"","end_seal":"PD9240181","end_seal_color":"RAL7024","system_angle_seal":"","upper_profile":"11260019","lower_profile":"11260018","upper_fastening_material":"c20","lower_fastening_material":"c20","installation_method":2,"vertical_profiles":"","side":[{"profile_sliding_left":0,"profile_sliding_right":0,"side_number":3,"length":2000,"height":2800,"product_length":2000,"product_height":2800,"start_reduction":0,"end_reduction":0,"upper_reduction":0,"lower_reduction":0,"z_measure":0,"prev_system_angle":null,"start_angle":90,"end_angle":90,"system_angle":null,"glass_thickness":10,"embedment_depth":0,"glass_panels_left":3,"glass_panels_right":0,"upper_bracket":null,"lower_bracket":null,"lower_bracket_width":0,"upper_bracket_color":"","lower_bracket_color":"","additional_lock":null,"connecting_profiles":null,"profile_extension_left":0,"profile_extension_right":0,"latch_height":1000,"latch_left":"PD9260064","latch_right":null,"obstacle_outside_edgedistance":0,"obstacle_outside_height":0,"cutout_start_position":0,"cutout_width":0,"cutout_height":0,"solar_screen":null,"solar_screen_length":0,"solar_sreen_position":0,"ventilation_cover":null,"obstacles":[],"lower_profile_reclamation":0,"upper_profile_reclamation":0,"upper_bracket_reclamation":0,"lower_bracket_reclamation":0,"latch_left_reclamation":0,"latch_right_reclamation":0,"solar_screen_reclamation":0,"pull_handle_reclamation":0,"additional_opening_left":"","additional_opening_right":"","blinds":1,"vertical_profiles_reclamation":0,"start_seal_reclamation":0,"end_seal_reclamation":0,"additional_opening_left_reclamation":0,"additional_opening_right_reclamation":0,"blinds_reclamation":0,"glass":[{"glass_number":9,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":1,"fixed":1,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":10,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":1,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":11,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":1,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1}]}]}],"flashings":[],"additionalprofiles":[],"stationaryglasses":[],"stationaryglassproybatch":0}';
      StructureGenerator.StructureWrapper wrapper = new StructureGenerator.StructureWrapper();
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
  
      StructureGenerator.Glass glass = new StructureGenerator.Glass();
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
  
      StructureGenerator.Side side = new StructureGenerator.Side();
      side.glass = new List<StructureGenerator.Glass>{glass};
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
  
      StructureGenerator.ProductOpening prodOpening = new StructureGenerator.ProductOpening();
      prodOpening.side = new List<StructureGenerator.Side>{side};
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
      wrapper.Product_opening = new List<StructureGenerator.ProductOpening>{prodOpening};
  
      String json = JSON.serialize(wrapper);
  	  String body = '{"status": "OK","statusCode":"200"}';
      MockResponseGenerator mockResp = new MockResponseGenerator(body, 200);
      Test.setMock(HttpCalloutMock.class, mockResp);
      Test.startTest();
      response = StructureGenerator.processStructureJSON(json, '12345678','10', b2cOrderId);
  	  System.assertEquals('success', response);
      Test.stopTest();
      System.debug('--- processStructureJSONTest - CPU TIME: '+LIMITS.getCpuTime()); 
      System.debug('--- processStructureJSONTest - SOQL USED: ' + LIMITS.getQueries());
  
      
    }

}