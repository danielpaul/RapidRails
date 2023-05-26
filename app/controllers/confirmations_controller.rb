class ConfirmationsController < Devise::ConfirmationsController
  protected

  def after_resending_confirmation_instructions_path_for(_resource_name)
    confirm_email_path(email: params[:user][:email])
  end
end
