/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-26-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class ProductStructureData {
    public class Structure {
		public String country {get; set;}
		public String product_type {get; set;}
		public Integer terrain_class {get; set;}
		public Integer building_height {get; set;}
		public Double reference_windspeed {get; set;}
		public Integer slope {get; set;}
		public Double wind_pressure {get; set;}
		public Integer corner_coefficient {get; set;}
		public Integer structure {get; set;}
		public Integer product_openings {get; set;}
		public Integer report {get; set;}
		public String structure_number {get; set;}
		public String original_sn {get; set;}
		public String line {get; set;}
		public String floor {get; set;}
		public String Unit {get; set;}
		public String address {get; set;}
		public Integer reclamation {get; set;}
        public Integer component_box_reclamation {get; set;}
		public Integer anchors_reclamation {get; set;}
		public Integer special_order {get; set;}
		public List<ProductOpening> Product_opening {get; set;}
		public List<Flashing> flashings {get; set;}
		public List<AdditionalProfile> additionalprofiles {get; set;}
		public List<StationaryGlass> stationaryglasses {get; set;}
		public List<StationaryGlassProfile> stationaryglassprofiles {get; set;}
		public String vendorid {get; set;}
		public Integer deliverybatch {get; set;}
	}
    public class ProductOpening {
		public Integer component_box_reclamation {get;set;} 
		public Object blind_profile_color {get;set;} 
		public Object prev_opening_product {get;set;} 
		public String next_opening_product {get;set;} 
		public Integer blind_start_reduction {get;set;} 
		public Integer blind_end_reduction {get;set;} 
		public Integer side_amount {get;set;} 
		public Integer glass_panel_amount {get;set;} 
		public Integer glass_thickness {get;set;} 
		public String upper_profile_color {get;set;} 
		public String lower_profile_color {get;set;} 
		public String lower_profile_seal {get;set;} 
		public String water_flashing_seal {get;set;} 
		public Object soundproofing_seal {get;set;} 
		public Integer drain_holes {get;set;} 
		public Integer different_height_sides {get;set;} 
		public Integer lower_milling {get;set;} 
		public String upper_seal {get;set;} 
		public String start_seal {get;set;} 
		public String start_seal_color {get;set;} 
		public String end_seal {get;set;} 
		public String end_seal_color {get;set;} 
		public String system_angle_seal {get;set;} 
		public String upper_profile {get;set;} 
		public String lower_profile {get;set;} 
		public String upper_fastening_material {get;set;} 
		public String lower_fastening_material {get;set;} 
		public Integer installation_method {get;set;} 
		public String vertical_profiles {get;set;} 
        public Integer embedded {get; set;}
		public String glass_gap_seal {get; set;}
		public String telescopic_profile {get; set;}
		public String lower_telescopic_profile {get; set;}
		public List<Side> side {get;set;} 
	}
	public class Side {
        public String additional_lock {get; set;}
        public Double balcony_glazing_height {get; set;}
        public Double balcony_glazing_z_measure {get; set;}
        public List<Blind> blind {get; set;}
        public Integer blinds {get; set;}
        public Integer blinds_reclamation {get; set;}
        public String connecting_profiles {get; set;}
        public Integer corner_bypass_left {get; set;}
        public Integer corner_bypass_right {get; set;}
        // CutOuts
        public Double cutout_height {get; set;}
        public Double cutout_start_position {get; set;}
        public Double cutout_width {get; set;}
        public Integer decor_profile_reclamation {get; set;}
        public Integer edge_seal_left_reclamation {get; set;}
        public Integer edge_seal_right_reclamation {get; set;}
        public Integer embedment_depth {get; set;}
        public Integer end_angle {get; set;}
        public Integer end_reduction {get; set;}
        public Integer facade_profile_reclamation {get; set;}
        public Integer fastener_box_reclamation {get; set;}
        public List<Glass> glass {get; set;}
        public Integer glass_amount {get; set;}
        public Integer glass_gap_seal_reclamation {get; set;}
        public Integer glass_module {get; set;}
        public String glass_module_position {get; set;}
        public Integer glass_panels_left {get; set;}
        public Integer glass_panels_left_second_gate {get; set;}
        public Integer glass_panels_right {get; set;}
        public Integer glass_panels_right_second_gate {get; set;}
        public Integer glass_thickness {get; set;}
        // Handrail
        public Integer handrail_pipe_bracket_reclamation {get; set;}
        public Integer handrail_pipe_reclamation {get; set;}
        public Integer handrail_reclamation {get; set;}
        public Integer handrail_support_piece_reclamation {get; set;}
        public Double height {get; set;}
        public Double hinge_relocation_left {get; set;}
        public Double hinge_relocation_right {get; set;}
        public Integer latch_height {get; set;}
        public String latch_left {get; set;}
        public Integer latch_left_reclamation {get; set;}
        public String latch_right {get; set;}
        public Integer latch_right_reclamation {get; set;}
        public Double length {get; set;}
        public String lower_bracket {get; set;}
        public String lower_bracket_color {get; set;}
        public Integer lower_bracket_reclamation {get; set;}
        public Integer lower_bracket_width {get; set;}
        public String lower_fastening_material{get; set;} 
        public Object lower_frame_cutpoint {get; set;}
        // Lower Frame
        public Double lower_frame_height {get; set;}
        public Double lower_frame_height_left {get; set;}
        public Double lower_frame_height_right {get; set;}
        public Integer lower_frame_reclamation {get; set;}
        public Integer lower_gap_profile_reclamation {get; set;}
        public Integer lower_profile_reclamation {get; set;}
        public Integer lower_reduction {get; set;}
        public Integer lower_telescopic_profile_reclamation {get; set;}
        // Obstacle
        public Integer obstacle_outside_edgedistance {get; set;}
        public Integer obstacle_outside_height {get; set;}
        public List<Obstacle> obstacles {get; set;}
        //Opening
        public String opening_type_left {get; set;}
        public String opening_type_right {get; set;}
        //Post
        public List<Post> post {get; set;}
        public Integer post_amount {get; set;}
        public Double post_end_distance {get; set;}
        public Integer prev_system_angle {get; set;}
        // Product Attribute
        public Double product_height {get; set;}
        public Double product_length {get; set;}
        public Integer profile_extension_left {get; set;}
        public Integer profile_extension_right {get; set;}
        public Integer profile_sliding_left {get; set;}
        public Integer profile_sliding_right {get; set;}
        public Integer pull_handle {get; set;}
        public Integer pull_handle_reclamation {get; set;}
        public Integer side_number {get; set;}
        // Solar Screen
        public Integer solar_screen {get; set;}
        public Integer solar_screen_length {get; set;}
        public Integer solar_screen_reclamation {get; set;}
        public Integer solar_sreen_position {get; set;}
        public String stackingdevice_left {get; set;}
        public String stackingdevice_right {get; set;}
        public Integer start_angle {get; set;}
        public Integer start_reduction {get; set;}
        public Integer system_angle {get; set;}
        public Integer telescopic_profile_reclamation {get; set;}
        // Upper Bracket
        public String upper_bracket {get; set;}
        public String upper_bracket_color {get; set;}
        public Integer upper_bracket_reclamation {get; set;}
        // Upper Fastening
        public String upper_fastening_material {get; set;}
        // Upper Profile
        public Integer upper_profile_reclamation {get; set;}
        public Integer upper_reduction {get; set;}
        public Integer ventilation_cover {get; set;}
        public Double z_measure {get; set;}
		public Integer side_number_opening {get;set;} 
        // Post
		public Object post_angle_L {get;set;} 
		public Integer post_angle_R {get;set;} 
		public Integer post_width_L {get;set;} 
		public Integer post_depth_L {get;set;} 
		public Integer post_width_R {get;set;} 
		public Integer post_depth_R {get;set;} 
		public Integer post_z_measure_L {get;set;} 
		public Integer post_z_measure_R {get;set;} 
		public Object roof_type {get;set;} 
        //Additional Opening
		public String additional_opening_left {get;set;} 
		public String additional_opening_right {get;set;} 		
		public Integer additional_opening_left_reclamation {get;set;} 
		public Integer additional_opening_right_reclamation {get;set;} 
        // Seals
        public Integer start_seal_reclamation {get;set;} 
		public Integer end_seal_reclamation {get;set;} 


	}
	public class Glass {
        // Glass Attributes
		public Integer glass_number {get; set;}
        public Integer glass_support {get; set;}
		public Integer glass_reclamation {get; set;}
		public String glass_item {get; set;}
		public Double width {get; set;}
		public Integer glass_direction {get; set;}
		public Integer fixed {get; set;}
		public Integer glasspack_index {get; set;}
        // Sand Blasting
		public Integer sandblasting {get; set;}
		public Double sandblasting_height {get; set;}
		public String sandblasting_type {get; set;}
		public Integer sandblasting_side {get; set;}
		public Integer safety_decals {get; set;}
        // Silk Printing
		public Integer silk_printing {get; set;}
		public String silk_printing_type {get; set;}
		public String silk_printing_color {get; set;}
		public Integer silk_printing_side {get; set;}
        public String silk_printing_item {get; set;}
        public Double silk_printing_height {get; set;}
		public String silk_printing_insert_point {get; set;}
        // Other Processing
		public Integer heatsoak {get; set;}
		public Integer cutout {get; set;}
        // Blinds
		public List<Blind> blinds {get; set;}
	}
    public class Blind {
		public Integer blind_number {get; set;}
		public Integer blind_reclamation {get; set;}
		public Integer blinds_fabric {get; set;}
		public String blind_profile_color {get; set;}
		public String blind_endplug_color {get; set;}
	}
    public class Post {
		public Integer post_number {get; set;}
		public Double post_position{get; set;}
		public Double post_z_measure {get; set;}
		public Integer post_reclamation {get; set;}
		public Double post_profile_height {get; set;}
		public Integer post_bracket_reclamation {get; set;}
		public Integer expansion {get; set;}
		public String fastening_material {get; set;}
		public String post_item {get; set;}
		public String post_color {get; set;}
		public String anchor_item {get; set;}
	}
	public class Flashing {
        public String flashcode {get;set;} 
        public String flashcolor {get;set;} 
        public Integer flashpcs {get;set;} 
        public Integer flashcutlength {get;set;} 
        public Integer flasha {get;set;} 
        public Integer flashb {get;set;} 
        public Integer flashc {get;set;} 
	} 
    public class AdditionalProfile {
		public String addprofilecode {get;set;} 
		public String addprofilecolor {get;set;} 
		public Integer addprofilepcs {get;set;} 
		public Integer addprofilelength {get;set;} 
		public Integer addprofileangleleft {get;set;} 
		public Integer addprofileangleright {get;set;} 
	}
    public class StationaryGlass {
		public String sgcode {get;set;} 
		public Integer sgshape {get;set;} 
		public Integer sgthickness {get;set;} 
		public Integer sgwaterguide {get;set;} 
		public Integer sglatchtype {get;set;} 
		public Integer sgsliding {get;set;} 
		public Object sghandedness {get;set;} 
		public Integer sgpcs {get;set;} 
		public Integer sga {get;set;} 
		public Integer sgb {get;set;} 
		public Integer sgc {get;set;} 
		public Integer sgd {get;set;} 
	}
    public class StationaryGlassProfile {
		public String sgprofileitem {get;set;} 
		public Integer sgprofilepcs {get;set;} 
		public Integer sgprofilelength {get;set;} 
		public String sgprofilecolor {get;set;} 
		public Integer sgprofilereclamation {get;set;} 
	}	
    public class Obstacle {
        
    }
    public static Structure parseStructureJSON(String json) {
        return (Structure) System.JSON.deserialize(json, Structure.class);
    }
}