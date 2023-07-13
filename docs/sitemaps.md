# Sitemaps

This guide provides a brief overview of how to use the [sitemap.rb](https://github.com/danielpaul/RapidRails/blob/main/config/sitemap.rb) configuration file in your Rails application. For more info visit the [sitemaps_generator GitHub](https://github.com/kjvarga/sitemap_generator).

## Adding Pages to the Sitemap

Inside the `SitemapGenerator::Sitemap.create` block, you can add pages to your sitemap.

## Sitemap Generation in Production

In a production environment, the sitemap is stored in an AWS S3 bucket. The bucket and region are specified in the Rails credentials. Remember to replace the AWS credentials and bucket details with your own.

## Rake Tasks

To refresh sitemaps run:

> `rake sitemap:refresh`

Schedule this rake task to run once a day in production.