local screen = require ("screen")
local state = require ("state")
local images = require("images")
local sound = require("sounds")
local particle = require("particle")

local data = {}
local leave = {}

local class = {}

local function selection(obj)
  return (love.mouse.getX() < obj.x + obj.w) and (love.mouse.getX() > obj.x) and (love.mouse.getY() > obj.y) and (love.mouse.getY() < obj.y + obj.h)
end

local function collision(a, x, y)
  return (x < a.x + a.w) and (x > a.x) and (y > a.y) and (y < a.y + a.h)
end

local function init()
  data.imgCrea = images.getImage("creajeux")
  data.imgLineUp = images.getImage("lineUp")
  data.imgMenu = images.getImage("artMenu")
  data.imgCadre = images.getImage("cadreOptions")
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


function class.load()
  init()
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

function class.update(dt)
  particle.update(dt)
  changeImage(leave)
end

function class.draw()
  love.graphics.setColor(1, 1, 1)

  love.graphics.draw(data.imgMenu)

  particle.draw()

  love.graphics.draw(data.imgCadre)
  love.graphics.draw(data.imgCrea, 1420 , 850)
  love.graphics.draw(data.imgLineUp, 200, 800)

  love.graphics.draw(leave.image, leave.x, leave.y)

  love.graphics.setColor(1, 1, 1)

  love.graphics.setFont(images.getFont50())

  love.graphics.print("Programmeurs", screen.getWidth()/2-700, 200)
  love.graphics.print("Graphistes", screen.getWidth()/2+140, 200)

  love.graphics.setFont(images.getFont40())

  love.graphics.print("Remerciements à ", screen.getWidth()/2-230, 650)

  love.graphics.setFont(images.getFont30())

  love.graphics.print("Alexis CLEMENT", screen.getWidth()/2-580, 300)
  love.graphics.print("Julien FORET", screen.getWidth()/2-560, 375)
  love.graphics.print("Camille GALICHET", screen.getWidth()/2-600, 450)
  love.graphics.print("Jonathan LAUVERGNE", screen.getWidth()/2-650, 525)

  love.graphics.print("Christopher CHAPLAIN-DUMONTIER", screen.getWidth()/2-20, 300)
  love.graphics.print("Laëtitia PIGEON", screen.getWidth()/2+180, 375)
  love.graphics.print("Bastien THOMASSIN", screen.getWidth()/2+140, 450)

  love.graphics.print("Pierre MINIGGIO", screen.getWidth()/2-140, 720)
  love.graphics.print("New Humanity Thème Musical", screen.getWidth()/2-320, 760)
end

function class.keypressed(key)
  if (key == 'escape') then
    sound.getPlay("reverse")
    state.setState("menu")
  end
end

function class.mousepressed(x,y,button)
  if (collision(leave, x, y)) then
    sound.getPlay("reverse")
    state.setState("menu")
  end
end

return class