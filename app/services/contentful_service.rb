class ContentfulService
  def initialize
  end

  def posts(page = 1)
    per_page = 10

    Rails.cache.fetch("#{posts_index_cache_key_base}/per_page_#{per_page}/#{page}") do
      client.entries(
        content_type: "blogPost",
        order: "-fields.publishedAt",
        limit: per_page,
        skip: (page - 1) * per_page
      )
    end
  end

  def posts_cache_clear
    cache_key = "#{posts_index_cache_key_base}/*"
    clear_cache_pattern(cache_key)
    cache_key
  end

  def post(slug)
    Rails.cache.fetch(post_cache_key(slug)) do
      client.entries(content_type: "blogPost", "fields.slug": slug).first
    end
  end

  def post_cache_clear(slug)
    cache_key = post_cache_key(slug)
    Rails.cache.delete(cache_key)
    cache_key
  end

  def page_content(key, field)
    Rails.cache.fetch(page_content_cache_key(key, field)) do
      entry = client.entries(content_type: "pageString", "fields.key": key).first
      return nil unless entry

      entry.fields[field.to_sym]
    end
  end

  def page_content_cache_clear(key)
    cache_key = "#{page_content_cache_key(key)}*"
    clear_cache_pattern(cache_key)
    cache_key
  end

  private

  def client
    @client ||= Contentful::Client.new(
      space: Rails.application.credentials.dig(:staging, :contentful, :space_id),
      access_token: Rails.application.credentials.dig(:staging, :contentful, :delivery_access_token),
      dynamic_entries: :auto,
      raise_errors: true
    )
  end

  def page_content_cache_key(key, field = nil)
    "page/#{key}/#{field}"
  end

  def posts_index_cache_key_base
    "blog/index"
  end

  def post_cache_key(slug)
    "blog/show/#{slug}"
  end

  def clear_cache_pattern(pattern)
    Rails.cache.delete_matched(pattern)
  end
end
