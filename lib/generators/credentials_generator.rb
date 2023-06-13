# Override Credentials Generator
# This handles the shared credentials file
require "rails/generators"
require "rails/generators/rails/credentials/credentials_generator"

Rails::Generators::CredentialsGenerator.class_eval do
  def credentials_template
    RapidRails::Credentials.template
  end
end

# Override Encrypted File Generator
require "rails/generators/rails/encrypted_file/encrypted_file_generator"

Rails::Generators::EncryptedFileGenerator.class_eval do
  private

  def encrypted_file_template
    RapidRails::Credentials.template
  end
end

module RapidRails
  module Credentials
    def self.template
      <<~YAML
        # Used as the base secret for all MessageVerifiers in Rails, including the one protecting cookies.
        secret_key_base: #{SecureRandom.hex(64)}

        active_record_encryption:
          primary_key: #{SecureRandom.alphanumeric(32)}
          deterministic_key: #{SecureRandom.alphanumeric(32)}
          key_derivation_salt: #{SecureRandom.alphanumeric(32)}

        default: &default
          google:
            client_id: XXX
            client_secret: XXX

          contentful:
            space_id: XXX
            webhook_secret_token: #{SecureRandom.alphanumeric(32)}
            delivery_access_token: XXX
            preview_access_token: XXX

        test:
          <<: *default

        development:
          <<: *default

          forest_admin:
            env_secret: XXX
            auth_secret: XXX

        staging:
          <<: *default

          postmark_api_token: XXX

          aws:
            access_key_id: XXX
            secret_access_key: XXX
            region: eu-west-2
            bucket: rapid_rails_staging

          forest_admin:
            env_secret: XXX
            auth_secret: XXX

        production:
          <<: *default

          postmark_api_token: XXX

          aws:
            access_key_id: XXX
            secret_access_key: XXX
            region: eu-west-2
            bucket: rapid_rails_production

          forest_admin:
            env_secret: XXX
            auth_secret: XXX

      YAML
    end
  end
end