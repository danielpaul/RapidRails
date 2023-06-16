class AlertComponent < ApplicationComponent
  include ActionView::Helpers::OutputSafetyHelper
  include Heroicon::Engine.helpers

  def initialize(type: nil, message: nil, dismissable: true)
    @type = type
    @message = message
    @dismissable = dismissable
  end

  def template
    div(class: alert_class) {
      unsafe_raw heroicon(icon, variant: "solid", options: {class: "icon"})
      div { @message }
      close_button if @dismissable
    }
  end

  private

  def alert_class
    # need to do this so Tailwind knows that these 
    # claases are being used and compiles the classes
    case @type
    when "success"
      'alert-success'
    when "warning"
      'alert-warning'
    when "danger"
      'alert-danger'
    end
  end

  def icon
    case @type
    when "success"
      "check-circle"
    when "warning"
      "exclamation-circle"
    when "danger"
      "x-circle"
    end
  end

  def close_button
    div(class: "ml-auto pl-3") do
      div(class: "-mx-1.5 -my-1.5") do
        button(type: "button", class: "close-btn") do
          span(class: "sr-only") { "Dismiss" }
          unsafe_raw heroicon("x-mark", options: {class: "h-4 w-4"})
        end
      end
    end
  end

end