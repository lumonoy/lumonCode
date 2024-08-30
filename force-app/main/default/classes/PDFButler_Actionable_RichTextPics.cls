/**
 * Created by CloudCrossing - PDF Butler on 12/02/2020.
 */
global with sharing class PDFButler_Actionable_RichTextPics implements cadmus_core.AbstractBeforeWithDataSourcesActionable{

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

				HttpRequest request = new HttpRequest();
                String[] fields = actionable.Rich_Text_Record_Field_Name__c.split('\\.');
                String field = fields[fields.size()-1];
                if(refid == null) {
                	request.setEndpoint(imgUrl);
                } else {
					request.setEndpoint( urlInstance + '/services/data/v47.0/sobjects/' + actionable.Rich_Text_Object_Name__c + '/' + eid + '/richTextImageFields/' + field + '/' + refid);
                }
                request.setMethod('GET');
				request.setHeader('Authorization', 'OAuth ' + mySessionId);
				HttpResponse response = http.send(request);
                while (response.getStatusCode() == 302 
                       || ( response.getStatusCode() == 301 && response.getStatus() != 'OK') //might be a cached image, then the code is 301 but the status is OK
                      ) {
                    String loc = response.getHeader('Location');
                    System.debug('loc: ' + loc);
                    request.setEndpoint(loc);
                    response = new Http().send(request);
                }
                
                String contentType=response.getHeader('Content-Type');
				// If the request is successful, parse the JSON response.
				if (response.getStatusCode() == 200) {
					//System.debug('response.getBody:' + response.getBody());
				
					//System.debug(response.getBody());
					String b64 = EncodingUtil.base64Encode(response.getBodyAsBlob());
					Map<String,String> imageDataSourceLine = new Map<String,String>();
					imageDataSourceLine.put('parentId',imgUrl);
					imageDataSourceLine.put('base64', b64); //backend can deal with the prefix for image type: 'data:'+contentType+', '+
					imageDataSourceLine.put('name','inline-image');
					//System.debug(imageDataSourceLine);
					imageData.add(imageDataSourceLine);
				} else {
					System.debug('error ' + response.getStatusCode());
				}
            }
        }
        cadmus_core.ListWrapper dsPictures = new cadmus_core.ListWrapper();
		dsPictures.data = imageData;
        dsMap.put(dsPictureContentDataSource,dsPictures);


    }
}