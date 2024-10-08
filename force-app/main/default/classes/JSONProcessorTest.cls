/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-14-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
private class JSONProcessorTest {
	// Some JSON samples from https://json.org/example.html
    public static final String orderMessageJSON = [SELECT Body FROM StaticResource WHERE Name = 'TestOrderMessageJSON' ].Body.toString();  
	public static final String SAMPLE1 = '{"menu":{"id":"file","value":"File","popup":{"menuitem":[{"value":"New","onclick":"CreateNewDoc()"},{"value":"Open","onclick":"OpenDoc()"},{"value":"Close","onclick":"CloseDoc()"}]}}}';
	public static final String SAMPLE2 = '{"otherProp":null,"widget":{"debug":"on","window":{"title":"SampleKonfabulatorWidget","name":"main_window","width":500,"height":500},"image":{"src":"Images/Sun.png","name":"sun1","hOffset":250,"vOffset":250,"alignment":"center"},"text":{"data":"ClickHere","size":36,"style":"bold","name":"text1","hOffset":250,"vOffset":100,"alignment":"center","onMouseUp":"sun1.opacity=(sun1.opacity/100)*90;"}}}';
	public static final String SAMPLE3 = '[{"servlet-name":"cofaxCDS","servlet-class":"org.cofax.cds.CDSServlet","init-param":{"configGlossary:installationAt":"Philadelphia,PA","configGlossary:adminEmail":"ksm@pobox.com","configGlossary:poweredBy":"Cofax","configGlossary:poweredByIcon":"/images/cofax.gif","configGlossary:staticPath":"/content/static","templateProcessorClass":"org.cofax.WysiwygTemplate","templateLoaderClass":"org.cofax.FilesTemplateLoader","templatePath":"templates","templateOverridePath":"","defaultListTemplate":"listTemplate.htm","defaultFileTemplate":"articleTemplate.htm","useJSP":false,"jspListTemplate":"listTemplate.jsp","jspFileTemplate":"articleTemplate.jsp","cachePackageTagsTrack":200,"cachePackageTagsStore":200,"cachePackageTagsRefresh":60,"cacheTemplatesTrack":100,"cacheTemplatesStore":50,"cacheTemplatesRefresh":15,"cachePagesTrack":200,"cachePagesStore":100,"cachePagesRefresh":10,"cachePagesDirtyRead":10,"searchEngineListTemplate":"forSearchEnginesList.htm","searchEngineFileTemplate":"forSearchEngines.htm","searchEngineRobotsDb":"WEB-INF/robots.db","useDataStore":true,"dataStoreClass":"org.cofax.SqlDataStore","redirectionClass":"org.cofax.SqlRedirection","dataStoreName":"cofax","dataStoreDriver":"com.microsoft.jdbc.sqlserver.SQLServerDriver","dataStoreUrl":"jdbc:microsoft:sqlserver://LOCALHOST:1433;DatabaseName=goon","dataStoreUser":"sa","dataStorePassword":"dataStoreTestQuery","dataStoreTestQuery":"SETNOCOUNTON;selecttest=\'test\';","dataStoreLogFile":"/usr/local/tomcat/logs/datastore.log","dataStoreInitConns":10,"dataStoreMaxConns":100,"dataStoreConnUsageLimit":100,"dataStoreLogLevel":"debug","maxUrlLength":500}},{"servlet-name":"cofaxEmail","servlet-class":"org.cofax.cds.EmailServlet","init-param":{"mailHost":"mail1","mailHostOverride":"mail2"}},{"servlet-name":"cofaxAdmin","servlet-class":"org.cofax.cds.AdminServlet"},{"servlet-name":"fileServlet","servlet-class":"org.cofax.cds.FileServlet"},{"servlet-name":"cofaxTools","servlet-class":"org.cofax.cms.CofaxToolsServlet","init-param":{"templatePath":"toolstemplates/","log":1,"logLocation":"/usr/local/tomcat/logs/CofaxTools.log","logMaxSize":"","dataLog":1,"dataLogLocation":"/usr/local/tomcat/logs/dataLog.log","dataLogMaxSize":"","removePageCache":"/content/admin/remove?cache=pages&id=","removeTemplateCache":"/content/admin/remove?cache=templates&id=","fileTransferFolder":"/usr/local/tomcat/webapps/content/fileTransferFolder","lookInContext":1,"adminGroupID":4,"betaServer":true}}]';

