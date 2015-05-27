require 'resque/tasks'
require 'resque/scheduler/tasks'

task 'resque:setup' => :environment do
  Resque.before_first_fork = Proc.new { 
    Rails.application.eager_load!
  }

Resque.before_fork = Proc.new { 
    ActiveRecord::Base.establish_connection

    # Open the new separate log file
    logfile = File.open(File.join(Rails.root, 'log', 'resque.log'), 'a')

    # Activate file synchronization
    logfile.sync = true

    Resque.redis.namespace = "resque:stuff:#{Rails.env}"

    # Create a new buffered logger
    Resque.logger = ActiveSupport::Logger.new(logfile)
    Resque.logger.level = Logger::INFO
    Resque.logger.formatter = Logger::Formatter.new
  }
end
