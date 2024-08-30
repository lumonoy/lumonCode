/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class MockResponseGenerator implements HttpCalloutMock {
	public String body = '';
	public Integer statusCode = 200;

	public MockResponseGenerator(String body, Integer statusCode) {
		this.body = body;
		this.statusCode = statusCode;
	}

	public HTTPResponse respond(HTTPRequest request) {
		// Create a fake response
		HttpResponse response = new HttpResponse();
		response.setHeader('Content-Type', 'application/json');
		response.setBody(body);
		response.setStatusCode(statusCode);
		return response;
	}
}