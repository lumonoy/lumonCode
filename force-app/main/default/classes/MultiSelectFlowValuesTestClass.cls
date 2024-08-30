@IsTest
public class MultiSelectFlowValuesTestClass{
    @IsTest
    static void MultiSelectFlowValuesTest(){
        List<String> tempLst = new List<String>();
        tempLst.add('AccidentalCoder');
        tempLst.add('Salesforce');
        MultiSelectFlowValues.CheckValues(tempLst);
    }
}