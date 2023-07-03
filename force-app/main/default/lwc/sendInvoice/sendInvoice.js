import { wire, api, LightningElement } from 'lwc';
import sendEmail from '@salesforce/apex/EmailSender.sendEmail';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';
import getEmailTemplates from '@salesforce/apex/EmailTemplateController.getEmailTemplates';
import getEmailInfo from '@salesforce/apex/GetEmailInfo.getEmailInfo';
import getReceiverName from '@salesforce/apex/GetReceiver.getReceiverName';
import getReceiverEmail from '@salesforce/apex/GetReceiver.getReceiverEmail';
import getOpportunityInvoiceNum from '@salesforce/apex/ShowInvoiceController.getOpportunityInvoiceNum';
import getContentDocumentId from '@salesforce/apex/ShowInvoiceController.getContentDocumentId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LwcQuickAction extends NavigationMixin(LightningElement) {

    @api recordId;

    opportunityInvoiceNum;

    contentDocumentId;

    emailTemplate;

    orderNum;

    receiverName;
    
    receiverEmail;

    @wire (getOpportunityInvoiceNum, {recordId: '$recordId'})
    wiredOpportunityInvoiceNum({error, data}) {
      if (error) {
        console.log(error);
        let event = new ShowToastEvent({
        title: 'Error',
        message: 'Something went wrong',
        variant: 'error'
        })
        this.dispatchEvent(event);
      }
      if (data) {
        this.opportunityInvoiceNum = data;
      }
    }
  
    @wire (getContentDocumentId, {test: '$opportunityInvoiceNum'})
    wiredContentDocumentId({error, data}) {
      if (error) {
        console.log(error);
        let event = new ShowToastEvent({
        title: 'Error',
        message: 'Something went wrong',
        variant: 'error'
        })
        this.dispatchEvent(event);
      }

      if (data) {
        this.contentDocumentId = data;
      }
    }

    @wire(getEmailTemplates) 
    wiredEmailTemplate({error, data}) {
      if (error) {
        console.log(error);
        let event = new ShowToastEvent({
        title: 'Error',
        message: 'Something went wrong',
        variant: 'error'
        })
        this.dispatchEvent(event);
      }

      if (data) {
        this.emailTemplate = data;
      }
    }

    @wire(getEmailInfo, {recordId: '$recordId'})
    wiredOrderNum({error, data}) {
      if (error) {
        console.log(error);
        let event = new ShowToastEvent({
        title: 'Error',
        message: 'Something went wrong',
        variant: 'error'
        })
        this.dispatchEvent(event);
      }

      if (data) {
        this.orderNum = data;
      }
    }

    @wire(getReceiverName, {recordId: '$recordId'})
    wiredReceiverName({error, data}) {
      if (error) {
        console.log(error);
        let event = new ShowToastEvent({
        title: 'Error',
        message: 'Something went wrong',
        variant: 'error'
        })
        this.dispatchEvent(event);
      }

      if (data) {
        this.receiverName = data;
      }
    }
    
    @wire (getReceiverEmail, {recordId: '$recordId'})
    wiredReceiverEmail({error, data}) {
    if (error) {
      console.log(error);
      let event = new ShowToastEvent({
      title: 'Error',
      message: 'Something went wrong',
      variant: 'error'
      })
      this.dispatchEvent(event);
    }

    if (data) {
      this.receiverEmail = data;
    }
  }

    emailBody = '';

    navigateToFiles() {
      this[NavigationMixin.Navigate]({
        type: 'standard__namedPage',
        attributes: {
            pageName: 'filePreview'
        },
        state : {
            recordIds: this.contentDocumentId,
            selectedRecordId: this.contentDocumentId
        }
      })
    }

    handleEmailBody(event) {
      let pTag = event.target.value;
      let index = pTag.indexOf('</p>');
      let pTagBody = pTag.substring(3, index);
      this.emailBody = pTagBody;
    }

    handleBtnClick() {  
      let toAddress = 'lepeshkoroman42@gmail.com';
      let replyToAddress = 'romalepeshko42@25adcwrcw23mhcv73u73f3ytceai98rgn0rav6it53c9nik7jf.dn-9taimmaw.na224.apex.salesforce.com';
      let subject = this.opportunityInvoiceNum + ' ' + this.emailTemplate.Subject;
      let body = '';
      if (this.emailBody != '') {
        body = this.emailBody;
      } else {
        body = this.emailTemplate.Body;
      }
      
      let invoiceNum = this.opportunityInvoiceNum;
      let contentDocumentId = this.contentDocumentId;

      sendEmail({toAddress, replyToAddress, subject, body, invoiceNum, contentDocumentId})
      .then(result => {
        let event = new ShowToastEvent({
          title: 'Success',
          message: 'Message has been sent to receiver',
          variant: 'success'
        })
        this.dispatchEvent(event)
      })
      .catch(error => {
        console.log(error);
        let event = new ShowToastEvent({
          title: 'Error!',
          message: 'Error has arrisen while sending email',
          variant: 'error'
        })
        this.dispatchEvent(event)
      });
    }

    closeAction() {
      this.dispatchEvent(new CloseActionScreenEvent());
    }
}