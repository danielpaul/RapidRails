# https://blog.testdouble.com/posts/2022-12-05-blending-tailwind-with-rails-forms/

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

  def submit(value = nil, options = {})
    classes = options[:class] || 'btn-primary'
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
    classes = options[:class] || 'btn-primary'
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

  def wrapper_classes(method, options)
    wrapper_classes = ["form-field"]
    wrapper_classes << "disabled" if options[:disabled]

    if errors_for(method, options).present?
      wrapper_classes << "error"
    end

    wrapper_classes.join(" ")
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
        options.merge(class: 'check-box-input'), 
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

  def text_like_field(field_method, object_method, options = {})
    form_field(object_method, options) do
      send(
        field_method,
        object_method,
        options.merge({tailwindified: true, class: "text-input #{options[:class]}"})
      )
    end
  end

  def form_field(method, options = {}, more_options = {}, &block)
    label = @template.content_tag(
      "div",
      label(method, options[:label], options.merge(class: 'label').except(:label, :error, :hint)), 
      {class: "mb-2"}
    )

    errors = errors_for(method, options)
    if errors.present?
      errors = label(method, errors, {class: "error-label"})
    end

    hint = if options[:hint].present?
      @template.content_tag("p", options[:hint], {class: "hint"})
    end

    @template.content_tag("div", {class: wrapper_classes(method, options.merge(more_options))}) do
      label + yield + errors + hint
    end
  end

  def radio_check_form_field(method, options = {}, &block)
    label = @template.content_tag(
      "div",
      label(
        method, 
        options[:label], 
        options.merge(class: 'radio-check-label').except(:label, :error, :hint)
      )
    )

    @template.content_tag("div", {class: wrapper_classes(method, options)}) do
      @template.content_tag("div", {class: "group flex items-center"}) do
        yield + label
      end
    end
  end

  # def hint(hint_text)
  #   return if hint_text.blank?

  #   # TODO: change to tailwind class
  #   @template.content_tag("p", hint_text, {class: "text-sm text-neutral-500 mt-2"})
  # end

  # def labels(field_method, object_method, options)
  #   label = tailwind_label(field_method, object_method, options)

  #   if [:check_box, :radio_button].include?(field_method)
  #     error_label(field_method, object_method, options) || label
  #   else
  #     @template.content_tag("div", label, {class: "mb-2"})
  #   end
  # end

  # def tailwind_label(field_method, object_method, options)
  #   label_classes = options[:class] || "block text-sm font-medium leading-6"
  #   if options[:disabled] && [:check_box, :radio_button].include?(field_method)
  #     # only disbaled check_box and radio_button have this class. 
  #     # others are disabled in the input level and not the labels.
  #     label_classes += " text-neutral-400 dark:text-neutral-500"
  #   else
  #     label_classes += " text-neutral-900 dark:text-white"
  #   end

  #   label(object_method, options[:label], {
  #     class: label_classes
  #   }.merge(options.except(:class)))
  # end

  # def error_label(field_method, object_method, options)
  #   return if errors_for(object_method, options).blank?

  #   error_text, error_class = if [:check_box, :radio_button].include?(field_method)
  #     [options[:label], options[:class]]
  #   else
  #     [errors_for(object_method, options), "block mt-2 text-sm"]
  #   end

  #   tailwind_label(
  #     field_method,
  #     object_method,
  #     options.merge({
  #       label: error_text,
  #       class: error_class + " text-red-600 dark:text-rose-400"
  #     })
  #   )
  # end


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
