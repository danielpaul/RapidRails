module User::Offboarding
  extend ActiveSupport::Concern
  include Discard::Model

  included do
    has_many :user_account_feedbacks
    accepts_nested_attributes_for :user_account_feedbacks

    # so user can sing up again with the same email again after deleting
    after_discard :discarded_account_email_update!

    def active_for_authentication?
      super && !discarded?
    end

    def inactive_message
      if discarded?
        # track error in Sentry so we can investigate & ensure that the user did sign up again.
        Sentry.capture_message("User ##{id} (#{email}) tried to sign in after being deleted.", level: :info)
  
        "Your account is being deleted. Please try again later or use another email."
      else
        super
      end
    end
  end

  def discarded_account_email_prefix
    "discarded-#{id}+"
  end

  private

  def discarded_account_email_update!
    update_column(:email, discarded_account_email_prefix + email)
  end

end
