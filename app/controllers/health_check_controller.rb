class HealthCheckController < ApplicationController
  def show
    health_status = {
      app: 'up',
      database: database_check,
      redis: redis_check,
      timestamp: Time.current
    }

    status = health_status.values.include?('down') ? :service_unavailable : :ok

    render json: health_status, status: status
  end

  private

  def database_check
    ActiveRecord::Base.connection.active? ? 'up' : 'down'
  rescue StandardError
    'down'
  end

  def redis_check
    Redis.new.ping == 'PONG' ? 'up' : 'down'
  rescue StandardError
    'down'
  end
end