local grid = require("grid")
local images = require("images")
local animation = require("animation")

local data = {}
local shotAnim = {}
local attackPlayerAnim = {}
local attackEnemyAnim = {}
local healAnim = {}
local boostAnim = {}
local class = {}

function class.createFeedback(mouseL, mouseC, value, skill)
  local feedback = {}
  feedback.l = mouseL
  feedback.c = mouseC
  feedback.x = grid.getX(feedback.c)
  feedback.y = grid.getY(feedback.l)
  feedback.timer = 0
  feedback.timerMax = 1.5
  feedback.op = 1.5
  feedback.value = value
  feedback.skill = skill
  table.insert(data, feedback)
end

function class.createShot(mouseL, mouseC)
  local shot = {}
  shot.sprite = images.getImage("hudShotSheet")
  shot.l = mouseL
  shot.c = mouseC
  shot.x = grid.getX(shot.c) + grid.getSize()/2
  shot.y = grid.getY(shot.l) - grid.getSize()/4
  shot.w = 128
  shot.h = 128
  shot.timer = 0
  shot.timerMax = 1.5
  shot.animation = animation.new(shot.sprite, 3, 4, 0, 0, shot.w, shot.h)
  table.insert(shotAnim, shot)
end

function class.createAttackPlayer(mouseL, mouseC)
  local attackPlayer = {}
  attackPlayer.sprite = images.getImage("hudAttackPlayerSheet")
  attackPlayer.l = mouseL
  attackPlayer.c = mouseC
  attackPlayer.x = grid.getX(attackPlayer.c) + grid.getSize()/2
  attackPlayer.y = grid.getY(attackPlayer.l) - grid.getSize()/4
  attackPlayer.w = 128
  attackPlayer.h = 128
  attackPlayer.timer = 0
  attackPlayer.timerMax = 1.5
  attackPlayer.animation = animation.new(attackPlayer.sprite, 3, 4, 0, 0, attackPlayer.w, attackPlayer.h)
  table.insert(attackPlayerAnim, attackPlayer)
end

function class.createAttackEnemy(mouseL, mouseC)
  local attackEnemy = {}
  attackEnemy.sprite = images.getImage("hudAttackEnemySheet")
  attackEnemy.l = mouseL
  attackEnemy.c = mouseC
  attackEnemy.x = grid.getX(attackEnemy.c) + grid.getSize()/2
  attackEnemy.y = grid.getY(attackEnemy.l) - grid.getSize()/4
  attackEnemy.w = 128
  attackEnemy.h = 128
  attackEnemy.timer = 0
  attackEnemy.timerMax = 1.5
  attackEnemy.animation = animation.new(attackEnemy.sprite, 3, 4, 0, 0, attackEnemy.w, attackEnemy.h)
  table.insert(attackEnemyAnim, attackEnemy)
end

function class.createHeal(mouseL, mouseC)
  local heal = {}
  heal.sprite = images.getImage("hudHealSheet")
  heal.l = mouseL
  heal.c = mouseC
  heal.x = grid.getX(heal.c) + grid.getSize()/2
  heal.y = grid.getY(heal.l) - grid.getSize()/4
  heal.w = 110
  heal.h = 110
  heal.timer = 0
  heal.timerMax = 1.5
  heal.animation = animation.new(heal.sprite, 4, 4, 0, 0, heal.w, heal.h)
  table.insert(healAnim, heal)
end

function class.createBoost(mouseL, mouseC)
  local boost = {}
  boost.sprite = images.getImage("hudBoostSheet")
  boost.l = mouseL
  boost.c = mouseC
  boost.x = grid.getX(boost.c) + grid.getSize()/2
  boost.y = grid.getY(boost.l) - grid.getSize()/4
  boost.w = 100
  boost.h = 240
  boost.timer = 0
  boost.timerMax = 1.5
  boost.animation = animation.new(boost.sprite, 15, 10, 0, 0, boost.w, boost.h)
  table.insert(boostAnim, boost)
end

function class.load()
  data = {}
  shotAnim = {}
  attackPlayerAnim = {}
  attackEnemyAnim = {}
  healAnim = {}
  boostAnim = {}
end

local function updateFeedback(dt)
  for dataId, dataV in ipairs(data) do 
    dataV.timer = dataV.timer + dt
    dataV.op = dataV.op - dt
    dataV.y = dataV.y - 50 * dt
    if (dataV.timer >= dataV.timerMax) then
      table.remove(data, dataId)
      dataV.timer = 0
      dataV.op = 1.5
    end
  end
end

local function updateAnim(list, dt)
  for hitId, hit in ipairs(list) do 
    hit.timer = hit.timer + dt
    animation.update(hit.animation, dt)
    if (hit.timer >= hit.timerMax) then
      table.remove(list, hitId)
    end
  end
end

function class.update(dt)
  updateFeedback(dt)
  updateAnim(shotAnim, dt)
  updateAnim(attackPlayerAnim, dt)
  updateAnim(attackEnemyAnim, dt)
  updateAnim(healAnim, dt)
  updateAnim(boostAnim, dt)
end

local function drawFeedBack(value, x, y, skill, op)
  if (skill == "soin") then
    love.graphics.setColor(0, 0, 1, op)
    love.graphics.setFont(images.getFont50())
    love.graphics.print("+"..value, x + 20, y - 220)
  elseif (skill == "acceleration") then
    love.graphics.setColor(0, 1, 0, op)
    love.graphics.setFont(images.getFont50())
    love.graphics.print("+"..value, x + 20, y - 220)
  else
    love.graphics.setColor(1, 0, 0, op)   
    love.graphics.setFont(images.getFont50())
    love.graphics.print(value, x + 45, y - 220)
  end
end

local function drawHitAnim(list)
  for hitId, hit in ipairs(list) do
    love.graphics.setColor(1, 1, 1)
    animation.draw(hit.animation, hit.x, hit.y, hit.w, hit.h)
  end
end

function class.draw()
  love.graphics.setColor(1, 1, 1)
  drawHitAnim(shotAnim)
  drawHitAnim(attackPlayerAnim)
  drawHitAnim(attackEnemyAnim)
  drawHitAnim(healAnim)
  drawHitAnim(boostAnim)
  for dataId, data in ipairs(data) do
    drawFeedBack(data.value, data.x, data.y, data.skill, data.op)
  end
end

return class