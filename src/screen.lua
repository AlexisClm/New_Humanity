local w
local h

local class = {}

function class.getWidth()
  return w
end

function class.setWidth(width)
  w = width
end

function class.getHeight()
  return h
end

function class.setHeight(height)
  h = height
end

function class.load()
  w = love.graphics.getWidth()
  h = love.graphics.getHeight()
end

return class