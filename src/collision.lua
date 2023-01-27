local grid = require("grid")
local mapManager = require("mapManager")
local player = require("player")
local player2 = require("player2")
local state = require("state")

local class = {}
local colCells = {}
local colPlayers = {}
local colEnemies = {}

function class.isCollidingCell(line, column)
  local isColliding = false
  for cellId, cell in ipairs(colCells) do
    if (cell.l == line) and (cell.c == column) then
      isColliding = true
    end
  end
  return isColliding
end

function class.isCollidingEntity(line, column)
  local isColliding = false

  for cellId, cell in ipairs(colPlayers) do
    if (cell.l == line) and (cell.c == column) then
      isColliding = true
    end
  end

  for cellId, cell in ipairs(colEnemies) do
    if (cell.l == line) and (cell.c == column) then
      isColliding = true
    end
  end

  return isColliding
end

function class.createColEnemies(list)
  colEnemies = {}

  for enemyId, enemy in ipairs(list) do
    table.insert(colEnemies, {l = enemy.l, c = enemy.c})
  end
end

function class.createColPlayers()
  colPlayers = {}

  if (player.isAlive()) then
    table.insert(colPlayers, {l = player.getLine(), c = player.getColumn()})
  end

  if (state.getState() == "skirmish") then
    if (player2.isAlive()) then
      table.insert(colPlayers, {l = player2.getLine(), c = player2.getColumn()})
    end
  end
end

local function createColCells(a)
  for line = grid.getLine(a.y), grid.getLine(a.y + a.height-1) do
    for column = grid.getColumn(a.x), grid.getColumn(a.x + a.width-1) do
      if (grid.checkCase(line, column)) then
        table.insert(colCells, {l = line, c = column})
        grid.setWalkable(line, column, false)
      end
    end
  end
end

local function initColCells()
  local map = mapManager.getActualMap()

  for layerId, layer in ipairs(map.layers) do
    if (layer.type == "objectgroup") then
      for objectId, object in ipairs(layer.objects) do
        if (object.shape == "rectangle") then
          createColCells(object)
        end
      end
    end
  end
end

function class.load()
  colCells = {}
  colPlayers = {}
  colEnemies = {}
  initColCells()
  class.createColPlayers()
end

return class