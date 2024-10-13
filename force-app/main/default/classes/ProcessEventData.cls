/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-12-2024
 * @last modified by  : Henk Reynders
**/
public without sharing class ProcessEventData {
    public String stage {get;set;}
    public String activity {get;set;}                                          
    public String recordId {get;set;}
    public String objectType {get;set;}                                       
    public String jsonString {get;set;}
    public String documentId {get;set;}
}