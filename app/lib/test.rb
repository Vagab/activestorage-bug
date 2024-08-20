require "async/scheduler"

module Test
  # this fails
  def self.test_fails
    dummy = Dummy.first
    Fiber.set_scheduler Async::Scheduler.new
    50.times do
      Fiber.schedule do
        dummy.file.attach(content_type: "text/plain", filename: "dummy.txt", io: StringIO.new("dummy" * 100))
      end
      Fiber.schedule do
        dummy.file.attach(content_type: "text/plain", filename: "dummy.txt", io: StringIO.new("dummy" * 100))
      end
    end
  ensure
    Fiber.set_scheduler nil
  end

  # this works
  def self.test_works
    dummy = Dummy.first
    Fiber.set_scheduler Async::Scheduler.new
    50.times do
      Fiber.schedule do
        # notice the only difference with the above code - we instantiate the object again. So probably something with the instance variables
        Dummy.find(dummy.id).file.attach(content_type: "text/plain", filename: "dummy.txt", io: StringIO.new("dummy" * 100))
      end
      Fiber.schedule do
        Dummy.find(dummy.id).file.attach(content_type: "text/plain", filename: "dummy.txt", io: StringIO.new("dummy" * 100))
      end
    end
  ensure
    Fiber.set_scheduler nil
  end
end
