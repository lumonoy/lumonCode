global without sharing class LP_ChangePasswordCtrl {

	public String newPassword{get;set;}
	public String verifyNewPassword{get;set;}
	public String oldPassword{get;set;}
	public Boolean isError{get;set;}
	public String errMsg { get; set; }

	public PageReference changePassword() {

		PageReference retValue = Site.changePassword(newPassword, verifyNewPassword, oldPassword);
		String apexMsg = '';
		for (ApexPages.Message m : ApexPages.getMessages()) {
			apexMsg = m.getSummary();
		}
		this.errMsg = (retValue == null ? apexMsg : '' );
		this.isError = this.errMsg != '';
		if(retValue != null && oldPassword != null){
			return null;
		}
		return retValue;
	}

	@AuraEnabled(Cacheable=true)
	public static String getVFOrigin() {
		String vfOrigin = '';
		String baseURL = URL.getOrgDomainUrl().toExternalForm();
		vfOrigin = baseURL.split('.my.')[0] + '--c.' + 'vf.force.com';
		return vfOrigin;
	}

}