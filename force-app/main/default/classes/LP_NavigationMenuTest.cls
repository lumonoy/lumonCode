@isTest
private class LP_NavigationMenuTest {
	@IsTest
	static void doTest(){
		Test.startTest();
		String networkId = [SELECT Id FROM Network WHERE Name = 'myLumon Portal' LIMIT 1].Id;
		String navigationDevName = [SELECT Id, DeveloperName FROM NavigationLinkSet WHERE NetworkId = :networkId LIMIT 1].DeveloperName;
		LP_NavigationMenu.fetchNavigationMenuItems(navigationDevName, 'Live');
		LP_NavigationMenu.fetchNavigationMenuItems('Default_Navigation', 'Draft');
		LP_NavigationMenu.fetchNavigationMenuItems('', null);
		Test.stopTest();
	}
}