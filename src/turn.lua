local state = require("state")
local player = require("player")
local player2 = require("player2")
local enemy = require("enemy")
local action = require("action")
local gridBar = require("gridBar")
local camera = require("camera")
local grid = require("grid")
local collision = require("collision")
local editingSkill = require("editingSkill")
local script = require("script")
local sound = require("sounds")

local class = {}

function class.endTurnPlayer()
  player.setTurn(false)
  player.setWalkMode(false)
  grid.resetWalkableCells()
  collision.createColPlayers()
  collision.createColEnemies(enemy.getEnemyList())

  if (state.getState() == "skirmish") then
    gridBar.setBarLock(2, false)
    player2.setTurn(true)
    camera.focusPlayer(player2)
  elseif (state.getState() == "tutorial") then
    enemy.setTurn(true)
    enemy.setTimerLaunch(1, true)
    camera.focus(enemy.getEnemyList()[1])
  end
end

function class.endTurnPlayer2()
  player2.setTurn(false)
  player2.setWalkMode(false)
  grid.resetWalkableCells()
  collision.createColPlayers()
  collision.createColEnemies(enemy.getEnemyList())
  enemy.setTurn(true)
  enemy.setTimerLaunch(1, true)
  gridBar.setBarLock(1, false)
  camera.focus(enemy.getEnemyList()[1])
end

function class.update(dt)
  if (player.isAlive()) or (player2.isAlive()) then
    if (player.isTurn()) and (not player.isAlive()) then
      class.endTurnPlayer()
    elseif (player2.isTurn()) and (not player2.isAlive()) then
      class.endTurnPlayer2()
    elseif (player.isTurn()) and (player.isAlive()) then
      editingSkill.setMenuLock(false)
      action.update(player, dt)
      gridBar.setBarLock(1, false)
    elseif (player2.isTurn()) and (player2.isAlive()) then
      editingSkill.setMenuLock(false)
      action.update(player2, dt)
    end
  else
    state.setState("gameOver")
    sound.getSound("soundPlay"):stop()
    sound.getSound("defeat"):play()
  end
end

local function turnDraw()
  if (player.isTurn()) and (player.isAlive()) then
    action.draw(player)
  elseif (player2.isTurn()) and (player2.isAlive()) then
    action.draw(player2)
  end
end

function class.draw()
  turnDraw()
end

function class.resetStats(obj, bar)
  obj.setPa(obj.getPaMax())
  obj.setPm(obj.getPmMax())

  if (state.getState() == "skirmish") then
    gridBar.setBarLock(bar, true)
  end
  editingSkill.setMenuLock(true)
end

local function turnKeypressed(key)
  if (player.isTurn()) and (player.isAlive()) and (not player.isMoving()) then
    action.keypressed(player, 1, key)
    if (key == "space") then
      class.resetStats(player, 1)
      class.endTurnPlayer()
      if (state.getState() == "tutorial") and (script.canPass()) then
        script.setPass(true)
        sound.getPlay("tuto")
      end
    end
  elseif (player2.isTurn()) and (player2.isAlive()) and (not player2.isMoving()) then
    action.keypressed(player2, 2, key)
    if (key == "space") then
      class.resetStats(player2, 2)
      class.endTurnPlayer2()
    end
  end
end

function class.keypressed(key)
  turnKeypressed(key)
end

local function turnMousepressed(x, y, button)
  if (player.isTurn()) and (player.isAlive()) and (not player.isMoving()) then
    action.mousepressed(player, 1, x, y, button)
  elseif (player2.isTurn()) and (player2.isAlive()) and (not player2.isMoving()) then
    action.mousepressed(player2, 2, x, y, button)
  end
end

function class.mousepressed(x, y, button)
  turnMousepressed(x, y, button)
end

return class