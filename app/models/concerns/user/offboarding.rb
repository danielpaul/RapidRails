module User::Offboarding
  extend ActiveSupport::Concern

  included do
    has_many :user_account_feedbacks
    accepts_nested_attributes_for :user_account_feedbacks
  end

  def active_for_authentication?
    !discarded? && super
  end

  def inactive_message
    if discarded?

      # track error in Sentry so we can investigate & ensure that the user did sign up again.
      Sentry.capture_message("User ##{id} (#{email}) tried to sign in after being deleted.", level: :info)

      "Your account is currently being deleted. You cannot sign up again with the same email. Please try again later or use another email."
    else
      super
    end
  end

end
