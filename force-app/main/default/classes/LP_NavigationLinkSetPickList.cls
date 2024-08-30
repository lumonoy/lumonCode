global class LP_NavigationLinkSetPickList extends VisualEditor.DynamicPickList {
	public VisualEditor.DynamicPickListRows pickListValues = new VisualEditor.DynamicPickListRows();
	global override VisualEditor.DataRow getDefaultValue() {
		VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(
				'--Select Navigation --',
				'Select_Navigation'
		);
		return defaultValue;
	}

	global override VisualEditor.DynamicPickListRows getValues() {
		picklistValues = new VisualEditor.DynamicPickListRows();
		List<NavigationLinkSet> navigationLinkSetList = [
				SELECT MasterLabel, DeveloperName
				FROM NavigationLinkSet
		];
		for (NavigationLinkSet navigationLinkSet : navigationLinkSetList) {
				VisualEditor.DataRow value = new VisualEditor.DataRow(
						navigationLinkSet.MasterLabel,
						navigationLinkSet.DeveloperName
				);
			picklistValues.addRow(value);
		}
		return picklistValues;
	}
}