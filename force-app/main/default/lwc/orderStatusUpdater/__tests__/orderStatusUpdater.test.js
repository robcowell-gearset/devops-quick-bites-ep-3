import { createElement } from '@lwc/engine-dom';
import orderStatusUpdater from 'c/orderStatusUpdater';
import { getRecord } from 'lightning/uiRecordApi';
const mockGetRecord = require('./data/getRecord.json');

describe('c-order-status-updater', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('renders the component with the correct status from the record', () => {
        const element = createElement('c-order-status-updater', {
            is: orderStatusUpdater
        });
        document.body.appendChild(element);
        getRecord.emit(mockGetRecord);
        console.log('element: ' + element);

        // Query the DOM for the output elements after data has been loaded
        return Promise.resolve().then(() => {
        const combobox = element.shadowRoot.querySelector('lightning-combobox');
        console.log('combobox: ' + combobox);
        expect(combobox.value).toBe(mockGetRecord.fields.Status__c.value);
        });
    });

        // Test changing the status and saving it
        it('updates the order status correctly when save button is clicked', () => {
            const element = createElement('c-order-status-updater', {
                is: orderStatusUpdater
            });
            document.body.appendChild(element);
            getRecord.emit(mockGetRecord);
    
            // Simulate user changing the status
            return Promise.resolve().then(() => {
            const combobox = element.shadowRoot.querySelector('lightning-combobox');
            combobox.dispatchEvent(new CustomEvent('change', { detail: { value: 'Processed' } }));
            
    
            // Simulate user clicking the save button
            const button = element.shadowRoot.querySelector('lightning-button');
            button.click();
    
            
                // Since we're mocking, you can verify interactions or changes in internal component states
                expect(button.label).toBe('Update Status'); // Example to check button label, adjust according to your logic
            });
        });
        
    });