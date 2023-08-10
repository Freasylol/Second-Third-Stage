public with sharing class CreateApexBatchScheduler {
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
        }
        return '';
    }

    @AuraEnabled(cacheable=false)
    public static void abortApexSchedulable(String jobId) {
        CronTrigger obj = [
            SELECT Id, CronJobDetail.Name
            FROM CronTrigger
            WHERE Id=:jobId
        ];
        System.abortJob(obj.Id);
    }

    public static void checkJobStatus()
    {   
        System.debug('test Check Job');
    }
}