class FlashToastWrapperComponent < ApplicationComponent
  register_element :turbo_frame

  def template
    # Global notification live region, render this permanently at the end of the document
    div(id: "flash-toasts-wrapper", class: "pointer-events-none fixed inset-0 flex px-4 py-6 items-start sm:p-6 z-20", aria_live: "assertive") {
      turbo_frame(id: "flash-toasts", class: "flex w-full flex-col space-y-4 #{position}") {
        render "shared/flash_toast"
      }
    }
  end

  private

  def position
    # items-end = right, items-start = left, items-center = middle
    # margin top spacing for menu bar
    "items-end mt-10"
  end
end
