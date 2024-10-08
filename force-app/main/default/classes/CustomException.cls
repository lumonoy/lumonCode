/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-13-2024
 * @last modified by  : Henk Reynders
**/
public class CustomException extends Exception{
    public static void logCustomException(Exception e)
    {
        logCustomException(e,'');
    }
    public static void logCustomException(Exception e,string relatedToId)
    {
        try
        {
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.');	
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            
            //Governer Limit of executingQuery 
            String QueryLimit = '1. SOQL Queries used / SOQL Queries allowed: ' + Limits.getQueries() + '/' + Limits.getLimitQueries();
            String DMLimit = '2. Number of records queried so far /  Number allowed: ' + Limits.getDmlRows() + '/' + Limits.getLimitDmlRows();
            String DMLStat = '3. Number of DML statements used so far / Number allowed: ' +  Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements();   
            String CPUT = '4. Amount of CPU time (in ms) used so far / CPU usage time (in ms) allowed: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime();
            
            //Log information in object
            CustomException__c customException = new CustomException__c();
            customException.Related_To_Number__c=relatedToId;
            customException.Govt_Limit_in_Executing_Code__c = String.format('{0}\n{1}\n{2}\n{3}',new List<string>{QueryLimit, DMLimit,DMLStat,CPUT});
            customException.Exception_Message__c = e.getMessage();
            customException.Exception_Type__c = e.getTypeName();
            customException.Line_Number__c = e.getLineNumber();
            customException.StackTrace__c = e.getStackTraceString();
            customException.MethodName__c=methodName;
            customException.ClassName__c=className;
            database.insert(customException);            
        } 
        finally{
        }            
    } 
}