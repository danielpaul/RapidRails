# For Contentful Webhooks

class ContentfulController < ApplicationController
  include ContentfulHelper

  before_action :verify_blog_enabled!, :verify_api_key!
  skip_before_action :verify_authenticity_token, only: :webhook

  def webhook
    data = JSON.parse(request.body.read)
    contentful = ContentfulService.new

    cleared_cache_keys = []
    new_cached_data = []

    if data["sys"]["contentType"]["sys"]["id"] == "blogPost"

      # clear all page cache & cache just the first page of the blog
      cleared_cache_keys << contentful.posts_cache_clear
      new_cached_data << contentful.posts.map(&:id)

      if data["fields"] && data["fields"]["slug"]
        post_slug = data["fields"]["slug"]["en-US"]
        cleared_cache_keys << contentful.post_cache_clear(post_slug)
        new_cached_data << contentful.post(post_slug)&.id
      end

    end

    render json: {
      message: "ok",
      cleared_cache_keys:,
      new_cached_data:
    }, status: :ok
  end

  private

  def verify_api_key!
    # Contenful will send an API webhook to our server with a secret key in the header
    # We need to verify that the secret key matches the one we have in our credentials for the webhook

    # This is the secret key that we have in our credentials for the webhook
    webhook_secret_token = Rails.application.credentials.dig(Rails.env.to_sym, :contentful, :webhook_secret_token)

    # This is the secret key that Contentful will send in the header
    contentful_webhook_secret_token = request.headers["Authorization:Bearer"]

    # If the secret key does not match, we will return a 404
    render_404! if webhook_secret_token != contentful_webhook_secret_token
  end
end
