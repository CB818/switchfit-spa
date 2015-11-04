set :stages,        %w(production staging development)
set :default_stage, "development"
set :stage_dir,     "config/deploy"
require 'capistrano/ext/multistage'

default_run_options[:pty] = true

set :user,                          "deployer"
set :use_sudo,                      false
set :shared_children,               []
set :asset_children,                []
set :normalize_asset_timestamps,    false

set :application,       "switchfit"
set :deploy_to,         "/srv/www/switchfit-spa"

set :repository,        "git@gitlab.com:switchfit/switchfit-spa.git"
set :scm,               :git

set :admin_runner,      "git"
set :keep_releases,     3

logger.level = Logger::MAX_LEVEL

before "deploy:finalize_update", "deploy:npm_install"
after "deploy:npm_install", "deploy:bower_install"
after "deploy:bower_install", "deploy:grunt_build"

namespace :deploy do
    desc "NPM Install"
    task :npm_install, :roles => :app, :except => { :no_release => true } do
        puts "--> Npm install"

        run "#{try_sudo} sh -c 'cd #{latest_release} && npm install'"
    end

    desc "Bower Install"
    task :bower_install, :roles => :app, :except => { :no_release => true } do
        puts "--> Bower install"

        run "#{try_sudo} sh -c 'cd #{latest_release} && bower install --quiet --config.interactive=false'"
    end

    desc "Grunt Build"
    task :grunt_build, :roles => :app, :except => { :no_release => true } do
        puts "--> Grunt build"

        run "#{try_sudo} sh -c 'cd #{latest_release} && grunt build'"
    end
end