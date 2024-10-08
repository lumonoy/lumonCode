/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-05-2024
 * @last modified by  : Henk Reynders
**/
global class CaseHandlingEmailController implements QuickAction.QuickActionDefaultsHandler {
    // Empty constructor
    global CaseHandlingEmailController() {
    }
    
    // The main interface method
    global void onInitDefaults(QuickAction.QuickActionDefaults[] defaults) {

        QuickAction.SendEmailQuickActionDefaults sendEmailDefaults = (QuickAction.SendEmailQuickActionDefaults) defaults.get(0);
        EmailMessage emailMessage = (EmailMessage)sendEmailDefaults.getTargetSObject(); 
        String userEmail = UserInfo.getUserEmail();
        String action = sendEmailDefaults.getActionName(); // Case.Email
        String actionType = sendEmailDefaults.getActionType(); // Email

        if(sendEmailDefaults != null){
            system.debug('--- CaseHandlingEmailController - sendEmailDefaults # ' + sendEmailDefaults  );
            system.debug('--- CaseHandlingEmailController - sendEmailDefaults ID # ' + sendEmailDefaults.getcontextId()); 
        }
        if (sendEmailDefaults.getActionName() == 'Case.SendEmail') {
            System.Debug ('--- CaseHandlingEmailController - Case Email Action');
            if (sendEmailDefaults.getActionType() == 'SendEmail') {
                System.Debug ('--- CaseHandlingEmailController - Email Message before '+emailMessage);
                System.Debug ('--- CaseHandlingEmailController - Email Action Type');
                System.Debug ('--- CaseHandlingEmailController - User Email Address '+ userEmail);
                List<String> fromAddresses = sendEmailDefaults.getFromAddressList();
                System.Debug ('--- CaseHandlingEmailController - Available From Addresses '+fromAddresses);
                //emailMessage.BccAddress = getBccAddress(c.Reason);

                Case c = [SELECT CaseNumber, Priority, RecordType.DeveloperName FROM Case WHERE Id=:sendEmailDefaults.getContextId()];
                System.Debug ('--- CaseHandlingEmailController - Case Record Type '+c.RecordType.DeveloperName);
                switch on c.RecordType.DeveloperName {
                    when 'CS_Case' {
                        emailMessage.FromAddress = 'cs@lumon.com';
                        emailMessage.FromName = 'cs@lumon.com';
                        emailMessage.ValidatedFromAddress = '';
                    }
                    when else {
                        emailMessage.FromAddress = userEmail;
                    }
                }
                    System.Debug ('--- CaseHandlingEmailController - Email Message after '+emailMessage);
            }
        }
    }
}