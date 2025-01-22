class FlashToastComponent < ApplicationComponent
  include ActionView::Helpers::OutputSafetyHelper
  include Heroicon::Engine.helpers
  include AlertHelper

  def initialize(toast, index)
    @toast = toast
    @index = index
  end

  def view_template
    div(
      class: "pointer-events-auto w-full max-w-sm overflow-hidden card shadow-lg",
      style: "display: none;",

      x_data: "{ show: false }",
      x_init: "() => { setTimeout(() => { show = true }, #{show_in}); setTimeout(() => { show = false }, #{hide_in}); }",
      x_show: "show",

      "x-transition:enter": "transform ease-out duration-300 transition",
      "x-transition:enter-start": "translate-y-2 opacity-0 sm:translate-y-0 sm:translate-x-2",
      "x-transition:enter-end": "translate-y-0 opacity-100 sm:translate-x-0",
      "x-transition:leave": "transition ease-in duration-100",
      "x-transition:leave-start": "opacity-100",
      "x-transition:leave-end": "opacity-0"
    ) {
      div(class: "p-4") {
        div(class: "flex items-start") {
          div(class: "flex-shrink-0") {
            unsafe_raw heroicon(
              alert_icon(alert_type(@toast[:type])),
              variant: "solid",
              options: {class: "alert-#{alert_type(@toast[:type])}-icon"}
            )
          }

          div(class: "ml-3 w-0 flex-1") {
            h5(class: "h5 font-medium") {
              @toast[:heading]
            }

            if @toast[:body]
              p(class: "mt-1 p") {
                @toast[:body]
              }
            end
          }

          close_button
        }
      }
    }
  end

  private

  def show_in
    100 * (@index + 1)
  end

  def hide_in
    5000 - (150 * (@index + 1))
  end
end
