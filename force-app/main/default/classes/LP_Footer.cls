public with sharing class LP_Footer {
	public class FooterSection{
		@AuraEnabled public String name;
		@AuraEnabled public Boolean isMainSection;
		@AuraEnabled public List<FooterLink> footerLinks;
	}
	public class FooterLink{
		@AuraEnabled public String url;
		@AuraEnabled public String label;
		@AuraEnabled public String socialIcon;
		public FooterLink(String url, String label, String icon){
			this.url = url;
			this.label = label;
			this.socialIcon = icon;
		}
	}

	@AuraEnabled public static String fetchFooterData(String portalLanguage){
		Map<String, FooterSection> footerSectionLinksMap = new Map<String, FooterSection>();
		if(portalLanguage != null){
			List<LP_Footer_Link__mdt> footerLinks = [
				SELECT
					Label,
					Country_Language__c,
					Is_Main_Footer_Section__c,
					Link_Order__c,
					Link_Section__c,
					Link_URL__c
				FROM LP_Footer_Link__mdt
				WHERE Country_Language__c = :portalLanguage
				ORDER BY Link_Section__c, Link_Order__c
				LIMIT 500
			];
			if(footerLinks.size() > 0){
				for(LP_Footer_Link__mdt fL : footerLinks){
					if(!footerSectionLinksMap.containsKey(fL.Link_Section__c)){
						FooterSection fSection = new FooterSection();
						fSection.name = fL.Link_Section__c;
						fSection.isMainSection = fL.Is_Main_Footer_Section__c;
						fSection.footerLinks = new List<FooterLink>{
							new FooterLink(fL.Link_URL__c, fL.Label, generateIconClass(fL.Link_Section__c, fL.Label)
							)
						};
						footerSectionLinksMap.put(fL.Link_Section__c, fSection);
					}else{
						footerSectionLinksMap.get(fL.Link_Section__c).footerLinks.add(
							new FooterLink(fL.Link_URL__c, fL.Label, generateIconClass(fL.Link_Section__c, fL.Label)
							)
						);
					}
				}
			}
		}
		return JSON.serialize(footerSectionLinksMap.values());
	}
	private static String generateIconClass(String linkSection, String linkLabel){
		if(linkSection.toUpperCase() != 'SOCIAL'){
			return null;
		}
		String socialMedia = linkLabel.toLowerCase().split(' ')[0];
		return 'icon-' + socialMedia;
	}
}