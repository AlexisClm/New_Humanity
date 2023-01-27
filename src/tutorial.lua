local camera = require("camera")
local editingSkill = require("editingSkill")
local enemy = require("enemy")
local state = require ("state")
local mapManager = require("mapManager")
local grid = require("grid")
local player = require("player")
local player2 = require("player2")
local playerList = require("playerList")
local gridBar = require("gridBar")
local turn = require("turn")
local skills = require("skills")
local collision = require("collision")
local hud = require("hud")
local sound = require("sounds")
local actionZone = require("actionZone")
local move = require("move")
local options = require("options")
local hudFight = require("hudFight")
local hudEntity = require("hudEntity")
local entityDraw = require("entityDraw")
local menuQuit = require("menuQuit")
local script = require("script")

local class = {}

function class.load()
  mapManager.load()
  mapManager.setActualMap(1)
  grid.load()
  camera.load()
  playerList.load()
  move.load()
  collision.load()
  enemy.load()
  gridBar.load()
  editingSkill.load()
  hud.load()
  hudEntity.load()
  script.load()
end

function class.update(dt)
  turn.update(dt)
  playerList.update(dt)
  enemy.update(dt)
  gridBar.update()
  actionZone.update()
  hud.update(dt)
  hudFight.update(dt)
  hudEntity.update(dt)
  script.update(dt)
end

function class.draw()
  love.graphics.push()
  love.graphics.translate(camera.getX(), camera.getY())
  mapManager.draw("background")
  grid.draw()
  turn.draw()
  entityDraw.draw()
  mapManager.draw("foreground")
  hudEntity.draw()
  hudFight.draw()
  love.graphics.pop()
  gridBar.draw()
  editingSkill.draw()
  hud.draw()
  script.draw()
end

local function gameKeypressed(key)
  -- A SUPPRIMER
  if (key == 'b') then
    state.setState("gameWin")
    sound.getSound("soundPlay"):stop()
    sound.getSound("soundMenu"):stop()
    sound.getSound("victory"):play()
    sound.getSound("defeat"):stop()
  elseif (key == 'n') then
    state.setState("gameOver")
    sound.getSound("soundPlay"):stop()
    sound.getSound("soundMenu"):stop()
    sound.getSound("defeat"):play()
    sound.getSound("victory"):stop()
  end
end

function class.keypressed(key)
  gameKeypressed(key)
  if (not editingSkill.getMenuOn()) then
    turn.keypressed(key)
  end
  if (not editingSkill.getMenuOn()) then
    menuQuit.keypressed(key)
  end
  editingSkill.keypressed(key)
end

local function isCollidingPointCircle(point, circle)
  local d = ((point.x - circle.x)^2 + (circle.y - point.y)^2)^0.5

  if (d < circle.r) then
    return true
  else
    return false
  end
end

function class.mousepressed(x, y, button)
  if (not menuQuit.getMenuQuitOn()) then
    hud.mousepressed(x, y, button)
    editingSkill.mousepressed(x, y, button)
    if (not editingSkill.getMenuOn()) then
      turn.mousepressed(x-camera.getX(), y-camera.getY(), button)
    end
  end
end

return class