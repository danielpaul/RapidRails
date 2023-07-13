# Background jobs

[Sidekiq](https://github.com/sidekiq/sidekiq) is the background job processor we use that handles long-running tasks, such as sending emails or processing images, asynchronously.

## Configuration

For sidekiq to work and process jobs, you need to setup two things:

1. A worker `bundle exec sidekiq` needs to run for the jobs to be processed. `bin/dev` by default runs sidekiq in addition to your rails server.
2. Redis is required for keeping track of the tasks queue. Set it up as a service on your servers and on your local with [this tutorial](https://redis.io/docs/getting-started/installation/install-redis-on-mac-os/).

## RapidRails Built-in Jobs

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

## Sidekiq Admin Panel

Sidekiq also provides a web interface for monitoring job queues which can be accessed at `/sidekiq` on your local and your production server.
To enable the web interface, set the username and password `SIDEKIQ_ADMIN_USERNAME` and `SIDEKIQ_ADMIN_PASSWORD` in the environment variables.
If you don't want to enable the web interface delete the above environment variables.
