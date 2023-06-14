# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  anonymized_at          :datetime
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  discarded_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  full_name              :string           not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_anonymized_at         (anonymized_at)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_discarded_at          (discarded_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }
  let(:omniauth_data) { 
    {
      'email' => "me@gmail.com",
      'email_verified' => true,
      'first_name' => "Daniel",
      'image' => "https://lh3.googleusercontent.com/a/AAcHTtfUNo3s4sQy7rF3dP05MXJvjqugGNhUKvXEQy-zUX8=s96-c",
      'last_name' => "Paul",
      'name' => "Daniel Paul",
      'unverified_email' => "me@gmail.com"
    }
  }

  describe "validations" do
    it { should validate_presence_of(:full_name) }
    it { should validate_length_of(:full_name).is_at_most(100) }
  end

  describe "associations" do
  end

  describe "#first_name" do
    it "returns the first name when full name has only first name" do
      user = FactoryBot.build(:user, full_name: "John")
      expect(user.first_name).to eq("John")
    end

    it "returns the first name when full name has first and last name" do
      user = FactoryBot.build(:user, full_name: "John Doe")
      expect(user.first_name).to eq("John")
    end

    it "returns the first name when full name has first, middle, and last name" do
      user = FactoryBot.build(:user, full_name: "John Jacob Doe")
      expect(user.first_name).to eq("John")
    end
  end

  describe "#last_name" do
    it "returns the last name when full name has only first name" do
      user = FactoryBot.build(:user, full_name: "John")
      expect(user.last_name).to eq(nil)
    end

    it "returns the last name when full name has first and last name" do
      user = FactoryBot.build(:user, full_name: "John Doe")
      expect(user.last_name).to eq("Doe")
    end

    it "returns the last name when full name has first, middle, and last name" do
      user = FactoryBot.build(:user, full_name: "John Jacob Doe")
      expect(user.last_name).to eq("Doe")
    end
  end

  describe '#User.from_omniauth - Google OmniAuth tests' do
    context 'when new email but unverified on google' do
      it "creates a new but unconfirmed user record" do
        omniauth_data['email_verified'] = false
        user = User.from_omniauth(omniauth_data)

        assert user.persisted?
        refute user.confirmed?
        expect(ActionMailer::Base.deliveries.first.subject).to eq("Confirmation instructions")
      end
    end

    context 'when new email but verified on google' do
      it "creates a new confirmed user record" do
        user = User.from_omniauth(omniauth_data)

        assert user.persisted?
        assert user.confirmed?
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end

    context 'when invalid email on google' do
      it "does not create user record if verified or unverified" do
        omniauth_data['email'] = 'invalid email'

        expect { 
          @user = User.from_omniauth(omniauth_data)
        }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Email is invalid')

        omniauth_data['email_verified'] = false
        expect { 
          @user2 = User.from_omniauth(omniauth_data)
        }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Email is invalid')
      end
    end

    describe 'Existing users logging in with omniauth' do
      before :each do
        @user = create(:user, email: 'me@gmail.com')
      end

      context 'when unconfirmed' do
        it "does not confirm existing user if unverified on google" do
          omniauth_data['email_verified'] = false
          
          old_confirm_at = @user.confirmed_at
          google_user = User.from_omniauth(omniauth_data)

          expect(User.count).to eq 1
          expect(old_confirm_at).to eq google_user.confirmed_at
        end
      end

      context 'when unconfirmed' do
        it "confirms existing user if verified on google" do
          refute @user.confirmed?
          google_user = User.from_omniauth(omniauth_data)

          assert google_user.confirmed?
        end
      end

      context 'when confirmed' do
        it "does nothing if unverified on google" do
          @user.update confirmed_at: 1.year.ago
          assert @user.confirmed?
          google_user = User.from_omniauth(omniauth_data)

          expect(@user.confirmed_at).to eq(google_user.confirmed_at)
        end
      end

      context 'when confirmed' do
        it "does nothing even if verified on google" do
          @user.update confirmed_at: 1.year.ago
          assert @user.confirmed?
          google_user = User.from_omniauth(omniauth_data)

          expect(@user.confirmed_at).to eq(google_user.confirmed_at)
        end
      end

      context 'when signing in with a discarded account' do
        it 'does not save record' do
          @user.discard
          google_user = User.from_omniauth(omniauth_data)

          assert google_user.discarded?
        end
      end

      context 'when user has no profile picture' do
        it 'attaches profile picture from google account' do
          expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq 0
          expect {
            User.from_omniauth(omniauth_data)
          }.to have_enqueued_job(ActiveStorage::AnalyzeJob)
        end
      end
    end
  end
end
