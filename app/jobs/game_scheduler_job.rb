class GameSchedulerJob < ApplicationJob
  queue_as :default

  def perform(value)
    # codes here will be executed once the task is fired
  end
end


