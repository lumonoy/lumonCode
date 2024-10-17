/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 04-28-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class LumonSystem {
    private static Boolean executeSystemDebug { 
        get {
            return FeatureManagement.checkPermission('Execute_Debug');
        }
    }
    public static void Debug(Object obj) {
        if (executeSystemDebug) {
            system.debug(obj);
        }  
    }  
}