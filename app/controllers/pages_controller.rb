class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout "application_landing_page"

  def show
    set_meta_tags canonical: (params[:id] == "home") ? root_path : page_path(params[:id])

    if params[:id].include?("legal/")

      # whitelist for security
      sanitized_id = ActiveStorage::Filename.new(params[:id].sub("legal/","")).sanitized

      begin
        @md_file = File.read("app/views/pages/legal/#{sanitized_id}.md")
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
