local grid = require("grid")
local collision = require("collision")
local camera = require("camera")
local state = require("state")
local script = require("script")
local sound = require("sounds")

local class = {}
local walkableList = {}
local pathfindingCells = {}
local mouse = {}

local canMove = false

function class.resetList()
  walkableList = {}
end

function class.load()
  pathfindingCells = {}
end

local function moving(obj, dt)
  if (obj.isMoving()) then
    local speed = 275

    for i = 1, #pathfindingCells do
      if (obj.getLine()-1 == pathfindingCells[i].l) and (obj.getColumn() == pathfindingCells[i].c) then
        obj.setMovingUp(true)
      elseif (obj.getLine()+1 == pathfindingCells[i].l) and (obj.getColumn() == pathfindingCells[i].c) then
        obj.setMovingDown(true)
      elseif (obj.getColumn()-1 == pathfindingCells[i].c) and (obj.getLine() == pathfindingCells[i].l) then
        obj.setMovingLeft(true)
      elseif (obj.getColumn()+1 == pathfindingCells[i].c) and (obj.getLine() == pathfindingCells[i].l) then
        obj.setMovingRight(true)
      end
    end

    if (obj.isMovingUp()) then
      if (obj.getY() > grid.getY(obj.getLine())-grid.getSize()) then
        obj.setY(obj.getY()-speed*dt)
        camera.focusPlayer(obj)
      else
        obj.setMovingUp(false)
        obj.setLine(obj.getLine()-1)
        obj.setY(grid.getY(obj.getLine()))
        obj.setPm(obj.getPm()-1)
        table.remove(pathfindingCells, 1)
      end
    elseif (obj.isMovingDown()) then
      if (obj.getY() < grid.getY(obj.getLine())+grid.getSize()) then
        obj.setY(obj.getY()+speed*dt)
        camera.focusPlayer(obj)
      else
        obj.setMovingDown(false)
        obj.setLine(obj.getLine()+1)
        obj.setY(grid.getY(obj.getLine()))
        obj.setPm(obj.getPm()-1)
        table.remove(pathfindingCells, 1)
      end
    elseif (obj.isMovingLeft()) then
      if (obj.getX() > grid.getX(obj.getColumn())-grid.getSize()) then
        obj.setX(obj.getX()-speed*dt)
        camera.focusPlayer(obj)
      else
        obj.setMovingLeft(false)
        obj.setColumn(obj.getColumn()-1)
        obj.setX(grid.getX(obj.getColumn()))
        obj.setPm(obj.getPm()-1)
        table.remove(pathfindingCells, 1)
      end
    elseif (obj.isMovingRight()) then
      if (obj.getX() < grid.getX(obj.getColumn())+grid.getSize()) then
        obj.setX(obj.getX()+speed*dt)
        camera.focusPlayer(obj)
      else
        obj.setMovingRight(false)
        obj.setColumn(obj.getColumn()+1)
        obj.setX(grid.getX(obj.getColumn()))
        obj.setPm(obj.getPm()-1)
        table.remove(pathfindingCells, 1)
      end
    else
      obj.setMoving(false)
    end
  else
    collision.createColPlayers()
  end
end

local function highlight()
  local x      = love.mouse.getX() - camera.getX()
  local y      = love.mouse.getY() - camera.getY()
  local line   = grid.getLine(y)
  local column = grid.getColumn(x)

  if (grid.checkCase(line, column)) and (grid.getDist(line, column) > 0) and (grid.isCheckDist(line, column)) then
    mouse.x = column * grid.getSize() - grid.getSize()
    mouse.y = line * grid.getSize() - grid.getSize()
  else
    mouse.x = -3000
    mouse.y = -3000
  end
end

function class.update(obj, dt)
  moving(obj, dt)
  highlight()
end

local function drawWalkableCells()
  for line = 1, grid.getNbLines() do
    for column = 1, grid.getNbColumns() do
      local x = grid.getX(column)
      local y = grid.getY(line)

      if (grid.getDist(line, column) > 0) and (grid.isCheckDist(line, column)) then
        love.graphics.setColor(0, 1, 0, 0.3)
        love.graphics.rectangle("fill", x, y, grid.getSize()-1, grid.getSize()-1)
      end
    end
  end
  love.graphics.setColor(0, 1, 0, 0.5)
  love.graphics.rectangle("fill", mouse.x, mouse.y, grid.getSize(), grid.getSize())
