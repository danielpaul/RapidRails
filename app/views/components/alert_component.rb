class AlertComponent < ApplicationComponent
  include ActionView::Helpers::OutputSafetyHelper
  include Heroicon::Engine.helpers
  include AlertHelper

  def initialize(type: nil, message: nil, dismissable: true)
    @type = type
    @message = message
    @dismissable = dismissable
  end

  def template(&block)
    div(class: "alert-#{@type}", x_data: "{show: true}", x_show: "show", 'data-turbo-cache': "false") {
      unsafe_raw heroicon(
        alert_icon(@type),
        variant: "solid",
        options: {class: "alert-#{@type}-icon"}
      )
      div { 
        div(class: 'font-medium') { @message }

        if block_given?
          div(class: 'mt-2 body') { yield }
        end
      }

      close_button if @dismissable
    }
  end

  private

  def close_button
    div(class: "ml-auto pl-3") {
      div(class: "-mx-1.5 -my-1.5") {
        button(type: "button", class: "close-btn", '@click': "show = false") {
          span(class: "sr-only") { "Dismiss" }
          unsafe_raw heroicon("x-mark", options: {class: "h-4 w-4"})
        }
      }
    }
  end

end