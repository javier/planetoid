set :application, "planeta"
set :repository,  "git@github.com:javier/planetoid.git"
set :scm, "git"
set :user, "#{application}"
ssh_options[:config] = false
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :use_sudo, false
set :keep_releases, 2
set :rails_env, "production"

set :deploy_via, :export
set :deploy_to, "/home/#{user}/app"

role :app, "megatron.aspgems.com"
role :web, "megatron.aspgems.com"
role :db,  "megatron.aspgems.com", :primary => true

files=%w(database.yml planetoid.yml)
dirs=%w(config)
after "deploy:update","deploy:symlink_config"
after "deploy:setup","deploy:create_dirs"

# Here comes the app config


namespace :deploy do

  task :symlink_config, :roles => :app do
    files.each do |f|
      run "ln -nfs #{shared_path}/config/#{f} #{release_path}/config/#{f}"
    end
  end

  task :restart, :roles => :app do
    run "touch  #{current_path}/tmp/restart.txt"
  end

  task :create_dirs, :roles => :app do
    dirs.each do |d|
      run "mkdir -p #{shared_path}/#{d}"
    end
  end

  desc "Enables maintenance mode in the app"
  task :maintenance_on, :roles => :app do
    run "cp current/public/system/maintenance.html.disabled current/public/system/maintenance.html"
  end

  desc "Disables maintenance mode in the app"
  task :maintenance_off, :roles => :app do
    run "rm current/public/system/maintenance.html"
  end
end

# Here comes the application namespace for custom tasks

namespace application do

end

