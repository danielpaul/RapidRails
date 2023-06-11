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
    edit_user_registration_path
  end

  def after_inactive_sign_up_path_for(resource)
    confirm_email_path(email: resource.email)
  end

  private

  def set_flash_message_for_update(resource, prev_unconfirmed_email)
    return unless is_flashing_format?

    if sign_in_after_change_password?
      flash_message(
        :success,
        t("devise.registrations.updated")
      )
    else
      super
    end
  end
end