	@IsTest static void testRawString() {

		JSONProcessor parser = new JSONProcessor('"HelloWorld"');
		System.assertEquals(false, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals('HelloWorld', parser.getStringValue());
	}

	@IsTest static void testRawBooleanFalse() {

		JSONProcessor parser = new JSONProcessor('false');
		System.assertEquals(false, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals(false, parser.getBooleanValue());
	}

	@IsTest static void testRawBooleanTrue() {

		JSONProcessor parser = new JSONProcessor('true');
		System.assertEquals(false, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals(true, parser.getBooleanValue());
	}

	@IsTest static void testRawNull() {

		JSONProcessor parser = new JSONProcessor('null');
		System.assertEquals(false, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals(null, parser.getValue());
	}

	@IsTest static void testRawInteger() {

		JSONProcessor parser = new JSONProcessor('42');
		System.assertEquals(false, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals(42, parser.getIntegerValue());
	}

	@IsTest static void testRawDecimal() {

		JSONProcessor parser = new JSONProcessor('17.22');
		System.assertEquals(false, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals(17.22, parser.getDecimalValue());
	}

	@IsTest static void testRawNumberWithENotation() {

		JSONProcessor parser = new JSONProcessor('1.2483e+2');
		System.assertEquals(false, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals(124.83, parser.getDecimalValue());
	}

	@IsTest static void testSimpleGet() {

		JSONProcessor parser = new JSONProcessor(SAMPLE1);
		System.assertEquals(true, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals('File', parser.get('menu.value').getStringValue());
		System.assertEquals('File', parser.get('menu.value').getValue());
	}

	@IsTest static void testArrayGet() {

		JSONProcessor parser = new JSONProcessor(SAMPLE1);
		System.assertEquals(true, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals('OpenDoc()', parser.get('menu.popup.menuitem.[1].onclick').getValue());
	}

	@IsTest static void testNumberGet() {

		JSONProcessor parser = new JSONProcessor(SAMPLE2);
		System.assertEquals(true, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals(100, parser.get('widget.text.vOffset').getIntegerValue());
	}

	@IsTest static void testCompoundGet() {

		JSONProcessor parser = new JSONProcessor(SAMPLE1);
		System.assertEquals(true, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals('Close', parser.get('menu').get('popup.menuitem').get('[2].value').getStringValue());
	}

	@IsTest static void testAsMap() {

		JSONProcessor parser = new JSONProcessor(SAMPLE1);
		System.assertEquals(true, parser.isObject());
		System.assertEquals(false, parser.isArray());
		Map<String, JSONProcessor> theMap = parser.get('menu').asMap();
		System.assertEquals(3, theMap.size());
		System.assertEquals(false, theMap.get('id').isObject());
		System.assertEquals(false, theMap.get('id').isArray());
		System.assertEquals('file', theMap.get('id').getValue());
		System.assertEquals(true, theMap.get('popup').isObject());
		System.assertEquals(false, theMap.get('popup').isArray());
	}

	@IsTest static void testAsList() {

		JSONProcessor parser = new JSONProcessor(SAMPLE3);
		System.assertEquals(false, parser.isObject());
		System.assertEquals(true, parser.isArray());
		List<JSONProcessor> items = parser.asList();
		System.assertEquals(5, items.size());
		System.assertEquals('ksm@pobox.com', items[0].get('init-param.configGlossary:adminEmail').getValue());
		System.assertEquals(true, items[1].get('init-param').isObject());
		System.assertEquals('cofaxEmail', items[1].get('servlet-name').getStringValue());
	}

	@IsTest static void testOutOfBoundsException() {

		JSONProcessor parser = new JSONProcessor(SAMPLE3);

		try {
			parser.get('[7]');
			System.assert(false, 'We used an index outside the bounds of our array, should have seen an exception about that.');
		}
		catch(ListException e) {
			System.assertEquals('List index out of bounds: 7', e.getMessage());
		}
	}

	@IsTest static void testMissingKeyException() {

		JSONProcessor parser = new JSONProcessor(SAMPLE2);

		try {
			parser.get('badKey');
			System.assert(false, 'Our key was invalid, should have seen an exception about that.');
		}
		catch(JSONProcessor.MissingKeyException e) {
			System.assertEquals('No match found for <badKey>: {otherProp, widget}', e.getMessage());
		}
	}

	@IsTest static void testRootNotAnObjectException() {

		JSONProcessor parser = new JSONProcessor(SAMPLE3);

		try {
			parser.asMap();
			System.assert(false, 'Root node is not an object, should have seen an exception about that.');
		}
		catch(JSONProcessor.NotAnObjectException e) {
			System.assert(e.getMessage().startsWith('The wrapped value is not a JSON object:'));
		}
	}

	@IsTest static void testGetNotAnObjectException() {

		JSONProcessor parser = new JSONProcessor(SAMPLE1);

		try {
			parser.get('menu.popup.menuitem.first');
			System.assert(false, 'Node is not an object, should have seen an exception about that.');
		}
		catch(JSONProcessor.NotAnObjectException e) {
			System.assert(e.getMessage().startsWith('The wrapped value is not a JSON object:'));
		}
	}

	@IsTest static void testRootNotAnArrayException() {

		JSONProcessor parser = new JSONProcessor(SAMPLE2);

		try {
			parser.asList();
			System.assert(false, 'Root node is not an array, should have seen an exception about that.');
		}
		catch(JSONProcessor.NotAnArrayException e) {
			System.assert(e.getMessage().startsWith('The wrapped value is not a JSON array:'));
		}
	}

	@IsTest static void testGetNotAnArrayException() {

		JSONProcessor parser = new JSONProcessor(SAMPLE1);

		try {
			parser.get('menu.popup.[0]');
			System.assert(false, 'Node is not an array, should have seen an exception about that.');
		}
		catch(JSONProcessor.NotAnArrayException e) {
			System.assert(e.getMessage().startsWith('The wrapped value is not a JSON array:'));
		}
	}

	@IsTest static void testExistsGoodKey() {

		JSONProcessor parser = new JSONProcessor(SAMPLE1);

		System.assertEquals(true, parser.exists('menu.popup.menuitem.[1].onclick'));
	}

	@IsTest static void testExistsNoIntermediaryKey() {

		JSONProcessor parser = new JSONProcessor(OrderMessageJSON);

		System.assertEquals(false, parser.exists('menu.popup.menuitems.[1].onclick'));
	}

	@IsTest static void testExistsNoKey() {

		JSONProcessor parser = new JSONProcessor(OrderMessageJSON);

		System.assertEquals(false, parser.exists('menu.popup.menuitem.[1].onexplosion'));
	}

	@IsTest static void testExistsGoodIndex() {

		JSONProcessor parser = new JSONProcessor(SAMPLE3);

		System.assertEquals(true, parser.exists('[1]'));
	}

	@IsTest static void testExistsBadIndex() {

		JSONProcessor parser = new JSONProcessor(SAMPLE3);

		System.assertEquals(false, parser.exists('[7]'));
	}

	@IsTest static void testExistsNullOk() {

		JSONProcessor parser = new JSONProcessor(SAMPLE2);

		System.assertEquals(true, parser.exists('otherProp', false));
	}

	@IsTest static void testExistsNotNull() {

		JSONProcessor parser = new JSONProcessor(SAMPLE2);

		System.assertEquals(false, parser.exists('otherProp', true));
	}

	@IsTest static void testExistsArrayFirstItem() {

		JSONProcessor parser = new JSONProcessor(SAMPLE3);

		// this has always worked
		System.assertEquals(true, parser.exists('[1]'));
		System.assertEquals(false, parser.exists('[7]'));

		// this works after a bug fix to how exists tests array elements
		System.assertEquals(true, parser.exists('[0]'));
	}

	@IsTest static void testExistsArrayFirstItemNestedElement() {

		JSONProcessor parser = new JSONProcessor(SAMPLE1);

		// this has always worked
		System.assertEquals(true, parser.exists('menu.popup.menuitem.[1].onclick'));
		System.assertEquals(false, parser.exists('menu.popup.menuitem.[1].notpresent'));
		System.assertEquals(false, parser.exists('menu.popup.menuitem.[7].onclick'));

		// this works after a bug fix to how exists tests array elements
		System.assertEquals(true, parser.exists('menu.popup.menuitem.[0].onclick'));
	}

	@IsTest static void testGetBlobValue() {

		Blob helloWorld = Blob.valueOf('HelloWorld');
		String encoded = EncodingUtil.base64Encode(helloWorld);

		JSONProcessor parser = new JSONProcessor('"' + encoded + '"');
		System.assertEquals(encoded, parser.getStringValue());
		System.assertEquals(helloWorld, parser.getBlobValue());

		try {
			parser = new JSONProcessor('42');
			parser.getBlobValue();
			System.assert(false, 'Node is not a valid Blob, should have seen an exception about that.');
		}
		catch(JSONProcessor.InvalidConversionException e) {
			System.assertEquals('Only String values can be converted to a Blob: 42', e.getMessage());
		}
	}

	@IsTest static void testGetBooleanValue() {

		JSONProcessor parser = new JSONProcessor('false');
		System.assertEquals(false, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals(false, parser.getBooleanValue());

		parser = new JSONProcessor('"false"');
		System.assertEquals(false, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals(false, parser.getBooleanValue());

		parser = new JSONProcessor('"FALSE"');
		System.assertEquals(false, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals(false, parser.getBooleanValue());

		parser = new JSONProcessor('true');
		System.assertEquals(false, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals(true, parser.getBooleanValue());

		parser = new JSONProcessor('"true"');
		System.assertEquals(false, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals(true, parser.getBooleanValue());

		parser = new JSONProcessor('"TRUE"');
		System.assertEquals(false, parser.isObject());
		System.assertEquals(false, parser.isArray());
		System.assertEquals(true, parser.getBooleanValue());
	}

	@IsTest static void testGetDatetimeValue() {

		JSONProcessor parser = new JSONProcessor('"2011-03-22T13:01:23"');
		System.assertEquals(Datetime.newInstanceGmt(2011, 3, 22, 13, 1, 23), parser.getDatetimeValue());

		parser = new JSONProcessor('1538783039073');
		System.assertEquals(Datetime.newInstanceGmt(2018, 10, 05, 23, 43, 59), parser.getDatetimeValue());

		try {
			parser = new JSONProcessor('[1,2,3]');
			parser.getDatetimeValue();
			System.assert(false, 'Node is not a valid Datetime, should have seen an exception about that.');
		}
		catch(JSONProcessor.InvalidConversionException e) {
			System.assertEquals('Only Long and String values can be converted to a Datetime: [ 1, 2, 3 ]', e.getMessage());
		}
	}

	@IsTest static void testGetDateValue() {

		JSONProcessor parser = new JSONProcessor('"2011-03-22"');
		System.assertEquals(Date.newInstance(2011, 3, 22), parser.getDateValue());

		parser = new JSONProcessor('1538783039073');
		System.assertEquals(Date.newInstance(2018, 10, 05), parser.getDateValue());

		try {
			parser = new JSONProcessor('[1,2,3]');
			parser.getDateValue();
			System.assert(false, 'Node is not a valid Date, should have seen an exception about that.');
		}
		catch(JSONProcessor.InvalidConversionException e) {
			System.assertEquals('Only Long and String values can be converted to a Date: [ 1, 2, 3 ]', e.getMessage());
		}
	}

	@IsTest static void testGetDecimalValue() {

		JSONProcessor parser = new JSONProcessor('12');
		System.assertEquals(12.0, parser.getDecimalValue());

		parser = new JSONProcessor('12.5');
		System.assertEquals(12.5, parser.getDecimalValue());

		parser = new JSONProcessor('"12.5"');
		System.assertEquals(12.5, parser.getDecimalValue());

		parser = new JSONProcessor('1538783039073');
		System.assertEquals(1538783039073.0, parser.getDecimalValue());

		try {
			parser = new JSONProcessor('[1,2,3]');
			parser.getDecimalValue();
			System.assert(false, 'Node is not a valid Decimal, should have seen an exception about that.');
		}
		catch(JSONProcessor.InvalidConversionException e) {
			System.assertEquals('This value cannot be converted to a Decimal: [ 1, 2, 3 ]', e.getMessage());
		}
	}

	@IsTest static void testGetDoubleValue() {

		JSONProcessor parser = new JSONProcessor('12');
		System.assertEquals(12.0, parser.getDoubleValue());

		parser = new JSONProcessor('12.5');
		System.assertEquals(12.5, parser.getDoubleValue());

		parser = new JSONProcessor('"12.5"');
		System.assertEquals(12.5, parser.getDoubleValue());

		parser = new JSONProcessor('1538783039073');
		System.assertEquals(1538783039073.0, parser.getDoubleValue());

		try {
			parser = new JSONProcessor('[1,2,3]');
			parser.getDoubleValue();
			System.assert(false, 'Node is not a valid Double, should have seen an exception about that.');
		}
		catch(JSONProcessor.InvalidConversionException e) {
			System.assertEquals('This value cannot be converted to a Double: [ 1, 2, 3 ]', e.getMessage());
		}
	}

	/*@IsTest static void testGetIdValue() {

		Account a = new Account(Name = 'Acme');
		insert a;

		JSONProcessor parser = new JSONProcessor('"' + String.valueOf(a.Id) + '"');
		System.assertEquals(a.Id, parser.getIdValue());

		try {
			parser = new JSONProcessor('[1,2,3]');
			parser.getIdValue();
			System.assert(false, 'Node is not a valid Id, should have seen an exception about that.');
		}
		catch(JSONProcessor.InvalidConversionException e) {
			System.assertEquals('This value cannot be converted to an Id: [ 1, 2, 3 ]', e.getMessage());
		}
	}*/

	@IsTest static void testGetIntegerValue() {

		JSONProcessor parser = new JSONProcessor('12');
		System.assertEquals(12, parser.getIntegerValue());

		parser = new JSONProcessor('"12"');
		System.assertEquals(12, parser.getIntegerValue());

		parser = new JSONProcessor('12.5');
		System.assertEquals(12, parser.getIntegerValue());

		parser = new JSONProcessor('1538783039073');
		System.assertEquals(1184747105, parser.getIntegerValue()); // integer gets truncated

		try {
			parser = new JSONProcessor('[1,2,3]');
			parser.getIntegerValue();
			System.assert(false, 'Node is not a valid Integer, should have seen an exception about that.');
		}
		catch(JSONProcessor.InvalidConversionException e) {
			System.assertEquals('This value cannot be converted to an Integer: [ 1, 2, 3 ]', e.getMessage());
		}
	}

	@IsTest static void testGetLongValue() {

		JSONProcessor parser = new JSONProcessor('12');
		System.assertEquals(12, parser.getLongValue());

		parser = new JSONProcessor('"12"');
		System.assertEquals(12, parser.getLongValue());

		parser = new JSONProcessor('12.5');
		System.assertEquals(12, parser.getLongValue());

		parser = new JSONProcessor('1538783039073');
		System.assertEquals(1538783039073L, parser.getLongValue());

		try {
			parser = new JSONProcessor('[1,2,3]');
			parser.getLongValue();
			System.assert(false, 'Node is not a valid Long, should have seen an exception about that.');
		}
		catch(JSONProcessor.InvalidConversionException e) {
			System.assertEquals('This value cannot be converted to a Long: [ 1, 2, 3 ]', e.getMessage());
		}
	}

	@IsTest static void testGetStringValue() {

		JSONProcessor parser = new JSONProcessor('"HelloWorld"');
		System.assertEquals('HelloWorld', parser.getStringValue());

		parser = new JSONProcessor('true');
		System.assertEquals('true', parser.getStringValue());

		parser = new JSONProcessor('null');
		System.assertEquals(null, parser.getStringValue());

		parser = new JSONProcessor('12.5');
		System.assertEquals('12.5', parser.getStringValue());

		try {
			parser = new JSONProcessor('{}');
			parser.getStringValue();
			System.assert(false, 'Node is not a valid String, should have seen an exception about that.');
		}
		catch(JSONProcessor.InvalidConversionException e) {
			System.assertEquals('Objects and arrays are not Strings: { }', e.getMessage());
		}

		try {
			parser = new JSONProcessor('[]');
			parser.getStringValue();
			System.assert(false, 'Node is not a valid String, should have seen an exception about that.');
		}
		catch(JSONProcessor.InvalidConversionException e) {
			System.assertEquals('Objects and arrays are not Strings: [ ]', e.getMessage());
		}
	}

	@IsTest static void testGetTimeValue() {

		JSONProcessor parser = new JSONProcessor('"2011-03-22T13:01:23"');
		System.assertEquals(Time.newInstance(13, 1, 23, 0), parser.getTimeValue());

		parser = new JSONProcessor('1538783039073');
		System.assertEquals(Time.newInstance(23, 43, 59, 73), parser.getTimeValue());

		try {
			parser = new JSONProcessor('[1,2,3]');
			parser.getTimeValue();
			System.assert(false, 'Node is not a valid Time, should have seen an exception about that.');
		}
		catch(JSONProcessor.InvalidConversionException e) {
			System.assertEquals('Only Long and String values can be converted to a Time: [ 1, 2, 3 ]', e.getMessage());
		}
	}
}