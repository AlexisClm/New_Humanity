local state = require("state")
local player = require("player")
local player2 = require("player2")
local images = require("images")
local animation = require("animation")

local class = {}
local playerList = {}

function class.getPlayerList()
  return playerList
end

function class.load()
  playerList = {}
  player.load(playerList)
  if (state.getState() == "skirmish") then
    player2.load(playerList)
  end
end

local function checkDeath()
  for playerId, player in ipairs(playerList) do
    if (player.hp <= 0) then
      player.alive = false
      table.remove(playerList, playerId)
    end
  end
end

function class.update(dt)
  player.update(dt)
  player2.update(dt)
  checkDeath()
end

return class