# frozen_string_literal: true

class App::TopNavigationComponent < ApplicationComponent
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include ActionView::Helpers::OutputSafetyHelper
  include Heroicon::Engine.helpers

  def initialize(current_user: nil)
    @current_user = current_user
  end

  def template
    div(id: 'top', class: 'pb-14') {
      div(class: 'top-bar') {

        div(class: 'flex items-center gap-x-4 lg:hidden') {
          open_sidebar_button
          seperator
          link_to(root_path) {
            render 'layouts/components/logo', custom_class: 'h-6'
          }
        }

        div(class: 'flex flex-1 gap-x-4 self-stretch lg:gap-x-6 items-center') {

          div(class: 'relative flex flex-1') {
            search_bar
          }

          div(class: 'flex items-center gap-x-4 lg:gap-x-6') {
            div(class: 'flex h-6 w-6 items-center justify-center button') {
              render DarkModeButtonComponent.new
            }
            seperator
            user_display
          }
        }
      }
    }
  end


  private

  def open_sidebar_button
    button(
      type: "button",
      class: "button", 
      "@click": "sidebarOpen = !sidebarOpen"
    ) {
      span(class: "sr-only") { "Open sidebar" }
      unsafe_raw heroicon("bars-3", options: { class: "h-6 w-6" })
    }
  end

  def seperator(classes: "")
    div(class: "h-5 w-px bg-zinc-900/10 dark:bg-neutral-700 #{classes}") { "" }
  end

  def search_bar
    div(
      class:
        "flex px-2 w-full"
    ) do
      div(class: "w-full") do
        whitespace
        label(for: "search", class: "sr-only") { "Search" }
        div(class: "relative") do
          div(
            class:
              "pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3"
          ) do
            whitespace
            svg(
              class: "h-5 w-5 text-gray-400",
              viewbox: "0 0 20 20",
              fill: "currentColor",
              aria_hidden: "true"
            ) do |s|
              s.path(
                fill_rule: "evenodd",
                d:
                  "M9 3.5a5.5 5.5 0 100 11 5.5 5.5 0 000-11zM2 9a7 7 0 1112.452 4.391l3.328 3.329a.75.75 0 11-1.06 1.06l-3.329-3.328A7 7 0 012 9z",
                clip_rule: "evenodd"
              )
            end
          end
          whitespace
          input(
            id: "search",
            name: "search",
            class:
              "block w-full rounded-md border-0 bg-card dark:bg-[#27262b] py-1.5 pl-10 pr-3 text-slate-800 dark:text-neutral-50 ring-1 ring-inset ring-neutral-300 dark:ring-neutral-750 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-primary sm:text-sm sm:leading-6",
            placeholder: "Search",
            type: "search"
          )
        end
      end
    end
  end

  def user_display
    div(class: 'relative', "x-data": "{ dropdownOpen: false }") {
      button(
        type: "button",
        id: 'user-menu-button',
        class: 'flex items-center -m-1.5 p-1.5',
        aria: {expanded: "false", haspopup: "true"},
        "@click": "dropdownOpen = !dropdownOpen"
      ) {
        span(class: 'sr-only') { "Open user menu" }
        img(src: url_for(@current_user.avatar_url), class: "h-8 w-8 rounded-full bg-neutral-50", alt: "")

        span(class: 'hidden lg:flex lg:items-center') {
          span(
            class: 'ml-4 text-sm font-semibold leading-6 text-heading',
            aria: {hidden: "true"}
          ) {
            @current_user.first_name.capitalize.truncate(20)
          }

          unsafe_raw heroicon("chevron-down", options: { class: "ml-2 h-5 w-5 button" })
        }
      }

      user_dropdown
    }
  end

  def user_dropdown_items
    [
      [
        {label: "Support", path: '#'}
      ],
      [
        {label: "Account Settings", path: edit_user_registration_path}
      ]
    ]
  end

  def user_dropdown
    div(
      role: "menu",
      class: 'absolute right-0 z-50 w-64 origin-top-right card shadow-lg mt-4 ring-neutral-900/5',
      aria: {labelledby: "user-menu-button", orientation: "vertical"},
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
    ) {
      div(class: 'py-2 px-3 mb-1 border-b card-border') {
        div(class: 'text-xs text-muted') { "Signed in as" }
        div(class: 'text-sm font-semibold text-heading truncate') { @current_user.email }
      }

      item_link_classes = 'block px-3 py-1 text-sm leading-6 btn-hover'

      user_dropdown_items.each_with_index do |item_group, index|
        if index != 0
          div(class: 'border-b card-border mt-1 mb-1') { "" }
        end

        item_group.each do |item|
          link_to item[:label], item[:path], class: item_link_classes
        end
      end

      link_to "Sign Out", destroy_user_session_path, data: { turbo_method: :delete }, class: item_link_classes
    }
  end

end