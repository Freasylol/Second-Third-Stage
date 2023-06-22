import { LightningElement, wire } from 'lwc';

import SUBJECT_FIELD from '@salesforce/schema/EmailTemplate.Subject';
import BODY_FIELD from '@salesforce/schema/EmailTemplate.Body';
import getEmailTemplates from '@salesforce/apex/EmailTemplateController.getEmailTemplates';

export default class HelloWorld extends LightningElement {
  greeting = 'World';

  @wire(getEmailTemplates) emailTemplates;
  changeHandler(event) {
    this.greeting = event.target.value;
  }
}