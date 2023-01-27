local grid = require("grid")
local enemy = require("enemy")
local player = require("player")
local player2 = require("player2")
local collision = require("collision")
local playerList = require("playerList")
local camera = require("camera")
local sound = require("sounds")
local hudFight = require("hudFight")
local state = require("state")
local script = require("script")

local class = {}
local data = {}
local actionCells = {}
local dmgZoneCells = {}
local feedBack = {}
local damageTakenCS
local damageTakenCD
local damageTakenTS
local damageTakenTD

function class.resetAttack()
  data.useCircle = false
  data.useLine = false
  data.useDiagonal = false
  data.useZone = false
end

function class.resetActionList()
  actionCells = {}
end

function class.useCircle(value)
  data.useCircle = value
end

function class.useLine(value)
  data.useLine = value
end

function class.useDiagonal(value)
  data.useDiagonal = value
end

function class.useZone(value)
  data.useZone = value
end

function class.circle(l, c, range)
  for line = l - range, l + range do
    for column = c - range + math.abs(l - line), c + range - math.abs(l - line) do
      if (grid.checkCase(line, column)) and (not collision.isCollidingCell(line, column)) then
        table.insert(actionCells, {l = line, c = column, aim = false, aimPlayer = false, aimEnemy = false})
      end
    end
  end
end

function class.line(l, c, range)
  for line = l - range, l + range do
    if (grid.checkCase(line, c)) and (not collision.isCollidingCell(line, c)) and (line ~= l) then
      table.insert(actionCells, {l = line, c = c, aim = false, aimPlayer = false, aimEnemy = false})
    end
  end
  for column = c - range, c + range do
    if (grid.checkCase(l, column)) and (not collision.isCollidingCell(l, column)) and (column ~= c) then
      table.insert(actionCells, {l = l, c = column, aim = false, aimPlayer = false, aimEnemy = false})
    end
  end
end

local function checkDiagonal(line, column, range, dirL, dirC)
  for i = 1, range do
    if (grid.checkCase(line, column)) and (not collision.isCollidingCell(line, column)) then
      table.insert(actionCells, {l = line, c = column, aim = false, aimPlayer = false, aimEnemy = false})
    end
    line = line + dirL
    column = column + dirC
  end
end

function class.diagonal(l, c, range)
  local line = l - 1
  local column = c - 1

  checkDiagonal(line, column, range, -1, -1)
  line = l + 1
  column = c + 1

  checkDiagonal(line, column, range, 1, 1)
  line = l - 1
  column = c + 1

  checkDiagonal(line, column, range, -1, 1)
  line = l + 1
  column = c - 1

  checkDiagonal(line, column, range, 1, -1)
end

local function checkEntity(entityList, mouseL, mouseC)
  for entityId, entity in ipairs(entityList) do
    if (entity.l == mouseL) and (entity.c == mouseC) then
      return true
    end
  end
end

function class.update()
  local x = love.mouse.getX() - camera.getX()
  local y = love.mouse.getY() - camera.getY()
  local enemyList = enemy.getEnemyList()
  local playersList = playerList.getPlayerList()

  for i = 1, #actionCells do
    if (actionCells[i].l == grid.getLine(y)) and (actionCells[i].c == grid.getColumn(x)) then
      if (checkEntity(playersList, grid.getLine(y), grid.getLine(x))) then
        actionCells[i].aimPlayer = true
      elseif (checkEntity(enemyList, grid.getLine(y), grid.getLine(x))) then
        actionCells[i].aimEnemy = true
      else
        actionCells[i].aim = true
      end
    else
      actionCells[i].aimPlayer = false
      actionCells[i].aimEnemy = false
      actionCells[i].aim = false
    end
  end
end

local function drawZone()
  local x = love.mouse.getX() - camera.getX()
  local y = love.mouse.getY() - camera.getY()

  if (data.useZone) then
    for i = 1, #actionCells do
      if (actionCells[i].l == grid.getLine(y)) and (actionCells[i].c == grid.getColumn(x)) then
        love.graphics.setColor(1, 0, 0, 0.6)
        love.graphics.rectangle("fill", (grid.getColumn(x) - 1) * grid.getSize(), (grid.getLine(y) - 1) * grid.getSize(), grid.getSize(), grid.getSize())
        love.graphics.rectangle("fill", grid.getColumn(x) * grid.getSize(), (grid.getLine(y) - 1) * grid.getSize(), grid.getSize(), grid.getSize())
        love.graphics.rectangle("fill", (grid.getColumn(x) - 1) * grid.getSize(), grid.getLine(y) * grid.getSize(), grid.getSize(), grid.getSize())
        love.graphics.rectangle("fill", (grid.getColumn(x) - 1) * grid.getSize(), (grid.getLine(y) - 2) * grid.getSize(), grid.getSize(), grid.getSize())
        love.graphics.rectangle("fill", (grid.getColumn(x) - 2) * grid.getSize(), (grid.getLine(y) - 1) * grid.getSize(), grid.getSize(), grid.getSize())
      end
    end
  end
end

function class.drawActionCells(obj)
  if (obj.getActionMode()) then
    for i = 1, #actionCells do
      local x = grid.getX(actionCells[i].c)
      local y = grid.getY(actionCells[i].l)
      local enemyList = enemy.getEnemyList()
      local playersList = playerList.getPlayerList()
      love.graphics.setColor(1, 1, 1, 0.2)
      if (actionCells[i].aimPlayer) then
        love.graphics.setColor(0, 0, 1, 0.6)
      elseif (actionCells[i].aimEnemy) then
        love.graphics.setColor(1, 0, 0, 0.6)
      elseif (actionCells[i].aim) then
        love.graphics.setColor(1, 1, 1, 0.6)
      end
      love.graphics.rectangle("fill", x, y, grid.getSize() - 1, grid.getSize() - 1)
    end
    drawZone()
  end
