Rails.application.routes.draw do
  authenticated :user do
    root to: "dashboard#index", as: :user_root
  end

  # ---------- [ Static Pages ] ---------- #
  if ENABLE_LANDING_PAGES == true
    root to: "pages#show", id: "home"
    get "pages/*id" => "pages#show", :as => :page, :format => false
  else
    root to: "dashboard#index"
  end

  # ---------- [ Blog ] ---------- #
  if ENABLE_LANDING_PAGES == true && ENABLE_BLOG == true
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

  # ---------- [ Health Check ] ---------- #
  get "/up", to: "health_check#show"

  # ---------- [ Sitemap ] ---------- #
  if Rails.env.production?
    # Sitemap - redirect /sitemap.xml.gz to s3
    get "/sitemap.xml.gz" => redirect("#{SITEMAP_HOST}/sitemaps/sitemap.xml.gz")
  end

  # ---------- [ Gems ] ---------- #
  # Admin Panel
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Sidekiq
  if defined?(Sidekiq)
    require "sidekiq/web"

    authenticate :admin_user do
      mount Sidekiq::Web => "/sidekiq"
    end
  end
end
