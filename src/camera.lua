local screen = require("screen")
local state = require("state")
local script = require("script")
local sound = require("sounds")

local class = {}
local data = {}
local up = {}
local down = {}
local left = {}
local right = {}

function class.getX()
  return data.x
end

function class.getY()
  return data.y
end

local function initSettings()
  data.x = 0
  data.y = 0

  data.xMin = 1024
  data.yMin = 512

  if (state.getState() == "tutorial") then
    data.xMax = -1536
    data.yMax = -2048
    data.speed = 15
  elseif (state.getState() == "skirmish") then
    data.xMax = -2800
    data.yMax = -3300
    data.speed = 20
  end
end

local function initUp()
  up.w = screen.getWidth()
  up.h = 15
  up.x = 0
  up.y = 0
end

local function initDown()
  down.w = screen.getWidth()
  down.h = 15
  down.x = 0
  down.y = screen.getHeight() - down.h
end

local function initLeft()
  left.w = 15
  left.h = screen.getHeight()
  left.x = 0
  left.y = 0
end

local function initRight()
  right.w = 15
  right.h = screen.getHeight()
  right.x = screen.getWidth() - right.w
  right.y = 0
end

function class.load()
  initSettings()
  initUp()
  initDown()
  initLeft()
  initRight()
end

local function checkCol(x, y, a)
  if (x >= a.x) and (x <= a.x + a.w) and (y >= a.y) and (y <= a.y + a.h) then
    return true
  else
    return false
  end
end

function class.moveCamera(obj)
  local x = love.mouse.getX()
  local y = love.mouse.getY()

  if (not obj.moving) and (obj.turn) then
    if (data.y < data.yMin) then
      if (checkCol(x, y, up)) or (love.keyboard.isDown("z")) then
        data.y = data.y+data.speed
        if (state.getState() == "tutorial") and (script.canCamera()) then
          script.setCamera(true)
          sound.getPlay("tuto")
        end
      end
    end
    if (data.y > data.yMax) then
      if (checkCol(x, y, down)) or (love.keyboard.isDown("s")) then
        data.y = data.y-data.speed
        if (state.getState() == "tutorial") and (script.canCamera()) then
          script.setCamera(true)
          sound.getPlay("tuto")
        end
      end
    end
    if (data.x < data.xMin) then
      if (checkCol(x, y, left)) or (love.keyboard.isDown("q")) then
        data.x = data.x+data.speed
        if (state.getState() == "tutorial") and (script.canCamera()) then
          script.setCamera(true)
          sound.getPlay("tuto")
        end
      end
    end
    if (data.x > data.xMax) then
      if (checkCol(x, y, right)) or (love.keyboard.isDown("d")) then
        data.x = data.x-data.speed
        if (state.getState() == "tutorial") and (script.canCamera()) then
          script.setCamera(true)
          sound.getPlay("tuto")
        end
      end
    end
  end
end

function class.focusPlayer(obj)
  local distX = obj.getX() + (obj.getW() - screen.getWidth())/2
  local distY = obj.getY() + (obj.getH()/2 - screen.getHeight())/2

  data.x = -distX
  data.y = -distY
end

function class.focus(enemyId)
  local distX = enemyId.x + (enemyId.w - screen.getWidth())/2
  local distY = enemyId.y + (enemyId.h/2 - screen.getHeight())/2

  data.x = -distX
  data.y = -distY
end

return class