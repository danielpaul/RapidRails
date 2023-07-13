# frozen_string_literal: true

class App::TopNavigationComponent < ApplicationComponent
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::FormWith
  include ActionView::Helpers::OutputSafetyHelper
  include Heroicon::Engine.helpers

  def initialize(current_user: nil)
    @current_user = current_user
  end

  def template
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
            search_bar
          end

          div(class: "flex items-center gap-x-4 lg:gap-x-6") do
            a(href: "#", class: "button text-neutral-400 hover:text-neutral-500 h-6 w-6 lg:hidden") do
              unsafe_raw heroicon("magnifying-glass")
            end

            div(class: "flex h-6 w-6 items-center justify-center button") do
              render DarkModeButtonComponent.new
            end
            seperator
            user_display
          end
        end
      end
    end
  end

  private

  def open_sidebar_button
    button(
      type: "button",
      class: "button",
      "@click": "sidebarOpen = !sidebarOpen"
    ) do
      span(class: "sr-only") { "Open sidebar" }
      unsafe_raw heroicon("bars-3", options: { class: "h-6 w-6" })
    end
  end

  def seperator(classes: "")
    div(class: "h-5 w-px bg-zinc-900/10 dark:bg-neutral-700 #{classes}") { "" }
  end

  def search_bar
    div(
      class:
        "px-2 w-full lg:w-3/5 hidden lg:flex"
    ) do
      form_with url: root_path, method: :get, class: "w-full" do
        label(for: "search", class: "sr-only") { "Search" }
        div(class: "relative") do
          div(
            class:
              "pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3"
          ) do
            unsafe_raw heroicon("magnifying-glass", options: { class: "h-5 w-5 text-neutral-400" })
          end
          input(
            id: "search",
            name: "search",
            class:
              "text-input w-full rounded-full py-1.5 pl-10 pr-3 shadow-none ring-neutral-300/50 dark:ring-neutral-750",
            placeholder: "Search...",
            type: "search",
            value: helpers.params[:search]
          )
        end
      end
    end
  end

  def user_display
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

      user_dropdown
    end
  end

  def user_dropdown_items
    [
      [
        { label: "Support", path: "#" }
      ],
      [
        { label: "Account Settings", path: edit_user_registration_path }
      ]
    ]
  end

  def user_dropdown
    div(
      role: "menu",
      class: "absolute right-0 z-50 w-64 origin-top-right card shadow-lg mt-4 ring-neutral-900/5",
      aria: { labelledby: "user-menu-button", orientation: "vertical" },
      tabindex: "-1",
      "x-show": "dropdownOpen",
      "@click.away": "dropdownOpen = false",
      "x-transition:enter": "ease-out duration-100",
      "x-transition:enter-start": "transform opacity-0 scale-95",
      "x-transition:enter-end": "transform opacity-100 scale-100",
      "x-transition:leave": "transition ease-in duration-75",
      "x-transition:leave-start": "transform opacity-100 scale-100",
      "x-transition:leave-end": "transform opacity-0 scale-95",
      style: "display: none"
    ) do
      div(class: "py-2 px-3 mb-1 border-b card-border") do
        div(class: "text-xs text-muted") { "Signed in as" }
        div(class: "text-sm font-semibold text-heading truncate") { @current_user.email }
      end

      item_link_classes = "block px-3 py-1 text-sm leading-6 btn-hover"

      user_dropdown_items.each_with_index do |item_group, index|
        div(class: "border-b card-border mt-1 mb-1") { "" } if index != 0

        item_group.each do |item|
          link_to item[:label], item[:path], class: item_link_classes
        end
      end

      link_to "Sign Out", destroy_user_session_path, data: { turbo_method: :delete }, class: item_link_classes
    end
  end
end
