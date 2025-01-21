class PasswordsController < Devise::PasswordsController
  def update
    super do |resource|
      # only confirm the initial email. not email pending change.
      if resource.errors.empty? && !resource.confirmed? && resource.unconfirmed_email.nil? 
        resource.confirm
      end
    end
  end
end