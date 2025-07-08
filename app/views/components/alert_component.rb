class AlertComponent < ApplicationComponent
  include Phlex::DeferredRender
  include ActionView::Helpers::OutputSafetyHelper
  include Heroicon::Engine.helpers
  include AlertHelper

  def initialize(type: nil, message: nil, dismissable: true)
    @type = type
    @message = message
    @dismissable = dismissable
  end

  def view_template
    div(class: "alert-#{@type}", x_data: "{show: true}", x_show: "show", "data-turbo-cache": "false") do
      unsafe_raw heroicon(
        alert_icon(@type),
        variant: "solid",
        options: { class: "alert-#{@type}-icon" }
      )
      div do
        div(class: "font-medium") { @message }

        div(class: "mt-2 body", &@body) if @body
      end

      close_button if @dismissable
    end
  end

  def body(&block)
    @body = block
  end
end
