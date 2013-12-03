require "bundler/capistrano"

set :application, "mochi"
set :repository,  "https://github.com:rubenjohne/mochi.git"
set :deploy_to, "/u/apps/#{application}"
set :scm, :git

set :user, "vagrant"
set :branch, "master"
set :deploy_type, 'deploy'
set :use_sudo, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".vagrant.d", "insecure_private_key")]

role :app, "mochi.dev"
role :web, "mochi.dev"
role :db,  "mochi.dev", :primary => true

after "deploy:setup" do
  deploy.fast_git_setup.clone_repository
  run "cd #{current_path} && bundle install"
end

namespace :unicorn do
  desc "Start unicorn for this application"
  task :start do
    run "cd #{current_path} && bundle exec unicorn -c /etc/unicorn/mochi.conf.rb -D"
  end
end

namespace :deploy do
  task :symlink do
  # no-op to remove default symlink task, not needed by fast_git_deploy
  end
end