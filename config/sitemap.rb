# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = HOST

# only if production
if Rails.env.production?
  SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
    aws_access_key_id: Rails.application.credentials.dig(Rails.env.to_sym, :aws, :access_key_id),
    aws_secret_access_key: Rails.application.credentials.dig(Rails.env.to_sym, :aws, :secret_access_key),
    fog_provider: "AWS",
    fog_directory: Rails.application.credentials.dig(Rails.env.to_sym, :aws, :bucket),
    fog_region: Rails.application.credentials.dig(Rails.env.to_sym, :aws, :region),
    fog_path_style: "sitemaps",
    fog_public: true
  )

  SitemapGenerator::Sitemap.sitemaps_host = SITEMAP_HOST
  SitemapGenerator::Sitemap.sitemaps_path = "sitemaps"
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
