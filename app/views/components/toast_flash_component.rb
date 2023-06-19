class ToastFlashComponent < ApplicationComponent

  def initialize(flash)
    @flash = flash
  end

  def template
    # Global notification live region, render this permanently at the end of the document
    div(class: "pointer-events-none fixed inset-0 flex px-4 py-6 items-start sm:p-6 z-40", aria_live: 'assertive') {
      div(class: "flex w-full flex-col space-y-4 #{position}") {
        @flash[:toast]&.each_with_index do |toast, index|
          toast = toast.with_indifferent_access
          next unless toast[:heading]

          render ToastCardComponent.new(toast, index)
        end
      }
    }
  end

  private

  def position
    # items-end = right, items-start = left, items-center = middle
    # margin top spacing for menu bar
    "items-end mt-10"
  end

  class ToastCardComponent < ApplicationComponent
    include ActionView::Helpers::OutputSafetyHelper
    include Heroicon::Engine.helpers
    include AlertHelper

    def initialize(toast, index)
      @toast = toast
      @index = index
    end

    def template
      div(
        class: "pointer-events-auto w-full max-w-sm overflow-hidden card shadow-lg",
        style: "display: none;",

        x_data: "{ show: false }",
        x_init: "() => { setTimeout(() => { show = true }, #{show_in}); setTimeout(() => { show = false }, #{hide_in}); }",
        x_show: "show",

        'x-transition:enter': "transform ease-out duration-300 transition",
        'x-transition:enter-start': "translate-y-2 opacity-0 sm:translate-y-0 sm:translate-x-2",
        'x-transition:enter-end': "translate-y-0 opacity-100 sm:translate-x-0",
        'x-transition:leave': "transition ease-in duration-100",
        'x-transition:leave-start': "opacity-100",
        'x-transition:leave-end': "opacity-0"
      ) {
        div(class: 'p-4') {
          div(class: 'flex items-start') {
            div(class: 'flex-shrink-0') {
              unsafe_raw heroicon(
                alert_icon(alert_type(@toast[:type])),
                variant: 'solid',
                options: {class: "alert-#{alert_type(@toast[:type])}-icon"}
              ) 
            }

            div(class: "ml-3 w-0 flex-1") {
              h4(class: "h4") {
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

    def close_button
      div(class: "ml-4 flex flex-shrink-0") do
        button(
          '@click': "show = false",
          type: "button",
          class:
            "inline-flex rounded-md bg-white dark:bg-card-dark text-neutral-400 hover:text-neutral-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
        ) do
          span(class: "sr-only") { "Close" }
          unsafe_raw heroicon("x-mark", options: {class: "h-5 w-5"})
        end
      end
    end
  end

end