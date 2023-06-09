class DeviseMailer < Devise::Mailer
  def confirmation_instructions(*)
    super
    @preheader = "Confirm your account"
  end

  def reset_password_instructions(*)
    super
    @preheader = "Reset your Password"
  end

  def email_changed(*)
    super
    @preheader = "Looks like your email has been changed"
  end

  def password_change(*)
    super
    @preheader = "Looks like your email has been changed"
  end
end
