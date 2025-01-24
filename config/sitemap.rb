# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = HOST

# only if production
if Rails.env.production? && ENABLE_FILE_UPLOAD
  SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(Rails.application.credentials.dig(Rails.env.to_sym, :cloudflare, :sitemaps_bucket),
    access_key_id: Rails.application.credentials.dig(Rails.env.to_sym, :cloudflare, :access_key_id),
    secret_access_key: Rails.application.credentials.dig(Rails.env.to_sym, :cloudflare, :secret_access_key),
    endpoint: "https://#{Rails.application.credentials.dig(Rails.env.to_sym, :cloudflare, :account_id)}.r2.cloudflarestorage.com",
    region: 'auto'
  )

  SitemapGenerator::Sitemap.sitemaps_host = SITEMAP_HOST
  SitemapGenerator::Sitemap.sitemaps_path = APP_SLUG
end

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  # All our static pages
  HighVoltage.page_ids.each do |page|
    add page, changefreq: "weekly"
  end

  # Blog Index & Posts
  if ENABLE_BLOG == true
    ContentfulService.new.all_posts.each do |post|
      add blog_post_path(post.id), changefreq: "weekly"
    end

    add blog_path, changefreq: "daily"
  end
end
