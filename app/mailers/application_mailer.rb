class ApplicationMailer < ActionMailer::Base
  default from: DEFAULT_FROM_EMAIL
  layout "mailer"
end
