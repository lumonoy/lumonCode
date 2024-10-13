/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-09-2024
 * @last modified by  : Henk Reynders
**/
public class CustomExceptionController{
    public static CustomException__c throwCustomException(CustomExceptionData exceptionData){
        CustomException__c  customException = new CustomException__c();
        customException.ClassName__c = exceptionData.className;
        customException.Exception_Message__c = exceptionData.message;
        customException.Line_Number__c = exceptionData.lineNumber; 
        customException.MethodName__c = exceptionData.method; 
        customException.Exception_Type__c = exceptionData.type;
        if(exceptionData.doInsert){
            insert customException;
        }
        return customException;
    }
    public static CustomException__c getCustomException(){
        CustomException__c  customException = new CustomException__c();
        customException = [SELECT Id, Name, 
                                    CreatedDate, CreatedById,  
                                    ClassName__c, Exception_Message__c, 
                                    Exception_Type__c, Govt_Limit_in_Executing_Code__c, 
                                    Line_Number__c, MethodName__c, 
                                    Related_To_Number__c, StackTrace__c
                            FROM CustomException__c
                            ORDER BY CreatedDate DESC 
                            LIMIT 1];
        return customException;
    }
    public static List<CustomException__c> getCustomExceptions(){
        List<CustomException__c>  customExceptions = new List<CustomException__c>();
        customExceptions = [SELECT Id, Name, 
                                    CreatedDate, CreatedById,  
                                    ClassName__c, Exception_Message__c, 
                                    Exception_Type__c, Govt_Limit_in_Executing_Code__c, 
                                    Line_Number__c, MethodName__c, 
                                    Related_To_Number__c, StackTrace__c
                            FROM CustomException__c
                            ORDER BY CreatedDate DESC 
                            LIMIT 25];
        return customExceptions;
    }
    public static List<CustomException__c> getCustomExceptionsByClass(String className){
        String classString = '%'+className+'%';
        List<CustomException__c>  customExceptions = new List<CustomException__c>();
        customExceptions = [SELECT Id, Name, 
                                    CreatedDate, CreatedById,  
                                    ClassName__c, Exception_Message__c, 
                                    Exception_Type__c, Govt_Limit_in_Executing_Code__c, 
                                    Line_Number__c, MethodName__c, 
                                    Related_To_Number__c, StackTrace__c
                            FROM CustomException__c
                            WHERE ClassName__c LIKE : classString
                            ORDER BY CreatedDate DESC 
                            LIMIT 25];
        return customExceptions;
    }
    public static List<CustomException__c> getCustomExceptionsByMethod(String methodName){
        String methodString = '%'+methodName+'%';
        List<CustomException__c>  customExceptions = new List<CustomException__c>();
        customExceptions = [SELECT Id, Name, 
                                    CreatedDate, CreatedById,  
                                    ClassName__c, Exception_Message__c, 
                                    Exception_Type__c, Govt_Limit_in_Executing_Code__c, 
                                    Line_Number__c, MethodName__c, 
                                    Related_To_Number__c, StackTrace__c
                            FROM CustomException__c
                            WHERE MethodName__c LIKE : methodString
                            ORDER BY CreatedDate DESC 
                            LIMIT 25];
        return customExceptions;
    }
}