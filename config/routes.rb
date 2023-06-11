Rails.application.routes.draw do
  authenticated :user do
    root to: "dashboard#index", as: :user_root
  end

  # ---------- [ Static Pages ] ---------- #
  root to: "pages#show", id: "home"
  get "pages/*id" => "pages#show", :as => :page, :format => false

  # ---------- [ Devise ] ---------- #
  devise_for :users, controllers: {
    registrations: "registrations",
    confirmations: "confirmations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  devise_scope :user do
    get :confirm_email, to: "registrations#confirm_email", as: "confirm_email", path: "users/confirm-email"
    post :cancel_email_change, to: "registrations#cancel_email_change!", as: "cancel_email_change", path: "users/cancel-email-change"
  end

  # ---------- [ Main Routes ] ---------- #
  resources :dashboard, only: :index

  # ---------- [ Custom Error Pages ] ---------- #

  get "/404", to: "errors#not_found"
  get "/500", to: "errors#internal_server"

  # ---------- [ API Routes ] ---------- #
  draw :api if ENABLE_API == true || Rails.env.test?

  # ---------- [ Gems ] ---------- #
  mount ForestLiana::Engine => "/forest"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  if defined?(Sidekiq) && ENV["SIDEKIQ_ADMIN_PASSWORD"] && ENV["SIDEKIQ_ADMIN_USERNAME"]
    require "sidekiq/web"

    Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
      # Protect against timing attacks:
      # - See https://codahale.com/a-lesson-in-timing-attacks/
      # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
      # - Use & (do not use &&) so that it doesn't short circuit.
      # - Use digests to stop length information leaking
      ActiveSupport::SecurityUtils.secure_compare(user, ENV["SIDEKIQ_ADMIN_USERNAME"]) &
        ActiveSupport::SecurityUtils.secure_compare(password, ENV["SIDEKIQ_ADMIN_PASSWORD"])
    end

    mount Sidekiq::Web => "/sidekiq"
  end
end
