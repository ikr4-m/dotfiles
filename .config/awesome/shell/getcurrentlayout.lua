local awful = require("awful")
local list = require("shell.layoutlist")
local layout = awful.layout.get_tag_layout_index(client.focus.first_tag)

return list[layout]
