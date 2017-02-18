# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'
require 'capistrano/safe_deploy_to'
require 'capistrano/unicorn_nginx'

require "capistrano-resque"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# needed for staging only
# require 'capistrano/rvm'

# needed for production only
require 'rvm1/capistrano3'

require 'capistrano/rails/migrations'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }

task :query_interactive do
  on 'ubuntu@54.146.179.63' do
    info capture("[[ $- == *i* ]] && echo 'Interactive' || echo 'Not interactive'")
  end
end
task :query_login do
  on 'ubuntu@54.146.179.63' do
    info capture("shopt -q login_shell && echo 'Login shell' || echo 'Not login shell'")
  end
end
