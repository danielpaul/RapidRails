module FlashHelper
  # Usage: flash_message(:success, "Success!", "You did it!")
  # used by toast flash messages
  def flash_message(type, heading, body = nil)
    flash[:toast] ||= []
    flash[:toast] << { type:, heading:, body: }
  end
end