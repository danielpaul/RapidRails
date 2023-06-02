class ConfirmationsController < Devise::ConfirmationsController
  protected

  def after_resending_confirmation_instructions_path_for(resource_name)
    confirm_email_path(email: params[resource_name][:email])
  end
end
