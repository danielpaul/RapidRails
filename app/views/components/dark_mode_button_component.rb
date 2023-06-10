class DarkModeButtonComponent < Phlex::HTML
  include Phlex::Rails::Helpers::LinkTo
  include ActionView::Helpers::OutputSafetyHelper
  include Heroicon::Engine.helpers

  def template
    div(
      "@click": "darkModeMenu = !darkModeMenu",
      "x-data": "{ darkModeMenu: false }",
      "data-controller": "dark-mode"
    ) do
      a(
        href: "#",
        class: "text-gray-400 hover:text-gray-500 dark:hidden",
        data: {action: "click->dark-mode#darkMode:prevent"}
      ) do
        unsafe_raw heroicon(
          "sun",
          options: {
            class: "h-6 w-6"
          }
        )
      end

      a(
        href: "#",
        class: "text-gray-400 hover:text-gray-500 hidden dark:block",
        data: {action: "click->dark-mode#lightMode:prevent"}
      ) do
        unsafe_raw heroicon(
          "moon",
          options: {
            class: "h-6 w-6"
          }
        )
      end
    end
  end
end
