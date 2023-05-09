@RestResource(urlMapping='/property-details/*')
global with sharing class WsPropertyDetails {
    @HttpGet
    global static List<PropertyDetail> getEventDetails() {
        List<PropertyDetail> details = new List<PropertyDetail>();
        for(Property__c prop : [Select Id, Name, PropertyType__c, Prerequisites__c, StartDateTime__c, EndDateTime__c
        FROM Property__c
        WHERE Prerequisites__c=TRUE
        AND StartDateTime__c >: Date.today()
        WITH SECURITY_ENFORCED ]){
            details.add(new PropertyDetail(prop));
        }
        return details;
    }
    global class PropertyDetail {
        //customize the respond body
        public String propertyId;
        public String name;
        public String propertyType;
        public Boolean prerequisites;
        public String startDate;
        public String endDate;

        public PropertyDetail(Property__c prop) {
            this.propertyId = prop.Id;
            this.name = prop.Name;
            this.propertyType = prop.PropertyType__c;
            this.prerequisites = prop.Prerequisites__c;
            this.startDate = prop.StartDateTime__c?.format('yyyy-MM-dd hh:MM');
            this.endDate = prop.EndDateTime__c?.format('yyyy-MM-dd hh:MM');
        }
    }
}

