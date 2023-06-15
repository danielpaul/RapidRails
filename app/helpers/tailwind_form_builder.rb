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
  SUBMIT_BUTTON_STYLE = "".freeze

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
    custom_opts, opts = partition_custom_opts(options)
    classes = apply_style_classes(SUBMIT_BUTTON_STYLE, custom_opts)

    super(value, {class: classes}.merge(opts))
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    custom_opts, opts = partition_custom_opts(options)
    classes = apply_style_classes(SELECT_FIELD_STYLE, custom_opts, method)

    labels = labels(:select, method, custom_opts, options)
    field = super(method, choices, opts, html_options.merge({class: classes}), &block)

    @template.content_tag('div', labels + field)
  end

  def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
    custom_opts, opts = partition_custom_opts(options)
    classes = apply_style_classes(CHECK_BOX_FIELD_STYLE, custom_opts, method)

    labels = labels(:check_box, method, custom_opts.merge(class: 'check-box-label'), options)
    field = super(method, {class: classes}.merge(opts))

    @template.content_tag("div", {class: "group flex items-center"}) do
      field + labels
    end
  end

  def radio_button(method, tag_value, options = {})
    custom_opts, opts = partition_custom_opts(options)
    classes = apply_style_classes(RADIO_BUTTON_FIELD_STYLE, custom_opts, method)

    label = labels(:radio_button, method, custom_opts.merge(class: 'radio-button-label', value: tag_value), options)
    field = super(method, tag_value, {class: classes}.merge(opts))

    @template.content_tag("div", {class: "group flex items-center"}) do
      field + label
    end
  end

  private

  def text_like_field(field_method, object_method, options = {})
    custom_opts, opts = partition_custom_opts(options)

    classes = apply_style_classes(TEXT_FIELD_STYLE, custom_opts, object_method)

    field = send(field_method, object_method, {
      class: classes,
      title: errors_for(object_method)&.join(" ")
    }.compact.merge(opts).merge({tailwindified: true}))

    labels = labels(field_method, object_method, custom_opts, options)

    hint = hint(options[:hint])
    error_label = error_label(object_method, options)

    # only display error label or hint
    @template.content_tag("div", labels + field + (error_label || hint))
  end

  def hint(hint_text)
    return unless hint_text.present?

    @template.content_tag("p", hint_text, {class: "text-sm text-neutral-500 mt-2"})
  end

  def labels(field_method, object_method, label_options, field_options)
    label = tailwind_label(field_method, object_method, label_options, field_options)

    if [:check_box, :radio_button].include?(field_method)
      label
    else
      @template.content_tag("div", label, {class: "mb-2"})
    end
  end

  def tailwind_label(field_method, object_method, label_options, field_options)
    text, label_opts = if label_options.present?
      [label_options[:label], label_options.except(:label)]
    else
      [nil, {}]
    end

    label_classes = label_opts[:class] || "block text-sm font-medium leading-6"
    if field_options[:disabled] && [:check_box, :radio_button].include?(field_method)
      # only disbaled check_box and radio_button have this class. 
      # others are disabled in the input level and not the labels.
      label_classes += " text-neutral-400 dark:text-neutral-500"
    else
      label_classes += " text-neutral-900 dark:text-white"
    end

    label(object_method, text, {
      class: label_classes
    }.merge(label_opts.except(:class)))
  end

  def error_label(object_method, options)
    return unless errors_for(object_method).present?

    error_message = @object.errors[object_method].join(", ")
    tailwind_label(object_method, {text: error_message, class: " mt-2 text-sm text-red-600"}, options)
  end

  def border_color_classes(object_method)
    if errors_for(object_method).present?
      " text-red-900 ring-red-300 placeholder:text-red-300 focus:ring-red-500"
    else
      " focus:border-primary-500"
    end
  end

  def apply_style_classes(classes, custom_opts, object_method = nil)
    classes + border_color_classes(object_method) + " #{custom_opts[:class]}"
  end

  CUSTOM_OPTS = %i[label class].freeze
  def partition_custom_opts(opts)
    opts.partition { |k, _v| CUSTOM_OPTS.include?(k) }.map(&:to_h)
  end

  def errors_for(object_method)
    return unless @object.present? && object_method.present?

    @object.errors[object_method]
  end
end
