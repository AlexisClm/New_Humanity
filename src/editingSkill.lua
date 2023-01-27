local screen = require("screen")
local gridBar = require("gridBar")
local images = require("images")
local player = require("player")
local player2 = require("player2")
local sound = require("sounds")

local class = {}

local menu = {}
local coupSimple = {}
local coupDouble = {}
local coupZone = {}
local soin = {}
local tirSimple = {}
local tirDouble = {}
local tirDePrecision = {}
local acceleration = {}
local verrou1 = {}
local verrou2 = {}

function class.setMenuOn(value)
  menu.on = value
end

function class.getMenuOn()
  return menu.on
end

function class.setMenuLock(value)
  menu.lock = value
end

function class.isMenuLock()
  return menu.lock
end

function class.getMenuX()
  return menu.x
end

function class.getMenuW()
  return menu.w
end

function class.getCoupSimpleHitbox()
  local hitbox = {}
  hitbox.x = coupSimple.x 
  hitbox.y = coupSimple.y
  hitbox.w = coupSimple.w
  hitbox.h = coupSimple.h
  return hitbox
end

function class.getCoupDoubleHitbox()
  local hitbox = {}
  hitbox.x = coupDouble.x 
  hitbox.y = coupDouble.y
  hitbox.w = coupDouble.w
  hitbox.h = coupDouble.h
  return hitbox
end

function class.getCoupZoneHitbox()
  local hitbox = {}
  hitbox.x = coupZone.x 
  hitbox.y = coupZone.y
  hitbox.w = coupZone.w
  hitbox.h = coupZone.h
  return hitbox
end

function class.getSoinHitbox()
  local hitbox = {}
  hitbox.x = soin.x
  hitbox.y = soin.y
  hitbox.w = soin.w
  hitbox.h = soin.h
  return hitbox
end

function class.getTirSimpleHitbox()
  local hitbox = {}
  hitbox.x = tirSimple.x
  hitbox.y = tirSimple.y
  hitbox.w = tirSimple.w
  hitbox.h = tirSimple.h
  return hitbox
end

function class.getTirDoubleHitbox()
  local hitbox = {}
  hitbox.x = tirDouble.x
  hitbox.y = tirDouble.y
  hitbox.w = tirDouble.w
  hitbox.h = tirDouble.h
  return hitbox
end

function class.getTirDePrecisionHitbox()
  local hitbox = {}
  hitbox.x = tirDePrecision.x
  hitbox.y = tirDePrecision.y
  hitbox.w = tirDePrecision.w
  hitbox.h = tirDePrecision.h
  return hitbox
end

function class.getAccelerationHitbox()
  local hitbox = {}
  hitbox.x = acceleration.x
  hitbox.y = acceleration.y
  hitbox.w = acceleration.w
  hitbox.h = acceleration.h
  return hitbox
end

function class.getVerrou1Hitbox()
  local hitbox = {}
  hitbox.x = verrou1.x
  hitbox.y = verrou1.y
  hitbox.w = verrou1.w
  hitbox.h = verrou1.h
  return hitbox
end

function class.getVerrou2Hitbox()
  local hitbox = {}
  hitbox.x = verrou2.x
  hitbox.y = verrou2.y
  hitbox.w = verrou2.w
  hitbox.h = verrou2.h
  return hitbox
end

function class.resetSkillSelection()
  coupSimple.selection = false
  coupDouble.selection = false
  coupZone.selection = false
  soin.selection = false
  tirSimple.selection = false
  tirDouble.selection = false
  tirDePrecision.selection = false
  acceleration.selection = false
end

local function InitMenu()
  menu.on = false
  menu.lock = false
  menu.img = images.getImage("menuSkill")
  menu.w = menu.img:getWidth()
  menu.h = menu.img:getHeight()
  menu.x = screen.getWidth()/2 - menu.w/2
  menu.y = screen.getHeight()/2 - menu.h/2
end

local function InitSkill()
  coupSimple.x = menu.x + 26
  coupSimple.y = 383
  coupSimple.w = 100
  coupSimple.h = 100
  coupSimple.selection = false
  coupSimple.img = images.getImage("coupSimple")

  coupDouble.x = menu.x + 256
  coupDouble.y = 285
  coupDouble.w = 100
  coupDouble.h = 100
  coupDouble.selection = false
  coupDouble.img = images.getImage("coupDouble")

  coupZone.x = menu.x + 26
  coupZone.y = 570
  coupZone.w = 100
  coupZone.h = 100
  coupZone.selection = false
  coupZone.img = images.getImage("coupZone")

  soin.x = menu.x + 488
  soin.y = 382
  soin.w = 100
  soin.h = 100
  soin.selection = false
  soin.img = images.getImage("soin")

  tirSimple.x = menu.x + 26
  tirSimple.y = 383
  tirSimple.w = 100
  tirSimple.h = 100
  tirSimple.selection = false
  tirSimple.img = images.getImage("tirSimple")

  tirDouble.x = menu.x + 256
  tirDouble.y = 285
  tirDouble.w = 100
  tirDouble.h = 100
  tirDouble.selection = false
  tirDouble.img = images.getImage("tirDouble")

  tirDePrecision.x = menu.x + 26
  tirDePrecision.y = 570
  tirDePrecision.w = 100
  tirDePrecision.h = 100
  tirDePrecision.selection = false
  tirDePrecision.img = images.getImage("tirDePrecision")

  acceleration.x = menu.x + 488
  acceleration.y = 382
  acceleration.w = 100
  acceleration.h = 100
  acceleration.selection = false
  acceleration.img = images.getImage("acceleration")

  verrou1.x = menu.x + 256
  verrou1.y = 669
  verrou1.w = 100
  verrou1.h = 100
  verrou1.img = images.getImage("verrou")

  verrou2.x = menu.x + 493
  verrou2.y = 577
  verrou2.w = 100
  verrou2.h = 100
  verrou2.img = images.getImage("verrou")

  coupSimple.font = love.graphics.setFont(images.getFont20())
