Rails.application.routes.draw do
  root "home#index"

  # ---------- [ Devise ] ---------- #
  devise_for :users, controllers: {registrations: "registrations"}

  devise_scope :user do
    get :confirm_email, to: "registrations#confirm_email", as: "confirm_email", path: "users/confirm-email"
  end
end
