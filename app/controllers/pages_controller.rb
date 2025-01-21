class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout "application_landing_page"

  def show
    set_meta_tags canonical: (params[:id] == "home") ? root_path : page_path(params[:id])

    if params[:id].include?("legal/")

      # whitelist for security
      @md_id = %w[privacy_policy terms_conditions].any?{|e| "legal/#{e}" == params[:id]} ? params[:id] : "404"

      begin
        @md_file = File.read("app/views/pages/#{@md_id}.md")
      rescue Errno::ENOENT
        raise ActionController::RoutingError, "Not Found"
      end

      set_meta_tags title: @md_file.lines.first.strip.gsub(/^#+\s*/, "")
      render template: "pages/legal/show"
    else
      super
    end
  end
end
