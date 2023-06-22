module User::Onboarding
  extend ActiveSupport::Concern

  included do
    before_save :set_onboarding_completed_at
  end

  def onboarding_required_fields
    # add other fields in here that are required for onboarding
    # users will be redirected to the onboarding page if any of these fields are blank
    %w[]
  end

  def onboarding_completed?
    # cache the result so we don't have to check all the fields on every request
    Rails.cache.fetch("user/#{hashid}/onboarding_completed?", expires_in: 12.hours) do
      onboarding_required_fields.all? { |field| send(field).present? }
    end
  end

  private

  def set_onboarding_completed_at
    self.onboarding_completed_at ||= Time.current if onboarding_completed?
  end  

end
