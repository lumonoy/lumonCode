import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import basePath from '@salesforce/community/basePath';

export default class LpMobileNavigationItem extends NavigationMixin(LightningElement) {
	@api item = {};
	@track href = '#';
	pageReference = null;

	get subMenuLinkStyle(){
		if(this.item.hasOwnProperty('parentId')){
			return 'padding-left: 15px;';
		}
		return '';
	}

	get navLinkStyle(){
		if(this.item.type === 'MenuLabel'){
			return 'position:relative;z-index:-1;'
		}
		return '';
	}

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
		}
	}
}