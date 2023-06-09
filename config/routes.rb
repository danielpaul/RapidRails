Rails.application.routes.draw do
  authenticated :user do
    root to: "dashboard#index", as: :user_root
  end

  # ---------- [ Devise ] ---------- #
  devise_for :users, controllers: {
    registrations: "registrations",
    confirmations: "confirmations"
  }

  devise_scope :user do
    get :confirm_email, to: "registrations#confirm_email", as: "confirm_email", path: "users/confirm-email"
  end

  resources :dashboard, only: :index

  # all pages that don't match

  get "/*id" => "pages#show", :as => :page, :format => false

  root to: "pages#show", id: "home"

  # ---------- [ Custom Error Pages ] ---------- #

  get "/404", to: "errors#not_found"
  get "/500", to: "errors#internal_server"

  # ---------- [ Gems ] ---------- #
  mount ForestLiana::Engine => "/forest"
end
