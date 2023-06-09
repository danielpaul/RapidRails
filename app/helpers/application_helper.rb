module ApplicationHelper
  include Pagy::Frontend

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

  def contentful_service
    @contentful_service ||= ContentfulService.new
  end

  def page_content(key, type)
    contentful_service.page_content(key, type)
  end

  def render_rich_text(rich_text)
    return nil if rich_text.nil?

    RichTextRenderer::Renderer.new(
      "embedded-asset-block" => RichText::Image
    ).render(rich_text).html_safe
  end
end
