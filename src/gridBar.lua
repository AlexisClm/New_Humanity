local screen = require("screen")
local player = require("player")
local player2 = require("player2")
local images = require("images")
local grid = require("grid")
local actionZone = require("actionZone")
local skills = require("skills")
local sound = require("sounds")
local state = require("state")
local script = require("script")
local camera = require("camera")

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

function class.setSlotSelection(line, column, value)
  data[line][column].selection = value
end

function class.getSlotSelection(line, column)
  return data[line][column].selection
end

function class.setSlot(line, column, value)
  data[line][column].type = value
end

function class.setBarLock(line, value)
  data[line].lock = value
end

function class.getBarLock(line)
  return data[line].lock
end

function class.checkCase(line, column)
  return (line >= 1) and (line <= nb.lines) and (column >= 1) and (column <= nb.columns) 
end

function class.getType(line, column)
  return data[line][column].type
end

function class.getHitbox(line, column)
  local hitbox = {}
  hitbox.x = class.getX(column) + data.size/2
  hitbox.y = class.getY(line) + data.size/2
  hitbox.r = data.size/2
  return hitbox
end

local function initSettings()
  nb.lines = 2
  nb.columns = 5

  data.size = 112
  data.x = 700 --C'est pour faire correspondre avec la barre de compétence. screen.getWidth()/2 - data.size * nb.columns/2
  data.y = 950
end

local function initGrid()
  for line = 1, nb.lines do
    data[line] = {}
    for column = 1, nb.columns do
      if (player.isTurn()) then
        data[line][column] = {type = "cellNil", selection = false, lock = false}
      end
    end
  end
  for line = 2, nb.lines do
    data[line].lock = true
  end
end

function class.resetSelection()
  for line = 1, nb.lines do
    for column = 1, nb.columns do
      data[line][column].selection = false
    end
  end
end

function class.selectionMenuToBar(obj, line, column, skill)
  if (obj.selection) then
    class.setSlot(line, column, skill)
    obj.selection = false
    class.resetSelection()
    sound.getPlay("affectSkill")
    if (state.getState() == "tutorial") and (script.canSkill()) then
      script.setSkill(true)
      sound.getPlay("tuto")
    end
  end
end

function class.selectionBarToMenu(obj, fonction, skill, line, column, x, y)
  if (x < obj.x + obj.w) and (x > obj.x) and (y > obj.y) and (y < obj.y + obj.h) then
    fonction.resetSkillSelection()
    obj.selection = true
    sound.getPlay("selectSkill")
    for line = 1, nb.lines do
      for column = 1, nb.columns do
        if (class.getSlotSelection(line, column)) then
          if (not class.getBarLock(line)) then
            class.setSlot(line, column, skill)
            obj.selection = false
            class.resetSelection()
            if (state.getState() == "tutorial") and (script.canSkill()) then
              script.setSkill(true)
              sound.getPlay("tuto")
            end
          end
        end
      end
    end
  end
end

function class.load()
  initSettings()
  initGrid()
end

function class.update()
  if (player.isTurn()) then
    data.y = 950
  elseif (player2.isTurn()) then
    data.y = 838
  end
end

local function drawGrid(line, lineMax)
  for line = line, lineMax do
    for column = 1, nb.columns do
      local cellValue = data[line][column]
      local x = class.getX(column)
      local y = class.getY(line)

      if (cellValue.type == "cellNil") then
        love.graphics.setColor(0, 0, 0)
      elseif (cellValue.type == "coupSimple") then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.getImage("coupSimple"), x -8, y -8)
        love.graphics.setColor(0, 0, 0)
      elseif (cellValue.type == "coupDouble") then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.getImage("coupDouble"), x -8, y -8)
        love.graphics.setColor(0, 0, 0)
      elseif (cellValue.type == "coupZone") then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.getImage("coupZone"), x -8, y -8)
        love.graphics.setColor(0, 0, 0)
      elseif (cellValue.type == "soin") then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.getImage("soin"), x -8, y -8)
        love.graphics.setColor(0, 0, 0)
      elseif (cellValue.type == "tirSimple") then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.getImage("tirSimple"), x -8, y -8)
        love.graphics.setColor(0, 0, 0)
      elseif (cellValue.type == "tirDouble") then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.getImage("tirDouble"), x -8, y -8)
        love.graphics.setColor(0, 0, 0)
      elseif (cellValue.type == "tirDePrecision") then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.getImage("tirDePrecision"), x -8, y -8)
        love.graphics.setColor(0, 0, 0)
      elseif (cellValue.type == "acceleration") then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.getImage("acceleration"), x -8, y -8)
        love.graphics.setColor(0, 0, 0)
      end
      if (cellValue.selection == true) then
        love.graphics.setColor(1, 1, 1)
      end
      love.graphics.circle("line", x + data.size/2, y + data.size/2, data.size/2)
    end
  end
