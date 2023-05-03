RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_length_of(:first_name).is_at_most(50) }
    it { should validate_length_of(:last_name).is_at_most(50) }
  end

  describe "associations" do
  end

  describe "full_name" do
    it "returns the user's full name" do
      user.first_name = "John"
      user.last_name = "Doe"
      expect(user.full_name).to eq("John Doe")
    end
  end
end
