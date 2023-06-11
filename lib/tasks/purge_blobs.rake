namespace :active_storage do
  desc "Purge unattached Active Storage blobs"
  task purge_unattached_blobs: :environment do
    # Find all the unattached blobs
    unattached_blobs = ActiveStorage::Blob.unattached.where(created_at: ..2.days.ago)

    # Output the count of unattached blobs
    puts "Total unattached blobs: #{unattached_blobs.count}"

    # Purge each unattached blob
    unattached_blobs.find_each do |blob|
      puts "Purging blob with key: #{blob.key}"
      blob.purge_later
    end

    puts "Unattached blobs purged successfully!"
  end
end
