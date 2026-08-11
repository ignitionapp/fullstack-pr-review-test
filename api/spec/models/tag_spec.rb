require "rails_helper"

RSpec.describe Tag do
  describe ".find_or_build" do
    it "creates a tag" do
      tag = Tag.find_or_build("home")

      expect(tag).to be_a(Tag)
    end

    it "finds an existing tag" do
      Tag.create!(name: "home")

      expect(Tag.count).to be > 0
    end
  end
end
