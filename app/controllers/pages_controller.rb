class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout "application_landing_page"

  caches_page :show

  def show
    if params[:id].include?('legal/')
      begin
        @md_file = File.read("app/views/pages/#{params[:id]}.md")
      rescue Errno::ENOENT
        raise ActionController::RoutingError, "Not Found"
      end
      
      set_meta_tags title: @md_file.lines.first.strip.gsub(/^#+\s*/, '')
      render template: 'pages/legal/show'
    else
      super
    end
  end
end
