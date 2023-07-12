# Flash Messages

Flash messages in this application are handled by the FlashHelper module and the FlashMessagesComponent, FlashToastWrapperComponent and FlashToastComponent classes.

## FlashMessagesComponent

The FlashMessagesComponent class is used to render flash messages. It takes the flash object as a parameter in its constructor and iterates over it in the template method, rendering an AlertComponent for each message.

Here's an example of how to use this method:

> `flash.now[:notice] = "This is an notice message."`

## FlashToastComponent

The FlashToastComponent class is used to render flash messages as toast notifications. There is a flash_message method that can be used to create toast notifications.

This method takes four parameters:

- type: The type of the message (:success, :notice, :alert, :error).
- heading: The heading of the message.
- body: The body of the message. This is optional.
- now: A boolean that determines whether the message should be displayed immediately. This is also optional.

Here's an example of how to use this method:
> `flash_message(:success, "Hello!", "This is a success message", now: true)`
