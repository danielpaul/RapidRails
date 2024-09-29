# frozen_string_literal: true

class App::Nav::Header::MenuComponent < App::Nav::Header::BaseComponent
  def initialize(current_user: nil)
    @current_user = current_user
  end

  def view_template
    div(id: "top", class: "pb-14") do
      div(class: "top-bar") do
        div(class: "flex items-center gap-x-4 lg:hidden") do
          open_sidebar_button
          seperator
          link_to(root_path) do
            render "layouts/components/logo", custom_class: "h-6"
          end
        end

        div(class: "flex flex-1 gap-x-4 self-stretch lg:gap-x-6 items-center") do
          div(class: "relative flex flex-1") do
            render App::Nav::Header::SearchBarComponent.new
          end

          div(class: "flex items-center gap-x-4 lg:gap-x-6") do
            a(href: "#", class: "button text-neutral-400 hover:text-neutral-500 h-6 w-6 lg:hidden") do
              unsafe_raw heroicon("magnifying-glass")
            end

            div(class: "flex h-6 w-6 items-center justify-center button") do
              render DarkModeButtonComponent.new
            end
            seperator

            render App::Nav::Header::UserDisplayComponent.new(current_user: @current_user)
          end
        end
      end
    end
  end
end
