require "rails_helper"

RSpec.describe BadgerMailer, type: :mailer do
  include ActiveJob::TestHelper
  before { ActionMailer::Base.deliveries = [] }
  let(:user1) { Fabricate(:user) }
  let(:task1) { Fabricate(:task) }

  it 'job is created' do
    expect {
        BadgerMailer.overdue_tasks_email(user1, task1).deliver_later
    }.to have_enqueued_job.on_queue('mailers')
end

  it "should send badger mail" do
    expect {
      perform_enqueued_jobs do
        BadgerMailer.overdue_tasks_email(user1, task1).deliver_later
      end
    }.to change{ ActionMailer::Base.deliveries.size }.by(1)
  end

  it 'badger mail is sent to the right user' do
    perform_enqueued_jobs do
      BadgerMailer.overdue_tasks_email(user1, task1).deliver_later
    end

    mail = ActionMailer::Base.deliveries.last
    expect(mail.to[0]).to eq user1.email
  end
end
