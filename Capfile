# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
require 'capistrano/rvm'
#require 'capistrano/rbenv'
require 'capistrano/console'
# require 'capistrano/chruby'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/ssh_doctor'
require 'capistrano/rails/console'
#require 'capistrano/cookbook'

require 'capistrano/cookbook/check_revision'
require 'capistrano/cookbook/compile_assets_locally'
require 'capistrano/cookbook/create_database'
require 'capistrano/cookbook/logs'
#require 'capistrano/cookbook/monit'
require 'capistrano/cookbook/nginx'
require 'capistrano/cookbook/restart'
require 'capistrano/cookbook/run_tests'
require 'capistrano/cookbook/setup_config'
# require 'capistrano/passenger'
require 'capistrano/sidekiq'

# Load custom tasks from `lib/capistrano/tasks' if you have any defined
#Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
Dir.glob('lib/capistrano/**/*.rb').each { |r| import r }