end

local function drawPathfinding()
  for i = 1, #pathfindingCells do
    local x = grid.getX(pathfindingCells[i].c)
    local y = grid.getY(pathfindingCells[i].l)

    love.graphics.setColor(0, 1, 0, 0.3)
    love.graphics.rectangle("fill", x, y, grid.getSize() - 1, grid.getSize() - 1)
  end
end

function class.draw()
  drawWalkableCells()
  drawPathfinding()
end

local function addDistance(line, column, dist)
  if (grid.checkCase(line, column)) and (not collision.isCollidingCell(line, column)) and (not collision.isCollidingEntity(line, column)) then
    if (not grid.isCheckDist(line, column)) then
      grid.setDist(line, column, dist, true)
      table.insert(walkableList, {l = line, c = column})
    end
  end
end

function class.floodFill(line, column, pm)
  grid.setDist(line, column, 0, true)

  local openList = {}

  table.insert(openList, {l = line, c = column})

  for dist = 1, pm do
    while (#openList > 0) do
      local currentCell = table.remove(openList, 1)
      addDistance(currentCell.l-1, currentCell.c, dist)
      addDistance(currentCell.l+1, currentCell.c, dist)
      addDistance(currentCell.l, currentCell.c-1, dist)
      addDistance(currentCell.l, currentCell.c+1, dist)
    end
    openList = walkableList
    walkableList = {}
  end
end

function class.pathfinding(line, column, dist)
  local availableDirections = {}

  if (grid.checkCase(line-1, column)) and (not collision.isCollidingEntity(line-1, column)) and (grid.getDist(line-1, column) == dist-1) then
    table.insert(availableDirections, {l = line-1, c = column})
  end
  if (grid.checkCase(line+1, column)) and (not collision.isCollidingEntity(line+1, column)) and (grid.getDist(line+1, column) == dist-1) then
    table.insert(availableDirections, {l = line+1, c = column})
  end
  if (grid.checkCase(line, column-1)) and (not collision.isCollidingEntity(line, column-1)) and (grid.getDist(line, column-1) == dist-1) then
    table.insert(availableDirections, {l = line, c = column-1})
  end
  if (grid.checkCase(line, column+1)) and (not collision.isCollidingEntity(line, column+1)) and (grid.getDist(line, column+1) == dist-1) then
    table.insert(availableDirections, {l = line, c = column+1})
  end

  local randomDirection = availableDirections[love.math.random(#availableDirections)]

  return randomDirection
end

local function moveEntity(obj, line, column, pm, x, y, button)
  local mouseL = grid.getLine(y)
  local mouseC = grid.getColumn(x)

  if (button == 1) then
    if (not obj.isWalkMode()) then
      if (not obj.getActionMode()) then
        if (line == mouseL) and (column == mouseC) then
          obj.setWalkMode(true)
          class.floodFill(line, column, pm)
        end
      end
    else
      if (grid.isCheckDist(mouseL, mouseC)) then
        local dist = grid.getDist(mouseL, mouseC)
        if (dist > 0) then
          local randomDirection = class.pathfinding(mouseL, mouseC, dist)

          table.insert(pathfindingCells, 1, {l = mouseL, c = mouseC})
          if (dist > 1) then
            table.insert(pathfindingCells, 1, {l = randomDirection.l, c = randomDirection.c})
          end

          for i = dist-1, 2, -1 do
            randomDirection = class.pathfinding(randomDirection.l, randomDirection.c, i)
            class.pathfinding(randomDirection.l, randomDirection.c, i)
            table.insert(pathfindingCells, 1, {l = randomDirection.l, c = randomDirection.c})
          end
          obj.setMoving(true)
          if (state.getState() == "tutorial") and (script.canMove()) then
            script.setMove(true)
            sound.getPlay("tuto")
          end
        end
      end
      grid.resetWalkableCells()
      obj.setWalkMode(false)
    end
  end
end

function class.mousepressed(obj, line, column, pm, x, y, button)
  moveEntity(obj, line, column, pm, x, y, button)
end

return class