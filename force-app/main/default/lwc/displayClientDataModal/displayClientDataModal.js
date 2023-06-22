import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class DisplayClientDataModal extends LightningModal  {
  @api content;
  @api options;

  columns = [
    { label: 'Opportunity Product Name', fieldName: 'Name' },
    { label: 'Quantity', fieldName: 'Quantity' },
    { label: 'UnitPrice', fieldName: 'UnitPrice', type: 'currency' },
    { label: 'TotalPrice', fieldName: 'TotalPrice', type: 'currency' },
  ]

  @api
  open(args) {
    console.log(args.options);
    console.log('hi');

    this.options = args.options;
  }

  handleOkay() {
      this.close('okay');
      console.log('Record id is ' + this.recordId);
  }
}