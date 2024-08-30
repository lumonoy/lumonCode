public with sharing class MultiSelectFlowValues {
    @InvocableMethod
    public static List<List<String>> CheckValues(List<String> values) {
        if (!(values.isEmpty())) {
            String tempStr = values[0];
            List<String> lstNew = tempStr.split(';');
            List<List<String>> finalLst = new List<List<String>>();
            finalLst.add(lstNew);
            return finalLst;
        }
        else return null;
    }
}