trigger PropertyRealtorTrigger on PropertyRealtor__c (before insert, before update) {
  if(Trigger.isBefore) {
    if(Trigger.isInsert || Trigger.isUpdate) {
      HandlerPropertyRealtor.rejectDuplicatePropertyRealtor(Trigger.new);
    }
  }
}