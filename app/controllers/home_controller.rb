class HomeController < ApplicationController
  layout 'application_landing_page'

  def index
    flash_message(
      :success,
      'Welcome to Rails Starter!',
      'Hope that this starter template gets your project up and running in no time.', now: true
    )

    flash_message(
      :warning,
      'Nothing is wrong here...',
      "This is a nice toast message that you can use across your app. Users Rail's flash.", now: true
    )
  end
end
