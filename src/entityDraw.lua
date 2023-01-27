local enemy = require("enemy")
local playerList = require("playerList")

local class = {}

local function insertionSort(tab)
  local copy = {}
  table.insert(copy, tab[1])
  for i = 2, #tab do
    local j = 0
    repeat
      j = j + 1
    until (j > #copy) or (tab[i].l < copy[j].l)
    table.insert(copy, j, tab[i])
  end
  for i = 1, #copy do
    tab[i] = copy[i]
  end
end

function class.draw()
  local enemyList = enemy.getEnemyList()
  local playersList = playerList.getPlayerList()
  local listClone = {}

  for enemyId, enemy in ipairs(enemyList) do
    table.insert(listClone, enemy)
  end

  for playerId, player in ipairs(playersList) do
    table.insert(listClone, player)
  end

  insertionSort(listClone)
  enemy.draw(listClone)
end

return class