end

function class.draw()
  if (player.isTurn()) then
    drawGrid(1, 1)
  elseif (player2.isTurn()) then
    drawGrid(2, nb.lines)
  end
end

local function lauchKeypressedSlot(obj)
  class.resetSelection()
  obj.setWalkMode(false)
  grid.resetWalkableCells()
  actionZone.resetActionList()
  obj.setActionMode(true)
end

local function resetKeypressedSlot(obj)
  class.resetSelection()
  obj.setActionMode(false)
  actionZone.resetActionList()
end

local function genericCheckCellsSkills(obj, line, column, lineBar, columnBar, skill)
  skills.init(skill)
  if (skills.getPa() <= obj.getPa()) then
    lauchKeypressedSlot(obj)
    class.setSlotSelection(lineBar, columnBar, true)
    actionZone.resetAttack()
    skills.useSkill(skill, line, column)
  end
end

local function checkCellsSkill(obj, line, column, lineBar, columnBar)
  if (data[lineBar][columnBar].type == "coupSimple") then
    genericCheckCellsSkills(obj, line, column, lineBar, columnBar, "coupSimple")
  elseif (data[lineBar][columnBar].type == "coupDouble") then
    genericCheckCellsSkills(obj, line, column, lineBar, columnBar, "coupDouble")
  elseif (data[lineBar][columnBar].type == "coupZone") then
    genericCheckCellsSkills(obj, line, column, lineBar, columnBar, "coupZone")
  elseif (data[lineBar][columnBar].type == "soin") then
    genericCheckCellsSkills(obj, line, column, lineBar, columnBar, "soin")

  elseif (data[lineBar][columnBar].type == "tirSimple") then
    genericCheckCellsSkills(obj, line, column, lineBar, columnBar, "tirSimple")
  elseif (data[lineBar][columnBar].type == "tirDouble") then
    genericCheckCellsSkills(obj, line, column, lineBar, columnBar, "tirDouble")
  elseif (data[lineBar][columnBar].type == "tirDePrecision") then
    genericCheckCellsSkills(obj, line, column, lineBar, columnBar, "tirDePrecision")
  elseif (data[lineBar][columnBar].type == "acceleration") then
    genericCheckCellsSkills(obj, line, column, lineBar, columnBar, "acceleration")
  end
end

local function genericKeypressed(obj, lineBar, nb, line, column)
  if (not class.getSlotSelection(lineBar, nb)) then
    checkCellsSkill(obj, line, column, lineBar, nb)
  elseif (class.getSlotSelection(lineBar, nb)) then
    resetKeypressedSlot(obj)
  end
end

function class.keypressed(obj, lineBar, line, column, key)
  if (key == "1") and (not class.getBarLock(lineBar)) then
    genericKeypressed(obj, lineBar, 1, line, column)
  elseif (key == "2") and (not class.getBarLock(lineBar)) then
    genericKeypressed(obj, lineBar, 2, line, column)
  elseif (key == "3") and (not class.getBarLock(lineBar)) then
    genericKeypressed(obj, lineBar, 3, line, column)
  elseif (key == "4") and (not class.getBarLock(lineBar)) then
    genericKeypressed(obj, lineBar, 4, line, column)
  elseif (key == "5") and (not class.getBarLock(lineBar)) then
    genericKeypressed(obj, lineBar, 5, line, column)
  end
end

local function skillSelection(obj, lineBar, columnBar, line, column, x, y, button)
  local mouseL = class.getLine(y + camera.getY())
  local mouseC = class.getColumn(x + camera.getX())

  if (button == 1) then
    if (class.checkCase(lineBar, columnBar)) and (not class.getBarLock(lineBar)) then
      if (mouseL == lineBar) and (mouseC == columnBar) then
        genericKeypressed(obj, lineBar, columnBar, line, column)
      end
    end
  end
end

function class.mousepressed(obj, lineBar, x, y, button, line, column)
  skills.mousepressed(obj, lineBar, class, x, y, button)
  skillSelection(obj, lineBar, 1, line, column, x, y, button)
  skillSelection(obj, lineBar, 2, line, column, x, y, button)
  skillSelection(obj, lineBar, 3, line, column, x, y, button)
  skillSelection(obj, lineBar, 4, line, column, x, y, button)
  skillSelection(obj, lineBar, 5, line, column, x, y, button)
end

return class