@isTest
private class LP_ManagedContentTest {
	@IsTest(SeeAllData=true)
	static void doTest() {
		LP_ManagedContent.getContent(null, 0, 1, 'en_US', '');
	}
}