local screen = require ("screen")
local images = require ("images")
local state = require ("state")
local sound = require ("sounds")

local class = {}
local menuQuit = {}
local yes = {}
local no = {}

function class.setMenuQuitOn(value)
  menuQuit.on = value
end

function class.getMenuQuitOn()
  return menuQuit.on
end

local function selection(obj)
  return (love.mouse.getX() < obj.x + obj.w) and (love.mouse.getX() > obj.x) and (love.mouse.getY() > obj.y) and (love.mouse.getY() < obj.y + obj.h)
end

local function collision(a, x, y)
  return (x < a.x + a.w) and (x > a.x) and (y > a.y) and (y < a.y + a.h)
end

function class.load()
  menuQuit.on = false
  menuQuit.img = images.getImage("cadreMenuQuit")
  menuQuit.x = (screen.getWidth() - menuQuit.img:getWidth())/2
  menuQuit.y = (screen.getHeight() - menuQuit.img:getHeight())/2

  yes.unselectedImage = images.getImage("yes")
  yes.selectedImage = images.getImage("yesOn")
  yes.image = yes.unselectedImage
  yes.x = menuQuit.x + 390
  yes.y = menuQuit.y + 260
  yes.w = yes.image:getWidth()
  yes.h = yes.image:getHeight()
  yes.isSelection = false

  no.unselectedImage = images.getImage("no")
  no.selectedImage = images.getImage("noOn")
  no.image = no.unselectedImage
  no.x = menuQuit.x + 50
  no.y = menuQuit.y + 260
  no.w = no.image:getWidth()
  no.h = no.image:getHeight()
  no.isSelection = false
end

local function changeImage(obj)
  if(selection(obj)) then
    obj.image = obj.selectedImage
    obj.isSelected = true
  else
    obj.image = obj.unselectedImage
    obj.isSelected = false
  end
end

function class.update()
  changeImage(yes)
  changeImage(no)
end

function class.draw()
  if (menuQuit.on) then
    if (state.getState() == "tutorial") or (state.getState() == "skirmish")then
      love.graphics.setColor(0, 0, 0, 0.5)
      love.graphics.rectangle("fill", 0, 0, screen.getWidth(), screen.getHeight())
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(menuQuit.img, menuQuit.x, menuQuit.y)
      love.graphics.draw(yes.image, yes.x, yes.y)
      love.graphics.draw(no.image, no.x, no.y)
      love.graphics.setFont(images.getFont30())
      love.graphics.printf("ÊTES-VOUS SÛR DE VOULOIR", menuQuit.x, menuQuit.y + 80, menuQuit.img:getWidth(), "center")
      love.graphics.printf("RETOURNER AU MENU ?", menuQuit.x, menuQuit.y + 130, menuQuit.img:getWidth(), "center")
    else
      love.graphics.setColor(0, 0, 0, 0.5)
      love.graphics.rectangle("fill", 0, 0, screen.getWidth(), screen.getHeight())
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(menuQuit.img, menuQuit.x, menuQuit.y)
      love.graphics.draw(yes.image, yes.x, yes.y)
      love.graphics.draw(no.image, no.x, no.y)
      love.graphics.setFont(images.getFont30())
      love.graphics.printf("ÊTES-VOUS SÛR DE VOULOIR", menuQuit.x, menuQuit.y + 80, menuQuit.img:getWidth(), "center")
      love.graphics.printf("QUITTER ?", menuQuit.x, menuQuit.y + 130, menuQuit.img:getWidth(), "center")
    end
  end
end

function class.mousepressed(x, y, button)
  if (menuQuit.on) then
    if (state.getState() == "tutorial") or (state.getState() == "skirmish")then
      if (button == 1) then
        if (collision(yes, x, y)) then
          state.setState("menu")
          menuQuit.on = false
          sound.getPlay("reverse")
        elseif(collision(no, x, y)) then
          menuQuit.on = false
          sound.getPlay("reverse")
        end
      end
    else
      if (collision(yes, x, y)) then
        love.event.quit()
      elseif(collision(no, x, y)) then
        menuQuit.on = false
        sound.getPlay("reverse")
      end
    end
  end
end

function class.keypressed(key)
  if (key == 'escape') then
    if (not menuQuit.on) then
      menuQuit.on = true
      sound.getPlay("click")
    elseif (menuQuit) then
      menuQuit.on = false
      sound.getPlay("reverse")
    end
  end
end

return class