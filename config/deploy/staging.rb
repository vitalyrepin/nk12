set :application, "test.nk12.su"

set :host, "nk12.su"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

set :use_sudo, false
set :deploy_to, "/home/nk12/data/www/#{application}"

# SVN and Auth
set :scm, :git
set :repository, "git@github.com:jesteracer/nk12.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :user, 'nk12'
ssh_options[:username] = 'nk12'


set :rails_env,      "staging"


# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "nk12.su"
role :web, "nk12.su"
role :db,  "nk12.su", :primary => true

#set :asset_directories, ['public/assets']

