/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 02-15-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class StructureData {
    public class Structure {
		public String country {public get; public set;}
		public String product_type {public get; public set;}
		public Integer terrain_class {public get; public set;}
		public Integer building_height {public get; public set;}
		public Double reference_windspeed {public get; public set;}
		public Integer slope {public get; public set;}
		public Double wind_pressure {public get; public set;}
		public Integer corner_coefficient {public get; public set;}
		public Integer structure {public get; public set;}
		public Integer product_openings {public get; public set;}
		public Integer report {public get; public set;}
		public String structure_number {public get; public set;}
		public String original_sn {public get; public set;}
		public String line {public get; public set;}
		public String floor {public get; public set;}
		public String Unit {public get; public set;}
		public String address {public get; public set;}
		public Integer reclamation {public get; public set;}
        public Integer component_box_reclamation {public get; public set;}
		public Integer anchors_reclamation {public get; public set;}
		public Integer special_order {public get; public set;}
		public List<ProductOpening> Product_opening {public get; public set;}
		public List<Flashings> flashings {public get; public set;}
		public List<AdditionalProfile> additionalprofiles {public get; public set;}
		public List<StationaryGlass> stationaryglasses {public get; public set;}
		public List<StationaryGlassProfile> stationaryglassprofiles {public get; public set;}
		public String vendorid {public get; public set;}
		public Integer deliverybatch {public get; public set;}
	}

	public class ProductOpening {
		public Integer embedded {public get; public set;}
		public String glass_gap_seal {public get; public set;}
		public String telescopic_profile {public get; public set;}
		public String lower_telescopic_profile {public get; public set;}
		public Integer component_box_reclamation {public get; public set;}
		public Integer side_amount {public get; public set;}
		public Integer glass_panel_amount {public get; public set;}
		public Integer glass_thickness {public get; public set;}
		public String upper_profile_color {public get; public set;}
		public String lower_profile_color {public get; public set;}
		public String lower_profile_seal {public get; public set;}
		public String water_flashing_seal {public get; public set;}
		public String soundproofing_seal {public get; public set;}
		public Integer drain_holes {public get; public set;}
		public Integer different_height_sides {public get; public set;}
		public Integer lower_milling {public get; public set;}
		public String upper_seal {public get; public set;}
		public String start_seal {public get; public set;}
		public String start_seal_color {public get; public set;}
		public String end_seal {public get; public set;}
		public String end_seal_color {public get; public set;}
		public String system_angle_seal {public get; public set;}
		public String upper_profile {public get; public set;}
		public String lower_profile {public get; public set;}
		public String upper_fastening_material {public get; public set;}
		public String lower_fastening_material {public get; public set;}
		public String installation_method {public get; public set;}
		public List<Side> side {public get; public set;}
	}

	public class Side {
        public String additional_lock {public get; public set;}
        public Double balcony_glazing_height {public get; public set;}
        public Double balcony_glazing_z_measure {public get; public set;}
        public List<Blind> blind {public get; public set;}
        public Integer blinds {public get; public set;}
        public Integer blinds_reclamation {public get; public set;}
        public String connecting_profiles {public get; public set;}
        public Integer corner_bypass_left {public get; public set;}
        public Integer corner_bypass_right {public get; public set;}
        // CutOuts
        public Double cutout_height {public get; public set;}
        public Double cutout_start_position {public get; public set;}
        public Double cutout_width {public get; public set;}
        public Integer decor_profile_reclamation {public get; public set;}
        public Integer edge_seal_left_reclamation {public get; public set;}
        public Integer edge_seal_right_reclamation {public get; public set;}
        public Integer embedment_depth {public get; public set;}
        public Integer end_angle {public get; public set;}
        public Integer end_reduction {public get; public set;}
        public Integer facade_profile_reclamation {public get; public set;}
        public Integer fastener_box_reclamation {public get; public set;}
        public List<Glass> glass {public get; public set;}
        public Integer glass_amount {public get; public set;}
        public Integer glass_gap_seal_reclamation {public get; public set;}
        public Integer glass_module {public get; public set;}
        public String glass_module_position {public get; public set;}
        public Integer glass_panels_left {public get; public set;}
        public Integer glass_panels_left_second_gate {public get; public set;}
        public Integer glass_panels_right {public get; public set;}
        public Integer glass_panels_right_second_gate {public get; public set;}
        public Integer glass_thickness {public get; public set;}
        // Handrail
        public Integer handrail_pipe_bracket_reclamation {public get; public set;}
        public Integer handrail_pipe_reclamation {public get; public set;}
        public Integer handrail_reclamation {public get; public set;}
        public Integer handrail_support_piece_reclamation {public get; public set;}
        public Double height {public get; public set;}
        public Double hinge_relocation_left {public get; public set;}
        public Double hinge_relocation_right {public get; public set;}
        public Integer latch_height {public get; public set;}
        public String latch_left {public get; public set;}
        public Integer latch_left_reclamation {public get; public set;}
        public String latch_right {public get; public set;}
        public Integer latch_right_reclamation {public get; public set;}
        public Double length {public get; public set;}
        public String lower_bracket {public get; public set;}
        public String lower_bracket_color {public get; public set;}
        public Integer lower_bracket_reclamation {public get; public set;}
        public Integer lower_bracket_width {public get; public set;}
        public String lower_fastening_material{public get; public set;} 
        public Object lower_frame_cutpoint {public get; public set;}
        // Lower Frame
        public Double lower_frame_height {public get; public set;}
        public Double lower_frame_height_left {public get; public set;}
        public Double lower_frame_height_right {public get; public set;}
        public Integer lower_frame_reclamation {public get; public set;}
        public Integer lower_gap_profile_reclamation {public get; public set;}
        public Integer lower_profile_reclamation {public get; public set;}
        public Integer lower_reduction {public get; public set;}
        public Integer lower_telescopic_profile_reclamation {public get; public set;}
        // Obstacles
        public Integer obstacle_outside_edgedistance {public get; public set;}
        public Integer obstacle_outside_height {public get; public set;}
        public List<Obstacle> obstacles {public get; public set;}
        public String opening_type_left {public get; public set;}
        public String opening_type_right {public get; public set;}
        public List<Post> post {public get; public set;}
        public Integer post_amount {public get; public set;}
        public Double post_end_distance {public get; public set;}
        public Integer prev_system_angle {public get; public set;}
        // Product Attributes
        public Double product_height {public get; public set;}
        public Double product_length {public get; public set;}
        public Integer profile_extension_left {public get; public set;}
        public Integer profile_extension_right {public get; public set;}
        public Integer profile_sliding_left {public get; public set;}
        public Integer profile_sliding_right {public get; public set;}
        public Integer pull_handle {public get; public set;}
        public Integer pull_handle_reclamation {public get; public set;}
        public Integer side_number {public get; public set;}
        // Solar Screens
        public Integer solar_screen {public get; public set;}
        public Integer solar_screen_length {public get; public set;}
        public Integer solar_screen_reclamation {public get; public set;}
        public Integer solar_sreen_position {public get; public set;}
        public String stackingdevice_left {public get; public set;}
        public String stackingdevice_right {public get; public set;}
        public Integer start_angle {public get; public set;}
        public Integer start_reduction {public get; public set;}
        public Integer system_angle {public get; public set;}
        public Integer telescopic_profile_reclamation {public get; public set;}
        // Upper Brackets
        public String upper_bracket {public get; public set;}
        public String upper_bracket_color {public get; public set;}
        public Integer upper_bracket_reclamation {public get; public set;}
        // Upper Fastening
        public String upper_fastening_material {public get; public set;}
        // Upper Profiles
        public Integer upper_profile_reclamation {public get; public set;}
        public Integer upper_reduction {public get; public set;}
        public Integer ventilation_cover {public get; public set;}
        public Double z_measure {public get; public set;}

	}

	public class Glass {
        // Glass Attributes
		public Integer glass_number {public get; public set;}
        public Integer glass_support {public get; public set;}
		public Integer glass_reclamation {public get; public set;}
		public String glass_item {public get; public set;}
		public Double width {public get; public set;}
		public Integer glass_direction {public get; public set;}
		public Integer fixed {public get; public set;}
		public Integer glasspack_index {public get; public set;}
        // Sand Blasting
		public Integer sandblasting {public get; public set;}
		public Double sandblasting_height {public get; public set;}
		public String sandblasting_type {public get; public set;}
		public Integer sandblasting_side {public get; public set;}
		public Integer safety_decals {public get; public set;}
        // Silk Printing
		public Integer silk_printing {public get; public set;}
		public String silk_printing_type {public get; public set;}
		public String silk_printing_color {public get; public set;}
		public Integer silk_printing_side {public get; public set;}
        public String silk_printing_item {public get; public set;}
        public Double silk_printing_height {public get; public set;}
		public String silk_printing_insert_point {public get; public set;}
        // Other Processing
		public Integer heatsoak {public get; public set;}
		public Integer cutout {public get; public set;}
        // Blinds
		public List<Blind> blinds {public get; public set;}
	}
    public class Blind {
		public Integer blind_number {public get; public set;}
		public Integer blind_reclamation {public get; public set;}
		public Integer blinds_fabric {public get; public set;}
		public String blind_profile_color {public get; public set;}
		public String blind_endplug_color {public get; public set;}
	}
    public class Post {
		public Integer post_number {public get; public set;}
		public Double post_position{public get; public set;}
		public Double post_z_measure {public get; public set;}
		public Integer post_reclamation {public get; public set;}
		public Double post_profile_height {public get; public set;}
		public Integer post_bracket_reclamation {public get; public set;}
		public Integer expansion {public get; public set;}
		public String fastening_material {public get; public set;}
		public String post_item {public get; public set;}
		public String post_color {public get; public set;}
		public String anchor_item {public get; public set;}
	}
	public class Flashings {

	}
    public class Obstacle {
    }
	public class AdditionalProfile {

	}

	public class StationaryGlass {

	}

	public class StationaryGlassProfile {

	}
    public static List<Structure> parseStructure(String structureJSON) {
        List<Structure> structures = (List<Structure>) System.JSON.deserialize(structureJSON, List<Structure>.class);
        System.Debug('--- StructureData - parsed '+structures.size()+' Structure Files');
		return structures;
	}

}