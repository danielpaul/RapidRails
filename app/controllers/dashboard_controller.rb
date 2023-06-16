class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    set_meta_tags title: "Home"
    flash_message(
      :success,
      "Welcome to Rails Starter!",
      "Hope that this starter template gets your project up and running in no time.",
      now: true
    )

    flash.now[:notice] = "This is an notice message."
    flash.now[:success] = "This is an alert message. That is really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really long."
    flash.now[:error] = "This is an error message."
  end
end
