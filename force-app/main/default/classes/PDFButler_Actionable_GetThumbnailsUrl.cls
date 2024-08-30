global class PDFButler_Actionable_GetThumbnailsUrl implements cadmus_core.AbstractBeforeWithDataSourcesActionable{

    public List<Map<String,Object>> wrapper2List(Object wrapper){
        if(wrapper==null) return null;

        List<Map<String,Object>> richFieldsRows=new List<Map<String, Object>>();

        if(wrapper instanceof cadmus_core.SingleWrapper){
            cadmus_core.SingleWrapper richFieldsRowsDsSingle =(cadmus_core.SingleWrapper)wrapper;
            richFieldsRows.add(richFieldsRowsDsSingle.data);
        }
        else if (wrapper instanceof cadmus_core.ListWrapper){
            cadmus_core.ListWrapper richFieldsRowsDsList =(cadmus_core.ListWrapper)wrapper;
            richFieldsRows.addAll(richFieldsRowsDsList.data);
        }else{
            richFieldsRows = null;
        }
        return richFieldsRows;
    }

    global void execute(cadmus_core__Actionable__c actionable, Id docConfig, Id objectId, Map<String, Object> inputMap, Map<String, Object> dsMap, cadmus_core.ConvertController.ConvertDataModel cdm) {

        String myFilesGuid = actionable.Get_Thumbnail_Pictures_DataSource_Guid__c;
        String fieldName = actionable.Get_Url_Field_API_Name__c;
        String thumbnailSize = actionable.Get_Thumbnail_Size__c;
        
        Object myFiles =  dsMap.get(myFilesGuid); //DS: Task Detail Files Ids
        System.debug('myFiles' + myFiles);
        List<Map<String,Object>> myFilesRows = wrapper2List(myFiles);
        System.debug('myFilesRows' + myFilesRows);

        if(myFilesRows==null || myFilesRows.size() == 0){
            System.debug('Missing input map: ' + myFilesGuid);
            return;
        }
                
        //we assume the pictures on the current ORG, so lets use the Domain of this ORG
        String urlInstance = Url.getOrgDomainUrl().toExternalForm();
        
        String mySessionId = '';
        if( !Test.isRunningTest() ) {
            mySessionId = Page.PDFButler_ThumbUrl_MySessionId.getContent().toString();
        }
        
        Boolean isSingle = false;
        
        if(myFiles instanceof cadmus_core.SingleWrapper){
            isSingle = true;
        }
        
        //check if this datasource is already from ContentDocumentLink
        List<Map<String,Object>> rows = new List<Map<String, Object>>();
        Boolean firstRow = true;
        if( String.isEmpty( String.valueOf(myFilesRows[0].get('ContentDocument.Id')))) {
                
            Map<String, Map<String,Object>> itemsMap = new Map<String, Map<String,Object>>();
            List<String> linked = new List<String>();
            //get all pictures related to the parent
            for (Map<String,Object> myFilesRow : myFilesRows) {
                String fieldValue = (String)myFilesRow.get(fieldName);
                //we will skip the values that are empty
                if( !String.isEmpty(fieldValue) ) {
                    itemsMap.put(fieldValue, myFilesRow);
                    linked.add(fieldValue);
                }
            }
            //if there are no id selected, can be when the field to retrieve is null
            if( linked.size() == 0 ) {
                return;
            }
            
            //Get all Files by LinkedEntityId
            List<ContentDocumentLink> files = [SELECT Id, ContentDocument.Id, LinkedEntityId 
                                               FROM ContentDocumentLink 
                                              WHERE LinkedEntityId  IN :linked];
          
            //for (Map<String,Object> myFilesRow : myFilesRows) {
            for (ContentDocumentLink file : files) {
                String cId = file.ContentDocument.Id;
                //THUMB120BY90 or THUMB240BY180 or THUMB720BY480
                String url = '';
                if( !thumbnailSize.equals('FULL') ) {
                	url = urlInstance + '/services/data/v55.0/connect/files/' + cId + '/rendition?type=' + thumbnailSize;
                } else {
                    url = urlInstance + '/services/data/v55.0/sobjects/ContentVersion/' + file.ContentDocument.LatestPublishedVersionId + '/VersionData';
                }
                
                System.debug('file.LinkedEntityId: ' + file.LinkedEntityId);
                Map<String,Object> myFilesRow = itemsMap.get(file.LinkedEntityId);
                System.debug('Id: ' + myFilesRow.get('Id'));
                
                myFilesRow.put('pdfbutler_url', url);
                if(firstRow) {
                    myFilesRow.put('pdfbutler_sessionId', mySessionId);
                    firstRow = false;
                }
                System.debug('pdfbutler_url: ' + myFilesRow.get('pdfbutler_url'));
                rows.add(myFilesRow);
            } 
        } else {
            for (Map<String,Object> myFilesRow : myFilesRows) {
                
                String cId = (String)myFilesRow.get('ContentDocument.Id');
                //THUMB120BY90 or THUMB240BY180 or THUMB720BY480
                String url = '';
                if( !thumbnailSize.equals('FULL') ) {
                    url = urlInstance + '/services/data/v55.0/connect/files/' + cId + '/rendition?type=' + thumbnailSize;
                } else {
                    String cvId = (String)myFilesRow.get('ContentDocument.LatestPublishedVersionId');
                    url = urlInstance + '/services/data/v55.0/sobjects/ContentVersion/' + cvId + '/VersionData';
                }
                myFilesRow.put('pdfbutler_url', url);
                if(firstRow) {
                    myFilesRow.put('pdfbutler_sessionId', mySessionId);
                    firstRow = false;
                }
                System.debug('is via ContentDocLink  pdfbutler_url: ' + myFilesRow.get('pdfbutler_url'));
                rows.add(myFilesRow);
            }
        }
        if(isSingle) {
            cadmus_core.SingleWrapper rowWrapper = new cadmus_core.SingleWrapper();
            //there must be at least 1 record otherwise we cannot get to here
            rowWrapper.data = rows[0];
            dsMap.put(myFilesGuid, rowWrapper); 
        } else {
            cadmus_core.ListWrapper rowsWrapper = new cadmus_core.ListWrapper();
            rowsWrapper.data = rows;
            dsMap.put(myFilesGuid, rowsWrapper); 
        }
    }
}