module ApplicationHelper
  include Pagy::Frontend

  def default_meta_tags
    meta_tags = {
      site: APP_NAME,
      reverse: true,
      canonical: request.original_url,
      icon: [
        { href: "/favicon.ico" },
        { href: "/apple-touch-icon.png", rel: "apple-touch-icon" }
      ],
      "theme-color": [
        { content: BROWSER_THEME_COLOR_LIGHT, media: "(prefers-color-scheme: light)" },
        { content: BROWSER_THEME_COLOR_DARK, media: "(prefers-color-scheme: dark)" }
      ],
      "color-scheme": "light dark"
    }

    meta_tags[:noindex] = true unless Rails.env.production?

    meta_tags
  end

  def theme_class
    theme = cookies[:theme]
    if theme == "dark"
      "dark"
    else
      "light"
    end
  end

  # Method used for turbo frame dom with hashid instead of record id
  def dom_hashid(record, prefix = nil)
    if (record_id = record.hashid)
      "#{dom_class(record, prefix)}_#{record_id}"
    else
      dom_class(record, prefix || "NEW")
    end
  end

  def open_email_inbox_url(email_address)
    return nil unless email_address.present? && email_address.match?(URI::MailTo::EMAIL_REGEXP)

    if /@(gmail\.com|googlemail\.com|google\.com)\z/.match?(email_address.downcase)
      base_url = "https://mail.google.com"
      encoded_email_address = ERB::Util.url_encode(email_address)
      search_params = "from:#{DEFAULT_FROM_EMAIL_ONLY} in:anywhere newer_than:1d"
      "#{base_url}/mail/u/#{encoded_email_address}/#search/#{ERB::Util.url_encode(search_params)}"
    else
      domain = email_address.split("@").last
      "https://#{domain}"
    end
  end
end
