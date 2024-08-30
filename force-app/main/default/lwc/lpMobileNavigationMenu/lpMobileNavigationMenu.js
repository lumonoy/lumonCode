import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import fetchNavigationMenuItems from '@salesforce/apex/LP_NavigationMenu.fetchNavigationMenuItems';
import isGuestUser from '@salesforce/user/isGuest';
import LANG from "@salesforce/i18n/lang";

export default class LpMobileNavigationMenu extends NavigationMixin(LightningElement) {
	@api menuName = '';
	@api cssClass = '';
	menuItems = [];
	publishedState;

	@wire(fetchNavigationMenuItems, {menuName: '$menuName', publishedState: '$publishedState'})
	wiredMenuItems({ error, data }) {
		if (data) {
			const navMenuItems = JSON.parse(data);
			this.menuItems = navMenuItems.map((item, index) => {
				return {
					target: item.target,
					id: index,
					label: this.getMenuLabel(item),
					defaultListViewId: item.defaultListViewId,
					type: item.type,
					accessRestriction: item.accessRestriction,
					subMenuItems: item.subMenuItems
				};
			})
			.filter((item) => {
				return (
					item.accessRestriction === 'None' ||
					(item.accessRestriction === 'LoginRequired' &&
						!isGuestUser)
				);
			});
		} else if (error) {
			this.menuItems = [];
		}
	}

	getMenuLabel = (item) =>{
		if(item.menuItemTranslations.length > 0){
			for(let translation of item.menuItemTranslations){
				if(translation.language === LANG){
					return translation.label;
				}
			}
		}
		return item.label;
	};

	@wire(CurrentPageReference)
	setCurrentPageReference(currentPageReference) {
		const app =
			currentPageReference &&
			currentPageReference.state &&
			currentPageReference.state.app;
		this.publishedState = app === 'commeditor' ? 'Draft' : 'Live';
	}

	handleItemClicked(event){
		let clickedNavItem = event.currentTarget.dataset.id;
		this.setSubMenuVisibility(clickedNavItem);
	}

	setSubMenuVisibility(clickedItem){
		let parentNavItem = this.template.querySelector('[data-id="'+clickedItem+'"]');
		if(parentNavItem.children.length === 2) {
			parentNavItem.children[0].classList.toggle('sub-menu-opened');
			parentNavItem.children[1].classList.toggle('visible');
		}
	}
	
	handleNavigationItemClick(event){
		let clickedNavItem = event.detail.clickedItem;
		this.setSubMenuVisibility(clickedNavItem);
	}

}