class FormErrorsComponent < ApplicationComponent
  include ActionView::Helpers::TextHelper

  def initialize(object)
    @object = object
  end

  def view_template
    return if @object.errors.empty?

    render AlertComponent.new(
      type: "danger",
      message: "#{pluralize(@object.errors.count, "error")} prohibited this from being saved:",
      dismissable: false
    ) do |alert|
      alert.body {
        ul(class: "list-disc list-inside") {
          @object.errors.full_messages.each do |msg|
            li { msg }
          end
        }
      }
    end
  end

end
