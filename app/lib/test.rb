require "async/scheduler"

module Test
  DUMMY_PAYLOAD = { content_type: "text/plain", filename: "dummy.txt", io: StringIO.new("dummy") }.freeze
  # this fails
  def self.test_fails
    dummy = Dummy.first
    Fiber.set_scheduler Async::Scheduler.new
    10.times do
      Fiber.schedule { dummy.file.attach(**DUMMY_PAYLOAD) }
      Fiber.schedule { dummy.file.attach(**DUMMY_PAYLOAD) }
    end
  ensure
    Fiber.set_scheduler nil
  end

  # this works
  def self.test_works
    dummy = Dummy.first
    Fiber.set_scheduler Async::Scheduler.new
    10.times do
      # notice the only difference with the above code - we instantiate the object again. So probably something with the instance variables
      Fiber.schedule { Dummy.find(dummy.id).file.attach(**DUMMY_PAYLOAD) }
      Fiber.schedule { Dummy.find(dummy.id).file.attach(**DUMMY_PAYLOAD) }
    end
  ensure
    Fiber.set_scheduler nil
  end
end
