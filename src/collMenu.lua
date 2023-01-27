local menu = require ("menu")
local state = require ("state")
local tutorial = require ("tutorial")
local skirmish = require ("skirmish")
local credit = require ("credits")
local options = require("options")
local sound = require("sounds")
local menuQuit = require("menuQuit")

local function isCollidingPointRectangle(pointX, pointY, rect)
  if (pointX > rect.x) and (pointX < rect.x + rect.w) and (pointY > rect.y) and (pointY < rect.y + rect.h)then
    return true
  else
    return false
  end
end

local class = {}

function class.mouseMenu(x, y, button)
  if (not menuQuit.getMenuQuitOn()) then
    if (isCollidingPointRectangle( x ,y , menu.getHitTutorial())) then
      sound.getPlay("clickPlay")
      state.setState("tutorial")
      tutorial.load()
    elseif (isCollidingPointRectangle( x ,y , menu.getHitSkirmish())) then
      sound.getPlay("clickPlay")
      state.setState("skirmish")
      skirmish.load()
    elseif (isCollidingPointRectangle( x ,y , menu.getHitOptions())) then
      sound.getPlay("click")
      state.setState("options")
      options.load()
    elseif (isCollidingPointRectangle( x ,y , menu.getHitCredits())) then
      sound.getPlay("click")
      state.setState("credit")
      credit.load()
    elseif (isCollidingPointRectangle(  x ,y , menu.getHitLeave())) then
      sound.getPlay("reverse")
      menuQuit.setMenuQuitOn(true)
    elseif (isCollidingPointRectangle(x, y, menu.getHitCreajeux())) then
      love.system.openURL("https://www.creajeux.fr")
    end
  end
end

return class