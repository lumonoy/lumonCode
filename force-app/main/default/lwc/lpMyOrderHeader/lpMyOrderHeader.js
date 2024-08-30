import {api, LightningElement} from 'lwc';
import {NavigationMixin} from "lightning/navigation";
import {navigateToOrderDetailPage} from "c/lpUtils";

export default class LpMyOrderHeader extends NavigationMixin(LightningElement)  {
	@api order;
	@api orderLabels;

	handleOrderDetailClick(){
		navigateToOrderDetailPage(this, 'order-details', this.order.orderId);
	}
}