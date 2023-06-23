class BlogController < ApplicationController
  include ContentfulHelper

  layout "application_landing_page"

  def index
    @page = (params[:page] || 1).to_i
    @posts = contentful_service.posts(@page)

    render_404! if @posts.empty?
  end

  def show
    @post = contentful_service.post(params[:id])
    render_404! if @post.nil?

    set_meta_tags(
      title: @post.title,
      description: @post.excerpt,
      article: {
        published_time: @post.published_at,
        modified_time: @post.updated_at
      }
    )
  end
end
