import {LightningElement, api} from 'lwc';
import PRODUCT_IMAGES from '@salesforce/resourceUrl/LP_Product_Images';

export default class LpMyOrderProduct extends LightningElement {
	@api productImageName;
	@api productName;
	get productImgUrl(){
		return PRODUCT_IMAGES + '/LP_Product_Images/' + this.productImageName + '.webp';
	}
}