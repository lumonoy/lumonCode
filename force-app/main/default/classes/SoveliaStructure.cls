/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-03-2023
 * @last modified by  : Henk Reynders
**/
public class SoveliaStructure {    
    // Structure Information
    public String product_type; // Type of Product eg "LG"
    public Integer structure;// 0
    public String structure_number; // Structure Id eg "30010526"
    public String original_sn; // Original Structure Id
    public Integer product_openings; // Number for Product Openings 1
    // Structural Analysis
    public Integer terrain_class; // Terrain Class from Picklist eg 0
    public Integer building_height; // Height of the Building in mm
    public Integer reference_windspeed; // Reference Windspeed at Building Location eg 21
    public Integer slope; // Indication if Building is on a Slope or Hill 0 or 1
    public Decimal wind_pressure; // Indication of wind Pressure
    public Integer corner_coefficient; // 0
    // Building/Apartment Details
    public String address; // The Streer Address of the Building
    public String country; // country Code for structure defaults eg  "FI1",
    public String line; // The "Horizontal Line placement of a balcony
    public String floor; // The Vertical Line placement of a balcony
    public String Unit; // The Apartment Number 
    // Order Type
    public Integer reclamation; // Indication if this is a reclamation order
    public Integer special_order; // Indication if this is a special order
    public Integer report; //0
    //Details and Attributes
    public List<Opening> Product_opening; 
    public List<Flashing> flashings;
    public List<Additional_Profile> additionalprofiles;
    public List<Stationary_Glass> stationaryglasses;
    public List<Stationary_Glass_Profile> stationaryglassprofiles;

    public class Opening {
        public Integer embedded;
        public Integer component_box_reclamation;
        public Integer drain_holes; //Indicates whether drailholes are required
        public Integer different_height_sides; //Indicates whether sides have different heights
        public Integer lower_milling;
        public Integer installation_method;
        public Integer side_amount; // Amount of sides of the Structure
        public Integer glass_panel_amount; // Amount of glass panels of the Structure
        public Integer glass_thickness; // Attribute to indicate Glass Thickness in mm
        public String start_seal; // Sales Code of Start Seal eg "PD9240183"
        public String start_seal_color; //Color Code of Start Seal
        public String glass_gap_seal;
        public String telescopic_profile;
        public String upper_profile; // Sales Code of Start Seal eg "11251205"
        public String upper_profile_color;// Attribute to indicate Upper Profile Color Code eg "RAL7024"
        public String upper_fastening_material;// Sales Code of Upper Fastening Material 
        public String upper_seal;
        public String lower_telescopic_profile;
        public String lower_profile; // Sales Code of Start Seal eg "11253003"
        public String lower_profile_color;// Attribute to indicate Lower Profile Color Code eg "RAL7024"
        public String lower_profile_seal;
        public String lower_fastening_material;// Sales Code of Lower Fastening Material 
        public String water_flashing_seal;
        public String soundproofing_seal;
        public String system_angle_seal; // Sales Code of System Angle Seal 
        public String end_seal; // Sales Code of End Seal eg "PD9240183"
        public String end_seal_color; //Color Code of End Seal
        public List<Side> side;
        public List<Obstacle> obstacles;
    }
    public class Obstacle{}
    public class Side {
        /*"corner_bypass_left": 0,

            "corner_bypass_right": 0,

            "opening_type_left": "in",

            "opening_type_right": "",

            "glass_panels_left_second_gate": 0,

            "glass_panels_right_second_gate": 0,

            "hinge_relocation_left": 0,

            "hinge_relocation_right": 0,

            "pull_handle": null,

            "profile_sliding_left": 0,

            "profile_sliding_right": 0,

            "telescopic_profile_reclamation": 1,

            "lower_telescopic_profile_reclamation": 0,

            "glass_gap_seal_reclamation": 0,

            "edge_seal_left_reclamation": 1,

            "edge_seal_right_reclamation": 1,

            "stackingdevice_left": "",

            "stackingdevice_right": null,

            "side_number": 1,

            "length": 4000,

            "height": 1500,

            "product_length": 4000,

            "product_height": 1500,

            "start_reduction": 0,

            "end_reduction": 0,

            "upper_reduction": 0,

            "lower_reduction": 0,

            "z_measure": 0,

            "prev_system_angle": null,

            "start_angle": 90,

            "end_angle": 90,

            "system_angle": null,

            "glass_thickness": 10,

            "embedment_depth": 0,

            "glass_panels_left": 5,

            "glass_panels_right": 0,

            "upper_bracket": "",

            "lower_bracket": "",

            "lower_bracket_width": 0,

            "upper_bracket_color": "",

            "lower_bracket_color": "",

            "additional_lock": null,

            "connecting_profiles": null,

            "profile_extension_left": 0,

            "profile_extension_right": 0,

            "latch_height": 0,

            "latch_left": "PD9240061",

            "latch_right": null,

            "obstacle_outside_edgedistance": 0,

            "obstacle_outside_height": 0,

            "cutout_start_position": 0,

            "cutout_width": 0,

            "cutout_height": 0,

            "solar_screen": null,

            "solar_screen_length": 0,

            "solar_sreen_position": 0,

            "ventilation_cover": null,

            "obstacles": [],

            "lower_profile_reclamation": 1,

            "upper_profile_reclamation": 1,

            "upper_bracket_reclamation": 0,

            "lower_bracket_reclamation": 0,

            "latch_left_reclamation": 1,

            "latch_right_reclamation": 0,

            "solar_screen_reclamation": 0,

            "pull_handle_reclamation": 0,*/
        List<GlassPanel> Glass;
    }
    public class Flashing{}
    public class Additional_Profile{}
    public class Stationary_Glass{}     
    public class Stationary_Glass_Profile{}  
    public class GlassPanel{
        /*
        "glass_number": 1,

            "glass_reclamation": 1,

            "glass_item": "20090018",

            "width": 1,

            "glass_direction": 1,

            "fixed": 0,

            "glasspack_index": 1,

            "sandblasting": 0,

            "sandblasting_height": 0,

            "sandblasting_type": "",

            "sandblasting_side": 0,

            "safety_decals": 0,

            "silk_printing": 0,

            "silk_printing_type": "",

            "silk_printing_color": "",

            "silk_printing_side": 0,

            "silk_printing_insert_point": "",

            "heatsoak": 0,

            "cutout": 0,

            "blinds": 0,

            "blinds_fabric": 0,

            "blind_type": 0,

            "blind_profile_color": null
        */
    }
                        
    public static SoveliaStructure parse(String json) {
        return (SoveliaStructure) System.JSON.deserialize(json, SoveliaStructure.class);
    }
}