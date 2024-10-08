public class ApexWait {
    public static void addDelay(Integer millisec) {
        Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();
        Long delta = finishTime - startTime;
        System.debug('ApexWait - delay Start: '+startTime); 
        while ((delta) < millisec) {
            finishTime = DateTime.now().getTime();
            delta = finishTime - startTime;
            //sleep for parameter x millisecs      
        }
        System.debug('--- ApexWait - delay End: '+finishTime); 
        System.debug('--- ApexWait - delayed: '+delta);  
    }
}