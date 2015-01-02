require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do
  describe "bootstrap_flash_type" do
    it "returns danger on error" do
      expect(helper.bootstrap_flash_type("error")).to eq("danger")
    end

    it "returns info on alert" do
      expect(helper.bootstrap_flash_type("alert")).to eq("info")
    end

    it "returns success on success" do
      expect(helper.bootstrap_flash_type("success")).to eq("success")
    end

    it "returns warning on notice" do
      expect(helper.bootstrap_flash_type("notice")).to eq("warning")
    end

    it "returns danger on danager" do
      expect(helper.bootstrap_flash_type("danger")).to eq("danger")
    end
  end
end