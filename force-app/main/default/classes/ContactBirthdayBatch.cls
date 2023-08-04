public class ContactBirthdayBatch implements Database.Batchable<sObject> {
    public ContactBirthdayBatch() {

    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        String query = 'SELECT Id, BirthDate, Name FROM Contact';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<Contact> scope) {
        Date todayDate = System.today();
        for (Contact c : scope) {
            if (c.BirthDate != null && c.Name != null) {
                if (c.BirthDate.day() == todayDate.day()) {
                if (c.BirthDate.month() == todayDate.month()) {
                    String toAddress = 'lepeshkoroman42@gmail.com';
                    String replyToAddress = 'romalepeshko42@25adcwrcw23mhcv73u73f3ytceai98rgn0rav6it53c9nik7jf.dn-9taimmaw.na224.apex.salesforce.com';
                    EmailTemplate emailTemplate = [
                        SELECT Name, Body, Subject
                        FROM EmailTemplate
                        WHERE Name='ContactBirthdayTemplate'
                        LIMIT 1
                    ][0];
                    Integer age = todayDate.year() - c.BirthDate.year();
                    String subject = emailTemplate.Subject;
                    String body = emailTemplate.Body + ' ' +  c.Name + ' you are ' + age + ' years old today';
                    EmailSender.sendEmail(toAddress, replyToAddress, subject, body);
                }
            }
            }
            
        }
    }
    
    public void finish(Database.BatchableContext context) {
    }
}