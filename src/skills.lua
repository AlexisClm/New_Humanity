local actionZone = require("actionZone")
local enemy = require("enemy")
local playerList = require("playerList")

local class = {}
local data = {}

function class.getPa()
  return data.paCount
end

function class.init(skill)
  if (skill == "coupSimple") then
    data.value = - 4
    data.paCount = 3
  elseif (skill == "coupDouble") then
    data.value = - 10
    data.paCount = 6
  elseif (skill == "coupZone") then
    data.value = - 8
    data.paCount = 9
  elseif (skill == "soin") then
    data.value = 10
    data.paCount = 6
  elseif (skill == "tirSimple") then
    data.value = - 5
    data.paCount = 3
  elseif (skill == "tirDouble") then
    data.value = - 13
    data.paCount = 6
  elseif (skill == "tirDePrecision") then
    data.value = - 20
    data.paCount = 9
  elseif (skill == "acceleration") then
    data.value = 2
    data.paCount = 2
  end
end

function class.useSkill(skill, l, c)
  data.name = skill

  if (skill == "coupSimple") then
    actionZone.circle(l, c, 2)
    actionZone.useCircle(true)
  elseif (skill == "coupDouble") then
    actionZone.diagonal(l, c, 1)
    actionZone.useDiagonal(true)
  elseif (skill == "coupZone") then
    actionZone.circle(l, c, 2)
    actionZone.useCircle(true)
    actionZone.useZone(true)
  elseif (skill == "soin") then
    actionZone.circle(l, c, 2)
    actionZone.useCircle(true)
  elseif (skill == "tirSimple") then
    actionZone.circle(l, c, 7)
    actionZone.useCircle(true)
  elseif (skill == "tirDouble") then
    actionZone.circle(l, c, 5)
    actionZone.useCircle(true)
  elseif (skill == "tirDePrecision") then
    actionZone.line(l, c, 7)
    actionZone.useLine(true)
  elseif (skill == "acceleration") then
    actionZone.circle(l, c, 1)
    actionZone.useCircle(true)
  end
end

function class.mousepressed(obj, lineBar, fonction, x, y, button)
  actionZone.mousepressed(obj, lineBar, fonction, data.name, data.value, data.paCount, x, y, button)
end

function class.draw(obj)
  actionZone.drawActionCells(obj)
end

return class