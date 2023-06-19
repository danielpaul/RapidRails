module AlertHelper
  def alert_icon(type)
    {
      "success" => "check-circle",
      "error" => "x-circle"
    }.fetch(type.to_s, "exclamation-circle")
  end

  def alert_type(type)
    {
      "success" => "success",
      "alert" => "danger",
      "error" => "danger"
    }.fetch(type.to_s, "warning")
  end

  def close_button
    div(class: "ml-auto pl-3") {
      div(class: "-mx-1.5 -my-1.5") {
        button(type: "button", class: "close-btn", '@click': "show = false") {
          span(class: "sr-only") { "Close" }
          unsafe_raw heroicon("x-mark", options: {class: "h-4 w-4"})
        }
      }
    }
  end
end
