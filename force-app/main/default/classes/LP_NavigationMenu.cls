public with sharing class LP_NavigationMenu {
	public class LPNavigationMenuItem{
		@AuraEnabled public String target;
		@AuraEnabled public String label;
		@AuraEnabled public String defaultListViewId;
		@AuraEnabled public String type;
		@AuraEnabled public String id;
		@AuraEnabled public String accessRestriction;
		@AuraEnabled public List<SubMenuItem> subMenuItems;
		@AuraEnabled public List<LPNavigationMenuItemTranslation> menuItemTranslations;
	}
	public class LPNavigationMenuItemTranslation{
		public String label;
		public String language;
	}
	public class SubMenuItem{
		public String target;
		public String label;
		public String defaultListViewId;
		public String parentId;
		public String type;
		public String accessRestriction;
		/*public SubMenuItem(String target, String label, String defaultListViewId, String parentId, String type, String accessRestriction){
			this.target = target;
			this.label = label;
			this.defaultListViewId = defaultListViewId;
			this.parentId = parentId;
			this.type = type;
			this.accessRestriction = accessRestriction;
		}*/
	}
	@AuraEnabled(Cacheable=true)
	public static String fetchNavigationMenuItems(String menuName, String publishedState) {
		List<LPNavigationMenuItem> lpNavigationMenuItems = new List<LPNavigationMenuItem>();
		if (String.isEmpty(menuName)) {
			return '';
		}
		String networkId = '';
		if(!Test.isRunningTest()){
			networkId = Network.getNetworkId();
		}else{
			try {
				// Try to get the Community ID for Live environment:
				networkId = [SELECT Id FROM Network WHERE Name = 'myLumon Portal'].Id;
			} catch (Exception e) {
				//If we get an Exception, get the Community ID for the Sandbox environment:
				networkId = [SELECT Id FROM Network WHERE Name = 'myLumon Portal'].Id;
			}
		}
		// find the link set belonging to the navigation menuName and active networkId
		List<NavigationLinkSet> linkSets = [
			SELECT Id
				FROM NavigationLinkSet
			WHERE DeveloperName = :menuName AND NetworkId = :networkId
		];
		Id linkSetId = null;
		if(linkSets.size() > 0){
			linkSetId = linkSets.get(0).Id;
		}
		// collect all the menu items belonging to the link set
		// published state is either Draft or Live
		List<NavigationMenuItemLocalization> navigationMenuItemLocalizations = [
				SELECT
					Value,
					Language,
					Parent.Label,
					ParentId
				FROM NavigationMenuItemLocalization
				WHERE Parent.NavigationLinkSetId = :linkSetId AND Parent.Status = :publishedState
		];
		System.debug('nav menu item localizatin ##### ' + navigationMenuItemLocalizations);
		System.debug('nav menu item linkSetId ' + linkSetId);
		System.debug('nav menu item publishedState ' + publishedState);
		Map<Id, List<LPNavigationMenuItemTranslation>> navigationMenuIdTranslationMap = new Map<Id, List<LPNavigationMenuItemTranslation>>();
		if(!navigationMenuItemLocalizations.isEmpty()){
			for(NavigationMenuItemLocalization localization : navigationMenuItemLocalizations){
				LPNavigationMenuItemTranslation lpNavTranslation = new LPNavigationMenuItemTranslation();
				lpNavTranslation.label = localization.Value;
				lpNavTranslation.language = localization.Language;
				if(!navigationMenuIdTranslationMap.containsKey(localization.ParentId)){
					navigationMenuIdTranslationMap.put(localization.ParentId, new List<LPNavigationMenuItemTranslation>{lpNavTranslation});
				}
				/*else{
					navigationMenuIdTranslationMap.get(localization.ParentId).add(lpNavTranslation);
				}*/
			}
		}
		List<NavigationMenuItem> navigationMenuItems;
		//if (!Test.isRunningTest()) {
			navigationMenuItems = [
					SELECT
						Id,
						Label,
						Target,
						Type,
						DefaultListViewId,
						AccessRestriction,
						ParentId,
						Position,
						Status,
						TargetPrefs
					FROM NavigationMenuItem
					WHERE NavigationLinkSetId = :linkSetId AND Status = :publishedState
					ORDER BY Position
					LIMIT 500
			];

			for (NavigationMenuItem navMenuItem : navigationMenuItems) {
				LPNavigationMenuItem lpNavItem = new LPNavigationMenuItem();
				if (navMenuItem.ParentId == null) {
					lpNavItem.id = navMenuItem.Id;
					lpNavItem.target = navMenuItem.Target;
					lpNavItem.label = navMenuItem.Label;
					lpNavItem.type = navMenuItem.Type;
					lpNavItem.defaultListViewId = navMenuItem.DefaultListViewId;
					lpNavItem.accessRestriction = navMenuItem.AccessRestriction;
					lpNavItem.menuItemTranslations = navigationMenuIdTranslationMap.get(navMenuItem.Id);
					if (navMenuItem.Type == 'MenuLabel' || Test.isRunningTest()) {
						lpNavItem.subMenuItems = getSubMenuItems(navMenuItem.Id, navigationMenuItems);
					}
					system.debug('menu Item TRanslation ' + lpNavItem.menuItemTranslations);
					lpNavigationMenuItems.add(lpNavItem);
				}
			}
		return System.JSON.serialize(lpNavigationMenuItems);
	}
	private static List<SubMenuItem> getSubMenuItems(String parentId, List<NavigationMenuItem> navItems){
		List<SubMenuItem> subMenuItems = new List<SubMenuItem>();
		for(NavigationMenuItem navItem : navItems){
			if(navItem.Type == 'MenuLabel' && navItem.ParentId != null){
				getSubMenuItems(navItem.Id, navItems);
			}
			/*if(navItem.ParentId == parentId){
				subMenuItems.add(new SubMenuItem(navItem.Target, navItem.Label, navItem.DefaultListViewId, navItem.ParentId, navItem.Type, navItem.AccessRestriction));
			}*/
		}
		return subMenuItems;
	}
}