Rails.application.routes.draw do
  authenticated :user do
    root to: "dashboard#index", as: :user_root
  end

  root to: "home#index"

  # ---------- [ Devise ] ---------- #
  devise_for :users, controllers: {
    registrations: "registrations",
    confirmations: "confirmations"
  }

  devise_scope :user do
    get :confirm_email, to: "registrations#confirm_email", as: "confirm_email", path: "users/confirm-email"
  end

  resources :dashboard, only: :index

  # ---------- [ Gems ] ---------- #
  mount ForestLiana::Engine => '/forest'


  if Rails.env.development? || Rails.env.test?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

end
