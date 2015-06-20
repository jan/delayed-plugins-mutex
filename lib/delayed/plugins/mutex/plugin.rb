module Delayed::Plugins::Mutex
  class Plugin < ::Delayed::Plugin
    callbacks do |lifecycle|
      lifecycle.around(:enqueue) do |job, *arguments, &block|
        # These attributes are optional
        enqueue_mutex = job.respond_to?(:enqueue_mutex) ? job.enqueue_mutex : nil
        enqueue_limit = job.respond_to?(:enqueue_limit) ? job.enqueue_limit : 1

        if enqueue_mutex.present?
          # If an enqueue_mutex is given as an argument to delay, lock the
          # database and check if the enqueue_limit (default 1) is reached.

          Delayed::Job.transaction do
            count = Delayed::Job.where(enqueue_mutex: enqueue_mutex).count

            # Minimum enqueue_limit of new and all existing jobs
            min_enqueue_limit = [
              enqueue_limit,
              Delayed::Job.
                where(enqueue_mutex: enqueue_mutex).
                minimum(:enqueue_limit) # This can be nil
            ].compact.min

            if count < min_enqueue_limit
              # There is still room
              block.call # This creates a Delayed::Job
            else
              Delayed::Worker.logger.info { "Delayed::Plugins::Mutex - Don't enquue, because #{enqueue_mutex.inspect} count #{count.inspect} >= min_enqueue_limit #{min_enqueue_limit.inspect}" }
            end
          end
        else
          # If no enqueue_mutex is given as an argument to delay, then
          # we need no transaction and can just call the block.
          block.call # This creates a Delayed::Job
        end
      end

      lifecycle.around(:perform) do |worker, job, *arguments, &block|
        # These attributes are optional
        perform_mutex = job.respond_to?(:perform_mutex) ? job.perform_mutex : nil
        perform_limit = job.respond_to?(:perform_limit) ? job.perform_limit : 1
        
        if perform_mutex.present?
          # If a perform_mutex is given as an argument to delay, lock the
          # database and check if the perform_limit (default 1) is reached.

          Delayed::Job.transaction do
            count = Delayed::Job.where(perform_mutex: perform_mutex).where.not(locked_at: nil).count

            # Minimum perform_limit of new and all existing jobs
            min_perform_limit = [
              perform_limit,
              Delayed::Job.
                where(perform_mutex: perform_mutex).
                minimum(:perform_limit) # This can be nil
            ].compact.min

            if count < min_perform_limit
              # There is still room
              block.call # This creates a Delayed::Job
            else
              raise "Delayed::Plugins::Mutex - Don't perform, because #{perform_mutex.inspect} count #{count.inspect} >= min_perform_limit #{min_perform_limit.inspect}"
            end
          end
        else
          # If no perform_mutex is given as an argument to delay, then
          # we need no transaction and can just call the block.
          block.call # This runs perform on the Delayed::Job
        end
      end
    end
  end
end