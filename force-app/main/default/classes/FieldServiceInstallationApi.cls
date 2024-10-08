/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-12-2024
 * @last modified by  : Henk Reynders
**/
@RestResource(urlMapping='/FieldServiceInstallationApi/*')
global class FieldServiceInstallationApi {
    @HttpPost
    global static void createInstallationData(){         
        try{
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            System.Debug('--- FieldServiceInstallationHelper - Parse OrderMessage: '+req.requestBody.toString());
            String inboundOrderJSON = req.requestBody.toString();
            
            if(String.isNotBlank(inboundOrderJSON)){
                    // Publish a new Configuration Event by calling the VisualConfigurationEvent (Controller)
                    System.debug('---  publish Configuration Change Event --- ');
                    String cfgType = 'Plantori';
                    String cfgAction = 'Process';
                    String cfgRecordId; 
                    String cfgObjectType; 
                    String cfgPlanId;
                    String cfgVisualId;
                    String cfgDocLinkId; // DO NOT USE cdL.Id
                    String cfgJSON = inboundOrderJSON;
                    ConfigurationEvent.publishConfigurationEvent(cfgType,cfgAction,cfgPlanId,//Visual, Price
                                                                    cfgRecordId,cfgObjectType,
                                                                    cfgVisualId,cfgDocLinkId,cfgJSON);
            }
            //InboundOrderData  orderData =  InboundOrderData.parse(req.requestBody.toString());
            //System.Debug('--- FieldServiceInstallationHelper - Process OrderData: '+orderData );
            //FieldServiceInstallationHelper.createData(orderData.Order);
            RestContext.response.responseBody = Blob.valueOf('{"status": "SUCCESS"}'); 
            RestContext.response.statusCode = 200; 
        } catch(exception e){
            RestContext.response.statusCode = 404;
            FieldServiceInstallationHelper.assignCustomException('FieldServiceInstallationHelper', e.getmessage() , e.getLineNumber() ,'createInstallationData',e.getTypeName (), true);
            RestContext.response.responseBody = Blob.valueOf(e.getmessage()+e.getLinenumber()+'{"status": "FAILED"}');
        }
    }
}