module DelayedJobHerokuScaler
  extend ActiveSupport::Concern
  
  included do
  
    def enqueue(job)
      if Rails.env.production?
        heroku = PlatformAPI.connect_oauth ENV['HEROKU_OAUTH_TOKEN']
        worker_info = heroku.formation.info('sf-ohana', 'worker')
        if worker_info['quantity'] == 0
          heroku.formation.update(ENV['HEROKU_APP_NAME'], 'worker', { quantity: 1 })
        end
      end
    end
  
    def after(job)
      if Rails.env.production?
        job_count = ::Delayed::Job.where(failed_at: nil).count
        if job_count == 0
          heroku = PlatformAPI.connect_oauth ENV['HEROKU_OAUTH_TOKEN']
          worker_info = heroku.formation.info('sf-ohana', 'worker')
          heroku.formation.update(ENV['HEROKU_APP_NAME'], 'worker', { quantity: 0 })
        end
      end
    end
        
  end
  
end
