global class OpportunityEmailService implements Messaging.InboundEmailHandler {
 
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
                                                        Messaging.InboundEnvelope env){
    
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        String myPlainText= '';
        String myHtmlBody = '';
        String mySubject = '';
        String myInvoiceNum = '';
        String answerStr = '';
        String statusStr = '';
            
        myPlainText = email.plainTextBody;
        myHtmlBody = email.htmlBody;
        mySubject = email.subject;

        System.debug('myPlainText is: ' + myPlainText);
        System.debug('mySubject is: ' + mySubject);
        System.debug('myInvoiceNum is: ' + myInvoiceNum);

        String regexInvoiceNum = 'INV-[0-9]{6}';

        Pattern patternInvoiceNum = Pattern.compile(regexInvoiceNum);

        Matcher matcherInvoiceNum = patternInvoiceNum.matcher(mySubject);

        while (matcherInvoiceNum.find()) {
            myInvoiceNum = matcherInvoiceNum.group();
            System.debug('Match found at position ' + myInvoiceNum);
        }

        String regexApproved = 'approved|rejected';

        Pattern patternApproved = Pattern.compile(regexApproved);

        Matcher matcherApproved = patternApproved.matcher(myPlainText.toLowerCase());

        List<String> matches = new List<String>();

        while (matcherApproved.find()) {
            answerStr = matcherApproved.group();
            matches.add(answerStr);
            System.debug('Approved|Rejected Match found at position ' + answerStr);
        }

        statusStr = matches[0];
        System.debug('StatusStr is ' + statusStr);

        for (String el: matches) {
            System.debug('Match el: ' + el);
        }

        Opportunity opportunityObj = [
            SELECT StageName 
            FROM Opportunity
            WHERE Invoice_Number__c=:myInvoiceNum
            LIMIT 1
        ][0];

        String stageName = opportunityObj.StageName;

        System.debug('StageName is ' + stageName);

        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            List<String> stageNames = new List<String>();
            for (Schema.PicklistEntry s : ple) {
            stageNames.add(s.getLabel());
            System.debug('value: ' + s.getLabel());
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

            System.debug('StageName is ' + stageName);

            opportunityObj.StageName = stageName;
            upsert opportunityObj;
        } else {
            opportunityObj.StageName = stageNames[stageNames.size() - 1];
            upsert opportunityObj;
        }
        
        result.success = true;
        
        return result;
    }
}