@IsTest
private class LP_ChangePasswordCtrlTest {
	@IsTest
	public static void testChangePasswordController() {
		LP_ChangePasswordCtrl controller = new LP_ChangePasswordCtrl();
		controller.oldPassword = '12345678';
		controller.newPassword = 'qWerty123';
		controller.verifyNewPassword = 'qWerty123';
		controller.errMsg = '';
		System.assertEquals(controller.changePassword(),null);

		LP_ChangePasswordCtrl.getVFOrigin();
	}
}