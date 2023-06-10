namespace :api do
  namespace :v1 do
    # ---------- [ Auth Controller ] ---------- #
    namespace :auth do
      post "/sign_in", to: "auth#sign_in"
      post "/forgot_password", to: "auth#forgot_password"
      post "/resend_invite", to: "auth#forgot_password"
      post "/confirm_email", to: "auth#confirm_email"
      post "/extend_token", to: "auth#extend_token"
      get "/user", to: "auth#user"
      put "/user", to: "auth#update_user"
    end
  end
end
