God.watch do |w|
  w.name = "solr-production"
  w.group = "solr-production"
  w.interval = 30.seconds
  w.start = "/sbin/service solr.production start"
  w.stop = "/sbin/service solr.production stop"
  w.restart = "/sbin/service solr.production restart"
  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = "/var/run/solr.production.pid"
  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end

  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 1024.megabytes
      c.times = [3,5] #3 out of 5 intervals
    end

    restart.condition(:cpu_usage) do |c|
      c.above = 25.percent
      c.times = 5
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitor
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end