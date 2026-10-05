require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "validations" do
    it "requires a title" do
      project = described_class.new

      expect(project).not_to be_valid
      expect(project.errors[:title]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "has many tasks" do
      project = described_class.new(title: "Example project")
      task = project.tasks.build(title: "Example task")

      expect(project.tasks).to include(task)
      expect(Project.reflect_on_association(:tasks).macro).to eq(:has_many)
    end
  end
end

decribed ""