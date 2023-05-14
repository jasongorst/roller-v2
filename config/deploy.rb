# frozen_string_literal: true

require 'mina/git'
require 'mina/bundler'
require 'mina/rbenv' # for rbenv support. (https://rbenv.org)
require 'mina/deploy'

require 'net/scp'
require 'dotenv/load'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'roller-v2'
set :domain, ENV['DOMAIN']
set :deploy_to, ENV['DEPLOY_TO']
set :repository, 'https://github.com/jasongorst/roller-v2.git'
set :branch, 'main'

# Optional settings:
set :user, ENV['SSH_USER'] # Username in the server to SSH to.
set :port, ENV['SSH_PORT'] # SSH port number.
set :forward_agent, true # SSH forward_agent.

set :rbenv_path, '/usr/local/rbenv'

set :version_scheme, :datetime

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
set :shared_dirs, fetch(:shared_dirs, []).push('log')
set :shared_files, fetch(:shared_files, []).push('.env.production')

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  invoke :'rbenv:load'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  # command %{rbenv install 2.5.3 --skip-existing}
  # command %{rvm install ruby-2.5.3}
  # command %{gem install bundler}
end

desc 'Deploys the current version to the server.'
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  invoke :'git:ensure_pushed'

  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :upload_dotenv
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :restart
    end
  end
end

desc 'Restarts the service on the server.'
task :restart do
  in_path(fetch(:current_path)) do
    command %(/usr/bin/passenger-config restart-app `pwd` --ignore-app-not-running)
  end
end

desc 'Upload .env files.'
task :upload_dotenv do
  Net::SCP.start(fetch(:domain), fetch(:user), port: fetch(:port)) do |scp|
    scp.upload! '.env.production', fetch(:shared_path)
  end
end
