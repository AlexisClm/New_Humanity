local state = require("state")
local screen = require("screen")
local tutorial = require("tutorial")
local skirmish = require("skirmish")
local images = require ("images")
local particle = require ("particle")

local class = {}

local menu = {}
local tuto = {}
local play = {}
local options = {}
local credits = {}
local leave = {}

local function selection(obj)
  return (love.mouse.getX() < obj.x + obj.w) and (love.mouse.getX() > obj.x) and (love.mouse.getY() > obj.y) and (love.mouse.getY() < obj.y + obj.h)
end

local function init()
  menu.imgCrea = images.getImage("creajeux")
  menu.imgLineUp = images.getImage("lineUp")
  menu.imgNH = images.getImage("newHumanity")
  menu.imgMenu = images.getImage("artMenu")
  menu.imgCadre = images.getImage("cadreMenu")

  menu.x = 0
  menu.y = 0

  tuto.unselectedImage = images.getImage("tuto")
  tuto.selectedImage = images.getImage("tutoOn")
  tuto.image = tuto.unselectedImage
  tuto.x = 1420
  tuto.y = 400
  tuto.w = tuto.unselectedImage:getWidth()
  tuto.h = tuto.unselectedImage:getHeight()
  tuto.isSelection = false

  play.unselectedImage = images.getImage("play")
  play.selectedImage = images.getImage("playOn")
  play.image = play.unselectedImage
  play.x = 1420
  play.y = 525
  play.w = play.unselectedImage:getWidth()
  play.h = play.unselectedImage:getHeight()
  play.isSelection = false

  options.unselectedImage = images.getImage("options")
  options.selectedImage = images.getImage("optionsOn")
  options.image = options.unselectedImage
  options.x = 1420
  options.y = 650
  options.w = options.unselectedImage:getWidth()
  options.h = options.unselectedImage:getHeight()
  options.isSelection = false

  credits.unselectedImage = images.getImage("credits")
  credits.selectedImage = images.getImage("creditsOn")
  credits.image = credits.unselectedImage
  credits.x = 1420
  credits.y = 775
  credits.w = credits.unselectedImage:getWidth()
  credits.h = credits.unselectedImage:getHeight()
  credits.isSelection = false

  leave.unselectedImage = images.getImage("leave")
  leave.selectedImage = images.getImage("leaveOn")
  leave.image = leave.unselectedImage
  leave.x = 1420
  leave.y = 900
  leave.w = leave.unselectedImage:getWidth()
  leave.h = leave.unselectedImage:getHeight()
  leave.isSelection = false
end

function class.load()
  init()
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
  changeImage(tuto)
  changeImage(play)
  changeImage(options)
  changeImage(credits)
  changeImage(leave)
end

local function draw()
  love.graphics.setColor(1, 1, 1)

  love.graphics.draw(menu.imgMenu)

  particle.draw()

  love.graphics.setColor(1, 1, 1)

  love.graphics.draw(menu.imgCrea, menu.x + 250, menu.y + 950)
  love.graphics.draw(menu.imgCadre, menu.x + 1360 , menu.y )
  love.graphics.draw(menu.imgNH, menu.x + 1300, menu.y + 50)
  love.graphics.draw(menu.imgLineUp, menu.x + 50, menu.y + 900)

  love.graphics.draw(tuto.image, tuto.x, tuto.y)
  love.graphics.draw(play.image, play.x, play.y)
  love.graphics.draw(options.image, options.x, options.y)
  love.graphics.draw(credits.image, credits.x, credits.y)
  love.graphics.draw(leave.image, leave.x, leave.y)
end

function class.draw()
  draw()
end

function class.getHitTutorial()
  local btnTutorial = {}

  btnTutorial.x = tuto.x
  btnTutorial.y = tuto.y
  btnTutorial.w = tuto.w
  btnTutorial.h = tuto.h

  return btnTutorial
end

function class.getHitSkirmish()
  local btnPlay = {}

  btnPlay.x = play.x
  btnPlay.y = play.y
  btnPlay.w = play.w
  btnPlay.h = play.h

  return btnPlay
end

function class.getHitOptions()
  local btnOptions = {}

  btnOptions.x = options.x
  btnOptions.y = options.y
  btnOptions.w = options.w
  btnOptions.h = options.h

  return btnOptions
end

function class.getHitCredits()
  local btnCredits = {}

  btnCredits.x = credits.x
  btnCredits.y = credits.y
  btnCredits.w = credits.w
  btnCredits.h = credits.h

  return btnCredits
end

function class.getHitLeave()
  local btnLeave = {}

  btnLeave.x = leave.x
  btnLeave.y = leave.y
  btnLeave.w = leave.w
  btnLeave.h = leave.h

  return btnLeave
end

function class.getHitCreajeux()
  local btnCreajeux = {}

  btnCreajeux.x = menu.x + 250
  btnCreajeux.y = menu.y + 950
  btnCreajeux.w = menu.imgCrea:getWidth()
  btnCreajeux.h = menu.imgCrea:getHeight()

  return btnCreajeux
end

return class