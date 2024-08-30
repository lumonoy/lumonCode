/**
 * Created by rinatnadav on 1.11.2022.
 */

import { api, LightningElement } from 'lwc';

export default class TimeSlotAccordion extends LightningElement {
	_listOfSlots = [];
	@api
	set listOfSlots(value) {
		this._listOfSlots = value.map((slot, id) => ({ ...slot, isOpened: id === 0, id }));
	}
	get listOfSlots() {
		return this._listOfSlots;
	}

	handleSlotSubmit(event) {
		this.dispatchEvent(
			new CustomEvent('select', {
				detail: {
					id: event.currentTarget.dataset.id
				}
			})
		);
	}
}