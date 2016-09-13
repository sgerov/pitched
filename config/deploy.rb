# config valid only for Capistrano 3.1
lock '3.4.0'
# require "amoeba_deploy_tools/capistrano"

set :application, 'pitched'
set :rails_env, 'production'
set :repo_url, 'git@github.com:savayg/pitched.git'

set :config_path,   '/home/pitched/shared/config'
set :deploy_to,     '/home/pitched'

set :ssh_options, forward_agent: true

# Default value for :linked_files is []
set :linked_files, %w(config/database.yml config/unicorn.rb .env)

set :linked_dirs, %w(public/uploads)

SSHKit.config.command_map[:rake]  = 'bundle exec rake' # 8
SSHKit.config.command_map[:rails] = 'bundle exec rails'

namespace :deploy do
  init_script = '/home/pitched/shared/init/pitched'
  desc 'Restart application'
  task :restart do
    on roles(:app) do
      # execute "#{init_script} upgrade" # soft restart - sometimes creates missing template errors
      execute "#{init_script} stop"

      # within current_path do
      #   with rails_env: fetch(:rails_env) do
      #     rake 'resque:restart_workers'
      #   end
      # end
    end
  end

  # desc "Gracefully kill the unicorn process"
  # task :stop, :roles => :app, :except => { :no_release => true } do
  #  run "#{init_script} stop"
  # end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  before :finishing, :create_symlinks do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          # rake 'sitemap:create_symlinks'
        end
      end
    end
  end

  # after 'deploy:updated', 'newrelic:notice_deployment'
end
