public with sharing class AlumniService {

    public static void sendStudentDetails(
        List<Application__c> newList,
        Map<Id, Application__c> oldMap
    ) {

        for (Application__c app : newList) {

            Application__c oldApp = oldMap.get(app.Id);

            if (app.Status__c == 'Offer Accepted' &&
                oldApp.Status__c != 'Offer Accepted') {

                System.debug('Sending student details to Alumni Office: ' + app.Id);

                // Future logic:
                // Create Alumni record
                // Send Email
                // Notify Alumni Office

            }
        }
    }
}
