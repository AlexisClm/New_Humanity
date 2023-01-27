local screen = require("screen")
local images = require("images")

local class = {}
local dataList = {}

local function createParticle()
  local data =  {}

  data.random = love.math.random(4)

  if (data.random == 1) then
    data.img = images.getImage("particle1")
  elseif (data.random == 2) then
    data.img = images.getImage("particle2")
  elseif (data.random == 3) then
    data.img = images.getImage("particle3")
  else
    data.img = images.getImage("particle4")
  end

  data.w = data.img:getWidth()
  data.h = data.img:getHeight()
  data.x = love.math.random(screen.getWidth())
  data.y = -data.h
  data.angle = math.rad(love.math.random(360))
  data.angularVelocity = math.rad(love.math.random(50, 120))
  data.rotation = love.math.random(2)
  data.speed = love.math.random(50, 100)

  table.insert(dataList, data)
end

local function updateParticle(dt)
  for dataId, data in ipairs(dataList) do
    data.x = data.x - data.speed * dt
    data.y = data.y + data.speed * dt

    if (data.rotation == 1) then
      data.angle = data.angle + data.angularVelocity * dt
    else
      data.angle = data.angle - data.angularVelocity * dt
    end

    if data.y > screen.getHeight() then
      table.remove(dataList, dataId)
    end
    if (data.x < 0) then
      data.x = screen.getWidth()
    end
  end
  if #dataList <= 700 then
    createParticle()
  end
end

function class.update(dt)
  updateParticle(dt)
end

local function drawParticle()
  for dataId, data in ipairs(dataList) do
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(data.img, data.x, data.y, data.angle)
  end
end

function class.draw()
  drawParticle()
end

return class