RSpec.describe "Auth Controller", type: :request do
  #----- HELPER METHODS -----#
  def post_request(path, params, headers)
    post path, params: params, headers: headers
  end

  def expected_error(message, status)
    expect(response.status).to eq(status)
    expect(JSON.parse(response.body)["errors"][0]["message"]).to eq message
  end

  def expected_message(message)
    expect(response.status).to eq(200)
    expect(JSON.parse(response.body)["message"]).to eq message
  end

  before :each do
    @user = create(:user, confirmed_at: 1.day.ago)
    @api_key_record = create(:api_key, name: "Test key", api_key: "test1234")
    @api_key = @api_key_record.api_key
  end

  describe "#sign_in (Basic API authorization)" do
    context "when active API key is passed" do
      it "should gain access and return user token" do
        post_request(
          api_v1_auth_sign_in_path,
          { email: @user.email, password: @user.password },
          { "X-API-KEY": @api_key }
        )

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)["token"]).to_not be nil
      end
    end

    context "when user is not confirmed" do
      it "should throw unprocessable entity error" do
        @user.update confirmed_at: nil
        post_request(
          api_v1_auth_sign_in_path,
          { email: @user.email, password: @user.password },
          { "X-API-KEY": @api_key }
        )

        expected_error(I18n.t("devise.failure.unconfirmed"), 422)
      end
    end

    describe "unauthorized cases" do
      context "when wrong password is passed" do
        it "should not gain access" do
          post_request(
            api_v1_auth_sign_in_path,
            { email: @user.email, password: "random password" },
            { "X-API-KEY": @api_key }
          )

          expected_error(
            "Invalid email or password.",
            401
          )
        end
      end

      context "when wrong email is passed" do
        it "should not gain access" do
          post_request(
            api_v1_auth_sign_in_path,
            { email: "random email" },
            { "X-API-KEY": @api_key }
          )

          expected_error(I18n.t("devise.failure.invalid", authentication_keys: "email"), 401)
        end
      end

      describe "generic errors" do
        context "when disabled API key is passed" do
          it "should not gain access" do
            @api_key_record.disabled!
            post_request(
              api_v1_auth_sign_in_path,
              { email: @user.email, password: @user.password },
              { "X-API-KEY": @api_key }
            )
          end
        end

        context "when invalid API key is passed" do
          it "should not gain access" do
            post_request(
              api_v1_auth_sign_in_path,
              { email: @user.email, password: @user.password },
              { "X-API-KEY": "random key" }
            )
          end
        end
        after :each do
          expected_error("Looks like you don't have the permission to do this.", 401)
        end
      end
    end
  end

  describe "#forgot_password" do
    context "when existing user is passed" do
      it "sends the password reset email" do
        post_request(
          api_v1_auth_forgot_password_path,
          { email: @user.email },
          { "X-API-KEY": @api_key }
        )

        expect(ActionMailer::Base.deliveries.count).to eq 1
        expect(ActionMailer::Base.deliveries[0].subject).to eq I18n.t("devise.mailer.reset_password_instructions.subject")
      end
    end

    context "when invalid user is passed" do
      it "returns paranoid instructions" do
        post_request(
          api_v1_auth_forgot_password_path,
          { email: "random email" },
          { "X-API-KEY": @api_key }
        )
        expect(ActionMailer::Base.deliveries.count).to eq 0
      end
    end

    after :each do
      expected_message(I18n.t("devise.passwords.send_paranoid_instructions"))
    end
  end

  describe "#confirm_email" do
    context "when existing user is passed" do
      it "sends the confirmation email" do
        post_request(
          api_v1_auth_confirm_email_path,
          { email: @user.email },
          { "X-API-KEY": @api_key }
        )
        expect(ActionMailer::Base.deliveries.count).to eq 1
        expect(ActionMailer::Base.deliveries[0].subject).to eq I18n.t("devise.mailer.confirmation_instructions.subject")
      end
    end

    context "when invalid user is passed" do
      it "returns paranoid instructions" do
        post_request(
          api_v1_auth_confirm_email_path,
          { email: "random email" },
          { "X-API-KEY": @api_key }
        )
        expect(ActionMailer::Base.deliveries.count).to eq 0
      end
    end

    after :each do
      expected_message(I18n.t("devise.confirmations.send_paranoid_instructions"))
    end
  end

  describe "#extend_token" do
    context "when valid JWT token is passed" do
      it "returns a JWT token" do
        jwt_token = JwtTokenService.generate!({ id: @user.id })
        post_request(
          api_v1_auth_extend_token_path,
          nil,
          { "X-API-KEY": @api_key, Authorization: "Bearer #{jwt_token}" }
        )
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)["token"]).to_not be nil
      end
    end

    context "when invalid JWT token is passed" do
      it "renders unauthorized state" do
        post_request(
          api_v1_auth_extend_token_path,
          nil,
          { "X-API-KEY": @api_key, Authorization: "Bearer random token" }
        )
        expect(response.status).to eq(401)
      end
    end
  end

  describe "GET#user" do
    context "when valid JWT token is passed" do
      it "returns user details" do
        jwt_token = JwtTokenService.generate!({ id: @user.id })
        get api_v1_auth_user_path,
            headers: { "X-API-KEY": @api_key, Authorization: "Bearer #{jwt_token}" }

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(
          {
            "first_name" => @user.first_name,
            "last_name" => @user.last_name,
            "email" => @user.email,
            "avatar_url" => @user.avatar_url
          }
        )
      end
    end

    context "when invalid JWT token is passed" do
      it "renders unauthorized state" do
        get api_v1_auth_user_path,
            headers: { "X-API-KEY": @api_key, Authorization: "Bearer random_token" }

        expected_error("Looks like you don't have the permission to do this.", 401)
      end
    end
  end

  describe "PUT#user" do
    context "when valid JWT token is passed with valid params" do
      it "updates the user" do
        jwt_token = JwtTokenService.generate!({ id: @user.id })
        put api_v1_auth_user_path,
            params: { full_name: "Sample full name" },
            headers: { "X-API-KEY": @api_key, Authorization: "Bearer #{jwt_token}" }

        expected_message("Your account has been updated successfully.")
        expect(@user.reload.full_name).to eq("Sample full name")
      end
    end

    context "when valid JWT token is passed with invalid params" do
      it "does not update the user" do
        jwt_token = JwtTokenService.generate!({ id: @user.id })
        put api_v1_auth_user_path,
            params: { password: "1234" },
            headers: { "X-API-KEY": @api_key, Authorization: "Bearer #{jwt_token}" }

        expected_error("Password is too short (minimum is 8 characters)", 422)
      end
    end

    context "when invalid JWT token is passed" do
      it "renders unauthorized state" do
        put api_v1_auth_user_path,
            headers: { "X-API-KEY": @api_key, Authorization: "Bearer random_token" }

        expected_error("Looks like you don't have the permission to do this.", 401)
      end
    end
  end
end
