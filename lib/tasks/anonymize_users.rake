# lib/tasks/anonymize_users.rake

desc 'Anonymize users who have been discarded over 30 days ago and not anonymized'
task anonymize_users: :environment do
  users = User.discarded.where(anonymized_at: nil).where('discarded_at <= ?', 30.days.ago)

  users.each do |user|
    AnonymizationWorker.perform_async(user.id)
  end

  puts "Anonymization queued for #{users.count} users."
end