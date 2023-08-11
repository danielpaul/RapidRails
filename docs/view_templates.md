# View Templates

In our project, we use three types of view templates: ERB, HAML, and Phlex. Each has its strengths so use them where it makes the most sense. Here's a brief overview of each and how we use them.

## ERB

[ERB](https://docs.ruby-lang.org/en/master/ERB.html) is a templating system that embeds Ruby code into an HTML document. It's the default templating system in Rails. ERB is used for most of the default views like the [mailer view](https://github.com/danielpaul/RapidRails/blob/main/app/views/layouts/mailer.html.erb).

## HAML

[HAML](https://haml.info/) is another templating system that's designed to be more concise and readable than ERB. We would use HAML for creating new views as it is easy to write and read.

## Phlex

[Phlex](https://www.phlex.fun/) is a component-based templating system that we use to build reusable components in our application. It is designed to be more modular and maintainable.

In our project, we use Phlex to define components that are used across multiple views. For example, the [FlashMessagesComponent](https://github.com/danielpaul/RapidRails/blob/main/app/views/components/flash_messages_component.rb.).
