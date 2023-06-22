import { LightningElement, api } from "lwc"; 

import { CloseActionScreenEvent } from "lightning/actions" 

export default class ScreenAction extends LightningElement { 

  @api recordId; 

  //calling this method in html to close the modal popup 

  closeAction() { 
    this.dispatchEvent(new CloseActionScreenEvent())
  }
}