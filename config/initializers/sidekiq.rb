# Perform Sidekiq jobs immediately in development,
# so you don't have to run a separate process.
# Also benefit from code reloading.

if Rails.env.development? || Rails.env.test?
  require 'sidekiq/testing'
  Sidekiq::Testing.inline!
end