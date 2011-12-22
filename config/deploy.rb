set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
require 'yaml'

set :backup_database_before_migrations, false
set :disable_web_during_migrations,     false
set :build_gems,                        false
set :tag_on_deploy,                     false
set :cleanup_on_deploy,                 true
set :compress_assets,                   false


namespace :deploy do

  [ :stop, :start, :restart ].each do |t|
    desc "#{t.to_s.capitalize} the pasenger server"
    task t, :roles => :app do
      run "touch #{current_release}/tmp/restart.txt"
    end
  end

  desc "Link shared files"
  #task :before_symlink do
  before :symlink do
    # public/uploads
    #run "rm -drf #{release_path}/public/uploads"
    #run "ln -s #{shared_path}/uploads #{release_path}/public/uploads"
    #run "rmdir #{current_release}/public/assets" # remove the folder present for development 
    #run "ln -s #{deploy_to}/#{shared_dir}/assets #{current_release}/public"
    
    # vendor/radiant
    #run "rm -drf #{release_path}/vendor/radiant"
    #run "ln -s #{shared_path}/radiant #{release_path}/vendor/radiant"
    #run "rm -f #{release_path}/config/database.yml"
    #run "ln -s #{shared_path}/database.yml #{release_path}/config/database.yml"
  end
end
=begin
namespace :update do
  desc "Dump remote production database into tmp/, rsync file to local machine, import into local development database"
  task :database do 
    # First lets get the remote database config file so that we can read in the database settings
    get("#{shared_path}/config/database.yml", "tmp/database.yml")
 
    # load the production settings within the database file
    remote_settings = YAML::load_file("tmp/database.yml")["production"]
 
    # we also need the local settings so that we can import the fresh database properly
    local_settings = YAML::load_file("config/database.yml")["development"]
 
    # dump the production database and store it in the current path's tmp directory. I chose to use the same filename everytime so that it would just overwrite the same file rather than creating a timestamped file.  If you want to use this to create backups then I would recommend putting something like Time.now in the filename and not storing it in the tmp directory
    run "mysqldump -u\"#{remote_settings["username"]}\" -p\"#{remote_settings["password"]}\" -h\"#{remote_settings["host"]}\" \"#{remote_settings["database"]}\" > #{current_path}/tmp/production-#{remote_settings["database"]}-dump.sql"
 
  # If your database is large you might want to bzip it up and then extract it later
 
    # run_locally is a method provided by capistrano to run commands on your local machine. Here we are just rsyncing the remote database dump with the local copy of the dump
    run_locally("rsync --times --rsh=ssh --compress --human-readable --progress #{user}@#{shared_host}:#{current_path}/tmp/production-#{remote_settings["database"]}-dump.sql tmp/production-#{remote_settings["database"]}-dump.sql")
 
    # now that we have the upated production dump file we should use the local settings to import this db.  
    run_locally("mysql -u#{local_settings["username"]} #{"-p#{local_settings["password"]}" if local_settings["password"]} #{local_settings["database"]} < tmp/production-#{remote_settings["database"]}-dump.sql")
  end
end
=end