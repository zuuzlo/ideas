require 'rails_helper'

RSpec.describe BadgerMail do
  before(:example) do
    (1..3).each do |i|
      Fabricate(:user, email: "email#{i}@1.com")
      user = User.where(email: "email#{i}@1.com").first
      (1..3).each do |j|
        Fabricate(:idea, name: "idea#{j}#{i}", status: "Active", user_id: user.id)
        idea = Idea.where(name: "idea#{j}#{i}" ).first
        (1..3).each do |k|
          status = ["Active", "Hold"]
          si = k%2
          Fabricate(:task, name: "task#{k}#{i}#{j}", user_id: user.id, status: status[si], finish_date: Time.now - 2.days)
          idea.tasks << Task.where(name: "task#{k}#{i}#{j}").first
        end
      end
    end

    (4..6).each do |i|
      Fabricate(:user, email: "email#{i}@1.com")
      user = User.where(email: "email#{i}@1.com").first
      (1..3).each do |j|
        Fabricate(:idea, name: "idea#{j}#{i}", status: "Active", user_id: user.id)
        idea = Idea.where(name: "idea#{j}#{i}" ).first
        (1..3).each do |k|
          status = ["Active", "Hold"]
          si = k%2
          Fabricate(:task, name: "task#{k}#{i}#{j}", user_id: user.id, status: status[si], finish_date: Time.now + 4.days)
          idea.tasks << Task.where(name: "task#{k}#{i}#{j}").first
        end
      end
    end

    (7..9).each do |i|
      Fabricate(:user, email: "email#{i}@1.com")
    end
  end

  describe "get_users_with_tasks" do

    it "return 6 users" do
      expect(BadgerMail.get_users_with_tasks.count).to eq(6)
    end

    it "returns an array" do
      expect(BadgerMail.get_users_with_tasks).to be_kind_of(Array)
    end

    it "returns user in array" do
       expect(BadgerMail.get_users_with_tasks.first).to be_kind_of(User)
    end
  end

  describe "get_user_overdue_tasks" do

    context "user has over due tasks" do

      it "returns array of tasks" do
        user = User.where(email: "email1@1.com").first
        expect(BadgerMail.get_user_overdue_tasks(user)).to be_kind_of(Array)
      end

      it "returns 3 tasks" do
        user = User.where(email: "email1@1.com").first
        expect(BadgerMail.get_user_overdue_tasks(user).count).to eq(3)
      end

      it "returns task in array" do
        user = User.where(email: "email1@1.com").first
        expect(BadgerMail.get_user_overdue_tasks(user).first).to be_kind_of(Task)
      end
    end

    context "user has no tasks" do

      it "returns array of tasks" do
        user = User.where(email: "email7@1.com").first
        expect(BadgerMail.get_user_overdue_tasks(user)).to be_kind_of(Array)
      end

      it "returns empty array" do
        user = User.where(email: "email7@1.com").first
        expect(BadgerMail.get_user_overdue_tasks(user).count).to eq(0)
      end
    end
  end

  describe "send_mail" do
    context "user has overdue tasks" do
      include ActiveJob::TestHelper
      
      after do
        clear_enqueued_jobs
      end

      it "queues 3 jobs" do
        expect{
         BadgerMail.send_mail
      }.to change{ enqueued_jobs.size }.by(3)
      end
    end
  end
end