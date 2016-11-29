set :application, 'ideas'
set :deploy_user, 'deploy' # added


# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
set :scm, :git
set :repo_url, 'git@github.com:zuuzlo/ideas.git'

# setup rvm.
set :rvm_type, :user                     # Defaults to: :auto
#set :rvm_ruby_version, '2.2.1-p85'      # Defaults to: 'default'
#set :rvm_custom_path, '~/.rvm'  # only needed if not detected

# Default value for :format is :pretty
set :format, :pretty
#set :format, :simpletext

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
# Default value for :linked_files is []
#set :linked_files, fetch(:linked_files, []).push('config/database.yml')
set :linked_files, %w{config/database.yml config/application.yml}

# dirs we want symlinking to shared
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
#start adding here 11-19-2016
# Defaults to :db role
set :migration_role, :db

# Defaults to the primary :db server
set :migration_servers, -> { primary(fetch(:migration_role)) }

# Defaults to false
# Skip migration if files in db/migrate were not modified
set :conditionally_migrate, true

# Defaults to [:web]
set :assets_roles, [:web, :app]

# Defaults to 'assets'
# This should match config.assets.prefix in your rails config/application.rb
#set :assets_prefix, 'prepackaged-assets'

# If you need to touch public/images, public/javascripts, and public/stylesheets on each deploy
set :normalize_asset_timestamps, %w{public/images public/javascripts public/stylesheets}
#ended adding here 11-19-2016

# Default value for keep_releases is 5
set :keep_releases, 3

set :pty, false

set(:config_files, %w(
  nginx.conf
  unicorn.rb
  unicorn_init.sh
))



set(:symlinks, [
  {
    source: "nginx.conf",
    link: "/etc/nginx/sites-enabled/#{fetch(:full_app_name)}"
  },
  {
    source: "unicorn_init.sh",
    link: "/etc/init.d/unicorn_#{fetch(:full_app_name)}"
  }
])

set(:executable_config_files, %w(
  unicorn_init.sh
))

after 'deploy:setup_config', 'nginx:reload'

namespace :deploy do

  # make sure we're deploying what we think we're deploying
  before :deploy, "deploy:check_revision"
  # only allow a deploy with passing tests to deployed
  #before :deploy, "deploy:run_tests"
  
  after :finishing, 'deploy:cleanup'

  # remove the default nginx configuration as it will tend
  # to conflict with our configs.
  #before 'deploy:setup_config', 'nginx:remove_default_vhost'

  # reload nginx to it will pick up any modified vhosts from
  # setup_config
  after 'deploy:setup_config', 'nginx:reload'

  # Restart monit so it will pick up any monit configurations
  # we've added
  #after 'deploy:setup_config', 'monit:restart'

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  after 'deploy:publishing', 'deploy:restart'
  after 'deploy:publishing', 'sidekiq:restart'
=begin
  Rake::Task['deploy:assets:backup_manifest'].clear_actions
  namespace :deploy do
    namespace :assets do
      task :backup_manifest do
        on roles(fetch(:assets_roles)) do
          within release_path do
            execute :cp,
                    release_path.join('public', fetch(:assets_prefix), '.sprockets-manifest*'),
                    release_path.join('assets_manifest_backup')
          end
        end
      end
    end
  end
=end
  desc 'Runs rake db:seed'
  task :seed => [:set_rails_env] do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:seed"
        end
      end
    end
  end
end

namespace :rails do
  desc "Open the rails console on each of the remote servers"
  task :console => 'rvm:hook' do
    on roles(:app), :primary => true do |host|
      rails_env = fetch(:stage)
      execute_interactively host, "console #{rails_env}"
    end
  end

  desc "Open the rails dbconsole on each of the remote servers"
  task :dbconsole => 'rvm:hook' do
    on roles(:app), :primary => true do |host|
      rails_env = fetch(:stage)
      execute_interactively host, "dbconsole #{rails_env}"
    end
  end

  def execute_interactively(host, command)
    command = "cd #{fetch(:deploy_to)}/current && #{SSHKit.config.command_map[:bundle]} exec rails #{command}"
    puts command if fetch(:log_level) == :debug
    exec "ssh -l #{host.user} #{host.hostname} -p #{host.port || 22} -t '#{command}'"
  end
end
