require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "associations" do
    it "belongs to a project" do
      expect(Task.reflect_on_association(:project).macro).to eq(:belongs_to)
    end
  end

  describe "validations" do
    it "cannot exist without a project" do
      task = described_class.new(title: "Example task")

      expect(task).not_to be_valid
      expect(task.errors[:project]).to include("must exist")
    end

  #on purpose failing test
    it "is invalid when it has no title" do
      task = described_class.new(project: Project.new(title: "Example project"))

      expect(task).not_to be_valid
      expect(task.errors[:title]).to include("can't be blank")
    end
  end
end
