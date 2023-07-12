# Background jobs

[Sidekiq](https://github.com/sidekiq/sidekiq) is the background job processor we use that handles long-running tasks, such as sending emails or processing images, asynchronously.

## Configuration

For sidekiq to work and process jobs, you need to setup two things:

1. A worker `bundle exec sidekiq` needs to be added on your cloud platform and running. This command should be run on your local as well.
2. Redis is also required. Set it up on your cloud platform as an add-on and set it up on your local with [this tutorial](https://redis.io/docs/getting-started/installation/install-redis-on-mac-os/).

## List of default jobs

Sidekiq provides the [deliver_later](https://apidock.com/rails/v5.2.3/ActionMailer/MessageDelivery/deliver_later) method which when used with a **Mailer**, adds email jobs to the sidekiq queue. Other sidekiq jobs included in the codebase are:

1. [AttachProfilePictureWorker](../app/workers/attach_profile_picture_worker.rb) - downloads an image from a given URL and attaches it to the corresponding user record.
2. [UserAnonymizationWorker](../app/workers/user_anonymization_worker.rb) - runs the [AnonymizationService](../app/services/anonymization_service.rb) which anonymizes a discarded **User** record by clearing/randomizing all it's attributes.

## Queue priority

Sidekiq fetches jobs from the queues in the order of their priority defined in the Sidekiq configuration file [config/sidekiq.yml](../config/sidekiq.yml). The numbers next to the queue names represent the weight of the queues with a higher weight checked more often.

```
:queues:
  - [critical, 100]
  - [default, 50]
  - [mailers, 25]
  - [low_priority, 1]
```

## View queues

Sidekiq also provides a web interface for monitoring job queues which can be accessed at `localhost:3000/sidekiq`
To enable the web interface, set the username and password in the environment variables `SIDEKIQ_ADMIN_USERNAME` and `SIDEKIQ_ADMIN_PASSWORD` respectively.
If you don't want to enable the web interface delete the above environment variables.
