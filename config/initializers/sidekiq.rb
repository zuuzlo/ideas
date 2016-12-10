require 'sidekiq/web'

Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://localhost:6379/0', namespace: "sidekiq_ideas_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://localhost:6379/0', namespace: "sidekiq_ideas_#{Rails.env}" }
end

Sidekiq::Web.set :session_secret, Rails.application.secrets.secret_key_base

schedule_file = "config/schedule.yml"

if File.exists?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end