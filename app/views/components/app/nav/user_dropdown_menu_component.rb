# frozen_string_literal: true

class App::Nav::UserDropdownMenuComponent < ApplicationComponent
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include ActionView::Helpers::OutputSafetyHelper
  include Heroicon::Engine.helpers

  def initialize(current_user:)
    @current_user = current_user
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

  def view_template
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
