import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getOpportunityInvoiceNum from '@salesforce/apex/ShowInvoiceController.getOpportunityInvoiceNum';
import getContentDocumentId from '@salesforce/apex/ShowInvoiceController.getContentDocumentId';

export default class OpenFileSample extends NavigationMixin(LightningElement) {
  @api recordId;

  @wire (getOpportunityInvoiceNum, {recordId: '$recordId'})
  opportunityInvoiceNum;

  @wire (getContentDocumentId, {test: '$opportunityInvoiceNum.data'})
  contentDocumentId;

  navigateToFiles() {
    this[NavigationMixin.Navigate]({
      type: 'standard__namedPage',
      attributes: {
          pageName: 'filePreview'
      },
      state : {
          recordIds: this.contentDocumentId.data,
          selectedRecordId: this.contentDocumentId.data
      }
    })
  }
}