require 'resque/server'

Resque::Server.use(Rack::Auth::Basic) do |_user, password|
  password == ENV['RESQUE_ADMIN_PASSWORD']
end

unless Rails.application.config.cache_classes
  Resque.after_fork do |job|
    ActionDispatch::Reloader.cleanup!
    ActionDispatch::Reloader.prepare!
  end
end
