local screen = require("screen")
local state = require ("state")
local sound = require("sounds")
local images = require("images")
local particle = require("particle")

local data = {}
local leave = {}

local upVolumeM = {}
local downVolumeM = {}
local upVolumeSE = {}
local downVolumeSE = {}
local muteVolume = {}

local function selection(obj)
  return (love.mouse.getX() < obj.x + obj.w) and (love.mouse.getX() > obj.x) and (love.mouse.getY() > obj.y) and (love.mouse.getY() < obj.y + obj.h)
end

local function collision(a, x, y)
  return (x < a.x + a.w) and (x > a.x) and (y > a.y) and (y < a.y + a.h)
end

local function initButton()
  data.imgCrea = images.getImage("creajeux")
  data.imgLineUp = images.getImage("lineUp")
  data.imgMenu = images.getImage("artMenu")
  data.imgMoins = images.getImage("moins")
  data.imgPlus = images.getImage("plus")
  data.imgButton = images.getImage("button")
  data.imgActif = images.getImage("active")
  data.imgNonActif = images.getImage("nonActif")
  data.imgCadre = images.getImage("cadreOptions")

  data.w = 1240 - 50
  data.h = 300  - 100
  data.x = 750 - 50
  data.y = 300 - 100

  data.v = "effect"
  data.m = "actif"

  downVolumeM.w = data.imgMoins:getWidth()
  downVolumeM.h = data.imgMoins:getHeight()
  downVolumeM.x = 845
  downVolumeM.y = 200

  upVolumeM.w = data.imgPlus:getWidth()
  upVolumeM.h = data.imgPlus:getHeight()
  upVolumeM.x = 1335
  upVolumeM.y = 200

  downVolumeSE.w = data.imgMoins:getWidth()
  downVolumeSE.h = data.imgMoins:getHeight()
  downVolumeSE.x = 845 
  downVolumeSE.y = 350 

  upVolumeSE.w = data.imgPlus:getWidth()
  upVolumeSE.h = data.imgPlus:getHeight()
  upVolumeSE.x = 1335 
  upVolumeSE.y = 350 

  data.volumeBtnWM = data.imgButton:getWidth()
  data.volumeBtnHM = data.imgButton:getHeight()
  data.volumeBtnXM = downVolumeM.x + downVolumeM.w +10 + sound.getVolumeM()*350
  data.volumeBtnYM = downVolumeM.y - data.volumeBtnHM/2  

  data.volumeBtnWS = data.imgButton:getWidth()
  data.volumeBtnHS = data.imgButton:getHeight()
  data.volumeBtnXS = downVolumeSE.x + downVolumeSE.w + 10 + sound.getVolumeS()*350 
  data.volumeBtnYS = downVolumeSE.y - data.volumeBtnHS/2  

  muteVolume.w = data.imgActif:getWidth()
  muteVolume.h = data.imgActif:getHeight()
  muteVolume.x = 850
  muteVolume.y = 475
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

local function drawVolume ()
  love.graphics.setColor(0, 0, 0)

  love.graphics.line(data.x + 150, data.y + 25, data.w + 150 ,data.h + 25) 
  love.graphics.line(data.x + 150, data.y + 175, data.w + 150,data.h + 175) 

  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(images.getFont30())

  love.graphics.printf("Volume Musiques", data.x - 850, data.y + 12 , screen.getWidth()/2, "right")
  love.graphics.printf("Volume Effets Sonores", data.x - 850, data.y + 125 + 35, screen.getWidth()/2, "right")
  love.graphics.printf("Muet", muteVolume.x - 1000, muteVolume.y + 12, screen.getWidth()/2, "right")

  love.graphics.draw(data.imgMoins, downVolumeM.x , downVolumeM.y)
  love.graphics.draw(data.imgPlus, upVolumeM.x, upVolumeM.y)
  love.graphics.draw(data.imgMoins, downVolumeSE.x , downVolumeSE.y)
  love.graphics.draw(data.imgPlus, upVolumeSE.x, upVolumeSE.y)
  love.graphics.draw(data.imgButton, data.volumeBtnXM, data.volumeBtnYM + 24)
  love.graphics.draw(data.imgButton, data.volumeBtnXS, data.volumeBtnYS + 24)

  if (data.m == "actif") then
    love.graphics.draw(data.imgActif, muteVolume.x, muteVolume.y)
  elseif (data.m == "muet") then
    love.graphics.draw(data.imgNonActif, muteVolume.x, muteVolume.y)
  end
