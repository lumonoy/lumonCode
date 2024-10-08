/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 07-06-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class ProcessStep {
    public String stage {get;set;}
    public String activity {get;set;}                                          
    public String recordId {get;set;}
    public String objectType {get;set;}                                       
    public String jsonString {get;set;}
    public String documentId {get;set;}
}