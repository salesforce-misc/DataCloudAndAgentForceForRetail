import {LightningElement, wire} from 'lwc';
import {getRecord} from 'lightning/uiRecordApi';
import getCommunityUserId from '@salesforce/apex/CommunityUserController.getCommunityUserId';
import FIRST_NAME_FIELD from '@salesforce/schema/User.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/User.LastName';
import EMAIL_FIELD from '@salesforce/schema/User.Email';
import CONTACT_FIELD from '@salesforce/schema/User.ContactId';
export default class DefaultPrechatValuesComponent extends LightningElement {
	userId;
	userDetails = {
		firstName: '',
		lastName: '',
		email: '',
		id: '',
		contactId: ''
	};
	

	@wire(getCommunityUserId) userDataHandler({data, error}) {
        if(data) {
			console.error('User data retrieved:', data);
			this.userDetails = {
				firstName: data.FirstName,
				lastName: data.LastName,
				email: data.Email,
				id: data.Id,
				contactId: data.ContactId
			};

			const userDetailsEvent = new CustomEvent("userDetails", {
				detail: this.userDetails,
				bubbles: true,
				composed: true
			});
			this.dispatchEvent(userDetailsEvent);
        }
	else if (error) {
		console.error('Error retrieving user data:', error);
	}
} 

}