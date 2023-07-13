# Styling with Tailwind CSS in RapidRails

In RapidRails, we use Tailwind CSS for styling. Tailwind is a utility-first CSS framework that provides low-level utility classes to build custom designs.  

## How to Use Tailwind CSS

Tailwind CSS classes are added directly in the HTML (or view files). For example, to apply padding, margin, and set the colour of a button, you would do:

>`<button class="px-4 py-2 mt-2 text-white bg-blue-500">Click me</button>`

## Customising Styles

In RapidRails, we have created some new classes for things like cards, links and buttons. These classes are defined in the [application.tailwind.css](https://github.com/danielpaul/RapidRails/blob/main/app/assets/stylesheets/application.tailwind.css) file. For example, we have a custom class for buttons which you can use this class in your HTML like so:

> `<button class="btn">Click me</button>`
  
## Tailwind CSS in Forms

We use a custom form builder RapidRailsFormBuilder that adds default classes to form fields for styling. You can override these classes by specifying the :class option. For example:

> `= form.text_field :username, label: 'Username', class: 'custom-class'`

## Modifying Default Styles

If you want to change the default styling for all form fields, you can do so by editing the [RapidRailsFormBuilder](https://github.com/danielpaul/RapidRails/blob/main/app/helpers/rapid_rails_form_builder.rb).
  
## Tailwind CSS Configuration

The Tailwind CSS configuration is located in [tailwind.config.js](https://github.com/danielpaul/RapidRails/blob/main/config/tailwind.config.js). Here you can customise the theme, add plugins, and specify the files that Tailwind should scan for class usage. You can also modify the colors for various UI elements in this file. For more information see the official [Tailwind Configuration Docs](https://tailwindcss.com/docs/configuration).

## Further Info
  
For more information on how to use Tailwind CSS, refer to the official [Tailwind CSS documentation](https://tailwindcss.com/docs/installation).