public with sharing class HelperErrorLog {
    public static void createdErrorLog(String processName, String logDetails) {
        insert new ErrorLog__c(LogDateTime__c = Datetime.now(), ProcessName__c = processName, LogDetails__c = logDetails);
    }
}
