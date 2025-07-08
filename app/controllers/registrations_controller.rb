class RegistrationsController < Devise::RegistrationsController
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
    if resource.valid_password?(params[:user][:current_password])
      # Creates user_account_feedbacks record
      resource.update(user_delete_params)

      resource.discard

      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)

      flash_message(
        :success,
        "Your account is deleted.",
        "We're sorry to see you go! If you change your mind and decide to come back, you're always welcome to create a new account."
      )

      respond_with_navigational(resource) do
        redirect_to after_sign_out_path_for(resource_name), status: Devise.responder.redirect_status
      end
    else

      flash_title = "Wrong password."
      flash_body = "The password you entered was incorrect. Please try again."

      respond_to do |format|
        format.html do
          flash_message(:error, flash_title, flash_body, now: false)
          redirect_to edit_user_registration_path
        end

        format.turbo_stream do
          flash_message(:error, flash_title, flash_body, now: true)

          render turbo_stream: turbo_stream.append(
            "flash-toasts",
            partial: "shared/flash_toast"
          )
        end
      end

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
    params.require(:user).permit(
      user_account_feedbacks_attributes: [ :feedback ]
    )
  end
end
