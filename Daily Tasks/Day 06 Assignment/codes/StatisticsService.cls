public with sharing class StatisticsService {

    public static void updatePlacementStatistics(
        List<Application__c> newList,
        Map<Id, Application__c> oldMap
    ) {

        for (Application__c app : newList) {

            Application__c oldApp = oldMap.get(app.Id);

            if (app.Status__c == 'Selected' &&
                oldApp.Status__c != 'Selected') {

                System.debug('Placement statistics updated for: ' + app.Id);

                // Add your statistics update logic here

            }
        }
    }
}
