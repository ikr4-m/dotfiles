local beautiful = require("beautiful")
local naughty = require("naughty")

-- Set default max height
beautiful.notification_max_height = 200

-- Default max width
beautiful.notification_max_width = 350

-- Access config from callback
naughty.config.Callback = function (args)
  -- Set timeout
  args.timeout = 3
end
