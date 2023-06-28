import { LightningElement, wire, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAccounts from '@salesforce/apex/DisplayClientData.getAccounts';
import getClosedOpportunitiesByAccountId from '@salesforce/apex/DisplayClientData.getClosedOpportunitiesByAccountId';
import getOpportunitiesProductByOpportunityId from '@salesforce/apex/DisplayClientData.getOpportunitiesProductByOpportunityId';
import searchAccountsByName from '@salesforce/apex/DisplayClientData.searchAccountsByName';
import DisplayClientDataModal from 'c/displayClientDataModal';
import getClosedOpportunities from '@salesforce/apex/DisplayClientData.getClosedOpportunities';

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

  @wire (getClosedOpportunities)
  closedOpportunities;

  handleSearch() {
    this.numSearchStr = '';
    this.nameSearchStr = '';
    if (/\d+/.test(event.target.value)) {
      this.numSearchStr = event.target.value;
    } else {
      this.nameSearchStr = event.target.value;
    }
    // this.nameSearchStr = event.target.value;
    // console.log();
    this.generateSearchPageData();
  }

  handleNumSearch() {
    this.numSearchStr = event.target.value;
    // console.log(this.numSearchStr);
    this.generateSearchPageData();
  }

  generateSearchPageData() {
    let searchArr = searchAccountsByName({searchInput: this.nameSearchStr})
    .then((value) => {
      this.sectionMap = [];
      this.currentPage = 1;
      let searchAccounts = [];
      if (Number(this.numSearchStr) !== 0) {
        // let searchAccounts = value;
        value.forEach((valueEl, valueElIndex) => { 
          let oppSum = 0;
          this.closedOpportunities.data.forEach((closedOppEl) => {
            // console.log('hi there');
            // console.log(valueEl.Id);
            // console.log(closedOppEl.AccountId);
            if (valueEl.Id === closedOppEl.AccountId) {
              console.log('hi');
              oppSum += closedOppEl.Amount;
            }
          })
          console.log(oppSum);
          if (oppSum >= Number(this.numSearchStr)) {
            console.log('hi compare');
            console.log(valueEl);
            searchAccounts.push(valueEl);
            // console.log(searchAccounts);
          }
          if (valueElIndex + 1 === value.length) {
            console.log(searchAccounts);
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
    // console.log('SectionMap is ' + this.sectionMap);
    let startPos= ((this.currentPage - 1) * 10) - 1;
    let endPos = (this.currentPage) * 10 - 1;
    if (startPos < 0) {
      startPos = 0; 
    } 
    let test = this.sectionMap;
    this.pageData = test.slice(startPos, endPos);
    // console.log('PageData is ' + this.pageData);
    console.log(this.currentPage);
  }

  previousPage() {
    if (this.currentPage !== 1) {
      this.currentPage -= 1;
    }
    // console.log('SectionMap is ' + this.sectionMap);
    // this.pageData = this.sectionMap.slice((currentPage - 1) * 10, currentPage * 10);
    // console.log('PageData is ' + this.pageData);
    console.log(this.currentPage);
    this.showPage();
  }

  nextPage() {
    if (this.sectionMap.length >= this.currentPage * this.pageSize) {
      console.log('Current mul is ' + this.currentPage * this.pageSize);
      this.currentPage += 1;
    }
    this.showPage();
    // console.log(this.currentPage);   
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
    console.log(result);
}

  async onRowAction(event) {
    let actionName = event.detail.action.name;
    let row = event.detail.row;


    if (actionName === 'showOpportunityProducts') {
      console.log('Row id is ' + row.id);
      let opportunityProductsPromise = await getOpportunitiesProductByOpportunityId({opportunityId: row.id})
      .then(async (value) => {
          console.log(value)
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
    console.log(data);
    this.genMap = [];
    this.labelArr = [];
    this.valueArr = [];
    if (this.recordId) {
      this.isDetail = true;
      console.log('--------');
      console.log(data);
      console.log(data[0]);
      let accountDetail;
      data.forEach((dataEl) => {
        if (dataEl.Id === this.recordId) {
          accountDetail = dataEl;
          return;
        }
      })
      // getAccountById({accountId: this.recordId})
      getClosedOpportunitiesByAccountId({accountId: this.recordId})
      .then((value) => {
        console.log(accountDetail.Name);
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
            console.log(this.genMap.length);
            if (labelIndex + 1 === this.labelArr.length) {
              this.sectionMap = this.genMap;
              console.log('Im here');
              this.pageData = this.sectionMap.slice(0,1);
              return;
            }
          })
          
      })
      .catch((error) => {
        console.log(error);
      })
    } else {
      console.log(this.recordId);
      console.log(data);
      console.log(this.closedOpportunities.data);
      this.genMap = [];
      this.labelArr = [];
      this.valueArr = [];
      data.forEach((dataEl, index) => {
        let oppSum = 0;
        let newValueArr = [];
        this.closedOpportunities.data.forEach((closedOppEl) => {
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
        console.log(newValueArr.length);
        this.labelArr.push(`${dataEl.Name} - ${oppSum}`);
        newValueArr.oppSum = oppSum;
        console.log(newValueArr.oppSum);
        if (newValueArr.length === 0) {
          this.valueArr.push(undefined);
        } else {
          console.log('hi');
          this.valueArr.push(newValueArr);
          console.log(this.valueArr[this.valueArr.length - 1]);
        }
        
        if (index + 1 === data.length) {
          // console.log('Label arr is ' + this.labelArr);
          this.labelArr.forEach((labelEl, labelIndex) => {
            // console.log(this.valueArr[labelIndex]);
            console.log(this.valueArr[labelIndex]);
            let newMap = {key: labelEl, value: this.valueArr[labelIndex]};
            this.genMap.push(newMap);
            // console.log(this.genMap.length);
            if (labelIndex + 1 === this.labelArr.length) {
              this.sectionMap = this.genMap;
              // console.log(this.sectionMap);
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
    if (data) {
      console.log(data)
      this.genOpportunity(data);
      this.accounts = data;
    }
  }

  handleSectionToggle() {

  }
}