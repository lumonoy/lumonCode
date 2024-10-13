/**
 * @description       : Wrapper Class for Custom Exception Data
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-12-2024
 * @last modified by  : Henk Reynders
**/
public class CustomExceptionData {
	public String message {get;set;}    //customException.ExceptionMessage__c 
	public String type {get;set;}       //customException.ExceptionType__c
	public String className {get;set;}  //customException.ClassName__c 
	public String method {get;set;}     //customException.MethodName__c                                           
	public Double lineNumber {get;set;} //customException.LineNumber__c
	public String govtlimit {get;set;}  //customException.GovtLimit_c_
	public String related {get;set;}    //customException.RelatedToNumber__c
	public String trace {get;set;}      //customException.StackTrace__c
	public Boolean doInsert {get;set;}  // Insert exception yes/no
}