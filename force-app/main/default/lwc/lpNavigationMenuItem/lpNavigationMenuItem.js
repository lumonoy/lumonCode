import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import basePath from '@salesforce/community/basePath';

export default class LpNavigationMenuItem extends NavigationMixin(LightningElement) {
	@api item = {};
	@track href = '#';

	get subMenuLinkStyle(){
		if(this.item.hasOwnProperty('parentId')){
			return 'padding-left: 15px;';
		}
		return '';
	}
	/*get navLinkStyle(){
		if(this.item.type === 'MenuLabel'){
			return 'position:relative;z-index:-1;'
		}
		return '';
	}*/
	pageReference = null;
	connectedCallback() {
		const { type, target, defaultListViewId } = this.item;
		if (type === 'SalesforceObject') {
			this.pageReference = {
				type: 'standard__objectPage',
				attributes: {
					objectApiName: target
				},
				state: {
					filterName: defaultListViewId
				}
			};
		} else if (type === 'InternalLink') {
			this.pageReference = {
				type: 'standard__webPage',
				attributes: {
					url: basePath + target
				}
			};
		} else if (type === 'ExternalLink') {
			this.pageReference = {
				type: 'standard__webPage',
				attributes: {
					url: target
				}
			};
		}
		// use the NavigationMixin from lightning/navigation to generate the URL for navigation.
		if (this.pageReference) {
			this[NavigationMixin.GenerateUrl](this.pageReference).then(
				(url) => {
					this.href = url;
				}
			);
		}
	}
	handleNavigation() {
		const navEvent = new CustomEvent('navigation', {
			detail: {
				clickedItem : this.item.id
			},
		});
		this.dispatchEvent(navEvent);
	}
	handleClick(evt) {
		evt.stopPropagation();
		evt.preventDefault();
		if(this.item.type === 'MenuLabel'){
			this.handleNavigation();
		}
		if (this.pageReference) {
			this[NavigationMixin.Navigate](this.pageReference);
		} else {
			console.log(
				`Navigation menu type "${
					this.item.type
				}" not implemented for item ${JSON.stringify(this.item)}`
			);
		}
	}
}