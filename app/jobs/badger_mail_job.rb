class BadgerMailJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    BadgerMail.send_mail
  end
end