end

local function drawOther()
  love.graphics.setColor(1, 1, 1)

  love.graphics.draw(data.imgMenu)

  particle.draw()

  love.graphics.draw(data.imgCadre)
  love.graphics.draw(data.imgCrea, 1420, 850)
  love.graphics.draw(data.imgLineUp, 200, 800)
  love.graphics.draw(leave.image, leave.x, leave.y)
end

local function drawOptions()
  love.graphics.setColor(1, 1, 1)

  love.graphics.printf("Langue : ", data.x - 850, data.y + 450, screen.getWidth()/2, "right")
  love.graphics.printf("Français", data.x + 150, data.y + 450, screen.getWidth(), "left")
end

local class = {}

function class.load()
  initButton()
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
  if (data.v == "musique") then
    data.volumeBtnXM = downVolumeM.x + downVolumeM.w + 10 + sound.getVolumeM()*350
  elseif (data.v == "effect") then
    data.volumeBtnXS = downVolumeSE.x + downVolumeSE.w + 10 + sound.getVolumeS()*350
  elseif (data.v == "muet") then
    data.volumeBtnXM = downVolumeM.x + downVolumeM.w + 10 + sound.getVolumeM()*350
    data.volumeBtnXS = downVolumeSE.x + downVolumeSE.w + 10 + sound.getVolumeS()*350
  end
  particle.update(dt)
  changeImage(leave)
end

function class.draw()
  love.graphics.setColor(1,1,1)

  drawOther()
  drawVolume()
  drawOptions()
end

function class.keypressed(key)
  if (key == 'escape') then
    sound.getPlay("reverse")
    if (state.getState() == "sOptions") then
      state.setState("skirmish")
    elseif (state.getState() == "tOptions") then
      state.setState("tutorial")
    elseif (state.getState() == "options") then
      state.setState("menu")
    end
  end
end

local function buttonVolume(x,y)

  if(collision(upVolumeM, x, y)) then
    data.v = "musique"
    if(sound.getVolumeM() < 1) then
      sound.setVolumeM(sound.getVolumeM() + 0.1)
      data.m = "actif"
      sound.getPlay("volumeBtn")
    end
  elseif(collision(downVolumeM, x, y)) then
    data.v = "musique"
    if(sound.getVolumeM() > 0.1) then
      sound.setVolumeM(sound.getVolumeM() - 0.1)
      data.m = "actif"
      sound.getPlay("volumeBtn")
    end
  elseif(collision(upVolumeSE, x, y)) then
    data.v = "effect"
    if(sound.getVolumeS() < 1) then
      sound.setVolumeS(sound.getVolumeS() + 0.1)
      sound.getPlay("volumeBtn")
      data.m = "actif"
    end
  elseif(collision(downVolumeSE, x, y))then
    data.v = "effect"
    if(sound.getVolumeS() > 0.1 ) then
      sound.setVolumeS(sound.getVolumeS() - 0.1)
      sound.getPlay("volumeBtn")
      data.m = "actif"
    end
  end

  if(collision(muteVolume, x, y)) then
    data.v = "muet"
    if (sound.getVolumeM() > 0) and (sound.getVolumeS() > 0) then
      sound.getPlay("volumeBtn")
      data.m = "muet"
      sound.setVolumeM(0)
      sound.setVolumeS(0)
    elseif(sound.getVolumeM() == 0) and (sound.getVolumeS() == 0) then
      data.m = "actif"
      sound.setVolumeM(0.5)
      sound.setVolumeS(0.5)
      sound.getPlay("volumeBtn")
    elseif(sound.getVolumeM() == 0) and (sound.getVolumeS() > 0) then
      data.m = "muet"
      sound.setVolumeS(0)
      sound.getPlay("volumeBtn")
    elseif (sound.getVolumeM() > 0) and (sound.getVolumeS() == 0) then
      data.m = "muet"
      sound.setVolumeM(0)
      sound.getPlay("volumeBtn")
    end
  end

end

function class.mousepressed(x,y,button)
  if button == 1 then
    buttonVolume(x,y)
  end
  if(collision(leave, x, y)) then
    sound.getPlay("reverse")
    if (state.getState() == "sOptions") then
      state.setState("skirmish")
    elseif (state.getState() == "tOptions") then
      state.setState("tutorial")
    elseif (state.getState() == "options") then
      state.setState("menu")
    end
  end
end

return class