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

    handleBtnClick() {  
      // let toAddress = this.receiverEmail.data;
      let toAddress = 'lepeshkoroman42@gmail.com';
      // let ccAddress = 'obereg2005.2002@gmail.com';
      let replyToAddress = 'romalepeshko42@25adcwrcw23mhcv73u73f3ytceai98rgn0rav6it53c9nik7jf.dn-9taimmaw.na224.apex.salesforce.com';
      let subject = this.opportunityInvoiceNum.data + ' ' + this.emailTemplate.data[0].Subject;
      let body = this.emailTemplate.data[0].Body;
      let invoiceNum = this.opportunityInvoiceNum.data;
      let contentDocumentId = this.contentDocumentId.data;

      sendEmail({toAddress, replyToAddress, subject, body, invoiceNum, contentDocumentId})
      .then(result => {
        console.log(result);
      })
      .catch(error => {
        console.log(error);
      });
    }

    closeAction() {
      this.dispatchEvent(new CloseActionScreenEvent());
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