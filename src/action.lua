local actionZone = require("actionZone")
local gridBar = require("gridBar")
local move = require("move")
local skills = require("skills")

local class = {}

function class.update(obj, dt)
  move.update(obj, dt)
end

function class.draw(obj)
  move.draw()
  skills.draw(obj)
end

function class.keypressed(obj, lineBar, key)
  gridBar.keypressed(obj, lineBar, obj.getLine(), obj.getColumn(), key)
end

function class.mousepressed(obj, lineBar, x, y, button)
  move.mousepressed(obj, obj.getLine(), obj.getColumn(), obj.getPm(), x, y, button)
  gridBar.mousepressed(obj, lineBar, x, y, button, obj.getLine(), obj.getColumn())
end

return class