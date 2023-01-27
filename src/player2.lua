local grid = require("grid")
local images = require("images")
local camera = require("camera")
local animation = require("animation")

local class = {}
local data = {}

function class.setX(value)
  data.x = value
end

function class.getX()
  return data.x
end

function class.setY(value)
  data.y = value
end

function class.getY()
  return data.y
end

function class.getW()
  return data.w
end

function class.getH()
  return data.h
end

function class.getLine()
  return data.l
end

function class.setLine(value)
  data.l = value
end

function class.getColumn()
  return data.c
end

function class.setColumn(value)
  data.c = value
end

function class.getActionMode()
  return data.actionMode
end

function class.setActionMode(value)
  data.actionMode = value
end

function class.isWalkMode()
  return data.walkMode
end

function class.setWalkMode(value)
  data.walkMode = value
end

function class.isMoving()
  return data.moving
end

function class.setMoving(value)
  data.moving = value
end

function class.isMovingUp()
  return data.moveUp
end

function class.setMovingUp(value)
  data.moveUp = value
end

function class.isMovingDown()
  return data.moveDown
end

function class.setMovingDown(value)
  data.moveDown = value
end

function class.isMovingLeft()
  return data.moveLeft
end

function class.setMovingLeft(value)
  data.moveLeft = value
end

function class.isMovingRight()
  return data.moveRight
end

function class.setMovingRight(value)
  data.moveRight = value
end

function class.setPm(value)
  data.pm = value
end

function class.getPm()
  return data.pm
end

function class.setPa(value)
  data.pa = value
end

function class.getPa()
  return data.pa
end

function class.getPaMax()
  return data.paMax
end

function class.getPmMax()
  return data.pmMax
end

function class.setHp(value)
  data.hp = value
end

function class.getHp()
  return data.hp
end

function class.getHpMax()
  return data.hpMax
end

function class.setTurn(value)
  data.turn = value
end

function class.isTurn()
  return data.turn
end

function class.isAlive()
  return data.alive
end

local function initPlayer(list)
  data.l = 14
  data.c = 15

  data.sprite = images.getImage("player2Sheet")
  data.w = 128
  data.h = 256
  data.x = grid.getX(data.c)
  data.y = grid.getY(data.l)

  data.hpMax = 20
  data.hp = data.hpMax

  data.paMax = 9
  data.pa = data.paMax
  data.pmMax = 4
  data.pm = data.pmMax

  data.actionMode = false
  data.walkMode = false
  data.moving = false

  data.moveUp = false
  data.moveDown = false
  data.moveLeft = false
  data.moveRight = false

  data.alive = true
  data.turn = false

  data.animations = {}
  data.animations.up    = animation.new(data.sprite, 4, 4, 0, 0, data.w, data.h)
  data.animations.down  = animation.new(data.sprite, 4, 4, 0, data.h, data.w, data.h)
  data.animations.left  = animation.new(data.sprite, 4, 4, 0, data.h*2, data.w, data.h)
  data.animations.right = animation.new(data.sprite, 4, 4, 0, data.h*3, data.w, data.h)
  data.animations.idle  = animation.new(data.sprite, 2, 2, 0, data.h*4, data.w, data.h)

  data.currentAnimation = data.animations.down

  table.insert(list, data)
end

function class.load(list)
  initPlayer(list)
end

local function updatePlayerAnim(dt)
  if (data.moveUp) then
    data.currentAnimation = data.animations.up
  elseif (data.moveDown) then
    data.currentAnimation = data.animations.down
  elseif (data.moveLeft) then
    data.currentAnimation = data.animations.left
  elseif (data.moveRight) then
    data.currentAnimation = data.animations.right
  elseif (not data.moving) then
    data.currentAnimation = data.animations.idle
  end
  animation.update(data.currentAnimation, dt)
end

function class.update(dt)
  camera.moveCamera(data)
  if (data.alive) then
    updatePlayerAnim(dt)
  end
end

return class