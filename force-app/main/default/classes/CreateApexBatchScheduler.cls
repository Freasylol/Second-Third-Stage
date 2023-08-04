public with sharing class CreateApexBatchScheduler {
    public CreateApexBatchScheduler() {
      
    }

    @AuraEnabled(cacheable=true)
    public static void createApexBatchable(String className) {
        Type t = Type.forName(className);
        if (t != null) {
            Database.Batchable<Object> batchInstance = (Database.Batchable<Object>)t.newInstance();
            String jobId = Database.executeBatch(batchInstance);
            AsyncApexJob job = [
                SELECT Id, ApexClass.Name, Status
                FROM AsyncApexJob
                WHERE Id=:jobId
            ];
            Boolean a = true;   
        } else {
        }
    }

    @AuraEnabled(cacheable=true)
    public static String createApexSchedulable(String className, String cronString) {
        String jobName = 'Schedule Contact Birthday';
        String cronExpr = cronString;

        Type t = Type.forName(className);
        if (t != null) {
            Schedulable batchInstance = (Schedulable)t.newInstance();
            String jobId = System.schedule(jobName, cronExpr, batchInstance);
            return jobId;
        } else {
        }
        return '';
    }

    @AuraEnabled(cacheable=false)
    public static void abortApexSchedulable(String jobName) {
        CronTrigger obj = [
            SELECT Id, CronJobDetail.Name
            FROM CronTrigger
            WHERE Id=:jobName
        ];
        System.abortJob(obj.Id);
    }
}