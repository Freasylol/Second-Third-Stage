import { LightningElement, api } from 'lwc';
import createApexBatchable from '@salesforce/apex/CreateApexBatchScheduler.createApexBatchable';
import createApexSchedulable from '@salesforce/apex/CreateApexBatchScheduler.createApexSchedulable';
import abortApexSchedulable from '@salesforce/apex/CreateApexBatchScheduler.abortApexSchedulable';


export default class ContactBirthday extends LightningElement {
    @api schedulerName = '';
    @api batchName = '';
    @api runOnceBtnVar = 'brand';
    @api scheduleBtnLabel = 'Schedule Batch';
    @api scheduleBtnVar = 'brand';
    @api scheduledJobId = '';
    @api isInputDisabled = false;
    cronString = '0 0 0 * * ?';

    handleInput(event) {
      this.cronString = event.target.value;
    }

    runOnceHandler() {
      createApexBatchable({className: this.batchName});
    }

    scheduleBatchHandler() {      
      if (this.scheduleBtnLabel == 'Schedule Batch') {
        createApexSchedulable({className: this.schedulerName, cronString: this.cronString})
        .then(result => {
          this.scheduledJobId = result;
        })
        this.isInputDisabled = true;
        this.scheduleBtnVar = 'destructive';
        this.scheduleBtnLabel = 'Abort Batch';
        
      } else if (this.scheduleBtnLabel == 'Abort Batch') {
        abortApexSchedulable({jobName: this.scheduledJobId})
        .then(result => {

        })
        .catch(error => {
            console.log(error);
        })
        this.isInputDisabled = false;
        this.scheduleBtnVar = 'brand';
        this.scheduleBtnLabel = 'Schedule Batch';
      }
      
    }
}