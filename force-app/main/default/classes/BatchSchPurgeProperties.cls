public with sharing class BatchSchPurgeProperties implements Database.Batchable<SObject>, Schedulable{
    //schedule functionality
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new BatchSchPurgeProperties());
    }
    //batch records query
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([select id from property__c where EndDateTime__c <=: Datetime.now().addMonths(-2) AND Status__c='Completed']);
    }
    //the real 'what to do'
    public void execute(Database.BatchableContext bc, List<Property__c> properties){
        delete properties;
    }
    //send email
    public void finish(Database.BatchableContext bc){
        //find members
        Set<Id> userIds = new Set<Id>();
        for(GroupMember gm : [SELECT UserOrGroupId FROM GroupMember WHERE Group.Name = 'Daily Job']){
            userIds.add(gm.UserOrGroupId);
        }
        Set<String> emailAddresses = new Set<String>();
        for(User us : [SELECT Email FROM User WHERE IsActive = true AND Id IN: userIds]){
            emailAddresses.add(us.Email);
        }
        //send Email to daily job public group members
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Daily Purge Property Job Completed');
        mail.setSenderDisplayName('SI Salesforce Robot');
        mail.setPlainTextBody('Daily purge property job is completed. You can check Setup --> Apex Jobs');
        mail.setHtmlBody('<p>Daily purge property job is completed. You can check Setup --> Apex Jobs</p>');
        mail.setToAddresses(new List<String>(emailAddresses));

        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
    }

}
