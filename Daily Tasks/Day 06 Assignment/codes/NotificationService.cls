public with sharing class NotificationService {

    public static void sendNotifications(
        List<Application__c> newList,
        Map<Id, Application__c> oldMap
    ) {

        for (Application__c app : newList) {

            Application__c oldApp = oldMap.get(app.Id);

            if (app.Status__c != oldApp.Status__c) {

                if (app.Status__c == 'Interview Scheduled') {
                    System.debug('Notify student: Interview Scheduled');
                }

                else if (app.Status__c == 'Selected') {
                    System.debug('Notify student: Selected');
                }

                else if (app.Status__c == 'Rejected') {
                    System.debug('Notify student: Rejected');
                }

                else if (app.Status__c == 'Offer Accepted') {
                    System.debug('Notify student: Offer Accepted');
                }
            }
        }
    }
}
