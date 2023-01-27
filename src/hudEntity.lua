local images = require("images")
local animation = require("animation")
local player = require("player")
local player2 = require("player2")
local playerList = require("playerList")
local enemy = require("enemy")

local class = {}
local arrow = {}
local infoBar = {}

local function initInfoBar()
  infoBar.img = images.getImage("infosBar")
  infoBar.w = infoBar.img:getWidth()
  infoBar.h = infoBar.img:getHeight()
end

local function initArrow()
  arrow.sprite = images.getImage("arrowSheet")
  arrow.w = 128
  arrow.h = arrow.sprite:getHeight()

  arrow.animation = animation.new(arrow.sprite, 6, 8, 0, 0, arrow.w, arrow.h)
end

function class.load()
  initInfoBar()
  initArrow()
end

local function updateArrow(dt)
  if (player.isTurn()) or (player2.isTurn()) then
    animation.update(arrow.animation, dt)
  end
  for enemyId, enemy in ipairs(enemy.getEnemyList()) do
    if (enemy.timerLaunch) or (enemy.timer2Launch) or (enemy.timer3Launch) then
      animation.update(arrow.animation, dt)
    end
  end
end

function class.update(dt)
  updateArrow(dt)
end

local function drawInfoBar(list)
  for entityId, entity in ipairs(list) do
    local ratio = entity.hp/entity.hpMax
    love.graphics.setColor(0.60, 0, 0)
    love.graphics.rectangle("fill", entity.x+2, entity.y - entity.h/2 - 80 + infoBar.h/2 - 3, ratio * (infoBar.w-4), 11)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(infoBar.img, entity.x, entity.y - entity.h/2 - 80)
    love.graphics.setFont(images.getFont10())
    love.graphics.printf(entity.hp.." / "..entity.hpMax, entity.x, entity.y - entity.h/2 - 80 + infoBar.h/2 - 1, infoBar.w, "center")
    love.graphics.setFont(images.getFont15())
    love.graphics.setColor(0.40, 0.2, 0)
    love.graphics.print("PA "..entity.pa, entity.x + 4, entity.y - entity.h/2 - 36)
    love.graphics.setColor(0.2, 0.60, 0)
    love.graphics.print("PM "..entity.pm, entity.x + 70, entity.y - entity.h/2 - 36)
  end
end

local function drawArrow()
  love.graphics.setColor(1, 1, 1)
  if (player.isTurn()) then
    animation.draw(arrow.animation, player.getX() + arrow.w/2, player.getY() - player.getH(), arrow.w, arrow.h)
  elseif (player2.isTurn()) then
    animation.draw(arrow.animation, player2.getX() + arrow.w/2, player2.getY() - player2.getH(), arrow.w, arrow.h)
  end

  for enemyId, enemy in ipairs(enemy.getEnemyList()) do
    if (enemy.timerLaunch) or (enemy.timer2Launch) or (enemy.timer3Launch) then
      animation.draw(arrow.animation, enemy.x + arrow.w/2, enemy.y - enemy.h, arrow.w, arrow.h)
    end
  end
end

function class.draw()
  drawInfoBar(playerList.getPlayerList())
  drawInfoBar(enemy.getEnemyList())
  drawArrow()
end

return class