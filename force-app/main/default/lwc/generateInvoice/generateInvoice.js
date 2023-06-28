import { wire, api, LightningElement } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import attachPDF from '@salesforce/apex/AttachPdfInvoice.attachPDF';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LwcQuickAction extends LightningElement {

    @api recordId;
    
    handleBtnClick() {
      console.log('Record id is ' + this.recordId);
      let attachPDFPromise = attachPDF({opportunityId: this.recordId})
      .then((value) => {
        let event = new ShowToastEvent({
          title: 'Success',
          message: 'New pdf has been created',
          variant: 'success'
        })
        this.dispatchEvent(event)
      })
      .catch((error) => {
        console.log(error);
        let event = new ShowToastEvent({
          title: 'Error',
          message: 'Araised error during pdf attachment',
          variant: 'error'
        })
        this.dispatchEvent(event)
      })
      
    }

    closeAction() {
      this.dispatchEvent(new CloseActionScreenEvent());
    }
}