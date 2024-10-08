/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 03-14-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class CustomNotificationController {
    @AuraEnabled
    public static void notifyUsers(CustomNotificationData notificationEntry) {
        // Create a new custom notification
        Messaging.CustomNotification notification = new Messaging.CustomNotification();

        // Set the contents for the notification
        notification.setTitle(notificationEntry.title);
        notification.setBody(notificationEntry.body);

        // Set the notification type and target
        notification.setNotificationTypeId(notificationEntry.customNotificationType);
        notification.setTargetId(notificationEntry.targetId);
        
        // Actually send the notification
        try {
            System.debug('--- customNotificationController - Notification: ' + notification);
            notification.send(getUserIds());
        }
        catch (Exception e) {
            System.debug('--- customNotificationController - Problem sending notification: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static List<CustomNotificationType> getNotificationList() {
        List<CustomNotificationType> notificationTypeList = new  List<CustomNotificationType>();
        notificationTypeList = [SELECT Id, CustomNotifTypeName, DeveloperName FROM CustomNotificationType ];
        return notificationTypeList;
    }
    @AuraEnabled
    public static List<CustomNotificationType> getRecords() {
        List<CustomNotificationType> notificationTypeList = new  List<CustomNotificationType>();
        notificationTypeList = [SELECT Id, CustomNotifTypeName, DeveloperName FROM CustomNotificationType ];
        return notificationTypeList;
    }

    @AuraEnabled
    public static decimal getLatestAPIVerion() {
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        String domainUrl=URL.getOrgDomainUrl().toExternalForm();
        system.debug('--- domainUrl:'+domainUrl);
        req.setEndpoint(domainUrl+'/services/data');
        req.setMethod('GET');

        Http h = new Http();
        HttpResponse res = h.send(req);
        String response = res.getBody();
        system.debug('--- Response Body:'+response); 
        List<decimal> apiVersions = new List<decimal>();
        JSONParser  parser = JSON.createParser(response);
        system.debug('--- JSON Parser:'+parser); 
        while (parser.nextToken() != null) {
         if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
          String fieldName = parser.getText();
             if(fieldName == 'version'){
                parser.nextToken(); 
                apiVersions.add(decimal.valueof(parser.getText()));
             }
          }
        }
        apiVersions.sort();
        system.debug('--- API Versions: '+apiVersions);
        Decimal apiVersion = apiVersions[apiVersions.size()-1];
        system.debug('--- Latest API version:'+apiVersion);
        return apiVersion;
    }
    @AuraEnabled
    public static List<String> getFlexiPages() {
        //     String query = 'SELECT ApexClassOrTrigger.Name, NumLinesCovered, NumLinesUncovered FROM ApexCodeCoverageAggregate ORDER BY ApexClassOrTrigger.Name ASC';
        List<String> flexipages = new List<String>();
        HttpRequest req = new HttpRequest();
        String query = 'SELECT Id,EntityDefinitionId,EntityDefinition.DeveloperName, DeveloperName FROM FlexiPage';
        req.setEndpoint(
            Url.getOrgDomainUrl() .toExternalForm()+
            '/services/data/v'+getLatestAPIVerion()+'/tooling/query?q='+
            EncodingUtil.urlEncode(query, 'UTF-8')
        );
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
        Http http = new Http();
        HttpResponse res = http.send(req);
        String response = res.getBody();
        system.debug('--- Response Body:'+JSON.serializePretty(response)); 
        JSONParser  parser = JSON.createParser(response);
        system.debug('--- JSON Parser:'+parser); 


        while (parser.nextToken() != null) {
            // Start at the array of invoices.
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    // Advance to the start object marker to
                    //  find next invoice statement object.
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        // Read entire invoice object, including its array of line items.
                        // For debugging purposes, serialize again to verify what was parsed.
                        //String s = JSON.serialize(inv);
    
                        // Skip the child start array and start object markers.
                        parser.skipChildren();
                    }
                }
            }
        }
        return flexipages;
    }




    public static set<String> getUserIds() {
        set<String> userids = new set<String>();
        for(User usr : [select id from User Where Profile.UserLicense.Name = 'Salesforce' and IsActive = true]){
            userids.add(usr.id);
        }
        return userids;
    }
    public class CustomNotificationData {
        @AuraEnabled public string title{ get; set; }
        @AuraEnabled public string body{ get; set; }
        @AuraEnabled public string customNotificationType{ get; set; }
        @AuraEnabled public string targetId{ get; set; }
    }
}