module ContentfulHelper
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

  def blog_enabled?
    ENABLE_BLOG == true && Rails.application.credentials.dig(Rails.env.to_sym, :contentful, :space_id).present?
  end

  def verify_blog_enabled!
    render_404! unless blog_enabled?
  end
end
