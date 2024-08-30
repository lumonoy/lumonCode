/**
 * Created by CloudCrossing - PDF Butler on 12/11/2019.
*/
@IsTest
global class PDFButler_Actionable_RichTextPics_Test {

    @IsTest
    global static void test_wrapper2List() {
        PDFButler_Actionable_RichTextPics agtdt = new PDFButler_Actionable_RichTextPics();
        
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
        agtdt.wrapper2List(new PDFButler_Actionable_RichTextPics());
    }

    @IsTest()
    global static void test_executeNoRows() {
        PDFButler_Actionable_RichTextPics agtdt = new PDFButler_Actionable_RichTextPics();
        
        Test.setMock(HttpCalloutMock.class, new YourHttpCalloutMockImpl200());
        
        Map<String, Object> dsMap = new Map<String, Object>();
        
        cadmus_core__Actionable__c actionable = new cadmus_core__Actionable__c();
        
        agtdt.execute(actionable, null, null, null, dsMap, null);
    }

    @IsTest()
    global static void test_execute200() {
        PDFButler_Actionable_RichTextPics agtdt = new PDFButler_Actionable_RichTextPics();
        
        Test.setMock(HttpCalloutMock.class, new YourHttpCalloutMockImpl200());
        
        Map<String, Object> dsMap = new Map<String, Object>();
        
        cadmus_core.ListWrapper lw = new cadmus_core.ListWrapper();
        List<Map<String, Object>> listData = new List<Map<String, Object>>();
        Map<String,String> singleData = new Map<String,String>();
        singleData.put('rtf', '<img src="http://www.pdfbutler.com"/>');
        listData.add(singleData);
        lw.data = listData;
        
        dsMap.put(null,lw);
        
        cadmus_core__Actionable__c actionable = new cadmus_core__Actionable__c();
        actionable.Rich_Text_Record_Field_Name__c = 'rtf';
        actionable.Rich_Text_Object_Name__c = 'test';
        actionable.Rich_Text_Pic_height__c = 150;
        //actionable.Get_Url_Master_DataSource_Guid__c = 'test';
        
        agtdt.execute(actionable, null, null, null, dsMap, null);
    }

    @IsTest()
    global static void test_executeByUrl() {
        PDFB_Act_RichTextPicsByUrl agtdt = new PDFB_Act_RichTextPicsByUrl();
        
        Test.setMock(HttpCalloutMock.class, new YourHttpCalloutMockImpl200());
        
        Map<String, Object> dsMap = new Map<String, Object>();
        
        cadmus_core.ListWrapper lw = new cadmus_core.ListWrapper();
        List<Map<String, Object>> listData = new List<Map<String, Object>>();
        Map<String,String> singleData = new Map<String,String>();
        singleData.put('rtf', '<img src="http://www.pdfbutler.com"/>');
        listData.add(singleData);
        lw.data = listData;
        
        dsMap.put(null,lw);
        
        cadmus_core__Actionable__c actionable = new cadmus_core__Actionable__c();
        actionable.Rich_Text_Record_Field_Name__c = 'rtf';
        actionable.Rich_Text_Object_Name__c = 'test';
        actionable.Rich_Text_Pic_height__c = 150;
        //actionable.Get_Url_Master_DataSource_Guid__c = 'test';
        
        agtdt.execute(actionable, null, null, null, dsMap, null);
    }
    
    global class YourHttpCalloutMockImpl200 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);
            return res;
        }
    }

}