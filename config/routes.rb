Rails.application.routes.draw do
  authenticated :user do
    root to: "dashboard#index", as: :user_root
  end

  # ---------- [ Static Pages ] ---------- #
  root to: "pages#show", id: "home"
  get "pages/*id" => "pages#show", :as => :page, :format => false

  # ---------- [ Blog ] ---------- #
  if ENABLE_BLOG == true
    resources :blog, only: %i[index show], path: "blog"
    post "/contentful/webhook", to: "contentful#webhook"
  end

  # ---------- [ Devise ] ---------- #
  custom_controllers = {
    registrations: "registrations",
    confirmations: "confirmations",
    passwords: "passwords"
  }
  custom_controllers[:omniauth_callbacks] = "users/omniauth_callbacks" if ENABLE_GOOGLE_OAUTH
  devise_for :users, controllers: custom_controllers

  devise_scope :user do
    get :confirm_email, to: "confirmations#confirm_email", as: "confirm_email", path: "users/confirm-email"
    post :cancel_email_change, to: "registrations#cancel_email_change!", as: "cancel_email_change",
      path: "users/cancel-email-change"
  end

  # User Onboarding
  get "/onboarding", to: "onboarding#index", as: "onboarding"
  patch "/onboarding", to: "onboarding#update"

  # ---------- [ Main Routes ] ---------- #
  resources :dashboard, only: :index

  # ---------- [ Custom Error Pages ] ---------- #

  get "/404", to: "errors#not_found"
  get "/500", to: "errors#internal_server"
  get "/422", to: "errors#unprocessable_entity"

  # ---------- [ API Routes ] ---------- #
  draw :api if ENABLE_API == true || Rails.env.test?

  # ---------- [ Sitemap ] ---------- #
  if Rails.env.production?
    # Sitemap - redirect /sitemap.xml.gz to s3
    get "/sitemap.xml.gz" => redirect("#{SITEMAP_HOST}/sitemaps/sitemap.xml.gz")
  end

  # ---------- [ Gems ] ---------- #
  mount ForestLiana::Engine => "/forest"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

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
