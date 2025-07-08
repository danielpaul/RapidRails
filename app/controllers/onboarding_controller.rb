class OnboardingController < ApplicationController
  before_action :authenticate_user!, :check_if_enabled!
  layout "application_devise"

  def index
  end

  def update
    if current_user.update(onboarding_params)
      redirect_to user_root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def onboarding_params
    params.require(:user).permit(current_user.onboarding_required_fields)
  end

  def check_if_enabled!
    return if ENABLE_ONBOARDING == true

    render_404!
  end
end
