# app/workers/anonymization_worker.rb

class AnonymizationWorker
  include Sidekiq::Worker

  def perform(user_id)
    AnonymizationService.anonymize_user(user_id)
  end
end
  