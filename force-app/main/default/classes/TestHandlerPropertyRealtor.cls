@isTest
public with sharing class TestHandlerPropertyRealtor {
    @TestSetup
    static void prepareData(){
        Manager__c managerR = new Manager__c( Name = 'Test Manager', Email__c = 'testmanageremail@test.com', Phone__c = '11111111111');
        insert managerR;

        Property__c property = new Property__c(Manager__c = managerR.Id, Name__c = 'Test Property', StartDateTime__c = Datetime.now().addDays(1), Prerequisites__c = true);
        insert property;

        Realtor__c realtor = new Realtor__c(Name = 'Test Realtor', Email__c = 'testrealtoremail@test.com', Phone__c = '2222222222');
        insert realtor;

        PropertyRealtor__c propertyRealtor = new PropertyRealtor__c();
        propertyRealtor.Property__c = Property.Id;
        propertyRealtor.Realtor__c = Realtor.Id;
        insert propertyRealtor;
    }
    @isTest
    static void testSuccess(){
        List<PropertyRealtor__c> systemRecord = [select Property__c, Realtor__c FROM PropertyRealtor__c LIMIT 1];

        Test.startTest();
        HandlerPropertyRealtor.rejectDuplicatePropertyRealtor(systemRecord);
        // try {
        //     insert new PropertyRealtor__c(Property__c = systemRecord.Property__c, Realtor__c = systemRecord.Realtor__c);
        // } catch (Exception exc) {
        // }
        Test.stopTest();
        System.assertEquals(1, systemRecord.size(),' ');

        // Integer systemCount = [select COUNT() from PropertyRealtor__c];
        // System.assertEquals(1, systemCount);
    }
    @isTest
    static void testNegative(){
        delete [select id from PropertyRealtor__c];
        Property__c property =[select id from Property__c limit 1];
        Realtor__c realtor = [select id from Realtor__c limit 1];
        PropertyRealtor__c listProperty = new PropertyRealtor__c(Property__c = property.id, Realtor__c=realtor.id);
            // insert listProperty;
        Test.startTest();
        // insert new PropertyRealtor__c(Property__c = event.id,
        //                             Realtor__c=realtor.id
        //                             );
        insert listProperty;
        test.stopTest();
        integer count = [select count() from PropertyRealtor__c];
        system.assertEquals(1, count,'');
    }
}
