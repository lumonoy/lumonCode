/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 04-26-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class EmailAlertController {
    @InvocableMethod(label='Send Localized Email Alert' description='Create an Email Alert with a specific Language')
    public static void sendAlert(List<EmailAlertTemplate> emailAlerts) {
        for (EmailAlertTemplate emailAlert : emailAlerts) {
            system.debug('--- EmailAlertController - emailAlert: '+emailAlert);
            
        }
        sendEmailNotification(emailAlerts);
    }
    public static Map<String,EmailTemplate> getEmailTemplateMap(){
        Map<String,EmailTemplate> emailTemplateMap = new Map<String,EmailTemplate>();
        List<EmailTemplate> emailTemplates = [SELECT    Id,
                                                        Name, 
                                                        Subject,
                                                        Description,
                                                        DeveloperName,
                                                        FolderId, 
                                                        FolderName, 
                                                        BrandTemplateId, 
                                                        EnhancedLetterheadId, 
                                                        TemplateStyle,
                                                        TemplateType,
                                                        IsActive, 
                                                        Encoding,
                                                        HtmlValue, 
                                                        Body
                                            FROM EmailTemplate 
                                            WHERE IsActive = true];
        if (emailTemplates?.size()>0){
            for (EmailTemplate emailTemplate : emailTemplates) {
                system.debug('--- EmailAlertController - emailTemplate: '+emailTemplate.DeveloperName);
                emailTemplateMap.put(emailTemplate.DeveloperName,emailTemplate);
            }
        }
        return emailTemplateMap;
    }

    public static void sendEmailNotification(List<EmailAlertTemplate> emailAlerts){
        //Get email template using SOQL 
        Map<String,EmailTemplate> emailTemplateMap = getEmailTemplateMap();
        if( emailAlerts?.size()>0) {
            List<Messaging.SingleEmailMessage> emailAlertMessages = new List<Messaging.SingleEmailMessage>();  
            for (EmailAlertTemplate emailAlert : emailAlerts) {
                Id recordId = emailAlert?.recordId; 
                String objectApiName = String.valueOf(recordId?.getsobjecttype());
                String templateName = String.IsNotBlank(emailAlert?.templateName) ? emailAlert.templateName: '';
                String templateLanguage = String.IsNotBlank(emailAlert?.language) ? '_'+emailAlert.language: '';
                
                String templateIdentifier = templateName + templateLanguage;
                String toEmailAddress = emailAlert?.emailAddress;
                Id templateId; 
                if (emailTemplateMap.containsKey(templateIdentifier)) {
                    templateId = emailTemplateMap.get(templateIdentifier)?.Id;
                } else if (emailTemplateMap.containsKey(templateName)) {
                    templateId = emailTemplateMap.get(templateName)?.Id;
                } else {
                    system.debug('--- EmailAlertController - no matching Template found for '+templateIdentifier+' or '+templateName);
                    return;
                }                      
                Messaging.SingleEmailMessage emailAlertMessage = new Messaging.SingleEmailMessage();
                emailAlertMessage.setTemplateId(templateId); //pass email template id here
                emailAlertMessage.setTargetObjectId(recordId); //pass record id here     
                emailAlertMessage.setToAddresses(new List<String> {toEmailAddress});
                //emailAlertMessage.setCcAddresses(ccEmailAddress);
                //emailAlertMessage.setBccAddresses(bccEmailAddress);
                emailAlertMessage.setSaveAsActivity(false);
                emailAlertMessage.setUseSignature(false);
                emailAlertMessages.add(emailAlertMessage);
            }
        // Send the Alert
        Messaging.sendEmail(emailAlertMessages);  
        }    
    }
    public class EmailAlertTemplate {
        @invocableVariable(label='RecordId' required=true) @AuraEnabled public Id recordId;
        @invocableVariable(label='EmailAddress' required=true) @AuraEnabled public String emailAddress;
        @invocableVariable(label='Language' required=true) @AuraEnabled public String language;
        @invocableVariable(label='Template Name' required=true)@AuraEnabled public String templateName;
    }
}