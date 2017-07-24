# Adapted from Bugsnag code as per Sidekiq 2.x comment request
#
# SideKiq 2.x: https://github.com/mperham/sidekiq/blob/2-x/lib/sidekiq/exception_handler.rb
# Bugsnag: https://github.com/bugsnag/bugsnag-ruby/blob/master/lib/bugsnag/sidekiq.rb

module Raygun

  class SidekiqMiddleware  # Used for Sidekiq 2.x only
    def call(worker, message, queue)
      begin
        yield
      rescue Exception => ex
        raise ex if [Interrupt, SystemExit, SignalException].include?(ex.class)
        SidekiqReporter.call(ex, worker: worker, message: message, queue: queue)
        raise ex
      end
    end
  end

  class SidekiqReporter
    def self.call(exception, context_hash)
      puts context_hash
      ::Raygun.track_exception(exception,
          custom_data: {
            sidekiq_context: context_hash
          }
        )
    end

    def affected_user(context_hash)
      affected_user_method = Raygun.configuration.affected_user_method
      worker_class = context_hash['worker']
      args = context_hash['message']['args']

      if worker_class.respond_to?(affected_user_method)
        affected_user = begin
            worker_class.send(affected_user_method, args)
          rescue
            nil
          end

        affected_user
      end

    end
  end
end

if Sidekiq::VERSION < '3'
  Sidekiq.configure_server do |config|
    config.server_middleware do |chain|
      chain.add Raygun::SidekiqMiddleware
    end
  end
else
  Sidekiq.configure_server do |config|
    config.error_handlers << Raygun::SidekiqReporter
  end
end
