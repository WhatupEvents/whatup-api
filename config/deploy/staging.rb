host = 'www.dainbramaged.me'
directory = 'staging.whatsup.com'
environment = 'staging'

role :app, [host]
role :web, [host]
role :db,  [host]

set :branch, environment
set :rails_env, environment
set :stage, environment

set :default_environment, 'RAILS_ENV' => environment
set :application, host
set :deploy_to, "/srv/www/#{host}"

deploy_to = "/srv/www/#{directory}"
unicorn_pid = "#{deploy_to}/unicorn.pid"
unicorn_conf = "/etc/unicorn/#{directory}.rb"

namespace :deploy do
  task :start do               
    on roles(:app) do          
      execute "cd /srv/www/#{host}/current && "\
      "unicorn_rails -E #{environment} -c #{unicorn_conf} -D"
    end
  end

  task :stop do                
    on roles(:app) do          
      execute "sudo kill -QUIT $(cat #{unicorn_pid)})"
    end
  end

  task :restart do             
    on roles(:app) do          
      execute "kill -USR2 $(cat /srv/www/#{directory}/unicorn.pid)"
    end
  end
end

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
