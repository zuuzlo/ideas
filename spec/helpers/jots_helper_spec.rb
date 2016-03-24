require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the JotsHelper. For example:
#
# describe JotsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe JotsHelper, :type => :helper do
  let!(:user1) { Fabricate(:user) }
  let(:jot1) { Fabricate(:jot, status: "Active", user_id: user1.id) }
  let(:jot2) { Fabricate(:jot, status: "Hold", user_id: user1.id) }
  let(:jot3) { Fabricate(:jot, status: "Complete", user_id: user1.id) }

  #before { sign_in user1 }
  #Hold Active Complete
  describe "row_class" do
    it "returns class success for Active jots" do
      expect(helper.row_class(jot1)).to eq("success")
    end

    it "returns class warning for Hold jots" do
      expect(helper.row_class(jot2)).to eq("warning")
    end

    it "returns class info for Complete jots" do
      expect(helper.row_class(jot3)).to eq("info")
    end
  end
end
