public with sharing class PaymentTriggerHandler {
    public PaymentTriggerHandler() {

    }

    public static void paymentTriggerMethod(List<Payment__c> newList) {
        for (Payment__c el : newList) {
            Opportunity oppEl = [
                SELECT Id, Name, StageName, PaymentSum__c, Amount, OwnerId
                FROM Opportunity
                WHERE Name=:el.OpportunityName__c
            ];

            oppEl.PaymentSum__c += el.Amount__c;

            if (oppEl.PaymentSum__c >= oppEl.Amount) {
                oppEl.StageName = 'Fully Paid';
                createTask(oppEl);
            } else if (oppEl.PaymentSum__c != 0) {
                oppEl.StageName = 'Partially Paid';
            } 

            update oppEl;
        }
    }

    public static void createTask(Opportunity oppEl) {
        DateTime nextDay = DateTime.now().addDays(1);

        DateTime rememberDate = DateTime.newInstance(
            nextDay.year(),
            nextDay.month(),
            nextDay.day(),
            10,
            0,
            0
        );

        Task task = new Task();
        task.OwnerId = oppEl.OwnerId;
        task.WhatId = oppEl.Id;
        task.Subject = 'Delivery of goods';
        task.Status = 'Not Started';
        task.Priority = 'High';
        task.ReminderDateTime = rememberDate;
        task.IsReminderSet = true;

        insert task;
    }
}