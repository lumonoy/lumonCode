/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-02-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class StructureDataTest {
    @TestVisible private static String balustradeStructure {
        get {return [SELECT Body FROM StaticResource WHERE Name = 'balustradeStructure' ].Body.toString();}
    }
    @TestSetup
    static void prepareData(){
        Test.startTest();
        //LumonTestDataFactory.setupProducts();
        LumonTestProducts.setupProducts('LG');
    }
    @IsTest
    static void parseStructureDataTest(){     
        Test.startTest();
        List<StructureData.Structure> structures = StructureData.parseStructure (balustradeStructure);
        for (StructureData.Structure structure : structures) {
            System.debug('--- parseStructureDataTest - structure RVN: '+structure.structure_number);
            List<StructureData.ProductOpening> openings = structure.Product_opening;
            for (StructureData.ProductOpening opening :openings){
                List<StructureData.Side> sides = opening.side;
                System.debug('--- parseStructureDataTest - structure Sides: '+sides);
                for (StructureData.Side side :sides){
                    System.debug('--- parseStructureDataTest - structure Side: '+side);
                    System.debug('--- parseStructureDataTest - structure Side Number: '+side.side_number);

                }
            }
        }
        System.assertNotEquals(0, structures.size(), 'Expected Structures to be returned');
        System.debug('--- parseStructureDataTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- parseStructureDataTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    public static void processStructureDataTest() {
        Test.startTest();
        String response;
        String jsonBody = '{"country":"FI1","product_type":"LGS","terrain_class":2,"building_height":15000,"reference_windspeed":21,"slope":0,"wind_pressure":0.0,"corner_coefficient":0,"structure":1,"product_openings":3,"report":0,"structure_number":"123","original_sn":"","line":"","floor":"","Unit":"","address":"teststreet","reclamation":0,"special_order":0,"Product_opening":[{"component_box_reclamation":0,"side_amount":1,"glass_panel_amount":3,"glass_thickness":10,"upper_profile_color":"RAL7024","lower_profile_color":"RAL7024","lower_profile_seal":"","water_flashing_seal":"","soundproofing_seal":null,"drain_holes":1,"different_height_sides":0,"lower_milling":0,"upper_seal":"","start_seal":"","start_seal_color":"","end_seal":"","end_seal_color":"","system_angle_seal":"","upper_profile":"11260019","lower_profile":"11260018","upper_fastening_material":"c20","lower_fastening_material":"c20","installation_method":2,"vertical_profiles":"","side":[{"profile_sliding_left":0,"profile_sliding_right":0,"side_number":1,"length":2486,"height":2800,"product_length":2486,"product_height":2800,"start_reduction":0,"end_reduction":0,"upper_reduction":0,"lower_reduction":0,"z_measure":0,"prev_system_angle":null,"start_angle":135,"end_angle":90,"system_angle":null,"glass_thickness":10,"embedment_depth":0,"glass_panels_left":0,"glass_panels_right":3,"upper_bracket":null,"lower_bracket":null,"lower_bracket_width":0,"upper_bracket_color":"","lower_bracket_color":"","additional_lock":null,"connecting_profiles":null,"profile_extension_left":0,"profile_extension_right":0,"latch_height":0,"latch_left":null,"latch_right":"PD9260061","obstacle_outside_edgedistance":0,"obstacle_outside_height":0,"cutout_start_position":0,"cutout_width":0,"cutout_height":0,"solar_screen":null,"solar_screen_length":0,"solar_sreen_position":0,"ventilation_cover":null,"obstacles":[],"lower_profile_reclamation":0,"upper_profile_reclamation":0,"upper_bracket_reclamation":0,"lower_bracket_reclamation":0,"latch_left_reclamation":0,"latch_right_reclamation":0,"solar_screen_reclamation":0,"pull_handle_reclamation":0,"additional_opening_left":"","additional_opening_right":"","blinds":1,"vertical_profiles_reclamation":0,"start_seal_reclamation":0,"end_seal_reclamation":0,"additional_opening_left_reclamation":0,"additional_opening_right_reclamation":0,"blinds_reclamation":0,"glass":[{"glass_number":1,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":2,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":3,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":1,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1}]}]},{"component_box_reclamation":0,"side_amount":1,"glass_panel_amount":5,"glass_thickness":10,"upper_profile_color":"RAL7024","lower_profile_color":"RAL7024","lower_profile_seal":"","water_flashing_seal":"","soundproofing_seal":null,"drain_holes":1,"different_height_sides":0,"lower_milling":0,"upper_seal":"","start_seal":"PD9240181","start_seal_color":"RAL7024","end_seal":"","end_seal_color":"","system_angle_seal":"","upper_profile":"11260021","lower_profile":"11260020","upper_fastening_material":"c20","lower_fastening_material":"c20","installation_method":2,"vertical_profiles":"","side":[{"profile_sliding_left":0,"profile_sliding_right":0,"side_number":2,"length":3600,"height":2800,"product_length":3600,"product_height":2800,"start_reduction":0,"end_reduction":0,"upper_reduction":0,"lower_reduction":0,"z_measure":0,"prev_system_angle":null,"start_angle":90,"end_angle":90,"system_angle":null,"glass_thickness":10,"embedment_depth":0,"glass_panels_left":0,"glass_panels_right":5,"upper_bracket":null,"lower_bracket":null,"lower_bracket_width":0,"upper_bracket_color":"","lower_bracket_color":"","additional_lock":null,"connecting_profiles":null,"profile_extension_left":0,"profile_extension_right":0,"latch_height":1000,"latch_left":null,"latch_right":"PD9260064","obstacle_outside_edgedistance":0,"obstacle_outside_height":0,"cutout_start_position":0,"cutout_width":0,"cutout_height":0,"solar_screen":null,"solar_screen_length":0,"solar_sreen_position":0,"ventilation_cover":null,"obstacles":[],"lower_profile_reclamation":0,"upper_profile_reclamation":0,"upper_bracket_reclamation":0,"lower_bracket_reclamation":0,"latch_left_reclamation":0,"latch_right_reclamation":0,"solar_screen_reclamation":0,"pull_handle_reclamation":0,"additional_opening_left":"","additional_opening_right":"","blinds":1,"vertical_profiles_reclamation":0,"start_seal_reclamation":0,"end_seal_reclamation":0,"additional_opening_left_reclamation":0,"additional_opening_right_reclamation":0,"blinds_reclamation":0,"glass":[{"glass_number":4,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":5,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":6,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":7,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":8,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":2,"fixed":1,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1}]}]},{"component_box_reclamation":0,"side_amount":1,"glass_panel_amount":3,"glass_thickness":10,"upper_profile_color":"RAL7024","lower_profile_color":"RAL7024","lower_profile_seal":"","water_flashing_seal":"","soundproofing_seal":null,"drain_holes":1,"different_height_sides":0,"lower_milling":0,"upper_seal":"","start_seal":"","start_seal_color":"","end_seal":"PD9240181","end_seal_color":"RAL7024","system_angle_seal":"","upper_profile":"11260019","lower_profile":"11260018","upper_fastening_material":"c20","lower_fastening_material":"c20","installation_method":2,"vertical_profiles":"","side":[{"profile_sliding_left":0,"profile_sliding_right":0,"side_number":3,"length":2000,"height":2800,"product_length":2000,"product_height":2800,"start_reduction":0,"end_reduction":0,"upper_reduction":0,"lower_reduction":0,"z_measure":0,"prev_system_angle":null,"start_angle":90,"end_angle":90,"system_angle":null,"glass_thickness":10,"embedment_depth":0,"glass_panels_left":3,"glass_panels_right":0,"upper_bracket":null,"lower_bracket":null,"lower_bracket_width":0,"upper_bracket_color":"","lower_bracket_color":"","additional_lock":null,"connecting_profiles":null,"profile_extension_left":0,"profile_extension_right":0,"latch_height":1000,"latch_left":"PD9260064","latch_right":null,"obstacle_outside_edgedistance":0,"obstacle_outside_height":0,"cutout_start_position":0,"cutout_width":0,"cutout_height":0,"solar_screen":null,"solar_screen_length":0,"solar_sreen_position":0,"ventilation_cover":null,"obstacles":[],"lower_profile_reclamation":0,"upper_profile_reclamation":0,"upper_bracket_reclamation":0,"lower_bracket_reclamation":0,"latch_left_reclamation":0,"latch_right_reclamation":0,"solar_screen_reclamation":0,"pull_handle_reclamation":0,"additional_opening_left":"","additional_opening_right":"","blinds":1,"vertical_profiles_reclamation":0,"start_seal_reclamation":0,"end_seal_reclamation":0,"additional_opening_left_reclamation":0,"additional_opening_right_reclamation":0,"blinds_reclamation":0,"glass":[{"glass_number":9,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":1,"fixed":1,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":10,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":1,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1},{"glass_number":11,"glass_reclamation":0,"glass_item":"20090018","width":0,"glass_direction":1,"fixed":0,"glasspack_index":0,"sandblasting":0,"sandblasting_height":0,"sandblasting_type":"","sandblasting_side":0,"safety_decals":0,"silk_printing":0,"silk_printing_type":"","silk_printing_color":"","silk_printing_side":0,"silk_printing_insert_point":"","heatsoak":0,"cutout":0,"blinds_reclamation":0,"blinds":1}]}]}],"flashings":[],"additionalprofiles":[],"stationaryglasses":[],"stationaryglassproybatch":0}';
        StructureData.Structure structure = new StructureData.Structure();
        structure.country = 'FI1';
        structure.product_type = 'LGS';
        structure.terrain_class = 2;
        structure.building_height = 15000;
        structure.reference_windspeed = 21;
        structure.slope = 0;
        structure.wind_pressure = 0;
        structure.corner_coefficient = 0;
        structure.structure = 1;
        structure.product_openings = 3;
        structure.report = 0;
        structure.structure_number = '123';
        structure.original_sn = '';
        structure.line = '';
        structure.floor = '';
        structure.Unit = '';
        structure.address = 'test';
        structure.reclamation = 0;
        structure.special_order = 0;
        structure.component_box_reclamation = 0;
		structure.anchors_reclamation = 0;
        structure.vendorid = 'LU';
		structure.deliverybatch = 1;

        StructureData.Flashings flashing = new StructureData.Flashings();
        structure.flashings = new List<StructureData.Flashings>();

        StructureData.AdditionalProfile profile = new StructureData.AdditionalProfile();
        structure.additionalprofiles = new List<StructureData.AdditionalProfile>();

        StructureData.StationaryGlass stationaryglass = new StructureData.StationaryGlass();
        structure.stationaryglasses = new List<StructureData.StationaryGlass>();

        StructureData.StationaryGlassProfile stationaryglassprofile = new StructureData.StationaryGlassProfile();
        structure.stationaryglassprofiles = new List<StructureData.StationaryGlassProfile>();

    
        StructureData.Blind blind = new StructureData.Blind();
        blind.blind_number = 1;
		blind.blind_reclamation = 0;
		blind.blinds_fabric = 0;
		blind.blind_profile_color = '';
		blind.blind_endplug_color ='';
    
        StructureData.Glass glass = new StructureData.Glass();
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
        glass.blinds = new List<StructureData.Blind>{blind};

        StructureData.Post post = new StructureData.Post();
        post.post_number =1;
        post.post_position = 10;
        post.post_z_measure =100;
        post.post_reclamation = 0;
        post.post_profile_height = 200;
        post.post_bracket_reclamation = 0;
        post.expansion = 0;
        post.fastening_material ='';
        post.post_item ='';
        post.post_color ='';
        post.anchor_item ='';
        
        StructureData.Side side = new StructureData.Side();
        side.glass = new List<StructureData.Glass>{glass};
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
        
        side.balcony_glazing_height = 1000;
        side.balcony_glazing_z_measure = 1000;
        side.blind = new List<StructureData.Blind>();
        side.blinds = 2;
        side.blinds_reclamation = 0;
        side.connecting_profiles = '1000';
        side.corner_bypass_left = 1;
        side.corner_bypass_right = 1;

        side.edge_seal_left_reclamation = 0;
        side.edge_seal_right_reclamation = 0;
        side.facade_profile_reclamation = 0;
        side.fastener_box_reclamation = 0;
        side.glass = new List<StructureData.Glass>();
        side.glass_amount = 1;
        side.glass_gap_seal_reclamation = 0;
        side.glass_module = 0;
        side.glass_module_position = '';
        side.glass_panels_left_second_gate = 0;
        side.glass_panels_right = 0;
        side.glass_panels_right_second_gate = 0;
        side.glass_thickness = 0;
        // Handrail
        side.handrail_pipe_bracket_reclamation = 0;
        side.handrail_pipe_reclamation = 0;
        side.handrail_reclamation = 0;
        side.handrail_support_piece_reclamation = 0;
        side.height = 0;
        side.hinge_relocation_left = 0;
        side.hinge_relocation_right = 0;
        side.lower_fastening_material = '';
        side.lower_frame_cutpoint = 0;
        // Lower Frame
        side.lower_frame_height = 0;
        side.lower_frame_height_left = 0;
        side.lower_frame_height_right = 0;
        side.lower_frame_reclamation = 0;
        side.lower_gap_profile_reclamation = 0;
        side.lower_profile_reclamation = 0;
        side.lower_reduction = 0;
        side.lower_telescopic_profile_reclamation = 0;
        // Obstacles
        side.obstacle_outside_edgedistance = 0;
        side.obstacle_outside_height = 0;
        side.obstacles = new List<StructureData.Obstacle>();
        side.opening_type_left = '';
        side.opening_type_right = '';
        side.post = new List<StructureData.Post>();
        side.post_amount = 0;
        side.post_end_distance = 0;
        side.pull_handle = 0;
        side.pull_handle_reclamation = 0;
        side.side_number = 0;
        // Solar Screens
        side.solar_screen = 0;
        side.solar_screen_length = 0;
        side.solar_screen_reclamation = 0;
        side.solar_sreen_position = 0;
        side.stackingdevice_left = '';
        side.stackingdevice_right = '';
        side.start_angle = 0;
        side.start_reduction = 0;
        side.system_angle = 0;
        side.telescopic_profile_reclamation = 0;
        // Upper Brackets
        side.upper_bracket= '';
        side.upper_bracket_color = '';
        side.upper_bracket_reclamation = 0;
        // Upper Fastening
        side.upper_fastening_material = '';
    
        StructureData.ProductOpening prodOpening = new StructureData.ProductOpening();
        prodOpening.side = new List<StructureData.Side>{side};
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
        prodOpening.embedded = 0;
		prodOpening.glass_gap_seal = '';
		prodOpening.telescopic_profile ='';
		prodOpening.lower_telescopic_profile ='';
        prodOpening.installation_method = '';
        structure.Product_opening = new List<StructureData.ProductOpening>{prodOpening};
        Test.stopTest();
        System.debug('--- processStructureDataTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- processStructureDataTest - SOQL USED: ' + LIMITS.getQueries());
    }
}