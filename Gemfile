source 'https://rubygems.org'
ruby '2.2.1' #ruby '2.0.0'
gem 'rails', '4.2.5.1' #'4.1.8'
gem 'pg'
#gem 'sass-rails', '~> 4.0.3'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development

gem "haml-rails"
gem 'friendly_id', '~> 5.0.0'

# Use ActiveModel has_secure_password
#gem 'bcrypt', '~> 3.1.7'
gem 'devise'
gem 'devise-bootstrap-views'
gem 'bootstrap_form'
gem 'high_voltage', '~> 2.2.1'

gem 'fabrication'
gem 'acts_as_list'

gem 'unicorn'
gem "unicorn-rails"
gem 'sidekiq'
gem 'redis'
#gem 'activejob_backport'
gem "sinatra", "~> 1.4.5"

gem "figaro"
gem 'mailgun_rails'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'faker'
  gem 'pry'
  gem 'pry-nav'
end

group :development do
  gem 'letter_opener'
  gem 'capistrano', '~> 3.4'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-rvm', '~> 0.1.1'
  gem 'capistrano-sidekiq'
  gem 'capistrano-ssh-doctor', '~> 1.0'
  gem 'capistrano-cookbook', require: false
end

group :test do
  gem "shoulda-matchers"
end
