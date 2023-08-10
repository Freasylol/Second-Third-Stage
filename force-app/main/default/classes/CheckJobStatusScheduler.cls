global class CheckJobStatusScheduler implements Schedulable {
    public CheckJobStatusScheduler() {

    }

    global void execute(SchedulableContext sc) {
        CreateApexBatchScheduler.checkJobStatus();
    }
    
    public static String scheduleJob() {
        CheckJobStatusScheduler scheduler = new CheckJobStatusScheduler();
        String jobID = System.schedule('TestJob', '0 51 * * * ?', scheduler);
        return jobID;
    }
}