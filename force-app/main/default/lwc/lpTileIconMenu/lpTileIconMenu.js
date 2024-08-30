import {LightningElement} from 'lwc';
import faqTitle from '@salesforce/label/c.LP_Tile_FAQ_Title';
import faqText from '@salesforce/label/c.LP_Tile_FAQ_Text';
import viewCasesTitle from '@salesforce/label/c.LP_Tile_View_Cases_Title';
import viewCasesText from '@salesforce/label/c.LP_Tile_View_Cases_Text';
import documentationTitle from '@salesforce/label/c.LP_Tile_Documentation_Title';
import documentationText from '@salesforce/label/c.LP_Tile_Documentation_Text';
import productTitle from '@salesforce/label/c.LP_Tile_Product_Title';
import productText from '@salesforce/label/c.LP_Tile_Product_Text';
import { NavigationMixin } from 'lightning/navigation';

export default class LpTileIconMenu extends NavigationMixin(LightningElement) {
	tileMenuLabels = {
		'faqTitle' : faqTitle,
		'faqText'  : faqText,
		'viewCasesTitle' : viewCasesTitle,
		'viewCasesText' : viewCasesText,
		'documentationTitle' : documentationTitle,
		'documentationText' : documentationText,
		'productTitle' : productTitle,
		'productText' : productText
	};
	/*connectedCallback(){
		const url = window.location.href;
		/!*console.log('URL@## ', url);
		console.log('index of supp center ', url.indexOf('support-center') > -1);
		this.template.querySelector(`[data-id="cases"]`).classList.add('active');*!/

		this.setActiveTileMenu(url);
	}*/
	isRendered = false;
	renderedCallback() {
		if(!this.isRendered){
			const url = window.location.href;
			this.setActiveTileMenu(url);
		}
		this.isRendered = true;
	}

	setActiveTileMenu(url){
			if(url.indexOf('support-center') > -1){
				this.template.querySelector(`[data-id="cases"]`).classList.add('active');
			}
		/*switch(url) {
			case url.indexOf('support-center') > -1:
				this.template.querySelector('[data-id="cases"]').classList.add('active');
				break;
			case url.indexOf('faq') > -1:
				this.template.querySelector(`[data-id="faq"]`).classList.add('active');
				break;
			case url.indexOf('documentation') > -1:
				this.template.querySelector(`[data-id="faq"]`).classList.add('active');
				break;
			case url.indexOf('product-details') > -1:
				this.template.querySelector(`[data-id="product"]`).classList.add('active');
				break;
		}*/
	}
	handleTileClick(event){

	}
}