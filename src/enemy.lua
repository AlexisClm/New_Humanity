local state = require("state")
local grid = require("grid")
local images = require("images")
local camera = require("camera")
local player = require("player")
local player2 = require("player2")
local collision = require("collision")
local move = require("move")
local animation = require("animation")
local sound = require("sounds")
local hudFight = require("hudFight")
local script = require("script")

local class = {}
local enemyList = {}
local walkableList = {}
local enemySpawn = {}
local enemyDie = {}
local pathfindingCells = {}
local randomCell

local playerL
local playerC
local turn
local actualDist

function class.setTurn(value)
  turn = value
end

function class.isTurn()
  return turn
end

function class.setTimerLaunch(id, value)
  enemyList[id].timerLaunch = value
end

function class.getEnemyList()
  return enemyList
end

function class.getEnemyDieList()
  return enemyDie
end

local function createEnemy(type, l, c)
  local enemy = {}

  if (type == "tuto") then
    enemy.sprite = images.getImage("enemy1Sheet")
    enemy.paMax = 6
    enemy.pmMax = 3
    enemy.hpMax = 20
    enemy.attack = 5
    enemy.soundAtk = sound.getSound("atkEnemy1")
    enemy.soundDead = sound.getSound("deadEnemy1")
    enemy.type = "tuto"
    
  elseif (type == "enemy1") then
    enemy.sprite = images.getImage("enemy1Sheet")
    enemy.paMax = 6
    enemy.pmMax = 5
    enemy.hpMax = 20
    enemy.attack = 5
    enemy.soundAtk = sound.getSound("atkEnemy1")
    enemy.soundDead = sound.getSound("deadEnemy1")
    enemy.type = "enemy1"

  elseif (type == "enemy2") then
    enemy.sprite = images.getImage("enemy2Sheet")
    enemy.paMax = 6
    enemy.pmMax = 4
    enemy.hpMax = 10
    enemy.attack = 10
    enemy.soundAtk = sound.getSound("atkEnemy2")
    enemy.soundDead = sound.getSound("deadEnemy2")
    enemy.type = "enemy2"
    
  elseif (type == "enemy3") then
    enemy.sprite = images.getImage("enemy3Sheet")
    enemy.paMax = 7
    enemy.pmMax = 6
    enemy.hpMax = 25
    enemy.attack = 4
    enemy.soundAtk = sound.getSound("atkEnemy3")
    enemy.soundDead = sound.getSound("deadEnemy3")
    enemy.type = "enemy3"

  elseif (type == "enemy4") then
    enemy.sprite = images.getImage("enemy4Sheet")
    enemy.paMax = 8
    enemy.pmMax = 8
    enemy.hpMax = 20
    enemy.attack = 7
    enemy.soundAtk = sound.getSound("atkEnemy3")
    enemy.soundDead = sound.getSound("deadEnemy3")
    enemy.type = "enemy4"

  elseif (type == "enemy5") then
    enemy.sprite = images.getImage("enemy5Sheet")
    enemy.paMax = 8
    enemy.pmMax = 4
    enemy.hpMax = 20
    enemy.attack = 7
    enemy.soundAtk = sound.getSound("atkEnemy3")
    enemy.soundDead = sound.getSound("deadEnemy3")
    enemy.type = "enemy5"

  elseif (type == "boss") then
    enemy.sprite = images.getImage("bossSheet")
    enemy.paMax = 9
    enemy.pa = enemy.paMax
    enemy.pmMax = 9
    enemy.hpMax = 40
    enemy.attack = 10
    enemy.soundAtk = sound.getSound("atkBoss")
    enemy.soundDead = sound.getSound("deadBoss")
    enemy.type = "boss"
  end

  enemy.hp = enemy.hpMax
  enemy.pa = enemy.paMax
  enemy.pm = enemy.pmMax

  enemy.l = l
  enemy.c = c

  enemy.w = 128
  enemy.h = 256
  enemy.x = grid.getX(enemy.c)
  enemy.y = grid.getY(enemy.l)
  
  enemy.isSelected = false

  enemy.timer = 0
  enemy.timerMax = 1.5
  enemy.timerLaunch = false

  enemy.timer2 = 0
  enemy.timer2Max = 1.5
  enemy.timer2Launch = false

  enemy.timer3 = 0
  enemy.timer3Max = 2
  enemy.timer3Launch = false

  enemy.animations = {}

  enemy.animations.up    = animation.new(enemy.sprite, 4, 4, 0, 0, enemy.w, enemy.h)
  enemy.animations.down  = animation.new(enemy.sprite, 4, 4, 0, enemy.h, enemy.w, enemy.h)
  enemy.animations.left  = animation.new(enemy.sprite, 4, 4, 0, enemy.h*2, enemy.w, enemy.h)
  enemy.animations.right = animation.new(enemy.sprite, 4, 4, 0, enemy.h*3, enemy.w, enemy.h)
  enemy.animations.idle  = animation.new(enemy.sprite, 2, 2, 0, enemy.h*4, enemy.w, enemy.h)

  enemy.currentAnimation = enemy.animations.idle

  table.insert(enemyList, enemy)
