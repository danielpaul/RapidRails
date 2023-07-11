# User Deletion

Deleting a user account revokes their access to the application and soft-deletes the User record. We use the [discard](https://github.com/jhawthorn/discard) gem to soft-delete records across the application.

## How to delete a user account

1. A signed in user goes to their **Account Settings** and clicks the **Delete Account** button, enters their password and optional feedback and then click the **Delete Account Now** button. This will soft-delete the record and sign them out.

## User Anonymization and Customization

We have an optional rake task that anonymizes user records after a period of time. This task calls `AnonymizationService` which strips all columns of the user's data.

1. Run `rake anonymize:users` to anonymize user records that were discarded a certain number of days ago and have not been anonymized yet. The number of days is stored in a constant called `ANONYMIZE_USER_DATA_AFTER_DAYS`.
2. Some fields are set to custom values. For example, `full_name` to **"Deleted User"**, `email` to **"prefix@domain"** where **prefix** and **domain** are customizable and password is set to a secure 60 character **SecureRandom** password.

## Permanentally delete a user record

If for some reason, you'd like to permanentally delete a user record, replace any traces of `discard` with `destroy` being called on a **User** record. The main location where this needs to be replaced is `controllers/registrations_controller.rb` in the **destroy** action.
