local screen = require("screen")
local images = require("images")
local state = require("state")
local animation = require("animation")

local data = {}
local arrowList = {}
local class = {}

function class.canMove()
  return data.canMove
end

function class.setMove(value)
  data.move = value
end

function class.canCamera()
  return data.canCamera
end

function class.setCamera(value)
  data.camera = value
end

function class.canSkill()
  return data.canSkill
end

function class.setSkill(value)
  data.skill = value
end

function class.canPass()
  return data.canPass
end

function class.setPass(value)
  data.pass = value
end

function class.canHit()
  return data.canHit
end

function class.setHit(value)
  data.hit = value
end

local function createArrow(type, x, y)
  local arrow = {}

  arrow.sprite = images.getImage("arrowSheetTuto")
  arrow.x = x
  arrow.y = y
  arrow.w = 64
  arrow.h = 64

  arrow.animation = {}
  arrow.animation.up = animation.new(arrow.sprite, 10, 15, 0, 0, arrow.w, arrow.h)
  arrow.animation.down = animation.new(arrow.sprite, 10, 15, 0, arrow.h*3, arrow.w, arrow.h)
  arrow.animation.left  = animation.new(arrow.sprite, 10, 15, 0, arrow.h*2, arrow.w, arrow.h)
  arrow.animation.right  = animation.new(arrow.sprite, 10, 15, 0, arrow.h, arrow.w, arrow.h)

  if (type == "up") then
    arrow.currentAnimation = arrow.animation.up
  elseif (type == "down") then
    arrow.currentAnimation = arrow.animation.down
  elseif (type == "left") then
    arrow.currentAnimation = arrow.animation.left
  elseif (type == "right") then
    arrow.currentAnimation = arrow.animation.right
  end
  table.insert(arrowList, arrow)
end

function class.load()
  arrowList = {}

  data.canMove = true
  data.move = false

  data.canCamera = false
  data.camera = false

  data.canSkill = false
  data.skill = false

  data.canPass = false
  data.pass = false

  data.canHit = false
  data.hit = false
end

local function updateArrowAnim(dt)
  for arrowId, arrow in ipairs(arrowList) do
    animation.update(arrow.currentAnimation, dt)
  end
end

function class.update(dt)
  if (data.move) then
    data.canCamera = true
    data.canMove = false
    data.move = false
    createArrow("up", screen.getWidth()/2 -32 , 32)
    createArrow("down", screen.getWidth()/2, screen.getHeight()-32)
    createArrow("left", 0, screen.getHeight()/2)
    createArrow("right", screen.getWidth()-64, screen.getHeight()/2)
  elseif (data.camera) then
    arrowList = {}
    data.canSkill = true
    data.canCamera = false
    data.camera = false
    createArrow("down", 1268, 920)
  elseif (data.skill) then
    arrowList = {}
    data.canPass = true
    data.canSkill = false
    data.skill = false
    createArrow("down", 610, 920)
  elseif (data.pass) then
    arrowList = {}
    data.canHit = true
    data.canPass = false
    data.pass = false
  elseif (data.hit) then
    data.canWin = true
    data.canHit = false
    data.hit = false
  end
  updateArrowAnim(dt)
end

local function drawArrow()
  for arrowId, arrow in ipairs(arrowList) do
    love.graphics.setColor(1, 1, 1)
    animation.draw(arrow.currentAnimation, arrow.x, arrow.y, 0, arrow.h)
  end
end

function class.draw()
  if (data.canMove) then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(images.getImage("tutoMove"), screen.getWidth()-512, screen.getHeight()-640)
    love.graphics.setFont(images.getFont20())
    love.graphics.print("1/6", screen.getWidth()-80, screen.getHeight()-50)
  elseif (data.canCamera) then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(images.getImage("tutoCamera"), screen.getWidth()-512, screen.getHeight()-640)
    love.graphics.setFont(images.getFont20())
    love.graphics.print("2/6", screen.getWidth()-80, screen.getHeight()-50)
  elseif (data.canSkill) then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(images.getImage("tutoSkill"), screen.getWidth()-512, screen.getHeight()-640)
    love.graphics.setFont(images.getFont20())
    love.graphics.print("3/6", screen.getWidth()-80, screen.getHeight()-50)
  elseif (data.canPass) then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(images.getImage("tutoPass"), screen.getWidth()-512, screen.getHeight()-640)
    love.graphics.setFont(images.getFont20())
    love.graphics.print("4/6", screen.getWidth()-80, screen.getHeight()-50)
  elseif (data.canHit) then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(images.getImage("tutoHit"), screen.getWidth()-512, screen.getHeight()-640)
    love.graphics.setFont(images.getFont20())
    love.graphics.print("5/6", screen.getWidth()-80, screen.getHeight()-50)
  elseif (data.canWin) then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(images.getImage("tutoWin"), screen.getWidth()-512, screen.getHeight()-640)
    love.graphics.setFont(images.getFont20())
    love.graphics.print("6/6", screen.getWidth()-80, screen.getHeight()-50)
  end
  drawArrow()
end

return class