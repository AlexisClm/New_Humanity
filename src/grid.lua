local mapManager = require("mapManager")
local state = require("state")

local class = {}
local data = {}
local nb = {}

function class.getX(column)
  return data.x + (column-1) * data.size
end

function class.getY(line)
  return data.y + (line-1) * data.size
end

function class.getColumn(x)
  return math.floor((x - data.x)/data.size) + 1
end

function class.getLine(y)
  return math.floor((y - data.y)/data.size) + 1
end

function class.getSize()
  return data.size
end

function class.getNbLines()
  return nb.lines
end

function class.getNbColumns()
  return nb.columns
end

function class.setShowGrid(value)
  data.showGrid = value
end

function class.isShowGrid()
  return data.showGrid
end

function class.setDist(line, column, value, bool)
  data[line][column].dist = value
  data[line][column].checkDist = bool
end

function class.resetWalkableCells()
  for line = 1, nb.lines do
    for column = 1, nb.columns do
      class.setDist(line, column, 0, false)
    end
  end
end

function class.setWalkable(line, column, value)
  data[line][column].walkable = value
end

function class.getDist(line, column)
  return data[line][column].dist
end

function class.isCheckDist(line, column)
  return data[line][column].checkDist
end

function class.checkCase(line, column)
  return (line >= 1) and (line <= nb.lines) and (column >= 1) and (column <= nb.columns) 
end

local function initSettings()
  if (state.getState() == "tutorial") then
    nb.lines = 20
    nb.columns = 20
  elseif (state.getState() == "skirmish") then
    nb.lines = 30
    nb.columns = 30
  end
  data.size = 128
  data.x = 0
  data.y = 0

  data.showGrid = true
end

local function initGrid()
  for line = 1, nb.lines do
    data[line] = {}
    for column = 1, nb.columns do
      data[line][column] = {walkable = true, dist = 0, checkDist = false}
    end
  end
end

function class.load()
  initSettings()
  initGrid()
end

local function drawGrid()
  for line = 1, nb.lines do
    for column = 1, nb.columns do
      local x = class.getX(column)
      local y = class.getY(line)
      if (data[line][column].walkable) then
        love.graphics.setColor(1, 1, 1, 0.2)
        love.graphics.rectangle("line", x, y, data.size, data.size)
      end
    end
  end
end

function class.draw()
  if (data.showGrid) then
    drawGrid()
  end
end

return class
