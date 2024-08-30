@isTest
private class LP_FooterTest {
		@IsTest
		static void doTestFooter(){
			Test.startTest();
			String footerSTR = LP_Footer.fetchFooterData('en-US');
			List<LP_Footer.FooterSection> footerList =
					(List<LP_Footer.FooterSection>) JSON.deserialize(footerSTR, List<LP_Footer.FooterSection>.class);
			System.assertEquals(true, footerList.size() > 0, 'No Footer Links found in custom meta data');
			Test.stopTest();
		}
}