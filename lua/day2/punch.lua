-- how to import modules:
scheduler = require 'scheduler'

function punch()
  for i=1, 5 do
    print("Punch " .. i)
    scheduler.wait(1.0)
  end
end

function block()
  for i=1, 3 do
    print("Block " .. i)
    scheduler.wait(2.0)
  end
end

scheduler.schedule(0.0, coroutine.create(punch))
scheduler.schedule(0.0, coroutine.create(block))

scheduler.run()
