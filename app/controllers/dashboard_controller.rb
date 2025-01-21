class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @width = "narrow"

    set_meta_tags title: "Home"

    flash_message(
      :success,
      "Welcome to Rails Starter!",
      "Hope that this starter template gets your project up and running in no time.",
      now: true
    )

    flash_message(
      :notice,
      "This is a notice message.",
      "This is a notice message. That is really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really long.",
      now: true
    )

    flash_message(
      :error,
      "This is an error message.",
      "This is an error message. That is really really really really really really really really really really really really really really really really really really really really really really really really really really really really really long.",
      now: true
    )

    flash.now[:notice] = "This is an notice message."
    flash.now[:success] = "This is an alert message. That is really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really long."
    flash.now[:error] = "This is an error message."
  end
end
