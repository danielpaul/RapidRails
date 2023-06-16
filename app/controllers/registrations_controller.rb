class RegistrationsController < Devise::RegistrationsController
  def confirm_email
    @email = params[:email]
    redirect_to root_path if @email.nil?
  end

  def cancel_email_change!
    authenticate_scope!

    if resource.pending_reconfirmation?
      resource.confirmation_token = nil
      resource.unconfirmed_email = nil
      resource.save(validate: false)
    end

    redirect_to after_update_path_for(resource)
  end

  def destroy
    if resource.valid_password?(user_delete_params[:current_password])
      resource.user_account_feedbacks.create(user: resource, feedback: user_delete_params[:feedback]) if user_delete_params[:feedback]
      resource.discard
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      set_flash_message! :notice, :destroyed
      respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name), status: Devise.responder.redirect_status }
    else
      flash.now[:alert] = "Invalid password entered. Please try again."
      redirect_to edit_user_registration_path(resource)
    end
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

  def after_update_path_for(resource)
    edit_registration_path(resource)
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

  def user_delete_params
    params.require(:user).permit(:current_password, :feedback)
  end
end
