# frozen_string_literal: true

# Footer component for the landing page
class LandingPage::FooterComponent < Phlex::HTML
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include ActionView::Helpers::OutputSafetyHelper
  include Heroicon::Engine.helpers

  def main_menu_items
    [
      {
        heading: "Solutions",
        items: [
          {label: "Marketing", path: "#"},
          {label: "Analytics", path: "#"},
          {label: "Commerce", path: "#"},
          {label: "Insights", path: "#"}
        ]
      },
      {
        heading: "Support",
        items: [
          {label: "Pricing", path: "#"},
          {label: "Documentation", path: "#"},
          {label: "Guides", path: "#"},
          {label: "API Status", path: "#"}
        ]
      },
      {
        heading: "Company",
        items: [
          {label: "About", path: "#"},
          {label: "Blog", path: "#"},
          {label: "Jobs", path: "#"},
          {label: "Press", path: "#"},
          {label: "Partners", path: "#"}
        ]
      },
      {
        heading: "Legal",
        items: [
          {label: "Claim", path: "#"},
          {label: "Privacy", path: page_path('legal/privacy_policy')},
          {label: "Terms", path: page_path('legal/terms_conditions')}
        ]
      }
    ]
  end

  def template
    footer(class: "bg-card dark:bg-card-dark border-t card-border", aria_labelledby: "footer-heading") do
      h2(id: "footer-heading", class: "sr-only") { "Footer" }
      div(class: "mx-auto max-w-7xl px-6 pb-8 pt-12 sm:pt-16 lg:px-8 lg:pt-20") do
        div(class: "xl:grid xl:grid-cols-3 xl:gap-8") do
          div(class: "grid grid-cols-2 gap-8 xl:col-span-2") do
            main_menu_items.each_slice(2) do |slice|
              div(class: "md:grid md:grid-cols-2 md:gap-8") do
                slice.each_with_index do |item, index|
                  div(class: (index != 0) ? "mt-10 md:mt-0" : nil) do
                    h3(
                      class:
                        "text-sm font-semibold leading-6 text-gray-900 dark:text-white "
                    ) { item[:heading] }
                    ul(role: "list", class: "mt-6 space-y-4") do
                      item[:items].each do |subitem|
                        li do
                          a(
                            href: subitem[:path],
                            class:
                              "text-sm link-secondary"
                          ) { subitem[:label] }
                        end
                      end
                    end
                  end
                end
              end
            end
          end

          div(class: "mt-10 xl:mt-0") do
            h3(
              class:
                "text-sm font-semibold leading-6 text-gray-900 dark:text-white "
            ) { "Subscribe to our newsletter" }
            p(class: "mt-2 text-sm leading-6 text-gray-600 dark:text-gray-300") do
              "The latest news, articles, and resources, sent to your inbox weekly."
            end
            form(class: "mt-6 sm:flex sm:max-w-md") do
              label(for: "email-address", class: "sr-only") { "Email address" }
              input(
                type: "email",
                name: "email-address",
                id: "email-address",
                required: true,
                class:
                  "text-input",
                placeholder: "Enter your email"
              )
              div(class: "mt-4 sm:ml-4 sm:mt-0 sm:flex-shrink-0") do
                button(
                  type: "submit",
                  class:
                    "flex w-full items-center justify-center btn-primary"
                ) { "Subscribe" }
              end
            end
          end
        end

        div(
          class:
            "mt-12 border-t card-border pt-8 flex items-center justify-between lg:mt-16"
        ) do
          p(
            class:
              "text-xs leading-5 text-gray-500 dark:text-gray-400 order-1 md:mt-0"
          ) do
            plain "© #{Date.today.year} #{COMPANY_NAME}. All rights reserved."
          end
          div class: "order-2" do
            render DarkModeButtonComponent.new
          end
        end
      end
    end
  end
end
