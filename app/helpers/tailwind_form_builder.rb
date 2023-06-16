# https://blog.testdouble.com/posts/2022-12-05-blending-tailwind-with-rails-forms/

class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  class_attribute :text_field_helpers,
    default: field_helpers - %i[label fields_for fields hidden_field]
  #  leans on the FormBuilder class_attribute `field_helpers`
  #  you'll want to add a method for each of the specific helpers listed here if you want to style them

  TEXT_FIELD_STYLE = "text-input".freeze
  SELECT_FIELD_STYLE = "select-input".freeze
  CHECK_BOX_FIELD_STYLE = "check-box-input".freeze
  RADIO_BUTTON_FIELD_STYLE = "radio-button-input".freeze
  SUBMIT_BUTTON_STYLE = "btn-primary".freeze

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

  def submit(value = nil, options = {})
    classes = options[:class] || SUBMIT_BUTTON_STYLE
    super(
      value,
      {
        class: classes
      }.merge(options).merge(
        button_data_disable_with(value, options)
      )
    )
  end

  def button(value = nil, options = {}, &block)
    classes = options[:class] || SUBMIT_BUTTON_STYLE
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
    classes = apply_style_classes(SELECT_FIELD_STYLE, options, method)

    labels = labels(:select, method, options)
    field = super(method, choices, options, html_options.merge({class: classes}), &block)

    hint = hint(options[:hint])
    error_label = error_label(:select, method, options)

    @template.content_tag('div', labels + field + (error_label || hint))
  end

  def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
    classes = apply_style_classes(CHECK_BOX_FIELD_STYLE, options, method)

    labels = labels(:check_box, method, options.merge(class: 'check-box-label'))
    field = super(method, {class: classes}.merge(options))

    @template.content_tag("div", {class: "group flex items-center"}) do
      field + labels
    end
  end

  def radio_button(method, tag_value, options = {})
    classes = apply_style_classes(RADIO_BUTTON_FIELD_STYLE, options, method)

    label = labels(:radio_button, method, options.merge(class: 'radio-button-label', value: tag_value))
    field = super(method, tag_value, {class: classes}.merge(options))

    @template.content_tag("div", {class: "group flex items-center"}) do
      field + label
    end
  end

  private

  def text_like_field(field_method, object_method, options = {})
    classes = apply_style_classes(TEXT_FIELD_STYLE, options, object_method)

    field = send(field_method, object_method, {
      class: classes,
      title: errors_for(object_method, options)
    }.compact.merge(options).merge({tailwindified: true}))

    labels = labels(field_method, object_method, options)

    hint = hint(options[:hint])
    error_label = error_label(field_method, object_method, options)

    # only display error label or hint
    @template.content_tag("div", labels + field + (error_label || hint))
  end

  def hint(hint_text)
    return if hint_text.blank?

    @template.content_tag("p", hint_text, {class: "text-sm text-neutral-500 mt-2"})
  end

  def labels(field_method, object_method, options)
    label = tailwind_label(field_method, object_method, options)

    if [:check_box, :radio_button].include?(field_method)
      error_label(field_method, object_method, options) || label
    else
      @template.content_tag("div", label, {class: "mb-2"})
    end
  end

  def tailwind_label(field_method, object_method, options)
    label_classes = options[:class] || "block text-sm font-medium leading-6"
    if options[:disabled] && [:check_box, :radio_button].include?(field_method)
      # only disbaled check_box and radio_button have this class. 
      # others are disabled in the input level and not the labels.
      label_classes += " text-neutral-400 dark:text-neutral-500"
    else
      label_classes += " text-neutral-900 dark:text-white"
    end

    label(object_method, options[:label], {
      class: label_classes
    }.merge(options.except(:class)))
  end

  def error_label(field_method, object_method, options)
    return if errors_for(object_method, options).blank?

    error_text, error_class = if [:check_box, :radio_button].include?(field_method)
      [options[:label], options[:class]]
    else
      [errors_for(object_method, options), "block mt-2 text-sm"]
    end

    tailwind_label(
      field_method,
      object_method,
      options.merge({
        label: error_text,
        class: error_class + " text-red-600 dark:text-rose-400"
      })
    )
  end

  def border_color_classes(object_method, options)
    if errors_for(object_method, options).present?
      "text-red-900 ring-red-500 placeholder:text-red-400 focus:ring-red-500 dark:ring-rose-500/30 dark:bg-rose-400/10 dark:text-rose-400 dark:placeholder:text-red-200"
    else
      "focus:border-primary-500"
    end
  end

  def apply_style_classes(classes, options, object_method = nil)
    "#{classes} #{options[:class]} #{border_color_classes(object_method, options)}"
  end

  def errors_for(object_method, options)
    return if options[:error].blank? && (@object.blank? || object_method.blank? || @object.errors[object_method].empty?)

    options[:error] || @object.errors[object_method].join(", ")
  end

  def button_data_disable_with(value, options)
    return if (options[:data] && options[:data][:turbo_disable_with]) || options[:data_turbo_disable_with]

    # just adds a spinner to the same button text
    { "data-turbo-submits-with": spinner_svg + value }
  end

  def spinner_svg
    html = <<-HTML
      <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    HTML

    html.html_safe
  end
end
