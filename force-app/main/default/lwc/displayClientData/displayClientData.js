import { LightningElement, wire, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAccounts from '@salesforce/apex/DisplayClientData.getAccounts';
import getClosedOpportunitiesByAccountId from '@salesforce/apex/DisplayClientData.getClosedOpportunitiesByAccountId';
import getOpportunitiesProductByOpportunityId from '@salesforce/apex/DisplayClientData.getOpportunitiesProductByOpportunityId';
import searchAccountsByName from '@salesforce/apex/DisplayClientData.searchAccountsByName';
import DisplayClientDataModal from 'c/displayClientDataModal';
import getClosedOpportunities from '@salesforce/apex/DisplayClientData.getClosedOpportunities';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const PAGE_SIZE = 10;

export default class LightningExampleAccordionBasic extends NavigationMixin(LightningElement)  {
  @api recordId;
  isDetail = false;

  labelArr = [];
  valueArr = [];
  test;
  accounts;
  accountInfo;
  searchMap = [];
  nameSearchStr = '';
  numSearchStr = '0';

  currentPage = 1;
  pageSize = PAGE_SIZE;
  pageData = [];
  sectionMap = [];

  closedOpportunities;

  @wire (getClosedOpportunities)
  wiredClosedOpportunities({error, data}) {
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
      this.closedOpportunities = data;
    }
  }

  handleSearch() {
    this.numSearchStr = '';
    this.nameSearchStr = '';
    if (/\d+/.test(event.target.value)) {
      this.numSearchStr = event.target.value;
    } else {
      this.nameSearchStr = event.target.value;
    }
    this.generateSearchPageData();
  }

  generateSearchPageData() {
    let searchArr = searchAccountsByName({searchInput: this.nameSearchStr})
    .then((value) => {
      this.sectionMap = [];
      this.currentPage = 1;
      let searchAccounts = [];
      if (Number(this.numSearchStr) !== 0) {
        value.forEach((valueEl, valueElIndex) => { 
          let oppSum = 0;
          this.closedOpportunities.forEach((closedOppEl) => {
            if (valueEl.Id === closedOppEl.AccountId) {
              oppSum += closedOppEl.Amount;
            }
          })
          if (oppSum >= Number(this.numSearchStr)) {
            searchAccounts.push(valueEl);
          }
          if (valueElIndex + 1 === value.length) {
            this.genOpportunity(searchAccounts);
            this.showPage();
          } 
        })
      } else {
        searchAccounts = value;
        this.genOpportunity(searchAccounts);
        this.showPage();
      }
      })
      .catch((error) => {
          console.log(error);
      })
  }

  showPage() {
    let startPos= ((this.currentPage - 1) * 10) - 1;
    let endPos = (this.currentPage) * 10 - 1;
    if (startPos < 0) {
      startPos = 0; 
    } 
    let test = this.sectionMap;
    this.pageData = test.slice(startPos, endPos);
  }

  previousPage() {
    if (this.currentPage !== 1) {
      this.currentPage -= 1;
    }
    this.showPage();
  }

  nextPage() {
    if (this.sectionMap.length >= this.currentPage * this.pageSize) {
      this.currentPage += 1;
    }
    this.showPage();
  }

  columns = [
    { label: 'OpportunityName', fieldName: 'oppUrl', type: 'url',
      typeAttributes: {
        label: {fieldName: 'oppName'},
        target: '_blank'
      } },
    { label: 'CreatedDate', fieldName: 'createdDate', type: 'date' },
    { label: 'CloseDate', fieldName: 'closeDate', type: 'date' },
    { label: 'Amount', fieldName: 'amount' },
    {
      type: 'button',
      label: 'ShowOpportunityProducts',
      initialSize: 75,
      typeAttributes: {
        label: 'ShowOpportunityProducts',
        name: 'showOpportunityProducts',
        variant: 'brand '
      }
    }
  ]

  async handleModal(oppId, options) {
    const result = await DisplayClientDataModal.open({
      options: options,
      size: 'large',
      description: 'Accessible description of modal\'s purpose',
      content: `Passed into content api ${oppId}`,
    })   
}

  async onRowAction(event) {
    let actionName = event.detail.action.name;
    let row = event.detail.row;


    if (actionName === 'showOpportunityProducts') {
      let opportunityProductsPromise = await getOpportunitiesProductByOpportunityId({opportunityId: row.id})
      .then(async (value) => {
          this.handleModal(row.id, value);
      })
      .catch((error) => {
          console.log(error);
      })

    }
  }

  sectionMap = [];
  genMap = [];
  
  genOpportunity(data) {      
    this.genMap = [];
    this.labelArr = [];
    this.valueArr = [];
    if (this.recordId) {
      this.isDetail = true;
      let accountDetail;
      data.forEach((dataEl) => {
        if (dataEl.Id === this.recordId) {
          accountDetail = dataEl;
          return;
        }
      })
      getClosedOpportunitiesByAccountId({accountId: this.recordId})
      .then((value) => {
        this.labelArr.push(`${accountDetail.Name} - ${String(value.length)}`);
          if (value.length != 0) {
            let newValueArr = [];
            value.forEach((valueEl) => {
              newValueArr.push({
                id: `${valueEl.Id}`,
                createdDate: `${valueEl.CreatedDate}`,
                closeDate: `${valueEl.CloseDate}`,
                amount: `${valueEl.Amount}`,
                oppUrl: `/${valueEl.Id}`,
                oppName: `${valueEl.Name}`,
              })
            })
            this.valueArr.push(newValueArr);
          } else {
            this.valueArr.push(undefined);
          }          

          this.labelArr.forEach((labelEl, labelIndex) => {
            let newMap = {key: labelEl, value: this.valueArr[labelIndex]};
            this.genMap.push(newMap);
            if (labelIndex + 1 === this.labelArr.length) {
              this.sectionMap = this.genMap;
              this.pageData = this.sectionMap.slice(0,1);
              return;
            }
          })
          
      })
      .catch((error) => {
        console.log(error);
      })
    } else {
      this.genMap = [];
      this.labelArr = [];
      this.valueArr = [];
      data.forEach((dataEl, index) => {
        let oppSum = 0;
        let newValueArr = [];
        this.closedOpportunities.forEach((closedOppEl) => {
          if (dataEl.Id === closedOppEl.AccountId) {
            oppSum += closedOppEl.Amount;
            newValueArr.push({
              id: `${closedOppEl.Id}`,
              createdDate: `${closedOppEl.CreatedDate}`,
              closeDate: `${closedOppEl.CloseDate}`,
              amount: `${closedOppEl.Amount}`,
              oppUrl: `/${closedOppEl.Id}`,
              oppName: `${closedOppEl.Name}`,
            })  
          }
        })
        this.labelArr.push(`${dataEl.Name} - ${oppSum}`);
        newValueArr.oppSum = oppSum;
        if (newValueArr.length === 0) {
          this.valueArr.push(undefined);
        } else {
          this.valueArr.push(newValueArr);
        }
        
        if (index + 1 === data.length) {
          this.labelArr.forEach((labelEl, labelIndex) => {
            let newMap = {key: labelEl, value: this.valueArr[labelIndex]};
            this.genMap.push(newMap);
            if (labelIndex + 1 === this.labelArr.length) {
              this.sectionMap = this.genMap;
              this.pageData = this.sectionMap.slice(0, 9);
              return;
            }
          })
        } 
      })
      }
  }

  @wire (getAccounts)
  getAccounts({error, data}) {
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
      this.genOpportunity(data);
      this.accounts = data;
    }
  }

  handleSectionToggle() {

  }
}