require 'spec_helper'

class FakesController < ApplicationController
  include LoadChildren
end

describe FakesController do

  let(:user1) { Fabricate(:user) }
  let(:ideap) { Fabricate(:idea, user_id: user1.id) }
  let(:taskp) { Fabricate(:task, user_id: user1.id) }
  let(:notep) { Fabricate(:note, user_id: user1.id) }
  let(:idea_linkp) { Fabricate(:idea_link, user_id: user1.id) }

  (1..3).each do |i|
    let("task#{i}".to_sym) { Fabricate(:task, name: "task#{i}", user_id: user1.id) }
    let("note#{i}".to_sym) { Fabricate(:note, title: "note#{i}", user_id: user1.id) }
    let("idea_link#{i}".to_sym) { Fabricate(:idea_link, name: "Idea Link#{i}", user_id: user1.id) }
  end
  
  context "defines new children" do
    before { subject.load_children(taskp) }
    
    it "@note is a Note" do  
      expect(assigns(:note)).to be_a Note
    end

    it "@task is a Task" do
      expect(assigns(:task)).to be_a Task
    end

    it "@idea_link is a IdeaLink" do
      expect(assigns(:idea_link)).to be_a IdeaLink
    end
  end

  context "parent is a idea" do
    before do
      ideap.tasks << [task1, task2, task3]
      ideap.notes << [note1, note2, note3]
      ideap.idea_links << [idea_link1, idea_link2, idea_link3]
      subject.load_children(ideap)
    end

    it "loads children tasks into @tasks" do
      expect(assigns(:tasks)).to match_array([task1, task2, task3])
    end

    it "loads children notes into @notes" do
      expect(assigns(:notes)).to match_array([note1, note2, note3])
    end

    it "loads children idea_links into @idea_links" do
      expect(assigns(:idea_links)).to match_array([idea_link1, idea_link2, idea_link3])
    end

  end
  context "parent is a task" do
    before do
      taskp.tasks << [task1, task2, task3]
      taskp.notes << [note1, note2, note3]
      taskp.idea_links << [idea_link1, idea_link2, idea_link3]
      subject.load_children(taskp)
    end

    it "loads children tasks into @tasks" do
      expect(assigns(:tasks)).to match_array([task1, task2, task3])
    end

    it "loads children notes into @notes" do
      expect(assigns(:notes)).to match_array([note1, note2, note3])
    end

    it "loads children idea_links into @idea_links" do
      expect(assigns(:idea_links)).to match_array([idea_link1, idea_link2, idea_link3])
    end
  end

  context "parent is a note" do
    before do
      notep.tasks << [task1, task2, task3]
      notep.notes << [note1, note2, note3]
      notep.idea_links << [idea_link1, idea_link2, idea_link3]
      subject.load_children(notep)
    end

    it "loads children tasks into @tasks" do
      expect(assigns(:tasks)).to match_array([task1, task2, task3])
    end

    it "loads children notes into @notes" do
      expect(assigns(:notes)).to match_array([note1, note2, note3])
    end

    it "loads children idea_links into @idea_links" do
      expect(assigns(:idea_links)).to match_array([idea_link1, idea_link2, idea_link3])
    end
  end

  context "parent is a idea link" do
    before do
      idea_linkp.tasks << [task1, task2, task3]
      idea_linkp.notes << [note1, note2, note3]
      idea_linkp.idea_links << [idea_link1, idea_link2, idea_link3]
      subject.load_children(idea_linkp)
    end

    it "loads children tasks into @tasks" do
      expect(assigns(:tasks)).to match_array([task1, task2, task3])
    end

    it "loads children notes into @notes" do
      expect(assigns(:notes)).to match_array([note1, note2, note3])
    end

    it "loads children idea_links into @idea_links" do
      expect(assigns(:idea_links)).to match_array([idea_link1, idea_link2, idea_link3])
    end
  end
end