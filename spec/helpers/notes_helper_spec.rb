require 'rails_helper'

RSpec.describe NotesHelper, :type => :helper do
  describe "#notable_link" do
    let(:cat1) { Fabricate(:category) }
    it "returns line to notable" do
      expect(helper.notable_link("Category", cat1.id)).to eq("<a href=\"/categories/#{cat1.slug}\">Link to Parent</a>")
    end
  end
end