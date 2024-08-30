/*
    Created by Reijo Mattila on 22.10.2023
*/
public class OperatingHoursHolidayTriggerHandler {

    public static Boolean dontRunInsertTriggerForTest = false;
    
    public static void insertResourceAbsences(List<OperatingHoursHoliday> scope){
        if(dontRunInsertTriggerForTest != true){
            for(OperatingHoursHoliday ohh : scope){
                Database.executeBatch(new ResourceAbsenceBatch('Insert', ohh.Id, ohh.OperatingHoursId), 200);
            }
        }    
    }

    public static void deleteResourceAbsences(List<OperatingHoursHoliday> scope){
        for(OperatingHoursHoliday ohh : scope){
            Database.executeBatch(new ResourceAbsenceBatch('Delete', ohh.Id, null), 200);
        }
    }
}