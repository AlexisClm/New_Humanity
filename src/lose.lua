local screen = require ("screen")
local state = require ("state")
local images = require("images")
local sound = require("sounds")
local particle = require("particle")
local animationUpDown = require("animationUpDown")

local data = {}
local leave = {}

local function selection(obj)
  return (love.mouse.getX() < obj.x + obj.w) and (love.mouse.getX() > obj.x) and (love.mouse.getY() > obj.y) and (love.mouse.getY() < obj.y + obj.h)
end

local function initLose()
  data.imgMenu = images.getImage("artMenu")

  data.sprite = images.getImage("defeatSheet")
  data.w = 1317
  data.h = 288
  data.x = screen.getWidth()/2
  data.y = screen.getHeight()/2 - 50

  data.animation = animationUpDown.new(data.sprite, 35, 20, 0, 0, data.w, data.h)
end

local function initLeave()
  leave.unselectedImage = images.getImage("leave")
  leave.selectedImage = images.getImage("leaveOn")
  leave.image = leave.unselectedImage
  leave.x = 850
  leave.y = 900
  leave.w = leave.unselectedImage:getWidth()
  leave.h = leave.unselectedImage:getHeight()
  leave.isSelection = false
end

local class = {}

function class.load()
  initLose()
  initLeave()
end

local function changeImage(obj)
  if(selection(obj)) then
    obj.image = obj.selectedImage
    obj.isSelected = true
  else
    obj.image = obj.unselectedImage
    obj.isSelected = false
  end
end

local function updateLoseAnim(dt)
  if (data.animation.currentFrame < 35) then
    animationUpDown.update(data.animation, dt)
  else
    data.animation.currentFrame = 35
  end
end

function class.update(dt)
  particle.update(dt)
  changeImage(leave)
  updateLoseAnim(dt)
end

function class.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(data.imgMenu)

  particle.draw()

  animationUpDown.draw(data.animation, data.x, data.y, data.w, data.h)

  love.graphics.draw(leave.image, leave.x, leave.y)
end

function class.keypressed(key)
  if (key == 'escape') then
    state.setState("menu")
    -- A SUPPRIMER
  elseif (key =='b') then 
    state.setState("gameWin")
    sound.getSound("victory"):play()
    sound.getSound("defeat"):stop()
  end
end

local function collision(x, y, rect)
  if (x > rect.x) and (x < rect.x + rect.w) and (y > rect.y) and (y < rect.y + rect.h)then
    return true
  else
    return false
  end
end

function class.mousepressed(x,y,button)
  if (collision( x, y, leave)) then
    sound.getPlay("reverse")
    state.setState("menu")
  end
end

return class