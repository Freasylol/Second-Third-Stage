@isTest
public class EmailTemplateControllerTest {
    public EmailTemplateControllerTest() {

    }

    @isTest static void testEmailTemplate() {
      List<EmailTemplate> testEmailTemplates = EmailTemplateController.getEmailTemplates();
      System.assertEquals('SendInvoiceTemplate', testEmailTemplates[0].Name);
    }
}