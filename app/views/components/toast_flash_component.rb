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

  def render_toast(toast, index)
    show_in = 100 * (index + 1)
    hide_in = 5000 - (150 * (index + 1))
  end

  class ToastCardComponent < ApplicationComponent
    def initialize(toast, index)
      @toast = toast
      @index = index
    end

    def template
      plain @toast.inspect
    end
  end

end