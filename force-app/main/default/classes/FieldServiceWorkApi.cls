/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 07-04-2024
 * @last modified by  : Henk Reynders
**/
@RestResource(urlMapping='/FieldServiceWorkApi/*')
global class FieldServiceWorkApi {
    @HttpPost
    global static void processOrderMessage(){         
        try{
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            ProjectData projectData = ProjectData.parse(req.requestBody.toString());
            //ProjectData.orderMessage orderMessage = ProjectData.parseOrderMessage(req.requestBody.toString());
            System.debug('--- FieldServiceWorkApi - projectData: '+projectData);
            FieldServiceWorkController.prepareProjectData(projectData);
            RestContext.response.responseBody = Blob.valueOf('{"status": "SUCCESS"}'); 
            RestContext.response.statusCode = 200; 
        }catch(exception e){
            RestContext.response.statusCode = 404;
            FieldServiceWorkController.assignCustomException('FieldServiceWorkController', e.getmessage() , e.getLineNumber() ,'createInstallationData',e.getTypeName (), true);
            RestContext.response.responseBody = Blob.valueOf(e.getmessage()+e.getLinenumber()+'{"status": "FAILED"}');
        }
    }
}