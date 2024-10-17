/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-24-2024
 * @last modified by  : Henk Reynders
**/
@RestResource(urlMapping='/InboundDataApi/*')
global class InboundDataApiController {
    @HttpPost
    global static void doPost(){         
        try{
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            String urlParams = req.requestURI.substringAfter('/InboundDataApi/');
            System.debug('--- InboundDataApiController - urlParams: '+urlParams);
            String inboundData = req.requestBody.toString();
            ProcessEvent.publishProcessEvent('Order', 'Import', '', '', inboundData, '');           
            RestContext.response.responseBody = Blob.valueOf('{"status": "SUCCESS"}'); 
            RestContext.response.statusCode = 200; 
        }catch(exception e){
            RestContext.response.statusCode = 404;
            CustomExceptionController.throwCustomException('InboundDataApiController', e.getmessage() , e.getLineNumber() ,'createInstallationData',e.getTypeName (), true);
            RestContext.response.responseBody = Blob.valueOf(e.getmessage()+e.getLinenumber()+'{"status": "FAILED"}');
        }
    }
}