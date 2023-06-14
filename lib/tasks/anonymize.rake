namespace :anonymize do
  desc 'Anonymize users who have been discarded over X days ago and not anonymized'
  task users: :environment do
    users = User.discarded
                .where(anonymized_at: nil)
                .where('discarded_at <= ?', ANONYMIZE_USER_DATA_AFTER_DAYS.days.ago)
                .select(:id)

    users.find_each do |user|
      UserAnonymizationWorker.perform_async(user.id)
    end

    puts "Anonymization queued for #{users.count} users."
  end
end
