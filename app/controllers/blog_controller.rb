class BlogController < ApplicationController
  include ContentfulHelper

  layout 'application_landing_page'

  def index
    @page = (params[:page] || 1).to_i
    @posts = contentful_service.posts(@page)

    render_404 if @posts.empty?
  end

  def show
    @post = contentful_service.post(params[:id])
    render_404 if @post.nil?
  end

  private

  def render_404
    raise ActionController::RoutingError, "Not Found"
  end
end
