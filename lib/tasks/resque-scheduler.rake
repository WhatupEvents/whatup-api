# Resque tasks
require 'resque/tasks'
require 'resque/scheduler/tasks'

import 'lib/tasks/resque.rake'

namespace :resque do

  task :setup_schedule => :setup do
    require 'resque-scheduler'

    # If you want to be able to dynamically change the schedule,
    # uncomment this line.  A dynamic schedule can be updated via the
    # Resque::Scheduler.set_schedule (and remove_schedule) methods.
    # When dynamic is set to true, the scheduler process looks for
    # schedule changes and applies them on the fly.
    # Note: This feature is only available in >=2.0.0.
    # Resque::Scheduler.dynamic = true

    Resque.schedule = YAML.load_file(Rails.root.join('config/resque_schedule.yml'))

    # If your schedule already has +queue+ set for each job, you don't
    # need to require your jobs.  This can be an advantage since it's
    # less code that resque-scheduler needs to know about. But in a small
    # project, it's usually easier to just include you job classes here.
    # So, something like this:
  end

  task :scheduler => :setup_schedule
end