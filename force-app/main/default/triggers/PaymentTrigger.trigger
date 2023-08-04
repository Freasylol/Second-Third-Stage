trigger PaymentTrigger on Payment__c (before insert) {
    PaymentTriggerHandler.paymentTriggerMethod(Trigger.new);
}