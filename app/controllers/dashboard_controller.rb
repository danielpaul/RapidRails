class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    flash_message(
      :success,
      'Welcome to Rails Starter!',
      'Hope that this starter template gets your project up and running in no time.', now: true
    )
  end
end
