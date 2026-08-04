trigger ApplicationTrigger on Application__c (before insert, after update) {

    if (Trigger.isBefore && Trigger.isInsert) {
        ApplicationService.validateApplications(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        StatisticsService.updatePlacementStatistics(
            Trigger.new,
            Trigger.oldMap
        );

        NotificationService.sendNotifications(
            Trigger.new,
            Trigger.oldMap
        );

        AlumniService.sendStudentDetails(
            Trigger.new,
            Trigger.oldMap
        );
    }
}
