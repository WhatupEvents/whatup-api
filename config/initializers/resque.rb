require 'resque/server'

Resque::Server.use(Rack::Auth::Basic) do |_user, password|
  password == ENV['RESQUE_ADMIN_PASSWORD']
end
