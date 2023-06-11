# spec/services/anonymization_service_spec.rb

require "rails_helper"

RSpec.describe AnonymizationService do
  describe ".anonymize_user" do
    let!(:user) {
      FactoryBot.create(:user,
        unconfirmed_email: "abc@email.com",
        reset_password_token: "123456",
        confirmation_token: "123456")
    }

    context "when the user exists and is not anonymized" do
      it "anonymizes the user data" do
        expect {
          AnonymizationService.anonymize_user(user.id)
          user.reload
        }.to change(user, :anonymized_at).from(nil)

        expect(user.full_name).to eq("Deleted User")
        expect(user.reload.email).to match("#{user.id}@deleted.example.com")
        expect(user.password).not_to be_nil
        expect(user.current_sign_in_ip).to be_nil
        expect(user.last_sign_in_ip).to be_nil
        expect(user.unconfirmed_email).to be_nil
        expect(user.reset_password_token).to be_nil
        expect(user.confirmation_token).to be_nil
      end
    end

    context "when the user does not exist" do
      it "does not raise an error" do
        expect {
          AnonymizationService.anonymize_user(-1)
        }.not_to raise_error
      end
    end

    context "when the user is already anonymized" do
      before do
        user.update(anonymized_at: Time.current)
      end

      it "does not change the user data" do
        expect {
          AnonymizationService.anonymize_user(user.id)
          user.reload
        }.not_to change(user, :anonymized_at)

        expect(user.full_name).not_to eq("Deleted User")
        expect(user.email).not_to match(/\A\d+@deleted\.example\.com\z/)
        expect(user.password).not_to be_nil
        expect(user.current_sign_in_ip).not_to be_nil
        expect(user.last_sign_in_ip).not_to be_nil
        expect(user.unconfirmed_email).not_to be_nil
        expect(user.reset_password_token).not_to be_nil
        expect(user.confirmation_token).not_to be_nil
      end
    end
  end
end
