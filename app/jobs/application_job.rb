# Not inheriting ActiveJob::Base 
# to use Sidekiq directly
# https://andycroll.com/ruby/use-sidekiq-directly-not-through-active-job/

class ApplicationJob
  include Sidekiq::Worker
end
