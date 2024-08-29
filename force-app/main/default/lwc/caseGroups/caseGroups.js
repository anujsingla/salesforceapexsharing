import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/CaseGroupController.getAccounts';
import getCaseGroupsByAccount from '@salesforce/apex/CaseGroupController.getCaseGroupsByAccount';

export default class CaseGroups extends LightningElement {
    @track selectedAccount;
    @track accountOptions = [];
    @track caseGroupOptions = [];
    @track selectedCaseGroups = [];
    @track showCaseGroups = false;

    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accountOptions = data.map(account => {
                return { label: account.Name, value: account.Id };
            });
        } else if (error) {
            console.error(error);
        }
    }

    handleAccountChange(event) {
        this.selectedAccount = event.detail.value;
        this.loadCaseGroups(this.selectedAccount);
    }

    loadCaseGroups(accountId) {
        getCaseGroupsByAccount({ accountId: accountId })
            .then(result => {
                this.caseGroupOptions = result.map(group => {
                    return { label: group.Name, value: group.Id };
                });
                this.showCaseGroups = true;
            })
            .catch(error => {
                console.error(error);
            });
    }

    handleCaseGroupChange(event) {
        this.selectedCaseGroups = event.detail.value;
        // Add your logic to handle selected case groups
    }
}