@IsTest
global class PDFButler_Actionable_GetThumbsUrlTest {

    @IsTest
    global static void test_wrapper2List() {
        PDFButler_Actionable_GetThumbnailsUrl agtdt = new PDFButler_Actionable_GetThumbnailsUrl();
        
        //empty
        agtdt.wrapper2List(null);
        
        //SINGLE
        cadmus_core.SingleWrapper sw = new cadmus_core.SingleWrapper();
        Map<String,String> singleData = new Map<String,String>();
        sw.data = singleData;
        agtdt.wrapper2List(sw);
        
        //LIST
        cadmus_core.ListWrapper lw = new cadmus_core.ListWrapper();
        List<Map<String, Object>> listData = new List<Map<String, Object>>();
        lw.data = listData;
        agtdt.wrapper2List(lw);
        
        //Any object
        agtdt.wrapper2List(new PDFButler_Actionable_GetThumbnailsUrl());
    }

    @IsTest()
    global static void test_executeListRows() {
        PDFButler_Actionable_GetThumbnailsUrl agtdt = new PDFButler_Actionable_GetThumbnailsUrl();
        
        Map<String, Object> dsMap = new Map<String, Object>();
        
        cadmus_core.ListWrapper lw = new cadmus_core.ListWrapper();
        List<Map<String, Object>> listData = new List<Map<String, Object>>();
        Map<String,String> singleData = new Map<String,String>();
        singleData.put('ContentDocument.Id', '123abc');
        singleData.put('url', 'http://www.google.be/');
        singleData.put('myidfield', '04t3X000002xTNK');
        listData.add(singleData);
        lw.data = listData;
        
        dsMap.put(null,lw);
        
        cadmus_core__Actionable__c actionable = new cadmus_core__Actionable__c();
        actionable.Get_Url_Field_API_Name__c = 'myidfield';  
        actionable.Get_Thumbnail_Size__c = 'THUMB120BY90';  
        
        agtdt.execute(actionable, null, null, null, dsMap, null);
    }

    @IsTest()
    global static void test_executeSingleRows() {
        PDFButler_Actionable_GetThumbnailsUrl agtdt = new PDFButler_Actionable_GetThumbnailsUrl();
        
        Map<String, Object> dsMap = new Map<String, Object>();
        
        cadmus_core.SingleWrapper sw = new cadmus_core.SingleWrapper();
        Map<String,String> singleData = new Map<String,String>();
        singleData.put('ContentDocument.Id', '123abc');
        singleData.put('url', 'http://www.google.be/');
        singleData.put('myidfield', '04t3X000002xTNK');
        sw.data = singleData;
        
        dsMap.put(null,sw);
        
        cadmus_core__Actionable__c actionable = new cadmus_core__Actionable__c();
        actionable.Get_Url_Field_API_Name__c = 'myidfield';  
        actionable.Get_Thumbnail_Size__c = 'THUMB120BY90';  
        
        agtdt.execute(actionable, null, null, null, dsMap, null);
    }

    @IsTest()
    global static void test_executeListRowsNoContentDocumentId() {
        PDFButler_Actionable_GetThumbnailsUrl agtdt = new PDFButler_Actionable_GetThumbnailsUrl();
        
        Map<String, Object> dsMap = new Map<String, Object>();
        
        cadmus_core.ListWrapper lw = new cadmus_core.ListWrapper();
        List<Map<String, Object>> listData = new List<Map<String, Object>>();
        Map<String,String> singleData = new Map<String,String>();
        singleData.put('url', 'http://www.google.be/');
        singleData.put('myidfield', '04t3X000002xTNK');
        listData.add(singleData);
        lw.data = listData;
        
        dsMap.put(null,lw);
        
        cadmus_core__Actionable__c actionable = new cadmus_core__Actionable__c();
        actionable.Get_Url_Field_API_Name__c = 'myidfield';  
        actionable.Get_Thumbnail_Size__c = 'THUMB120BY90';  
        
        agtdt.execute(actionable, null, null, null, dsMap, null);
    }

    @IsTest()
    global static void test_executeRows() {
        PDFButler_Actionable_GetThumbnailsUrl agtdt = new PDFButler_Actionable_GetThumbnailsUrl();
        
        Map<String, Object> dsMap = new Map<String, Object>();
        
        cadmus_core__Actionable__c actionable = new cadmus_core__Actionable__c();
        
        agtdt.execute(actionable, null, null, null, dsMap, null);
    }
}