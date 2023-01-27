local screen = require("screen")
local images = require("images")
local menu = require("menu")
local state = require("state")
local tutorial = require("tutorial")
local collMenu = require ("collMenu")
local credit = require("credits")
local sounds = require ("sounds")
local options = require("options")
local intro = require("intro")
local lose = require("lose")
local win = require("win")
local skirmish = require("skirmish")
local menuQuit = require("menuQuit")
local camera = require("camera")

function love.load()
  state.load()
  screen.load()
  images.load()
  sounds.load()
  intro.load()
  menu.load()
  lose.load()
  win.load()
  menuQuit.load()
  love.mouse.setVisible(false)
end

function love.update(dt)
  local gameState = state.getState()

  if (gameState == "intro") then
    intro.update(dt)
  elseif (gameState == "menu") then
    menu.update(dt)
    menuQuit.update()
  elseif (gameState == "tutorial") then
    tutorial.update(dt)
    menuQuit.update()
  elseif (gameState == "skirmish") then
    skirmish.update(dt)
    menuQuit.update()
  elseif (gameState == "credit") then
    credit.update(dt)
  elseif (gameState == "options") then
    options.update(dt)
  elseif (gameState == "sOptions") then
    options.update(dt)
  elseif (gameState == "tOptions") then
    options.update(dt)
  elseif (gameState == "gameOver") then
    lose.update(dt)
  elseif (gameState == "gameWin") then
    win.update(dt)
  end
  sounds.update(dt)
end

function love.draw()
  local gameState = state.getState()

  if (gameState == "intro") then
    intro.draw()
  elseif (gameState == "menu") then
    menu.draw()
    menuQuit.draw()
  elseif (gameState == "tutorial") then
    tutorial.draw()
    menuQuit.draw()
  elseif (gameState == "skirmish") then
    skirmish.draw()
    menuQuit.draw()
  elseif (gameState == "credit") then
    credit.draw()
  elseif (gameState == "options") then
    options.draw()
  elseif (gameState == "sOptions") then
    options.draw()
  elseif (gameState == "tOptions") then
    options.draw()
  elseif (gameState == "gameOver") then
    lose.draw()
  elseif (gameState == "gameWin") then
    win.draw()
  end

  if (gameState ~= "intro") then
    love.graphics.draw(images.getImage("mouse"), love.mouse.getX(), love.mouse.getY()+1)
  end
end

function love.keypressed(key)
  local gameState = state.getState()

  if (gameState == "intro") then
    intro.keypressed(key)
  elseif (gameState == "menu") then
    menuQuit.keypressed(key)
  elseif (gameState == "tutorial") then
    tutorial.keypressed(key)
  elseif (gameState == "skirmish") then
    skirmish.keypressed(key)
  elseif (gameState == "credit") then
    credit.keypressed(key)
  elseif (gameState == "options") then
    options.keypressed(key)
  elseif (gameState == "sOptions") then
    options.keypressed(key)
  elseif (gameState == "tOptions") then
    options.keypressed(key)
  elseif (gameState == "gameOver") then
    lose.keypressed(key)
  elseif (gameState == "gameWin") then
    win.keypressed(key)
  end
end

function love.mousepressed(x, y, button)
  local gameState = state.getState()

  if (gameState == "menu") then
    collMenu.mouseMenu(x, y, button)
    menuQuit.mousepressed(x, y, button)
  elseif (gameState == "tutorial") then 
    tutorial.mousepressed(x, y, button)
    menuQuit.mousepressed(x, y, button)
  elseif (gameState == "skirmish") then 
    skirmish.mousepressed(x, y, button)
    menuQuit.mousepressed(x, y, button)
  elseif (gameState == "options") then 
    options.mousepressed(x, y, button)
  elseif (gameState == "sOptions") then 
    options.mousepressed(x, y, button)
  elseif (gameState == "tOptions") then 
    options.mousepressed(x, y, button)
  elseif (gameState == "credit") then 
    credit.mousepressed(x, y, button)
  elseif (gameState == "gameWin") then
    win.mousepressed(x, y, button)
  elseif (gameState == "gameOver") then
    lose.mousepressed(x, y, button)
  end
end