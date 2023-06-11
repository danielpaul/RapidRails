class ContentfulController < ApplicationController
  http_basic_authenticate_with 
    name: Rails.credentials.dig(Rails.env.to_sym, :contentful, :space_id),
    password: Rails.credentials.dig(Rails.env.to_sym, :contentful, :webhook_password)

  skip_before_action :verify_authenticity_token, only: :webhook

  def webhook
    data = JSON.parse(request.body.read)
    contentful = ContentfulService.new

    cleared_cache_keys = []
    new_cached_data = []

    if data['sys']['contentType']['sys']['id'] == 'blogPost'

      # clear all page cache & cache just the first page of the blog
      cleared_cache_keys << contentful.posts_cache_clear
      new_cached_data << contentful.posts.map(&:id)

      if data['fields'] && data['fields']['slug']
        post_slug = data['fields']['slug']['en-US']
        cleared_cache_keys << contentful.post_cache_clear(post_slug)
        new_cached_data << contentful.post(post_slug)&.id
      end
      
    end

    render json: {
      message: 'ok',
      cleared_cache_keys:,
      new_cached_data:
    }, status: :ok
  end
end
