local t          = require "terminal"
local rows, cols = t.size()
local write      = t.output.write
local position   = t.cursor.position
local read_key   = t.input.readansi

local y, x       = math.floor(rows * 0.98), math.floor(cols * 0.5)
local character  = "🫪"

t.initwrap(function()
  t.cursor.visible.set(false)

  while true do
    local key = read_key(0.05)
    if key == "a" then
      x = x - 1
    elseif key == "d" then
      x = x + 1
    end

    t.clear.screen()
    write(position.set_seq(x, y) .. character)
  end
end, { displaybackup = true })()
