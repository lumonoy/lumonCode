@isTest
public with sharing class LP_NavigationLinkSetPickListTest {
	@isTest
	static void testAllValues() {
		LP_NavigationLinkSetPickList navLinkSet = new LP_NavigationLinkSetPickList();
		VisualEditor.DynamicPickListRows rows = navLinkSet.getValues();
		VisualEditor.DataRow defaultRowValue = navLinkSet.getDefaultValue();
		System.assertEquals(true, rows != null, 'No Navigations were found');
		System.assertEquals(true, defaultRowValue != null, 'No Default row value was found');
	}
}