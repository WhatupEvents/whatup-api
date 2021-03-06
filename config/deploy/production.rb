host = '18.224.34.179'
environment = 'production'

role :app, [host]
role :web, [host]
role :db,  host

set :branch, 'master'
set :rails_env, environment
set :stage, environment

#role :resque_worker, [ host ]
#role :resque_scheduler, [ host ]

set :default_environment, 'RAILS_ENV' => environment
set :application, host

set :use_sudo, true
set :ssh_options, keys: ['~/.ssh/whatupnewsandevents.pem'], forward_agent: true, user: 'ec2-user'

why_here = "/var/www/#{host}"
unicorn_pid = "#{why_here}/current/tmp/pids/unicorn.pid"
unicorn_conf = "#{why_here}/shared/config/unicorn.rb"

namespace :deploy do
  task :start do               
    on roles(:app) do          
      execute "cd #{why_here}/current && "\
      "bundle exec unicorn_rails -E #{environment} -c #{unicorn_conf} -D"
    end
  end

  task :stop do                
    on roles(:app) do          
      execute "sudo kill -QUIT $(cat #{unicorn_pid})"
    end
  end

  task :restart do             
    on roles(:app) do          
      execute "kill -USR2 $(cat #{unicorn_pid})"
    end
  end
end

namespace :assets do
  task :compile do
    on roles(:app) do
      # execute "cd #{why_here}/current && "\
      # "bundle exec rake assets:precompile"
    end
  end
end


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

# server 'example.com', user: 'deploy', roles: %w{web app}, my_property: :my_value


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
