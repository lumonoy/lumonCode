/**
 * Created by CloudCrossing - PDF Butler on 19/02/2022.
 */
global with sharing class PDFB_Act_RichTextPicsByUrl implements cadmus_core.AbstractBeforeWithDataSourcesActionable{

    global List<Map<String,Object>> wrapper2List(Object wrapper){
        if(wrapper==null) return null;

        List<Map<String,Object>> richFieldsRows=new List<Map<String, Object>>();

        if(wrapper instanceof cadmus_core.SingleWrapper){
            cadmus_core.SingleWrapper richFieldsRowsDsSingle =(cadmus_core.SingleWrapper)wrapper;
            richFieldsRows.add(richFieldsRowsDsSingle.data);
        }
        else if (wrapper instanceof cadmus_core.ListWrapper){
            cadmus_core.ListWrapper richFieldsRowsDsSingle =(cadmus_core.ListWrapper)wrapper;
            richFieldsRows.addAll(richFieldsRowsDsSingle.data);
        }else{
            richFieldsRows = null;
        }
        return richFieldsRows;
    }

    global void execute(cadmus_core__Actionable__c actionable, Id docConfig, Id objectId, Map<String, Object> inputMap, Map<String, Object> dsMap, cadmus_core.ConvertController.ConvertDataModel cdm) {

        System.debug('Starting!');
        System.debug(dsMap);
        String myMasterDataSourceGuid = actionable.Get_Url_Master_DataSource_Guid__c;
        String dsPictureContentDataSource = actionable.Get_Url_Pictures_DataSource_Guid__c;
        

        System.debug(myMasterDataSourceGuid);
        System.debug(dsPictureContentDataSource);

        Object richFieldsRowsDs =  dsMap.get(myMasterDataSourceGuid);
        System.debug('richFieldsRowsDs: ' + richFieldsRowsDs);
        List<Map<String,Object>> richFieldsRows = wrapper2List(richFieldsRowsDs);
        System.debug(richFieldsRows);

        if(richFieldsRows==null){
            System.debug('Missing input map for actionable '+myMasterDataSourceGuid);
            return;
        }
        List<Map<String,Object>> imageData = wrapper2List(dsMap.get(dsPictureContentDataSource));

        if(imageData==null){
            imageData = new List<Map<String, Object>>();
        }
        Http http = new Http();
				
        //we assume the pictures on the current ORG, so lets use the Domain of this ORG
		String urlInstance = Url.getOrgDomainUrl().toExternalForm();
        String mySessionId = '';
        if( !Test.isRunningTest() ) {
        	mySessionId = Page.PDFButler_RichText_MySessionId.getContent().toString();
        }
        
        Decimal height = actionable.Rich_Text_Pic_height__c;


        //loop through all records
        for (Map<String,Object> richFieldRow : richFieldsRows) {
            System.debug(richFieldRow);
            System.debug(actionable.Rich_Text_Record_Field_Name__c);
            // get the RichText Field
            String rtf = String.valueOf(richFieldRow.get(actionable.Rich_Text_Record_Field_Name__c));
            if(String.IsEmpty(rtf)) {
                continue;
            }
            
            if(height > 0) {
                //if the height is set => replace all '<img ' with '<img height="THE HEIGHT" '
                rtf = rtf.replace('<img ', '<img height="' + height + 'px" ');
                richFieldRow.put(actionable.Rich_Text_Record_Field_Name__c, rtf);
            }
            
            // get all URL's
            Matcher m=Pattern.compile('<img .*?\\bsrc=\"([^\"]+)\"').matcher(rtf);
            while (m.find()){
                String imageUrl = m.group(1);

				String imgUrl = imageUrl.unescapeHtml4();
				System.PageReference pageReference = new System.PageReference('/' + imgUrl);
				Map<String,String> parameters = pageReference.getParameters();
				 
				String eid = parameters.get('eid');
				String refid = parameters.get('refid');

				String key = imgUrl;
                if(refid != null) {
                    String[] fields = actionable.Rich_Text_Record_Field_Name__c.split('\\.');
                    String field = fields[fields.size()-1];
					imageUrl = urlInstance + '/services/data/v47.0/sobjects/' + actionable.Rich_Text_Object_Name__c + '/' + eid + '/richTextImageFields/' + field + '/' + refid;
                }
                System.debug('key:' + key);
					
                Map<String,String> imageDataSourceLine = new Map<String,String>();
                imageDataSourceLine.put('pdfbutler_parentId', key);
                imageDataSourceLine.put('pdfbutler_url', imageUrl);
                imageData.add(imageDataSourceLine);
            }
        }
        
        if(imageData.size() > 0) {
            imageData[0].put('pdfbutler_sessionId', mySessionId);
        }
        cadmus_core.ListWrapper dsPictures = new cadmus_core.ListWrapper();
		dsPictures.data = imageData;
        dsMap.put(dsPictureContentDataSource,dsPictures);

    }
}