end

local function initSpawn(lMin, lMax, cMin, cMax)
  for line = lMin, lMax do
    for column = cMin, cMax do
      table.insert(enemySpawn, {l = line, c = column})
    end
  end
end

local function createRandomEnemy(enemyType)
  randomCell = table.remove(enemySpawn, love.math.random(#enemySpawn))
  createEnemy(enemyType, randomCell.l, randomCell.c)
end

function class.load()
  if (state.getState() == "skirmish") then
    local random = love.math.random(4)
    if (random == 1) then
      initSpawn(1, 5, 4, 7)
    elseif (random == 2) then
      initSpawn(2, 5, 22, 28)
    elseif (random == 3) then
      initSpawn(27, 30, 4, 10)
    elseif (random == 4) then
      initSpawn(24, 26, 24, 30)
    end
  elseif (state.getState() == "tutorial") then
    initSpawn(6, 6, 2, 2)
  end

  enemyList = {}
  enemyDie = {}
  pathfindingCells = {}

  if (state.getState() == "skirmish") then
    createRandomEnemy("boss")
    createRandomEnemy("enemy5")
    createRandomEnemy("enemy4")
    createRandomEnemy("enemy3")
    createRandomEnemy("enemy2")
    createRandomEnemy("enemy1")
  elseif (state.getState() == "tutorial") then
    createRandomEnemy("tuto")
  end

  for i = 1, #enemySpawn do
    table.remove(enemySpawn)
  end

  collision.createColEnemies(enemyList)
end

local function focusPlayer(enemy)
  if (player.isAlive()) and (player2.isAlive()) then
    if (math.abs(player.getLine() - enemy.l) + math.abs(player.getColumn() - enemy.c) < math.abs(player2.getLine() - enemy.l) + math.abs(player2.getColumn() - enemy.c)) then
      playerL = player.getLine()
      playerC = player.getColumn()

    elseif (math.abs(player.getLine() - enemy.l) + math.abs(player.getColumn() - enemy.c) > math.abs(player2.getLine() - enemy.l) + math.abs(player2.getColumn() - enemy.c)) and (player2.isAlive()) then
      playerL = player2.getLine()
      playerC = player2.getColumn()

    elseif (math.abs(player.getLine() - enemy.l) + math.abs(player.getColumn() - enemy.c) == math.abs(player2.getLine() - enemy.l) + math.abs(player2.getColumn() - enemy.c)) then
      local focus = love.math.random(1, 2)

      if (focus == 1) then
        playerL = player.getLine()
        playerC = player.getColumn()
      elseif (focus == 2) then
        playerL = player2.getLine()
        playerC = player2.getColumn()
      end
    end

  elseif (player.isAlive()) and (not player2.isAlive()) then
    playerL = player.getLine()
    playerC = player.getColumn()

  elseif (not player.isAlive()) and (player2.isAlive()) then
    playerL = player2.getLine()
    playerC = player2.getColumn()
  end
end

local function enemyAttack(enemy, playerL, playerC)
  if (playerL == player.getLine()) and (playerC == player.getColumn()) then
    player.setHp(player.getHp() - enemy.attack)
    hudFight.createFeedback(playerL, playerC, -enemy.attack, "")
    sound.getPlay("dmgCroco")
    enemy.soundAtk:play()
  else
    player2.setHp(player2.getHp() - enemy.attack)
    hudFight.createFeedback(playerL, playerC, -enemy.attack, "")
    sound.getPlay("dmgSnipe")
    enemy.soundAtk:play()
  end
  enemy.pa = 0
end

local function selectDir(enemy)
  local dist = {}

  if (grid.checkCase(enemy.l-1, enemy.c)) and (not collision.isCollidingEntity(enemy.l-1, enemy.c)) then
    dist.up = grid.getDist(enemy.l-1, enemy.c)
  end
  if (grid.checkCase(enemy.l+1, enemy.c)) and (not collision.isCollidingEntity(enemy.l+1, enemy.c)) then
    dist.down = grid.getDist(enemy.l+1, enemy.c)
  end
  if (grid.checkCase(enemy.l, enemy.c-1)) and (not collision.isCollidingEntity(enemy.l, enemy.c-1)) then
    dist.left = grid.getDist(enemy.l, enemy.c-1)
  end
  if (grid.checkCase(enemy.l, enemy.c+1)) and (not collision.isCollidingEntity(enemy.l, enemy.c+1)) then
    dist.right = grid.getDist(enemy.l, enemy.c+1)
  end


  if (dist.up == 0) or (dist.up == nil) then
    dist.up = 100
  end
  if (dist.down == 0) or (dist.down == nil) then
    dist.down = 100
  end
  if (dist.left == 0) or (dist.left == nil) then
    dist.left = 100
  end
  if (dist.right == 0) or (dist.right == nil) then
    dist.right = 100
  end

  actualDist = math.min(dist.up, dist.down, dist.left, dist.right)

  local availableDirections = {}

  if (actualDist == dist.up) then
    table.insert(availableDirections, {l = enemy.l-1, c = enemy.c})
  end
  if (actualDist == dist.down) then
    table.insert(availableDirections, {l = enemy.l+1, c = enemy.c})
  end
  if (actualDist == dist.left) then
    table.insert(availableDirections, {l = enemy.l, c = enemy.c-1})
  end
  if (actualDist == dist.right) then
    table.insert(availableDirections, {l = enemy.l, c = enemy.c+1})
  end

  local randomDirection = availableDirections[love.math.random(#availableDirections)]

  return randomDirection
end

local function genericCheck(entityL, entityC)
  if (grid.checkCase(entityL, entityC)) and (grid.isCheckDist(entityL, entityC)) then
    return true
  else
    return false
  end
end

local function enemyMove(enemy)
  local cell = {}
  
  move.floodFill(playerL, playerC, 100)

  cell.playerUp = genericCheck(playerL-1, playerC)
  cell.playerDown = genericCheck(playerL+1, playerC, cell.playerDown)
  cell.playerLeft = genericCheck(playerL, playerC-1, cell.playerLeft)
  cell.playerRight = genericCheck(playerL, playerC+1, cell.playerRight)

  cell.enemyUp = genericCheck(enemy.l-1, enemy.c, cell.enemyUp)
  cell.enemyDown = genericCheck(enemy.l+1, enemy.c, cell.enemyDown)
  cell.enemyLeft = genericCheck(enemy.l, enemy.c-1, cell.enemyLeft)
  cell.enemyRight = genericCheck(enemy.l, enemy.c+1, cell.enemyRight)

  if (cell.enemyUp) or (cell.enemyDown) or (cell.enemyLeft) or (cell.enemyRight) then
    if (cell.playerUp) or (cell.playerDown) or (cell.playerLeft) or (cell.playerRight) then
      local distL = math.abs(playerL - enemy.l)
      local distC = math.abs(playerC - enemy.c)
      local distMax = distL + distC

      if (enemy.pm > 0) and (distMax > 1) then
        local randomDirection = selectDir(enemy)
        local finalDist = actualDist-enemy.pm+2

        table.insert(pathfindingCells, {l = randomDirection.l, c = randomDirection.c})

        if (finalDist < 2) then
          finalDist = 2
        end

        for i = actualDist, finalDist, -1 do
          randomDirection = move.pathfinding(randomDirection.l, randomDirection.c, i)
          move.pathfinding(randomDirection.l, randomDirection.c, i)
          table.insert(pathfindingCells, {l = randomDirection.l, c = randomDirection.c})
        end
      end
    end
  end

  enemy.moving = true
  grid.resetWalkableCells()
end

local function enemyMoving(enemy, dt)
  if (enemy.moving) then
    local speed = 275

    for i = 1, #pathfindingCells do
      if (enemy.l-1 == pathfindingCells[i].l) and (enemy.c == pathfindingCells[i].c) then
        enemy.moveUp = true
      elseif (enemy.l+1 == pathfindingCells[i].l) and (enemy.c == pathfindingCells[i].c) then
        enemy.moveDown = true
      elseif (enemy.c-1 == pathfindingCells[i].c) and (enemy.l == pathfindingCells[i].l) then
        enemy.moveLeft = true
      elseif (enemy.c+1 == pathfindingCells[i].c) and (enemy.l == pathfindingCells[i].l) then
        enemy.moveRight = true
      end
    end

    if (enemy.moveUp) then
      if (enemy.y > grid.getY(enemy.l)-grid.getSize()) then
        enemy.y = enemy.y-speed*dt
        camera.focus(enemy)
      else
        enemy.moveUp = false
        enemy.l = enemy.l-1
        enemy.y = grid.getY(enemy.l)
        enemy.pm = enemy.pm-1
        table.remove(pathfindingCells, 1)
      end
    elseif (enemy.moveDown) then
      if (enemy.y < grid.getY(enemy.l)+grid.getSize()) then
        enemy.y = enemy.y+speed*dt
        camera.focus(enemy)
      else
        enemy.moveDown = false
        enemy.l = enemy.l+1
        enemy.y = grid.getY(enemy.l)
        enemy.pm = enemy.pm-1
        table.remove(pathfindingCells, 1)
      end
    elseif (enemy.moveLeft) then
      if (enemy.x > grid.getX(enemy.c)-grid.getSize()) then
        enemy.x = enemy.x-speed*dt
        camera.focus(enemy)
      else
        enemy.moveLeft = false
        enemy.c = enemy.c-1
        enemy.x = grid.getX(enemy.c)
        enemy.pm = enemy.pm-1
        table.remove(pathfindingCells, 1)
      end
    elseif (enemy.moveRight) then
      if (enemy.x < grid.getX(enemy.c)+grid.getSize()) then
        enemy.x = enemy.x+speed*dt
        camera.focus(enemy)
      else
        enemy.moveRight = false
        enemy.c = enemy.c+1
        enemy.x = grid.getX(enemy.c)
        enemy.pm = enemy.pm-1
        table.remove(pathfindingCells, 1)
      end
    else
      enemy.moving = false
    end
  end
end

local function checkAttack(enemy)
  local distL = math.abs(playerL - enemy.l)
  local distC = math.abs(playerC - enemy.c)
  local distMax = distL + distC

  if (distMax == 1) then
    enemyAttack(enemy, playerL, playerC)
    hudFight.createAttackEnemy(playerL, playerC)
  end
end

local function resetStats(enemy)
  enemy.pa = enemy.paMax
  enemy.pm = enemy.pmMax
end

local function enemyTurn(dt)
  if (turn) then
    for enemyId, enemy in ipairs(enemyList) do
      if (enemy.timerLaunch) then
        enemy.timer = enemy.timer + dt
        if (enemy.timer > enemy.timerMax) then
          focusPlayer(enemy)
          enemyMove(enemy)
          enemy.timer = 0
          enemy.timerLaunch = false
          enemy.timer2Launch = true
          camera.focus(enemy)
        end

      elseif (enemy.timer2Launch) then
        enemyMoving(enemy, dt)
        collision.createColEnemies(enemyList)
        if (not enemy.moving) then
          enemy.timer2 = enemy.timer2 + dt
        end
        if (enemy.timer2 > enemy.timer2Max) then
          checkAttack(enemy)
          enemy.timer2 = 0
          enemy.timer2Launch = false
          enemy.timer3Launch = true
        end

      elseif (enemy.timer3Launch) then
        enemy.timer3 = enemy.timer3 + dt
        if (enemy.timer3 > enemy.timer3Max) then
          enemy.timer3 = 0
          enemy.timer3Launch = false
          resetStats(enemy)
          if (enemyId < #enemyList) then
            enemyList[enemyId+1].timerLaunch = true
            camera.focus(enemyList[enemyId+1])
          else
            turn = false
            player.setTurn(true)
            camera.focusPlayer(player)
          end
        end
      end
    end
  end
end

local function updateAnim(dt)
  for enemyId, enemy in ipairs(enemyList) do
    if (enemy.moveUp) then
      enemy.currentAnimation = enemy.animations.up
    elseif (enemy.moveDown) then
      enemy.currentAnimation = enemy.animations.down
    elseif (enemy.moveLeft) then
      enemy.currentAnimation = enemy.animations.left
    elseif (enemy.moveRight) then
      enemy.currentAnimation = enemy.animations.right
    elseif (not enemy.moving) then
      enemy.currentAnimation = enemy.animations.idle
    end
    animation.update(enemy.currentAnimation, dt)
  end
end

local function checkVictory()
  if (#enemyList == 0) then
    state.setState("gameWin") 
    sound.getSound("soundPlay"):stop()
    sound.getSound("victory"):play()
  end
end

local function checkDeath()
  for enemyId, enemy in ipairs(enemyList) do
    if (enemy.hp <= 0) then
      enemy.soundDead:play()
      table.insert(enemyDie, table.remove(enemyList, enemyId))
      collision.createColEnemies(enemyList)
    end
  end
end

function class.update(dt)
  if (turn) then
    enemyTurn(dt)
  end
  updateAnim(dt)
  checkVictory()
  checkDeath()
end

local function drawPathfinding()
  for i = 1, #pathfindingCells do
    local x = grid.getX(pathfindingCells[i].c)
    local y = grid.getY(pathfindingCells[i].l)

    love.graphics.setColor(0, 1, 0, 0.3)
    love.graphics.rectangle("fill", x, y, grid.getSize() - 1, grid.getSize() - 1)
  end
end

function class.draw(list)
  drawPathfinding()
  for enemyId, enemy in ipairs(list) do
    love.graphics.setColor(1, 1, 1)
    animation.draw(enemy.currentAnimation, enemy.x, enemy.y, 0, enemy.h)
  end
end

return class