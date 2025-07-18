module User::Avatar
  extend ActiveSupport::Concern

  included do
    if ENABLE_USER_AVATAR_UPLOAD
      has_one_attached :profile_picture

      validates :profile_picture,
        content_type: {
          in: ["image/png", "image/jpeg"],
          message: "must be a png or jpeg image file"
        },
        size: {less_than: 10.megabytes}
    end
  end

  def avatar_url
    if ENABLE_USER_AVATAR_UPLOAD && profile_picture.attached? && profile_picture.variable?
      # Use ActiveStorage's variant to resize image to 500x500 and return the URL
      return Rails.application.routes.url_helpers.url_for(
        profile_picture.variant(resize_to_fill: [500, 500])
      )
    end

    initials_avatar_url
  rescue ActiveStorage::FileNotFoundError
    initials_avatar_url
  end

  def initials_avatar_url
    # Don't share real names. Just initials.
    # Add hash to get unique color variant for each user. Otherwise all DP will be same.
    hash = Digest::MD5.hexdigest(email.downcase)
    "https://api.dicebear.com/6.x/initials/png?backgroundType=gradientLinear&seed=#{initials + hash}"
  end
end
