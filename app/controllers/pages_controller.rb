class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout "application_landing_page"

  def show
    set_meta_tags canonical: params[:id] == "home" ? root_path : page_path(params[:id])

    if params[:id].include?("legal/")

      # whitelist for security
      md_file_whitelist = %w[privacy_policy terms_conditions]
      sanitized_id = ActiveStorage::Filename.new(params[:id].sub("legal/", "")).sanitized

      # Ensure sanitized_id only contains allowed values
      md_id = (sanitized_id if md_file_whitelist.include?(sanitized_id))

      begin
        raise ActionController::RoutingError, "Not Found" unless md_id

        @md_file = File.read(Rails.root.join("app", "views", "pages", "legal", "#{md_id}.md"))
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
