class DarkModeButtonComponent < Phlex::HTML
  include Phlex::Rails::Helpers::LinkTo
  include ActionView::Helpers::OutputSafetyHelper
  include Heroicon::Engine.helpers

  def template
    div class: "relative bg-white dark:bg-slate-900/50 p-1 rounded-lg cursor-pointer ring-1 ring-inset ring-gray-300 dark:ring-slate-700", "@click": "darkModeMenu = !darkModeMenu", "x-data": "{ darkModeMenu: false }" do
      unsafe_raw heroicon(
        "sun",
        variant: "solid",
        options: {
          class: "h-5 w-5 text-primary dark:text-white"
        }
      )

      div(
        :class => "absolute left-0 z-10 w-32 origin-top-right rounded-md bg-card dark:bg-card-dark py-2 shadow-lg ring-1 focus:outline-none text-gray-900 dark:text-white mt-2.5 ring-gray-900/5",
        "aria-labelledby" => "user-menu-button",
        "aria-orientation" => "vertical",
        :role => "menu",
        :tabindex => "-1",
        :"x-show" => "darkModeMenu",
        :"@click.away" => "darkModeMenu = false",
        :"x-transition:enter" => "ease-out duration-100",
        :"x-transition:enter-start" => "transform opacity-0 scale-95",
        :"x-transition:enter-end" => "transform opacity-100 scale-100",
        :"x-transition:leave" => "transition ease-in duration-75",
        :"x-transition:leave-start" => "transform opacity-100 scale-100",
        :"x-transition:leave-end" => "transform opacity-0 scale-95"
      ) do
        link_to "javascript:void()", class: "flex gap-2 items-center block px-4 py-1 text-sm leading-6 hover:bg-gray-50 dark:hover:bg-body-dark", "data-action": "dark-mode#lightMode" do
          unsafe_raw heroicon(
            "sun",
            variant: "solid",
            options: {
              class: "h-5 w-5 text-primary dark:text-white"
            }
          )
          div do "Light" end
        end
        link_to "javascript:void()", class: "flex gap-2 items-center block px-4 py-1 text-sm leading-6 hover:bg-gray-50 dark:hover:bg-body-dark", "data-action": "dark-mode#darkMode" do
          unsafe_raw heroicon(
            "moon",
            variant: "solid",
            options: {
              class: "h-5 w-5 text-primary dark:text-white"
            }
          )
          div do "Dark" end
        end
        link_to "javascript:void()", class: "flex gap-2 items-center block px-4 py-1 text-sm leading-6 hover:bg-gray-50 dark:hover:bg-body-dark", "data-action": "dark-mode#systemSetting" do
          unsafe_raw heroicon(
            "computer-desktop",
            variant: "solid",
            options: {
              class: "h-5 w-5 text-primary dark:text-white"
            }
          )
          div do "System" end
        end
      end
    end
  end
end
