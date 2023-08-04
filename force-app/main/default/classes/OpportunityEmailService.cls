global class OpportunityEmailService implements Messaging.InboundEmailHandler {
 
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
                                                        Messaging.InboundEnvelope env){
    
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        String myPlainText= '';
        String mySubject = '';
        String myInvoiceNum = '';
        String answerStr = '';
        String statusStr = '';
            
        myPlainText = email.plainTextBody;
        mySubject = email.subject;

        String regexInvoiceNum = 'INV-[0-9]{6}';

        Pattern patternInvoiceNum = Pattern.compile(regexInvoiceNum);

        Matcher matcherInvoiceNum = patternInvoiceNum.matcher(mySubject);

        while (matcherInvoiceNum.find()) {
            myInvoiceNum = matcherInvoiceNum.group();
        }

        String regexApproved = 'approved|rejected';

        Pattern patternApproved = Pattern.compile(regexApproved);

        Matcher matcherApproved = patternApproved.matcher(myPlainText.toLowerCase());

        List<String> matches = new List<String>();

        while (matcherApproved.find()) {
            answerStr = matcherApproved.group();
            matches.add(answerStr);
        }

        statusStr = matches[0];

        Opportunity opportunityObj = [
            SELECT StageName 
            FROM Opportunity
            WHERE Invoice_Number__c=:myInvoiceNum
            LIMIT 1
        ][0];

        String stageName = opportunityObj.StageName;

        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            List<String> stageNames = new List<String>();
            for (Schema.PicklistEntry s : ple) {
            stageNames.add(s.getLabel());
            }

        if (statusStr == 'approved') {
            for (Integer i = 0; i < stageNames.size(); i++) {
            if (stageNames[i] == stageName && 
                stageNames[i] != 'Closed Won' && 
                stageNames[i] != 'Closed Lost') {
                stageName = stageNames[i + 1];
                break;
            }
            }

            opportunityObj.StageName = stageName;
            upsert opportunityObj;
        } else {
            opportunityObj.StageName = 'Closed Lost';
            upsert opportunityObj;
        }
        
        result.success = true;
        
        return result;
    }
}