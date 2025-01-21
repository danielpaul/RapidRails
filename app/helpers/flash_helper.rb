module FlashHelper
  # Usage: flash_message(:success, "Success!", "You did it!")
  # used by toast flash messages
  def flash_message(type, heading, body = nil, now: false)
    toast = if now
      flash.now[:toast] ||= []
    else
      flash[:toast] ||= []
    end

    toast << {type:, heading:, body:}
  end
end
