# frozen_string_literal: true

class App::Nav::Header::BaseComponent < ApplicationComponent
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include ActionView::Helpers::OutputSafetyHelper
  include Heroicon::Engine.helpers

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
end
