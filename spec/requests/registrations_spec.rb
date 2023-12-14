RSpec.describe "Registrations Controller", type: :request do
  #----- HELPER METHODS -----#
  def post_request(path, params)
    post path, params:
  end

  describe "Email verification flow" do
    before :each do
      Devise.allow_unconfirmed_access_for = 0.days
    end

    context "when confirmation is required setting is enabled in devise config" do
      context "when creating a new user" do
        it "should redirect to the `check email for confirmatiom page` after sign up" do
          post_request user_registration_path, {
            user: {
              full_name: "test",
              email: "test@email.com",
              password: "test1234"
            }
          }
          expect(response).to redirect_to(confirm_email_path(email: "test@email.com"))
        end
      end

      context "when requesting a new confirmation email" do
        it "redirects the user to the `check email for confirmatiom page`" do
          post_request user_confirmation_path, {
            user: {
              email: "test@email.com"
            }
          }
          expect(response).to redirect_to(confirm_email_path(email: "test@email.com"))
        end
      end

      context "when trying to access the new confirmation email page" do
        it "allows access" do
          get new_user_confirmation_path

          expect(response.body).to include("Resend Email Confirmation")
        end
      end
    end

    context "when confirmation is not required in devise config" do
      before :each do
        Devise.allow_unconfirmed_access_for = nil
      end

      it "should sign in user after sign up" do
        post_request user_registration_path, {
          user: {
            full_name: "test",
            email: "test@email.com",
            password: "test1234"
          }
        }

        expect(response).to redirect_to(root_path)
      end

      it "does not allow access to confirmation page and should redirect to sign in page" do
        get new_user_confirmation_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
