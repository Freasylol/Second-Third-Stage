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

  // logId() {
  //   console.log('Record id is ' + this.recordId);
  // }

  // logOpportunityInvoiceNum() {
  //   console.log('OpportunityInvoiceNum is ' + this.opportunityInvoiceNum.data);
  // }

  // logContentDocumentId() {
  //   console.log('Content document is ' + this.contentDocumentId.data)
  // }

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

  // navigateToFiles() {
  //   this[NavigationMixin.Navigate]({
  //     type: 'standard__namedPage',
  //     attributes: {
  //         pageName: 'filePreview'
  //     },
  //     state : {
  //         recordIds: '069Dn000003hIYlIAM',
  //         selectedRecordId:'069Dn000003hIYlIAM'
  //     }
  //   })
  // }
}