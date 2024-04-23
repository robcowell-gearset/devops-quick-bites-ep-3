import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import STATUS_FIELD from '@salesforce/schema/Order__c.Status__c';
import ID_FIELD from '@salesforce/schema/Order__c.Id';

const FIELDS = [STATUS_FIELD];

export default class OrderStatusUpdater extends LightningElement {
    @api recordId;
    @track status = 'Pending';

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    order;

    get statusOptions() {
        return [
            { label: 'Pending', value: 'Pending' },
            { label: 'Processed', value: 'Processed' },
            { label: 'Cancelled', value: 'Cancelled' }
        ];
    }

    handleStatusChange(event) {
        this.status = event.detail.value;
    }

    updateOrderStatus() {
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[STATUS_FIELD.fieldApiName] = this.status;

        const recordInput = { fields };
        updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Order status updated',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}
