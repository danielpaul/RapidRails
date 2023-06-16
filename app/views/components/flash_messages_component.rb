class FlashMessagesComponent < ApplicationComponent

  def initialize(flash)
    @flash = flash
  end

  def template
    @flash.each do |type, message|
      next if ['success', 'notice', 'alert', 'error'].exclude?(type)
      render AlertComponent.new(type: parse_flash_type(type), message: message, dismissable: true)
    end
  end

  private

  def parse_flash_type(type)
    case type
    when "success"
      "success"
    when "notice"
      "warning"
    when "alert"
      "danger"
    when "error"
      "danger"
    else
      type
    end
  end

end