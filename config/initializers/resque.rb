#require 'resque/server'
#require 'resque-scheduler'

# Resque::Server.use(Rack::Auth::Basic) do |_user, password|
#   password == ENV['RESQUE_ADMIN_PASSWORD']
# end
# 
# # Resque.schedule = YAML.load_file('config/resque_schedule.yml')
# 
# unless Rails.application.config.cache_classes
#   Resque.after_fork do |job|
#     ActionDispatch::Reloader.cleanup!
#     ActionDispatch::Reloader.prepare!
#   end
# end
