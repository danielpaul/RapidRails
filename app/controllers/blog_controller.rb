class BlogController < ApplicationController
  def index
    @page = (params[:page] || 1).to_i
    @posts = contentful.posts(@page)

    render_404 if @posts.empty?
  end

  def show
    @post = contentful.post(params[:id])
    render_404 if @post.nil?
  end

  private

  def contentful
    @contentful ||= ContentfulService.new
  end

  def render_404
    raise ActionController::RoutingError, "Not Found"
  end
end
