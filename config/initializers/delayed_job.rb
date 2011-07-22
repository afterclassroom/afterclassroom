Delayed::Worker.destroy_failed_jobs = true
Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.backend = :active_record
worker = Delayed::Worker.new(:max_priority => nil, 
                             :min_priority => nil,
                             :quiet => true
)
worker.work_off