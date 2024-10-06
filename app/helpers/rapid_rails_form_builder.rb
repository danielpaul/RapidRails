class RapidRailsFormBuilder < ActionView::Helpers::FormBuilder
  class_attribute :text_field_helpers,
    default: field_helpers - %i[label fields_for fields hidden_field]
  #  leans on the FormBuilder class_attribute `field_helpers`
  #  you'll want to add a method for each of the specific helpers listed here if you want to style them

  text_field_helpers.each do |field_method|
    class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def #{field_method}(method, options = {})
          if options.delete(:tailwindified)
            super
          else
            text_like_field(#{field_method.inspect}, method, options)
          end
        end
    RUBY_EVAL
  end

  def submit(value = nil, options = {}, &block)
    classes = options[:class] || "btn-primary"
    super(
      value,
      {
        class: classes
      }.merge(options).merge(
        button_data_disable_with(value, options)
      ),
      &block
    )
  end

  def button(value = nil, options = {}, &block)
    classes = options[:class] || "btn-primary"
    super(
      value,
      {
        class: classes
      }.merge(options).merge(
        button_data_disable_with(value, options)
      ),
      &block
    )
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    form_field(method, options, html_options) do
      super(
        method,
        choices,
        options,
        html_options.merge(class: "select-input #{html_options[:class]}"),
        &block
      )
    end
  end

  def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
    form_field(method, options, html_options) do
      super(
        method,
        collection,
        value_method,
        text_method,
        options,
        html_options.merge(class: "select-input #{html_options[:class]}")
      )
    end
  end

  def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
    radio_check_form_field(method, options) do
      super(
        method,
        options.merge(class: "check-box-input #{options[:class]}"),
        checked_value,
        unchecked_value
      )
    end
  end

  def radio_button(method, tag_value, options = {})
    radio_check_form_field(method, options.merge(value: tag_value)) do
      super(
        method,
        tag_value,
        options.merge(class: "radio-button-input #{options[:class]}")
      )
    end
  end

  private

  # For multiple fields that are all based on the input field style
  # e.g. text_field, email_field, password_field, etc.
  def text_like_field(field_method, object_method, options = {})
    form_field(object_method, options) do
      send(
        field_method,
        object_method,
        options.merge({
          tailwindified: true,
          class: "text-input #{options[:class]}"
        }).except(:label, :error, :hint)
      )
    end
  end

  # wrapper with error and disabled classes
  def wrapper_classes(method, options)
    wrapper_classes = ["form-field"]
    wrapper_classes << "disabled" if options[:disabled]

    wrapper_classes << "error" if errors_for(method, options).present?

    wrapper_classes.join(" ")
  end

  def label(method, text = nil, options = {}, &block)
    new_options = options.except(:label, :error, :hint, :id).merge(
      class: "#{options[:class]} #{"required" if options[:required]}"
    )

    if options[:id]
      new_options[:id] = "#{options[:id]}_label"
      new_options[:for] = options[:id]
    end

    super(
      method,
      text,
      new_options,
      &block
    )
  end

  # for most fields
  def form_field(method, options = {}, more_options = {})
    label = if options[:label] == false
      ""
    else
      @template.content_tag(
        "div",
        label(
          method,
          options[:label],
          options.merge(class: "label")
        ),
        {class: "mb-2"}
      )
    end

    errors = errors_for(method, options)
    errors = label(method, errors, {class: "error-label"}) if errors.present?

    hint = (@template.content_tag("p", options[:hint], {class: "hint"}) if options[:hint].present?)

    @template.content_tag("div", {class: wrapper_classes(method, options.merge(more_options))}) do
      [label, yield, errors, hint].join.html_safe
    end
  end

  # only for radio buttons and check boxes
  # where the labels are beside it and we don't support error and hint messages
  def radio_check_form_field(method, options = {})
    label = @template.content_tag(
      "div",
      label(
        method,
        options[:label],
        options.merge(class: "radio-check-label")
      )
    )

    @template.content_tag("div", {class: wrapper_classes(method, options)}) do
      @template.content_tag("div", {class: "group flex items-center"}) do
        yield + label
      end
    end
  end

  # get manual errors and errors from the object
  # return as error message.
  # manual error takes precedence.
  def errors_for(object_method, options)
    return if options[:error].blank? && (@object.blank? || object_method.blank? || @object.errors[object_method].empty?)

    options[:error] || @object.errors[object_method].join(", ")
  end

  # Automatic disable_with for buttons with spinner animation
  def button_data_disable_with(value, options)
    return if (options[:data] && options[:data][:turbo_disable_with]) || options[:data_turbo_disable_with]

    # just adds a spinner to the same button text
    {"data-turbo-submits-with": spinner_svg + value}
  end

  def spinner_svg
    html = <<-HTML
      <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white inline-block" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    HTML

    html.html_safe
  end
end