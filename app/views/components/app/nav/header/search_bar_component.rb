# frozen_string_literal: true

class App::Nav::Header::SearchBarComponent < ApplicationComponent
  include Phlex::Rails::Helpers::FormWith
  include ActionView::Helpers::OutputSafetyHelper
  include Heroicon::Engine.helpers

  def template
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
end
