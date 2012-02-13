set :stages, %w(acceptance production)
require 'capistrano/ext/multistage'

set :application, "node"
set :user, "ubuntu"
set :host, "ec2-127-0-0-1.compute-1.amazonaws.com"
set :deploy_to, "/var/www/node"
set :use_sudo, true

set :scm, :git
set :repository, "git@github.com:your/repo.git"
set :branch, "development"

set :deploy_via, :remote_cache
role :app, host

set :bluepill, '/var/lib/gems/1.8/bin/bluepill'

default_run_options[:pty] = true

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo :as => 'root'} #{bluepill} start #{application}"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo :as => 'root'} #{bluepill} stop #{application}"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo :as => 'root'} #{bluepill} restart #{application}"
  end

  task :create_deploy_to_with_sudo, :roles => :app do
    run "#{try_sudo :as => 'root'} mkdir -p #{deploy_to}"
  end

  task :npm_install, :roles => :app, :except => { :no_release => true } do
    run "cd #{release_path} && npm install"
  end
end

before 'deploy:setup', 'deploy:create_deploy_to_with_sudo'
after 'deploy:finalize_update', 'deploy:npm_install'