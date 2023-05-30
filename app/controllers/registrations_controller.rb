class RegistrationsController < Devise::RegistrationsController

  def confirm_email
    @email = params[:email]
    redirect_to root_path if @email.nil?
  end

  protected

  def update_resource(resource, params)
    if params[:password].present? || params[:password_confirmation].present?
      # user looking to change password. Require current password.
      resource.update_with_password(params)
    else
      params.delete(:password)
      params.delete(:password_confirmation)
      params.delete(:current_password)

      resource.update_without_password(params)
    end
  end

  def after_update_path_for(_resource)
    flash[:notice] = "Account succesfully updated."
    edit_user_registration_path
  end

  def after_inactive_sign_up_path_for(resource)
    confirm_email_path(email: resource.email)
  end
end
