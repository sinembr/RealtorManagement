@isTest
private class TestBatchSchPurgeProperties {
    @isTest
    static void testMethod1() {
        Manager__c managerR = new Manager__c( Name = 'Test Manager', Email__c = 'testmanageremail@test.com', Phone__c = '11111111111');
        insert managerR;

        List<Property__c> properties = new List<Property__c>();
        for(Integer i=0; i<200; i++) {
            properties.add(new Property__c(Manager__c = managerR.Id,  Name__c = 'Test Property ' + String.valueOf(i), StartDateTime__c = Datetime.now().addMonths(-3), EndDateTime__c = Datetime.now().addMonths(-3).addDays(1).addMinutes(1) , Prerequisites__c = true));
        }
        insert properties;

        Test.startTest();
        BatchSchPurgeProperties obj = new BatchSchPurgeProperties();
        obj.execute(null);
        Test.stopTest();

        Integer propertyCount = [Select COUNT() FROM Property__c];
        System.assertNotEquals(199, propertyCount);
     }
}