end

local function genericEntityDmg(entityList, mouseL, mouseC, value, skill)
  for entityId, entity in ipairs(entityList) do
    if (entity.l == mouseL) and (entity.c == mouseC) then
      if (skill == "soin") then
        if (entity.hp < entity.hpMax - value) then
          entity.hp = entity.hp + value
        else
          entity.hp = entity.hpMax
        end
        hudFight.createHeal(mouseL, mouseC)
        hudFight.createFeedback(mouseL, mouseC, value, skill)
      elseif (skill == "coupSimple") or (skill == "coupDouble") then
        entity.hp = entity.hp + value
        hudFight.createAttackPlayer(mouseL, mouseC)
        hudFight.createFeedback(mouseL, mouseC, value, skill)
        if (state.getState() == "tutorial") and (script.canHit()) and (entityList == enemy.getEnemyList()) then
          script.setHit(true)
          sound.getPlay("tuto")
        end
      else
        entity.hp = entity.hp + value
        hudFight.createShot(mouseL, mouseC)
        hudFight.createFeedback(mouseL, mouseC, value, skill)
      end
    end
  end
end

local function genericEntityPm(entityList, mouseL, mouseC, value)
  for entityId, entity in ipairs(entityList) do
    if (entity.l == mouseL) and (entity.c == mouseC) then
      entity.pm = entity.pm + value
      hudFight.createBoost(mouseL, mouseC)
      hudFight.createFeedback(mouseL, mouseC, value, "acceleration")
    end
  end
end

local function checkList(line, column, list)
  for i = 1, 1 do
    if (grid.checkCase(line, column)) and (not collision.isCollidingCell(line, column)) then
      table.insert(list, {l = line, c = column})
    end
  end
end

local function dmgAttack(entityList, l, c, value)
  local line = l
  local column = c

  checkList(line, column, dmgZoneCells)

  line = l
  column = c + 1
  checkList(line, column, dmgZoneCells)

  line = l + 1
  column = c
  checkList(line, column, dmgZoneCells)

  line = l
  column = c - 1
  checkList(line, column, dmgZoneCells)

  line = l - 1
  column = c
  checkList(line, column, dmgZoneCells)

  for i = 1, #dmgZoneCells do
    for entityId, entity in ipairs(entityList) do
      if (entity.l == dmgZoneCells[i].l) and (entity.c == dmgZoneCells[i].c) then
        entity.hp = entity.hp + value
        hudFight.createAttackPlayer(entity.l, entity.c)
        hudFight.createFeedback(entity.l, entity.c, value, "coupZone")
        if (state.getState() == "tutorial") and (script.canHit()) and (entityList == enemy.getEnemyList()) then
          script.setHit(true)
          sound.getPlay("tuto")
        end
      end
    end
  end
  for i = 1, #dmgZoneCells do
    table.remove(dmgZoneCells)
  end
end

local function selectListActionCells(obj, lineBar, fonction, skill, value, pa, x, y, button)
  local mouseL = grid.getLine(y)
  local mouseC = grid.getColumn(x)
  local enemyList = enemy.getEnemyList()
  local playersList = playerList.getPlayerList()

  if (button == 1) then
    for i = 1, #actionCells do
      if (actionCells[i].l == mouseL) and (actionCells[i].c == mouseC) then
        if (skill == "coupSimple") or (skill == "coupDouble") then
          genericEntityDmg(enemyList, mouseL, mouseC, value, skill)
          genericEntityDmg(playersList, mouseL, mouseC, value, skill)
          sound.getPlay("atkCroco")
          sound.getPlay("sword")
        elseif (skill == "coupZone") then
          dmgAttack(enemyList, mouseL, mouseC, value)
          dmgAttack(playersList, mouseL, mouseC, value)
          sound.getPlay("atkCroco")
          sound.getPlay("sword")
        elseif (skill == "tirSimple") or (skill == "tirDouble") or (skill == "tirDePrecision")then
          genericEntityDmg(enemyList, mouseL, mouseC, value, skill)
          genericEntityDmg(playersList, mouseL, mouseC, value, skill)
          sound.getPlay("atkSnipe")
          sound.getPlay("snipe")
        elseif (skill == "soin") then
          genericEntityDmg(enemyList, mouseL, mouseC, value, skill)
          genericEntityDmg(playersList, mouseL, mouseC, value, skill)
          sound.getPlay("atkCroco")
          sound.getPlay("heal")
        elseif (skill == "acceleration") then
          genericEntityPm(enemyList, mouseL, mouseC, value)
          genericEntityPm(playersList, mouseL, mouseC, value)
          sound.getPlay("atkSnipe")
          sound.getPlay("upStatut")
        end
        obj.setPa(obj.getPa()-pa)
        if (obj.getPa() <= 0) then
          fonction.setBarLock(lineBar, true)
        end
      end
    end
    fonction.resetSelection()
    obj.setActionMode(false)
    actionCells = {}
  elseif (button == 2) then
    obj.setActionMode(false)
    actionCells = {}
    fonction.resetSelection()
  end
end

function class.mousepressed(obj, lineBar, fonction, skill, value, pa, x, y, button)
  if (obj.getActionMode()) then
    selectListActionCells(obj, lineBar, fonction, skill, value, pa, x, y, button)
  end
end

return class