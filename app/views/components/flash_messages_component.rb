class FlashMessagesComponent < ApplicationComponent
  include AlertHelper

  def initialize(flash)
    @flash = flash
  end

  def view_template
    @flash.each do |type, message|
      next if %w[success notice alert error].exclude?(type)

      render AlertComponent.new(type: alert_type(type), message: message, dismissable: true)
    end
  end
end
