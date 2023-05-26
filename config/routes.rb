Rails.application.routes.draw do
  root "home#index"

  devise_for :users, controllers: {registrations: "registrations"}

  scope controller: :static do
    get :confirm_email, path: "users/confirm-email"
  end
end
