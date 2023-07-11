# Background jobs

Sidekiq is the background job processor we use that handles long-running tasks, such as sending emails or processing images, asynchronously.

`AttachProfilePictureWorker` is a Sidekiq worker that downloads an image from a given URL and attaches it to the corresponding user record.

## Queue priority

Sidekiq fetches jobs from the queues in the order of their priority defined in the Sidekiq configuration file `config/sidekiq.yml`. The numbers next to the queue names represent the weight of the queues with a higher weight checked more often.

```
:queues:
  - [critical, 100]
  - [default, 50]
  - [mailers, 25]
  - [low_priority, 1]
```

## View queues

Sidekiq also provides a web interface for monitoring job queues. If the necessary environment variables `SIDEKIQ_ADMIN_USERNAME` and `SIDEKIQ_ADMIN_PASSWORD` are set, it can be accessed at `localhost:3000/sidekiq`.
