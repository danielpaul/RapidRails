class StaticController < ApplicationController
  layout "application_devise", only: :confirm_email

  def confirm_email
    @email = params[:email]
    redirect_to root_path if @email.nil?
  end
end
