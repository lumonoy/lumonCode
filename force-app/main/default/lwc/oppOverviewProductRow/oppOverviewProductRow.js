/**
 * Created by Filip on 17. 2. 2023.
 */

import {api, LightningElement} from 'lwc';

export default class OppOverviewProductRow extends LightningElement {
	@api fields;
	@api timeZone;
	hoveredCellId;
	getCellId(event){
		this.hoveredCellId = event.currentTarget.dataset.id;
	}
	assignNullToCellId(){
		this.hoveredCellId = null;
	}
}