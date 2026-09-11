local t          = require "terminal"
local rows, cols = t.size()
local write      = t.output.write
local position   = t.cursor.position
local read_key   = t.input.readansi


local function new_game_state()
  return {
    frame = 0,
    char = {
      icon = "🫪",
      x = math.floor(cols / 2),
      y = math.floor(rows * 0.9),
      laser = {
        icon = "│",
        beams = {},
      },
    },
    enemy = {
      units = {
        icon = "👾",
        x = math.floor(cols / 2),
        y = math.floor(rows / 4),
      }
    },
    collision = "💥",
  }
end


local function char_action(state)
  local key = read_key(0.05)
  local char = state.char
  local beams = char.laser.beams
  if key == "a" then
    char.x = char.x - 1
  elseif key == "d" then
    char.x = char.x + 1
  elseif key == " " then
    beams[#beams + 1] = { x = char.x, y = char.y - 1 }
  end
end


local function draw_char(state)
  local char = state.char
  write(
    position.set_seq(
      char.y, char.x
    ) .. char.icon)
end


local function draw_enemy_units(state)
  local units = state.enemy.units
  for i = 1, #units do
    local unit = units[i]
    write(
      position.set_seq(
        unit.y, unit.x
      ) .. unit.icon)
  end
  write(

  )
end


local function draw_lasers(state)
  local frame = state.frame
  local laser = state.char.laser
  local remove = {}
  for i = 1, #laser.beams do
    if laser.beams[i].y < 5 then
      remove[#remove + 1] = i
    end

    if frame % 4 == 0 then
      laser.beams[i].y = laser.beams[i].y - 1
    end

    write(
      position.set_seq(
        laser.beams[i].y, laser.beams[i].x
      ) .. laser.icon)
  end

  for i = 1, #remove do
    table.remove(laser.beams, i)
  end
end


local function update_frames(state)
  local frame = state.frame
  if frame > 3 then
    frame = 0
  else
    frame = frame + 1
  end
end


local function render(state)
  update_frames(state)
  draw_char(state)
  draw_lasers(state)
  draw_enemy_units(state)
end


local function clear_screen()
  t.clear.screen()
  t.cursor.position.set(1, 1)
end


t.initwrap(function()
  t.cursor.visible.set(false)
  local state = new_game_state()
  while true do
    char_action(state)
    clear_screen()
    render(state)
  end
end, { displaybackup = true })()
