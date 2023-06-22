global class TestEmailService implements Messaging.InboundEmailHandler {
 
  global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
                                                       Messaging.InboundEnvelope env){
 
  // Create an InboundEmailResult object for returning the result of the 
  // Apex Email Service
  Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
  
  String myPlainText= '';
  String myHtmlBody = '';
  String mySubject = '';
  String myInvoiceNum = '';
  String answerStr = '';
  String statusStr = '';
    
  // Add the email plain text into the local variable 
  myPlainText = email.plainTextBody;
  myHtmlBody = email.htmlBody;
  mySubject = email.subject;

  System.debug('myPlainText is: ' + myPlainText);
  // System.debug('myHtmlBody is: ' + myHtmlBody);
  System.debug('mySubject is: ' + mySubject);
  System.debug('myInvoiceNum is: ' + myInvoiceNum);

  // myInvoiceNum = mySubject;
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

  if (statusStr == 'approved') {
    List<String> stageNames = new List<String>();

    stageNames.add('Prospecting');
    stageNames.add('Qualification');
    stageNames.add('Needs analysis');
    stageNames.add('Value Proposition');
    stageNames.add('Id. Decision Makers');
    stageNames.add('Perception Analysis');
    stageNames.add('Proposal/Price Quote');
    stageNames.add('Negotiation/Review');
    stageNames.add('Closed Won');
    
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
    opportunityObj.StageName = 'Closed Lost';
    upsert opportunityObj;
  }





  
   // Set the result to true. No need to send an email back to the user 
   // with an error message
  result.success = true;
   
   // Return the result for the Apex Email Service
  return result;
  }
}