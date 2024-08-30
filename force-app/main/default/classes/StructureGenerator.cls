/**
 * Created by Konrad Niewiadomski on 23.11.2022.
 */

public without sharing class StructureGenerator {

	public static String processStructureJSON(String jsonBody, String structureNumber,String salesCode, String recordId) {
		StructureWrapper wrapper = (StructureWrapper) System.JSON.deserialize(jsonBody, StructureWrapper.class);
        System.debug('*** sales code value ***'+salesCode);
		wrapper.structure_number = structureNumber;
		wrapper.vendorid = 'LU';
		wrapper.deliverybatch = 0;
		notifySovelia(JSON.serialize(wrapper), '', '', structureNumber,salesCode, recordId);
		return 'success';
	}

	@future (callout=true)
	public static void notifySovelia (String jsonBody, String endpoint, String apiKey, String structureNum, String salesCode, String recordId) {
		System.debug('!!!! notifySovelia for record: '+recordId);
		System.debug('!!!! notifySovelia JSON');
		Order orderRecord = new Order(Id = recordId);
		try {
			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint('https://tlstest.lumon.com/visualtori/toplmbatch?product='+salesCode+'&name='+ salesCode +'_' + structureNum);
			request.setMethod('POST');
			request.setHeader('Content-Type', 'application/json;charset=UTF-8');
			request.setHeader('X-APIKey', 'Test1234');
			request.setBody(jsonBody);
            request.setTimeout(120000); // timeout included for read timed out errors 
			System.debug('!! sovelia body: ' + jsonBody);
			HttpResponse response = http.send(request);

			System.debug('!!STATUS: ' + response.getStatus());

			if (response.getStatusCode() != 200 && response.getStatusCode() != 201) {
				System.debug('!!ERROR: ' + response.getBody());
				orderRecord.Is_Structure_JSON_Processed__c = false;
			} else {
				System.debug('!!SUCCESS: ' + response.getBody());
				orderRecord.Is_Structure_JSON_Processed__c = true;
			}
		} catch(System.Exception e) {
			orderRecord.Is_Structure_JSON_Processed__c = false;
			update orderRecord;
		}
	}

	public class StructureWrapper {
		public String country {public get; public set;}
		public String product_type {public get; public set;}
		public Integer terrain_class {public get; public set;}
		public Integer building_height {public get; public set;}
		public Integer reference_windspeed {public get; public set;}
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
		public Integer installation_method {public get; public set;}
		public List<Side> side {public get; public set;}
	}

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

	public class Flashings {

	}

	public class AdditionalProfile {

	}

	public class StationaryGlass {

	}

	public class StationaryGlassProfile {

	}
}