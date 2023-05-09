public with sharing class HandlerPropertyRealtor {
    public static void rejectDuplicatePropertyRealtor
        (List<PropertyRealtor__c> propertyRealtors) {
            Set<ID> realtorIDs = new Set<ID>();
            Set<ID> propertyIDs = new Set<ID>();
            Map<String , PropertyRealtor__c> propertyRealtorMap = new Map<String,PropertyRealtor__c>();

            for(PropertyRealtor__c eachPR: propertyRealtors) {
                realtorIDs.add(eachPR.Realtor__c);
                propertyIDs.add(eachPR.Property__c);

                string myKey = String.valueOf(eachPR.Realtor__c) + String.valueOf(eachPR.Property__c);
                propertyRealtorMap.put(myKey, eachPR);
            }
            List<PropertyRealtor__c> listPR = [select id, Property__c, Realtor__c FROM PropertyRealtor__c  WHERE Realtor__c IN :realtorIDs AND Property__c IN :propertyIDs WITH SECURITY_ENFORCED];

            for(PropertyRealtor__c es : listPR) {
                string systemKey = String.valueOf(es.Realtor__c) + String.valueOf(es.Property__c);
                PropertyRealtor__c toBeFailed = propertyRealtorMap.get(systemKey);

                if(propertyRealtorMap.containsKey(systemKey)) {
                    //if(tobeFailed != null)
                    toBeFailed.addError('This is a duplicate record of ' + es.Id);
                    //if our currentMap combines realtor and property id, which contains the exact id in our system, it will alert our system user not to generate such data repeatedly.
                }
            }
    }
}