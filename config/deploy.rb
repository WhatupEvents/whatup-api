# config valid only for Capistrano 3.1
lock '3.6.1'

set :application, 'whatup'
set :repo_url, 'git@github.com:fellou89/whatup-api.git'

set :resque_environment_task, true
set :workers, messages: 1

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

set :ssh_options, keys: ['~/.ssh/whatup.pem'], forward_agent: true, user: 'ubuntu'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

namespace :resque do
  task :setup_schedule => :setup do
    require 'resque-scheduler'

    Resque.schedule = YAML.load_file('config/resque_schedule.yml')
  end

  task :scheduler => :setup_schedule
end

after "deploy", "resque:restart"
after "resque:restart", "resque:scheduler"
