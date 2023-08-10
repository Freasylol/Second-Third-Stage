global class ContactBirthdayScheduler implements Schedulable {
    public ContactBirthdayScheduler() {

    }

    global void execute(SchedulableContext sc) {
        ContactBirthdayBatch batch = new ContactBirthdayBatch();
        
        Database.executeBatch(batch);      
    }
}