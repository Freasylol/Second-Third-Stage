import { wire, track, api, LightningElement } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
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

    @wire (getOpportunityInvoiceNum, {recordId: '$recordId'})
    opportunityInvoiceNum;
  
    @wire (getContentDocumentId, {test: '$opportunityInvoiceNum.data'})
    contentDocumentId;

    @wire(MessageContext)
    messageContext;

    @wire(getEmailTemplates) 
    emailTemplate;

    @wire(getEmailInfo, {recordId: '$recordId'})
    orderNum;

    @wire(getReceiverName, {recordId: '$recordId'})
    receiverName;

    @wire (getReceiverEmail, {recordId: '$recordId'})
    receiverEmail;

    emailBody = '';

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

    handleEmailBody(event) {
      let pTag = event.target.value;
      let index = pTag.indexOf('</p>');
      let pTagBody = pTag.substring(3, index);
      console.log(pTagBody);
      this.emailBody = pTagBody;
    }

    handleBtnClick() {  
      let toAddress = 'lepeshkoroman42@gmail.com';
      let replyToAddress = 'romalepeshko42@25adcwrcw23mhcv73u73f3ytceai98rgn0rav6it53c9nik7jf.dn-9taimmaw.na224.apex.salesforce.com';
      let subject = this.opportunityInvoiceNum.data + ' ' + this.emailTemplate.data[0].Subject;
      let body = '';
      if (this.emailBody != '') {
        body = this.emailBody;
        console.log('body is' + body);
      } else {
        body = this.emailTemplate.data[0].Body;
      }
      
      let invoiceNum = this.opportunityInvoiceNum.data;
      let contentDocumentId = this.contentDocumentId.data;

      sendEmail({toAddress, replyToAddress, subject, body, invoiceNum, contentDocumentId})
      .then(result => {
        console.log(result);
        let event = new ShowToastEvent({
          title: 'Success',
          message: 'Message has been sent to receiver',
          variant: 'success'
        })
        this.dispatchEvent(event)
      })
      .catch(error => {
        console.log(error);
        console.log(result);
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