class HomeController < ApplicationController
  def index
    flash_message(:success, "Success!", "You did it!")
  end
end
