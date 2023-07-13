# Forms

Our `RapidRailsFormBuilder` is a custom form builder class that provides additional functionality and customization for form fields.

## Usage

To use this form builder, you need to specify it when using the form_with or form_for helper in your views:
> `= form_for :something, method: :post, builder: RapidRailsFormBuilder do |form|`

To show form errors render the `FormErrorsComponent` inside the form as follows:

> `= form_for(resource, as: resource_name, url: registration_path(resource_name), builder: RapidRailsFormBuilder`  
&nbsp;&nbsp;&nbsp;&nbsp;`= render FormErrorsComponent.new(resource)`

## Methods

Here are some of the methods you can use with this form builder:

### **text_field, email_field, password_field, etc.**

These methods create text-like fields. You can specify additional options such as `:label`, `:error`, `:hint`, and `:class`.

> `= form.text_field :username, label: 'Username', class: 'custom-class'`

### **submit**

This method creates a submit button. You can specify the `:class` option to add custom classes.

> `= form.submit 'Submit', class: 'custom-class'`

### **button**

This method creates a button. You can specify the `:class` option to add custom classes.

> `= form.button 'Cancel', class: 'custom-class'`

### **select and collection_select**

These methods create select fields. You can specify the `:class` option to add custom classes.

> `= form.select :category, Category.all, class: 'custom-class'`
  
> `= form.collection_select :category_id, Category.all, :id, :name, class: 'custom-class'`

### **check_box and radio_button**

These methods create checkbox and radio button fields. You can specify the :class option to add custom classes.

> `= form.check_box :remember_me, class: 'custom-class'`
  
> `= form.radio_button :gender, 'male', class: 'custom-class'`

## Styling

The `RapidRailsFormBuilder` adds default classes to the form fields for styling. You can override these classes by specifying the `:class` option. If you would like to change the default styling for all form fields, you can do so by editing the RapidRailsFormBuilder at `/app/helpers/rapid_rails_form_builder.rb`. 

The `FormErrorsComponent` can be edited in `/app/views/components/form_errors_component.rb`

Form classes are located in `/app/assets/stylesheets/application.tailwind.css` and can be customized by editing the classes.