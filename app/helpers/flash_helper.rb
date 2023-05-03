module FlashHelper
  # Usage: flash_message(:success, "Success!", "You did it!")
  # used by toast flash messages
  def flash_message(type, heading, body = nil, now: false)
    if now
      toast = flash.now[:toast] ||= []
    else
      toast = flash[:toast] ||= []
    end

    toast << { type:, heading:, body: }
  end
end