end

function class.load()
  InitMenu()
  InitSkill()
end

local function setCircleColor(obj)
  if (not obj.selection) then
    love.graphics.setColor(0, 0, 0)
  elseif (obj.selection) then
    love.graphics.setColor(1, 1, 1)
  end
  love.graphics.circle("line", obj.x + obj.w/2 + 14, obj.y + obj.w/2 + 14, obj.w/2)
end

function class.draw()
  if (menu.on) then
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.draw(menu.img, menu.x, menu.y)
    if (player.isTurn()) then
      setCircleColor(coupSimple)
      setCircleColor(coupDouble)
      setCircleColor(coupZone)
      setCircleColor(soin)
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(coupSimple.img, coupSimple.x, coupSimple.y)
      love.graphics.draw(coupDouble.img, coupDouble.x, coupDouble.y)
      love.graphics.draw(coupZone.img, coupZone.x, coupZone.y)
      love.graphics.draw(soin.img, soin.x, soin.y)
      love.graphics.draw(verrou1.img, verrou1.x, verrou1.y)
      love.graphics.draw(verrou2.img, verrou2.x, verrou2.y)
    elseif (player2.isTurn()) then
      setCircleColor(tirSimple)
      setCircleColor(tirDouble)
      setCircleColor(tirDePrecision)
      setCircleColor(acceleration)
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(tirSimple.img, tirSimple.x, tirSimple.y)
      love.graphics.draw(tirDouble.img, tirDouble.x, tirDouble.y)
      love.graphics.draw(tirDePrecision.img, tirDePrecision.x, tirDePrecision.y)
      love.graphics.draw(acceleration.img, acceleration.x, acceleration.y)
      love.graphics.draw(verrou1.img, verrou1.x, verrou1.y)
      love.graphics.draw(verrou2.img, verrou2.x, verrou2.y)
    end
  end
end

function class.keypressed(key)
  if (not menu.lock) then
    if (key == 'i') then
      if (not menu.on) then
        menu.on = true
        gridBar.resetSelection()
        sound.getPlay("click")
      elseif (menu.on) then
        menu.on = false
        class.resetSkillSelection()
        gridBar.resetSelection()
        sound.getPlay("reverse")
      end
    elseif (key == "escape") and (menu.on) then
      menu.on = false
    end
  end
end

local function selectionBarToMenuPlayer(line, column, x, y)

  gridBar.selectionBarToMenu(coupSimple, class, "coupSimple", line, column, x, y)
  gridBar.selectionBarToMenu(coupDouble, class, "coupDouble", line, column, x, y)
  gridBar.selectionBarToMenu(coupZone, class, "coupZone", line, column, x, y)
  gridBar.selectionBarToMenu(soin, class, "soin", line, column, x, y)

end

local function selectionBarToMenuPlayer2(line, column, x, y)

  gridBar.selectionBarToMenu(tirSimple, class, "tirSimple", line, column, x, y)
  gridBar.selectionBarToMenu(tirDouble, class, "tirDouble", line, column, x, y)
  gridBar.selectionBarToMenu(tirDePrecision, class, "tirDePrecision", line, column, x, y)
  gridBar.selectionBarToMenu(acceleration, class, "acceleration", line, column, x, y)

end

local function selectionMenuToBarPlayer(line, column)

  gridBar.selectionMenuToBar(coupSimple, line, column, "coupSimple")
  gridBar.selectionMenuToBar(coupDouble, line, column, "coupDouble")
  gridBar.selectionMenuToBar(coupZone, line, column, "coupZone")
  gridBar.selectionMenuToBar(soin, line, column, "soin")

end

local function selectionMenuToBarPlayer2(line, column)

  gridBar.selectionMenuToBar(tirSimple, line, column, "tirSimple")
  gridBar.selectionMenuToBar(tirDouble, line, column, "tirDouble")
  gridBar.selectionMenuToBar(tirDePrecision, line, column, "tirDePrecision")
  gridBar.selectionMenuToBar(acceleration, line, column, "acceleration")

end

local function editingSkillEntity(line, column, x, y, button)
  if (button == 1) then
    if (player.isTurn()) then
      selectionBarToMenuPlayer(line, column, x, y)
    elseif (player2.isTurn()) then
      selectionBarToMenuPlayer2(line, column, x, y)
    end
    if (gridBar.checkCase(line, column)) then
      if (not gridBar.getBarLock(line)) then
        if (not gridBar.getSlotSelection(line, column)) then
          gridBar.resetSelection()
          gridBar.setSlotSelection(line, column, true)
          if (player.isTurn()) then
            selectionMenuToBarPlayer(line, column)
          elseif (player2.isTurn()) then
            selectionMenuToBarPlayer2(line, column)
          end
        elseif (gridBar.getSlotSelection(line, column)) then
          gridBar.resetSelection()
        end
      end
    end
  elseif (button == 2) then
    if (gridBar.checkCase(line, column)) then
      if (gridBar.getSlotSelection(line, column)) then
        gridBar.setSlot(line, column, "cellNil")
        gridBar.resetSelection()
      end
    end
  end
end

function class.mousepressed(x, y, button)
  if (menu.on) then
    editingSkillEntity(gridBar.getLine(y), gridBar.getColumn(x), x, y, button)
  end
end

return class