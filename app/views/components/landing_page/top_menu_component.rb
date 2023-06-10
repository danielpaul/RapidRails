# frozen_string_literal: true

class LandingPage::TopMenuComponent < Phlex::HTML
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes

  def main_menu_items
    [
      {label: "Product", path: "#"},
      {label: "Features", path: "#"},
      {label: "Marketplace", path: "#"},
      {label: "Company", path: "#"}
    ]
  end

  def template
    header(
      class: "sticky top-0 z-40 w-full flex-none transition-color duration-500 lg:z-20 bg-transparent",
      x_data: "{ dropdownOpen: false, atTop: true }",
      ":class": "{ 'bg-transparent': atTop, 'shadow-sm backdrop-blur bg-white dark:bg-body-dark/75 supports-backdrop-blur:bg-white/95 dark:supports-backdrop-blur:bg-body-dark/95 border-b lg:border-slate-900/10 dark:border-none': !atTop}",
      "@scroll.window": "atTop = (window.pageYOffset < 50)"
    ) do
      nav aria_label: "Global", class: "lg:px-8 mx-auto flex max-w-7xl items-center justify-between gap-x-6 p-6" do
        div class: "flex md:flex-1 gap-3 items-center" do
          link_to root_path do
            render "layouts/components/logo"
          end
        end

        div class: "hidden lg:flex lg:gap-x-12" do
          main_menu_items.each do |item|
            link_to item[:label], item[:path],
              class: "text-sm font-semibold leading-6 text-gray-900 dark:text-white hover:text-primary-500"
          end
        end
        div class: "flex flex-1 items-center justify-end gap-x-6" do
          link_to "Sign In", new_user_session_path, class: "link hidden lg:flex text-sm font-medium"
          sign_up_button
        end
        mobile_menu_open_button
      end

      mobile_menu
    end
  end

  private

  def sign_up_button(classes: "")
    link_to "Sign Up", new_user_registration_path, class: "btn-primary justify-end " + classes
  end

  def mobile_menu
    div class: "lg:hidden", style: "display:none", aria_modal: "true", role: "dialog", x_show: "dropdownOpen" do
      # Background backdrop, show/hide based on slide-over state.
      div class: "fixed inset-0 z-20 backdrop-blur-md bg-white/30", "@click": "dropdownOpen = false"

      div(class: "fixed inset-y-0 right-0 z-20 w-full overflow-y-auto bg-white dark:bg-body-dark px-6 py-6 sm:max-w-sm sm:ring-1 sm:ring-gray-900/10") do
        div(class: "flex items-center gap-x-6") do
          render "layouts/components/logo"
          sign_up_button(classes: "ml-auto")
          mobile_menu_close_button
        end
        div(class: "mt-6 flow-root") do
          div(class: "divide-gray-500/10 -my-6 divide-y") do
            div(class: "space-y-2 py-6") do
              main_menu_items.each do |item|
                link_to item[:label], item[:path], class: mobile_menu_link_classes
              end
            end
            div(class: "py-6") do
              link_to "Sign In", new_user_session_path, class: "#{mobile_menu_link_classes} py-2.5"
            end
          end
        end
      end
    end
  end

  def mobile_menu_link_classes
    "-mx-3 block rounded-lg px-3 py-2 text-base font-semibold leading-7 text-gray-900 dark:text-white hover:bg-gray-50 dark:hover:bg-card-dark hover:text-primary-500"
  end

  def mobile_menu_open_button
    div(class: "flex lg:hidden") do
      button(
        class: "inline-flex items-center justify-center rounded-md text-gray-700 dark:text-gray-300 -m-2.5 p-2.5",
        type: "button",
        "@click": "dropdownOpen = !dropdownOpen"
      ) do
        span(class: "sr-only") { "Open main menu" }
        svg(
          aria_hidden: "true",
          class: "h-6 w-6",
          fill: "none",
          stroke: "currentColor",
          stroke_width: "1.5",
          viewbox: "0 0 24 24"
        ) do |s|
          s.path(
            d: "M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5",
            stroke_linecap: "round",
            stroke_linejoin: "round"
          )
        end
      end
    end
  end

  def mobile_menu_close_button
    button(
      class: "rounded-md text-gray-700 dark:text-gray-300 -m-2.5 p-2.5",
      type: "button",
      "@click": "dropdownOpen = !dropdownOpen"
    ) do
      span(class: "sr-only") { "Close menu" }
      svg(
        aria_hidden: "true",
        class: "h-6 w-6",
        fill: "none",
        stroke: "currentColor",
        stroke_width: "1.5",
        viewbox: "0 0 24 24"
      ) do |s|
        s.path(
          d: "M6 18L18 6M6 6l12 12",
          stroke_linecap: "round",
          stroke_linejoin: "round"
        )
      end
    end
  end
end
