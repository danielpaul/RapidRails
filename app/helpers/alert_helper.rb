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
end
