class App::Nav::Header::UserDisplayComponent < ApplicationComponent
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include ActionView::Helpers::OutputSafetyHelper
  include Heroicon::Engine.helpers

  def initialize(current_user:)
    @current_user = current_user
  end

  def view_template
    div(class: "relative", "x-data": "{ dropdownOpen: false }") do
      button(
        type: "button",
        id: "user-menu-button",
        class: "flex items-center -m-1.5 p-1.5",
        aria: { expanded: "false", haspopup: "true" },
        "@click": "dropdownOpen = !dropdownOpen"
      ) do
        span(class: "sr-only") { "Open user menu" }
        img(src: url_for(@current_user.avatar_url), class: "h-8 w-8 rounded-full bg-neutral-50", alt: "")

        span(class: "hidden lg:flex lg:items-center") do
          span(
            class: "ml-4 text-sm font-semibold leading-6 text-heading",
            aria: { hidden: "true" }
          ) do
            @current_user.first_name.capitalize.truncate(20)
          end

          unsafe_raw heroicon("chevron-down", options: { class: "ml-2 h-5 w-5 button" })
        end
      end

      render App::Nav::UserDropdownMenuComponent.new(current_user: @current_user)
    end
  end
end
