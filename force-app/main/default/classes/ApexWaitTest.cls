@IsTest
public class ApexWaitTest {
    @IsTest
    static void addDelayTest(){
        Long startTime = DateTime.now().getTime();
        try{
            ApexWait.addDelay(5000);
        } catch (Exception e){
            System.debug('-- ApexWaitTest - Error Occured: '+e.getMessage()); 
        }       
        Long finishTime = DateTime.now().getTime();
		System.Debug('-- ApexWaitTest - Delayed '+ (finishTime - startTime));
        System.AssertNotEquals(finishTime,startTime);
    }
}