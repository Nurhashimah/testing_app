class Event < ActiveRecord::Base
  
  def start_time
    self.start_at ##Where 'start' is a attribute of type 'Date' accessible through MyModel's relationship
  end
  
  def end_time
    self.end_at
  end
end
