/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-11-2023
 * @last modified by  : Henk Reynders
**/
public class VisualStructure {    
    // Structure Information
    public String product_type; // Type of Product eg "LG"
    public Integer structure;// 0
    public String structure_number; // Structure Id eg "30010526"
    public String original_sn; // Original Structure Id
    public Integer product_openings; // Number for Product Openings 1
    // Structural Analysis
    public Integer terrain_class; // Terrain Class from Picklist eg 0
    public Integer building_height; // Height of the Building in mm
    public Decimal reference_windspeed; // Reference Windspeed at Building Location eg 21
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
		public Integer corner_bypass_left {public get; public set;}
		public Integer corner_bypass_right {public get; public set;}
		public String opening_type_left {public get; public set;}
		public String opening_type_right {public get; public set;}
		public Integer glass_panels_left_second_gate {public get; public set;}
		public Integer glass_panels_right_second_gate {public get; public set;}
		public Integer hinge_relocation_left {public get; public set;}
		public Integer hinge_relocation_right {public get; public set;}
		public Integer pull_handle {public get; public set;}
		public Integer profile_sliding_left {public get; public set;}
		public Integer profile_sliding_right {public get; public set;}
		public Integer telescopic_profile_reclamation {public get; public set;}
		public Integer lower_telescopic_profile_reclamation {public get; public set;}
		public Integer glass_gap_seal_reclamation {public get; public set;}
		public Integer edge_seal_left_reclamation {public get; public set;}
		public Integer edge_seal_right_reclamation {public get; public set;}
		public String stackingdevice_left {public get; public set;}
		public String stackingdevice_right {public get; public set;}
		public Integer side_number {public get; public set;}
		public Integer length {public get; public set;}
		public Integer height {public get; public set;}
		public Integer product_length {public get; public set;}
		public Integer product_height {public get; public set;}
		public Integer start_reduction {public get; public set;}
		public Integer end_reduction {public get; public set;}
		public Integer upper_reduction {public get; public set;}
		public Integer lower_reduction {public get; public set;}
		public Integer z_measure {public get; public set;}
		public Integer prev_system_angle {public get; public set;}
		public Integer start_angle {public get; public set;}
		public Integer end_angle {public get; public set;}
		public Integer system_angle {public get; public set;}
		public Integer glass_thickness {public get; public set;}
		public Integer embedment_depth {public get; public set;}
		public Integer glass_panels_left {public get; public set;}
		public Integer glass_panels_right {public get; public set;}
		public String upper_bracket {public get; public set;}
		public String lower_bracket {public get; public set;}
		public Integer lower_bracket_width {public get; public set;}
		public String upper_bracket_color {public get; public set;}
		public String lower_bracket_color {public get; public set;}
		public String additional_lock {public get; public set;}
		public String connecting_profiles {public get; public set;}
		public Integer profile_extension_left {public get; public set;}
		public Integer profile_extension_right {public get; public set;}
		public Integer latch_height {public get; public set;}
		public String latch_left {public get; public set;}
		public String latch_right {public get; public set;}
		public Integer obstacle_outside_edgedistance {public get; public set;}
		public Integer obstacle_outside_height {public get; public set;}
		public Integer cutout_start_position {public get; public set;}
		public Integer cutout_width {public get; public set;}
		public Integer cutout_height {public get; public set;}
		public Integer solar_screen {public get; public set;}
		public Integer solar_screen_length {public get; public set;}
		public Integer solar_sreen_position {public get; public set;}
		public Integer ventilation_cover {public get; public set;}
		public List<String> obstacles {public get; public set;}
		public Integer lower_profile_reclamation {public get; public set;}
		public Integer upper_profile_reclamation {public get; public set;}
		public Integer upper_bracket_reclamation {public get; public set;}
		public Integer lower_bracket_reclamation {public get; public set;}
		public Integer latch_left_reclamation {public get; public set;}
		public Integer latch_right_reclamation {public get; public set;}
		public Integer solar_screen_reclamation {public get; public set;}
		public Integer pull_handle_reclamation {public get; public set;}
		public List<Glass> glass {public get; public set;}
	}

	public class Glass {
		public Integer glass_number {public get; public set;}
		public Integer glass_reclamation {public get; public set;}
		public String glass_item {public get; public set;}
		public Integer width {public get; public set;}
		public Integer glass_direction {public get; public set;}
		public Integer fixed {public get; public set;}
		public Integer glasspack_index {public get; public set;}
		public Integer sandblasting {public get; public set;}
		public Integer sandblasting_height {public get; public set;}
		public String sandblasting_type {public get; public set;}
		public Integer sandblasting_side {public get; public set;}
		public Integer safety_decals {public get; public set;}
		public Integer silk_printing {public get; public set;}
		public String silk_printing_type {public get; public set;}
		public String silk_printing_color {public get; public set;}
		public Integer silk_printing_side {public get; public set;}
		public String silk_printing_insert_point {public get; public set;}
		public Integer heatsoak {public get; public set;}
		public Integer cutout {public get; public set;}
		public Integer blinds {public get; public set;}
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
                        
    public static VisualStructure parse(String json) {
        return (VisualStructure) System.JSON.deserialize(json, VisualStructure.class);
    }
	
}