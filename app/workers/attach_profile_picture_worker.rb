class AttachProfilePictureWorker < ApplicationWorker
  sidekiq_options queue: "low_priority", retry: 3

  def perform(user_id, image_url)
    begin
      image = URI(image_url).open
    rescue OpenURI::HTTPError => e
      Rails.logger.error("Error downloading profile picture (#{image_url}) for user #{user_id}: #{e.message}")
      return
    end

    user = User.find(user_id)

    return if image.nil? || user.nil?

    # Don't attach the image if the user already has a profile picture
    return if user.profile_picture.attached?

    user.profile_picture
      .attach(
        io: image,
        filename: "google_profile_picture.png"
      )
  end
end
