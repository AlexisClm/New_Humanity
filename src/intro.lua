local screen = require("screen")
local images = require("images")
local state = require("state")

local class = {}
local data = {}

function class.load()
  data.img = images.getImage("creajeuxIntro")
  data.x = screen.getWidth()/2
  data.y = screen.getHeight()/2

  data.timer = 0
  data.timerState = false
  data.timerMax = 2

  data.state = true
  data.alpha = 0
end

function class.update(dt)
  data.alpha = data.timer/data.timerMax
  data.w = data.img:getWidth()
  data.h = data.img:getHeight()

  if (data.state) then
    if (not data.timerState) then
      data.timer = data.timer + dt
      if (data.timer > data.timerMax) then
        data.timerState = true
      end
    else
      data.timer = data.timer - dt
      if (data.timer < 0) then
        data.timerState = false
        data.state = false
      end
    end

  else
    data.img = images.getImage("lineUpIntro")

    if (not data.timerState) then
      data.timer = data.timer + dt
      if (data.timer > data.timerMax) then
        data.timerState = true
      end
    else
      data.timer = data.timer - dt
      if (data.timer < 0) then
        state.setState("menu")
      end
    end
  end
end

function class.draw()
  love.graphics.setColor(1, 1, 1, data.alpha)
  love.graphics.draw(data.img, data.x, data.y, 0, 1, 1, data.w/2, data.h/2)
end

function class.keypressed(key)
  if (data.state) then
    data.timer = 0
    data.timerState = false
    data.state = false
  else
    state.setState("menu")
  end
end

return class