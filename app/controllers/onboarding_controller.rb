class OnboardingController < ApplicationController
  before_action :authenticate_user!
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

end
