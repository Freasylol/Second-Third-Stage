import { wire, api, LightningElement } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import attachPDF from '@salesforce/apex/AttachPdfInvoice.attachPDF';

export default class LwcQuickAction extends LightningElement {

    @api recordId;
    
    handleBtnClick() {
      console.log('Record id is ' + this.recordId);
      attachPDF({opportunityId: this.recordId});
    }

    closeAction() {
      this.dispatchEvent(new CloseActionScreenEvent());
    }
}