class HardWorker
  include Sidekiq::Worker
  #sidekiq_options retry :false

  def perform(*args)
    # Do something
    puts "Sidekiq worker running job #{args}"
  end
end
