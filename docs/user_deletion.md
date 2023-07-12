# User Deletion

In it's default setup, deleting a user account revokes their access to the application and soft-deletes the User record. We use the [discard](https://github.com/jhawthorn/discard) gem to soft-delete records across the application.

Depending on legalities of your application, you can choose from three options:

1. Soft-delete(default)
2. Soft-delete and anonymization
3. Permanentaly delete the user record

## How to delete a user account

1. A signed in user goes to their **Account Settings** and clicks the **Delete Account** button, enters their password and optional feedback and then click the **Delete Account Now** button. This will soft-delete the record and sign them out.

## User Anonymization and Customization

We have an optional rake task that if setup, anonymizes user records after a period of time. This task calls [AnonymizationService](../app/services/anonymization_service.rb) which strips all columns of the user's data.

1. Run `rake anonymize:users` to anonymize user records that were discarded a certain number of days ago and have not been anonymized yet. The number of days is stored in a constant called [ANONYMIZE_USER_DATA_AFTER_DAYS](../config/initializers/0_constants.rb) which if set to **0** will anonymize the user record immediately.
2. Some fields are set to custom values. For example, `full_name` to **"Deleted User"**, `email` to **"prefix@domain"** where **prefix** and **domain** are customizable and password is set to a secure 60 character **SecureRandom** password.

### IMPORTANT:

If using the anonymizer, don't forget to update the method `anonymize_user` in [AnonymizationService](../app/services/anonymization_service.rb) to clear or randomize any new fields you may add to the **User** record.

## Permanentaly delete a user record

If you'd like to permanentally delete a user record, replace `discard` with `destroy` wherever it is called on a **User** record. The main location where this needs to be replaced is [registrations_controller.rb](../app/controllers/registrations_controller.rb) in the **destroy** action.
