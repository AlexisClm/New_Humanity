local screen = require("screen")
local player = require("player")
local player2 = require("player2")
local images = require("images")
local enemy = require("enemy")
local editingSkill = require("editingSkill")
local skills = require("skills")
local gridBar = require("gridBar")
local state = require("state")
local grid = require("grid")
local playerList = require("playerList")
local turn = require("turn")
local script = require("script")
local sound = require("sounds")
local animation = require("animation")
local animationUpDown = require("animationUpDown")
local menuQuit = require("menuQuit")
local options = require("options")

local listE
local listP
local listCh
local listCadre = {}
local listD

local data = {}
local hitboxes = {}
local drawingCS
local drawingCD
local drawingCZ
local drawingS
local drawingTS
local drawingTD
local drawingTDP
local drawingA
local drawingCSB
local drawingCDB
local drawingCZB
local drawingSB
local drawingTSB
local drawingTDB
local drawingTDPB
local drawingAB
local drawingV1
local drawingV2

local x
local y

local class = {}

function class.getLeaveHitbox()
  local hitbox = {}
  hitbox.x = 1800
  hitbox.y = 70
  hitbox.r = data.leaveRadius
  return hitbox
end

function class.getOptionHitbox()
  local hitbox = {}
  hitbox.x = 1750
  hitbox.y = 70
  hitbox.r = data.optionRadius
  return hitbox
end

function class.getGridHitbox()
  local hitbox = {}
  hitbox.x = data.gridX
  hitbox.y = data.gridY
  hitbox.r = data.gridRadius
  return hitbox
end

function class.getSkillsHitbox()
  local hitbox = {}
  hitbox.x = data.skillsX
  hitbox.y = data.skillsY
  hitbox.r = data.skillsRadius
  return hitbox
end

function class.getPassHitbox()
  local hitbox = {}
  hitbox.x = data.passX
  hitbox.y = data.passY
  hitbox.r = data.passRadius
  return hitbox
end

local function createCadre()
  for i = 1, listCh do
    local cadre = {}
    cadre.width = 100
    cadre.height = 100
    cadre.x = 30
    cadre.y = 105 * i
    cadre.value = 0 + i
    table.insert(listCadre, cadre)
  end
end

function class.load()
  listE = enemy.getEnemyList()
  listP = playerList.getPlayerList()
  listCh = #listP + #listE

  data.playerSkillImg = images.getImage("hudPlayerSkill")
  data.playerSkillWidth = data.playerSkillImg:getWidth()
  data.playerSkillHeight = data.playerSkillImg:getHeight()

  data.statImg = images.getImage("hudStats")
  data.statWidth = data.statImg:getWidth()
  data.statHeight = data.statImg:getHeight()

  data.optionImg = images.getImage("option")
  data.optionWidth = data.optionImg:getWidth()
  data.optionHeight = data.optionImg:getHeight()
  data.optionX = 1750
  data.optionY = 70
  data.optionRadius = math.min(data.optionWidth, data.optionHeight)/2

  data.leaveImg = images.getImage("leaveIG")
  data.leaveWidth = data.leaveImg:getWidth()
  data.leaveHeight = data.leaveImg:getHeight()
  data.leaveX = 1800
  data.leaveY = 70
  data.leaveRadius = math.min(data.leaveWidth, data.leaveHeight)/2

  data.gridImg = images.getImage("showGrid")
  data.gridWidth = data.gridImg:getWidth()
  data.gridHeight = data.gridImg:getHeight()
  data.gridX = 1700
  data.gridY = 70
  data.gridRadius = math.min(data.gridWidth, data.gridHeight)/2

  data.skillsImg = images.getImage("iconSkills")
  data.skillsWidth = data.skillsImg:getWidth()
  data.skillsHeight = data.skillsImg:getHeight()
  data.skillsX = 1300
  data.skillsY = screen.getHeight()-75
  data.skillsRadius = math.min(data.skillsWidth, data.skillsHeight)/2

  data.passImg = images.getImage("iconPass")
  data.passWidth = data.passImg:getWidth()
  data.passHeight = data.passImg:getHeight()
  data.passX = 640
  data.passY = screen.getHeight()-70
  data.passRadius = math.min(data.passWidth, data.passHeight)/2

  drawingCS = false
  drawingCD = false
  drawingCZ = false
  drawingS = false
  drawingTS = false
  drawingTD = false
  drawingTDP = false
  drawingA = false 
  drawingV1 = false
  drawingV2 = false

  drawingCSB = false
  drawingCDB = false
  drawingCZB = false
  drawingSB = false
  drawingTSB = false
  drawingTDB = false
  drawingTDPB = false
  drawingAB = false

  data.cadreAllie1Img = images.getImage("cadrePlayer1")
  data.cadreAllie1Width = data.cadreAllie1Img:getWidth()
  data.cadreAllie1Height = data.cadreAllie1Img:getHeight()
  data.cadreAllie1X = 30
  data.cadreAllie1Y = 105

  data.cadreAllie2Img = images.getImage("cadrePlayer2")
  data.cadreAllie2Width = data.cadreAllie2Img:getWidth()
  data.cadreAllie2Height = data.cadreAllie2Img:getHeight()
  data.cadreAllie2X = 30
  data.cadreAllie2Y = 210

  data.cadreBossImg = images.getImage("cadreBoss")
  data.cadreBossWidth = data.cadreBossImg:getWidth()
  data.cadreBossHeight = data.cadreBossImg:getHeight()
  data.cadreBossX = 30
  data.cadreBossY = 315

  data.cadreEnemy5Img = images.getImage("cadreEnemy5")
  data.cadreEnemy5Width = data.cadreEnemy5Img:getWidth()
  data.cadreEnemy5Height = data.cadreEnemy5Img:getHeight()
  data.cadreEnemy5X = 30
  data.cadreEnemy5Y = 420

  data.cadreEnemy4Img = images.getImage("cadreEnemy4")
  data.cadreEnemy4Width = data.cadreEnemy4Img:getWidth()
  data.cadreEnemy4Height = data.cadreEnemy4Img:getHeight()
  data.cadreEnemy4X = 30
  data.cadreEnemy4Y = 525

  data.cadreEnemy3Img = images.getImage("cadreEnemy3")
  data.cadreEnemy3Width = data.cadreEnemy3Img:getWidth()
  data.cadreEnemy3Height = data.cadreEnemy3Img:getHeight()
  data.cadreEnemy3X = 30
  data.cadreEnemy3Y = 630

  data.cadreEnemy2Img = images.getImage("cadreEnemy2")
  data.cadreEnemy2Width = data.cadreEnemy2Img:getWidth()
  data.cadreEnemy2Height = data.cadreEnemy2Img:getHeight()
  data.cadreEnemy2X = 30
  data.cadreEnemy2Y = 735

  data.cadreEnemy1Img = images.getImage("cadreEnemy1")
  data.cadreEnemy1Width = data.cadreEnemy1Img:getWidth()
  data.cadreEnemy1Height = data.cadreEnemy1Img:getHeight()
  data.cadreEnemy1X = 30
  data.cadreEnemy1Y = 840

  data.cadreArrow = images.getImage("cadreArrow")
  data.cadreArrowW = data.cadreArrow:getWidth()
  data.cadreArrowH = data.cadreArrow:getHeight()
  data.cadreArrowX = -40
  data.cadreArrowY = 105

  data.cadreCroixImg = images.getImage("cadreCroix")
  data.cadreCroixWidth = data.cadreCroixImg:getWidth()
  data.cadreCroixHeight = data.cadreCroixImg:getHeight()

  data.animations = {}

  data.allieTurn = images.getImage("turnAllies")
  data.allieTurnWidth = data.allieTurn:getWidth()
  data.allieTurnHeight = data.allieTurn:getHeight()
  data.animations.startP = animationUpDown.new(data.allieTurn, 14, 12, 0, 0, data.allieTurnWidth, data.allieTurnHeight/14)
--  data.animations.idleP = animationUpDown.new(data.allieTurn, 1, 0, 0, 0, data.allieTurnWidth, data.allieTurnHeight/14)
  data.allieTurnX = 750
  data.allieTurnY = 125
  data.allieTurnIsVisible = false
  data.allieTimer = 0
  data.allieTimerIdle = 2
  data.allieTimerMax = 4
  data.allieOpa = 2

  data.enemyTurnSprite = images.getImage("turnEnemy")
  data.enemyTurnWidth = data.enemyTurnSprite:getWidth()
  data.enemyTurnHeight = data.enemyTurnSprite:getHeight()
  data.animations.startE = animationUpDown.new(data.enemyTurnSprite, 14, 12, 0, 0, data.enemyTurnWidth, data.enemyTurnHeight/14)
--  data.animations.idleE = animationUpDown.new(data.enemyTurnSprite, 1, 0, 0, 0, data.enemyTurnWidth, data.enemyTurnHeight/14)
  data.enemyTurnX = 750
  data.enemyTurnY = 125
  data.enemyTurnIsVisible = false
  data.enemyTimer = 0
  data.enemyTimerIdle = 2
  data.enemyTimerMax = 4
  data.enemyOpa = 2

  data.currentAnimation = data.animations.startP
end

local function updateAnim(dt)
  if (enemy.isTurn()) then
    data.allieTimer = 0
    data.enemyTurnIsVisible = true
    data.currentAnimation = data.animations.startE
    data.enemyTimer = data.enemyTimer + dt
    if (data.enemyTimer >= data.enemyTimerIdle) then
--      data.currentAnimation = data.animations.idleE
      data.enemyOpa = data.enemyOpa - dt
    end
    if (data.enemyTimer >= data.enemyTimerMax) then
      data.enemyTurnIsVisible = false
      data.enemyOpa = 2
    end
  end
  if (player.isTurn()) or (player2.isTurn()) then
    data.enemyTimer = 0
    data.allieTurnIsVisible = true
    data.currentAnimation = data.animations.startP
    data.allieTimer = data.allieTimer + dt
    if (data.allieTimer >= data.allieTimerIdle) then
--      data.currentAnimation = data.animations.idleP
      data.allieOpa = data.allieOpa - dt
    end
    if (data.allieTimer >= data.allieTimerMax) then
      data.allieTurnIsVisible = false
      data.allieOpa = 2
    end
  end
  animationUpDown.update(data.currentAnimation, dt)
end

local function updateArrow(dt)
  if (player.isTurn()) then
    data.cadreArrowY = data.cadreAllie1Y
  elseif (player2.isTurn()) then
    data.cadreArrowY = data.cadreAllie2Y
  end

  for enemyId, enemys in ipairs(listE) do
    if (enemys.timerLaunch) then
      if (enemys.type == "boss") then
        data.cadreArrowY = data.cadreBossY
      elseif (enemys.type == "enemy5") then
        data.cadreArrowY = data.cadreEnemy5Y
      elseif (enemys.type == "enemy4") then
        data.cadreArrowY = data.cadreEnemy4Y
      elseif (enemys.type == "enemy3") then
        data.cadreArrowY = data.cadreEnemy3Y
      elseif (enemys.type == "enemy2") then
        data.cadreArrowY = data.cadreEnemy2Y
      elseif (enemys.type == "enemy1") then
        data.cadreArrowY = data.cadreEnemy1Y
      elseif (enemys.type == "tuto") then
        data.cadreArrowY = 210
      end
    end
  end
end

local function checkDeath()
  listD = enemy.getEnemyDieList()
  for enemyDieId, enemyDie in ipairs(listD) do
    if (enemyDie.type == "boss") then
      love.graphics.setColor(0, 0, 0, 0.5)
      love.graphics.rectangle("fill", data.cadreBossX, data.cadreBossY, data.cadreBossWidth, data.cadreBossHeight)
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(data.cadreCroixImg, data.cadreBossX, data.cadreBossY)
    end
    if (enemyDie.type == "enemy5") then
      love.graphics.setColor(0, 0, 0, 0.5)
      love.graphics.rectangle("fill", data.cadreEnemy5X, data.cadreEnemy5Y, data.cadreEnemy5Width, data.cadreEnemy5Height)
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(data.cadreCroixImg, data.cadreEnemy5X, data.cadreEnemy5Y)
    end
    if (enemyDie.type == "enemy4") then
      love.graphics.setColor(0, 0, 0, 0.5)
      love.graphics.rectangle("fill", data.cadreEnemy4X, data.cadreEnemy4Y, data.cadreEnemy4Width, data.cadreEnemy4Height)
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(data.cadreCroixImg, data.cadreEnemy4X, data.cadreEnemy4Y)
    end
    if (enemyDie.type == "enemy3") then
      love.graphics.setColor(0, 0, 0, 0.5)
      love.graphics.rectangle("fill", data.cadreEnemy3X, data.cadreEnemy3Y, data.cadreEnemy3Width, data.cadreEnemy3Height)
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(data.cadreCroixImg, data.cadreEnemy3X, data.cadreEnemy3Y)
    end
    if (enemyDie.type == "enemy2") then
      love.graphics.setColor(0, 0, 0, 0.5)
      love.graphics.rectangle("fill", data.cadreEnemy2X, data.cadreEnemy2Y, data.cadreEnemy2Width, data.cadreEnemy2Height)
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(data.cadreCroixImg, data.cadreEnemy2X, data.cadreEnemy2Y)
    end
    if (enemyDie.type == "enemy1") then
      love.graphics.setColor(0, 0, 0, 0.5)
      love.graphics.rectangle("fill", data.cadreEnemy1X, data.cadreEnemy1Y, data.cadreEnemy1Width, data.cadreEnemy1Height)
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(data.cadreCroixImg, data.cadreEnemy1X, data.cadreEnemy1Y)
    end
  end
  if (player.getHp() <= 0) then
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", data.cadreAllie1X, data.cadreAllie1Y, data.cadreAllie1Width, data.cadreAllie1Height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(data.cadreCroixImg, data.cadreAllie1X, data.cadreAllie1Y)
  end
  if (state.getState() == "skirmish") then
    if (player2.getHp() <= 0) then
      love.graphics.setColor(0, 0, 0, 0.5)
      love.graphics.rectangle("fill", data.cadreAllie2X, data.cadreAllie2Y, data.cadreAllie2Width, data.cadreAllie2Height)
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(data.cadreCroixImg, data.cadreAllie2X, data.cadreAllie2Y)
    end
  end
end

local function drawCadrePersoTuto()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(data.cadreAllie1Img, data.cadreAllie1X, data.cadreAllie1Y)
  love.graphics.draw(data.cadreEnemy1Img, data.cadreEnemy1X, 210)

  love.graphics.draw(data.cadreArrow, data.cadreArrowX, data.cadreArrowY)
end

local function drawCadrePerso()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(data.cadreAllie1Img, data.cadreAllie1X, data.cadreAllie1Y)
  love.graphics.draw(data.cadreAllie2Img, data.cadreAllie2X, data.cadreAllie2Y)
  love.graphics.draw(data.cadreEnemy1Img, data.cadreEnemy1X, data.cadreEnemy1Y)
  love.graphics.draw(data.cadreEnemy2Img, data.cadreEnemy2X, data.cadreEnemy2Y)
  love.graphics.draw(data.cadreEnemy3Img, data.cadreEnemy3X, data.cadreEnemy3Y)
  love.graphics.draw(data.cadreEnemy4Img, data.cadreEnemy4X, data.cadreEnemy4Y)
  love.graphics.draw(data.cadreEnemy5Img, data.cadreEnemy5X, data.cadreEnemy5Y)
  love.graphics.draw(data.cadreBossImg, data.cadreBossX, data.cadreBossY)

  love.graphics.draw(data.cadreArrow, data.cadreArrowX, data.cadreArrowY)
end

local function drawHUDSkill()
  love.graphics.setColor(1, 1, 1, 0.5)
  love.graphics.draw(data.playerSkillImg, 700, 950)
  love.graphics.draw(data.playerSkillImg, 701 + data.playerSkillWidth, 950)
  love.graphics.draw(data.playerSkillImg, 701 + (data.playerSkillWidth*2), 950)
  love.graphics.draw(data.playerSkillImg, 701 + (data.playerSkillWidth*3), 950)
  love.graphics.draw(data.playerSkillImg, 701 + (data.playerSkillWidth*4), 950)
end

local function drawHUDSkillDescriptionCS()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(images.getFont20())
  love.graphics.printf("Coup Simple", editingSkill.getMenuX(), 410, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont15())
  love.graphics.print("Coût en PA : 3", 800, 450)
  love.graphics.print("Portée : 2 cases", 800, 470)
  love.graphics.print("Type : Attaque de mêlée", 800, 490)
  love.graphics.print("Nombre de cibles : Cible unique", 800, 510)
  love.graphics.print("Zone de ciblage : Cercle", 800, 530)
  love.graphics.print("Effet : Inflige 4 points de dégâts", 800, 550)
  love.graphics.printf("Vous effectuez une frappe", editingSkill.getMenuX(), 580, editingSkill.getMenuW(), "center")
  love.graphics.printf("simple sur la cible.", editingSkill.getMenuX(), 600, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont10())
end

local function drawHUDSkillDescriptionCD()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(images.getFont20())
  love.graphics.printf("Coup Double", editingSkill.getMenuX(), 410, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont15())
  love.graphics.print("Coût en PA : 6", 800, 450)
  love.graphics.print("Portée : 1 case", 800, 470)
  love.graphics.print("Type : Attaque de mêlée", 800, 490)
  love.graphics.print("Nombre de cibles : Cible unique", 800, 510)
  love.graphics.print("Zone de ciblage : Cercle", 800, 530)
  love.graphics.print("Effet : Inflige 10 points de dégâts", 800, 550)
  love.graphics.printf("Vous frappez 2 fois la cible.", editingSkill.getMenuX(), 580, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont10())
end

local function drawHUDSkillDescriptionCZ()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(images.getFont20())
  love.graphics.printf("Frappe Lourde", editingSkill.getMenuX(), 410, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont15())
  love.graphics.print("Coût en PA : 9", 800, 450)
  love.graphics.print("Portée : 2 cases", 800, 470)
  love.graphics.print("Type : Attaque de mêlée", 800, 490)
  love.graphics.print("Nombre de cibles : Cible multiples", 800, 510)
  love.graphics.print("Zone de ciblage : Cercle", 800, 530)
  love.graphics.print("Effet : Inflige 8 points de dégâts", 800, 550)
  love.graphics.printf("Vous frappez la cible et ses", editingSkill.getMenuX(), 580, editingSkill.getMenuW(), "center")
  love.graphics.printf("allies aux alentours.", editingSkill.getMenuX(), 600, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont10())
end

local function drawHUDSkillDescriptionS()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(images.getFont20())
  love.graphics.printf("Soin", editingSkill.getMenuX(), 410, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont15())
  love.graphics.print("Coût en PA : 6", 800, 450)
  love.graphics.print("Portée : 2 cases", 800, 470)
  love.graphics.print("Type : Compétence de soutien", 800, 490)
  love.graphics.print("Nombre de cibles : Cible unique", 800, 510)
  love.graphics.print("Zone de ciblage : Cercle", 800, 530)
  love.graphics.print("Effet : Rend 10 points de vie", 800, 550)  
  love.graphics.printf("Vous soignez les blessures de", editingSkill.getMenuX(), 580, editingSkill.getMenuW(), "center")
  love.graphics.printf("votre cible.", editingSkill.getMenuX(), 600, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont10())
end

local function drawHUDSkillDescriptionTS()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(images.getFont20())
  love.graphics.printf("Tir simple", editingSkill.getMenuX(), 410, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont15())
  love.graphics.print("Coût en PA : 3", 800, 450)
  love.graphics.print("Portée : 7 cases", 800, 470)
  love.graphics.print("Type : Attaque à distance", 800, 490)
  love.graphics.print("Nombre de cibles : Cible unique", 800, 510)
  love.graphics.print("Zone de ciblage : Cercle", 800, 530)
  love.graphics.print("Effet : Inflige 5 points de dégâts", 800, 550)
  love.graphics.printf("Vous faites feu en direction de", editingSkill.getMenuX(), 580, editingSkill.getMenuW(), "center")
  love.graphics.printf("votre cible.", editingSkill.getMenuX(), 600, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont10())
end

local function drawHUDSkillDescriptionTD()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(images.getFont20())
  love.graphics.printf("Tir double", editingSkill.getMenuX(), 410, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont15())
  love.graphics.print("Coût en PA : 6", 800, 450)
  love.graphics.print("Portée : 5 cases", 800, 470)
  love.graphics.print("Type : Attaque à distance", 800, 490)
  love.graphics.print("Nombre de cibles : Cible unique", 800, 510)
  love.graphics.print("Zone de ciblage : Cercle", 800, 530)
  love.graphics.print("Effet : Inflige 13 points de dégâts", 800, 550)
  love.graphics.printf("Vous êtes assez rapide pour", editingSkill.getMenuX(), 580, editingSkill.getMenuW(), "center")
  love.graphics.printf("effectuer un double tir.", editingSkill.getMenuX(), 600, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont10())
end

local function drawHUDSkillDescriptionTDP()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(images.getFont20())
  love.graphics.printf("Tir de Précision", editingSkill.getMenuX(), 410, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont15())
  love.graphics.print("Coût en PA : 9", 800, 450)
  love.graphics.print("Portée : 7 cases", 800, 470)
  love.graphics.print("Type : Attaque à distance", 800, 490)
  love.graphics.print("Nombre de cibles : Cible unique", 800, 510)
  love.graphics.print("Zone de ciblage : Ligne", 800, 530)
  love.graphics.print("Effet : Inflige 20 points de dégâts", 800, 550)
  love.graphics.printf("Vous effectuez un tir de", editingSkill.getMenuX(), 580, editingSkill.getMenuW(), "center")
  love.graphics.printf("précision.", editingSkill.getMenuX(), 600, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont10())
end

local function drawHUDSkillDescriptionA()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(images.getFont20())
  love.graphics.printf("Accélération", editingSkill.getMenuX(), 410, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont15())
  love.graphics.print("Coût en PA : 2", 800, 450)
  love.graphics.print("Portée : 1 case", 800, 470)
  love.graphics.print("Type : Bonus PM", 800, 490)
  love.graphics.print("Nombre de cibles : Cible unique", 800, 510)
  love.graphics.print("Zone de ciblage : Cercle", 800, 530)
  love.graphics.print("Effet : Rajoute 2 PM", 800, 550)
  love.graphics.printf("Vous soutenez votre cible lui", editingSkill.getMenuX(), 580, editingSkill.getMenuW(), "center")
  love.graphics.printf("permettant de se déplacer", editingSkill.getMenuX(), 600, editingSkill.getMenuW(), "center")
  love.graphics.printf("plus loin.", editingSkill.getMenuX(), 620, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont10())
end

local function drawHUDSkillDescriptionV()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(images.getFont15())
  love.graphics.printf("Vous n'avez pas débloqué cette", editingSkill.getMenuX(), 530, editingSkill.getMenuW(), "center")
  love.graphics.printf("compétence.", editingSkill.getMenuX(), 550, editingSkill.getMenuW(), "center")
  love.graphics.setFont(images.getFont15())
end

local function drawHUDSkillDescriptionCSBar()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(data.statImg, x, y - 50)
  love.graphics.setFont(images.getFont15())
  love.graphics.printf("Coup Simple", x , y - 36, data.statImg:getWidth(), "center")
  love.graphics.setFont(images.getFont10())
  love.graphics.print("Coût en PA : 3", x + 30, y - 10)
  love.graphics.print("Portée : 2 cases", x + 30, y + 10)
  love.graphics.print("Attaque de mêlée", x + 30, y + 30)
  love.graphics.setFont(images.getFont15())
end

local function drawHUDSkillDescriptionCDBar()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(data.statImg, x, y - 50)
  love.graphics.setFont(images.getFont15())
  love.graphics.printf("Coup Double", x , y - 36, data.statImg:getWidth(), "center")
  love.graphics.setFont(images.getFont10())
  love.graphics.print("Coût en PA : 6", x + 30, y - 10)
  love.graphics.print("Portée : 1 case", x + 30, y + 10)
  love.graphics.print("Attaque de mêlée", x + 30, y + 30)
  love.graphics.setFont(images.getFont15())
end

local function drawHUDSkillDescriptionCZBar()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(data.statImg, x, y - 50)
  love.graphics.setFont(images.getFont15())
  love.graphics.printf("Coup Zone", x , y - 36, data.statImg:getWidth(), "center")
  love.graphics.setFont(images.getFont10())
  love.graphics.print("Coût en PA : 9", x + 30, y - 10)
  love.graphics.print("Portée : 2 cases", x + 30, y + 10)
  love.graphics.print("Attaque de mêlée", x + 30, y + 30)
  love.graphics.setFont(images.getFont15())
end

local function drawHUDSkillDescriptionSBar()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(data.statImg, x, y - 50)
  love.graphics.setFont(images.getFont15())
  love.graphics.printf("Soin", x , y - 36, data.statImg:getWidth(), "center")
  love.graphics.setFont(images.getFont10())
  love.graphics.print("Coût en PA : 6", x + 30, y - 10)
  love.graphics.print("Portée : 2 cases", x + 30, y + 10)
  love.graphics.print("Compétence de soutien", x + 30, y + 30)
  love.graphics.setFont(images.getFont15())
end

local function drawHUDSkillDescriptionTSBar()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(data.statImg, x, y - 50)
  love.graphics.setFont(images.getFont15())
  love.graphics.printf("Tir Simple", x , y - 36, data.statImg:getWidth(), "center")
  love.graphics.setFont(images.getFont10())
  love.graphics.print("Coût en PA : 3", x + 30, y - 10)
  love.graphics.print("Portée : 7 cases", x + 30, y + 10)
  love.graphics.print("Attaque à distance", x + 30, y + 30)
  love.graphics.setFont(images.getFont15())
end

local function drawHUDSkillDescriptionTDBar()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(data.statImg, x, y - 50)
  love.graphics.setFont(images.getFont15())
  love.graphics.printf("Tir Double", x , y - 36, data.statImg:getWidth(), "center")
  love.graphics.setFont(images.getFont10())
  love.graphics.print("Coût en PA : 6", x + 30, y - 10)
  love.graphics.print("Portée : 5 cases", x + 30, y + 10)
  love.graphics.print("Attaque à distance", x + 30, y + 30)
  love.graphics.setFont(images.getFont15())
end

local function drawHUDSkillDescriptionTDPBar()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(data.statImg, x, y - 50)
  love.graphics.setFont(images.getFont15())
  love.graphics.printf("Tir de Précision", x , y - 36, data.statImg:getWidth(), "center")
  love.graphics.setFont(images.getFont10())
  love.graphics.print("Coût en PA : 9", x + 30, y - 10)
  love.graphics.print("Portée : 7 cases", x + 30, y + 10)
  love.graphics.print("Attaque à distance", x + 30, y + 30)
  love.graphics.setFont(images.getFont15())
end

local function drawHUDSkillDescriptionABar()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(data.statImg, x, y - 50)
  love.graphics.setFont(images.getFont15())
  love.graphics.printf("Acceleration", x , y - 36, data.statImg:getWidth(), "center")
  love.graphics.setFont(images.getFont10())
  love.graphics.print("Coût en PA : 2", x + 30, y - 10)
  love.graphics.print("Portée : 1 case", x + 30, y + 10)
  love.graphics.print("Compétence de soutien", x + 30, y + 30)
  love.graphics.setFont(images.getFont15())
end

local function drawOption()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(data.optionImg, data.optionX - data.optionRadius, data.optionY - data.optionRadius)
end

local function drawLeave()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(data.leaveImg, data.leaveX - data.leaveRadius, data.leaveY - data.leaveRadius)
end

local function drawGrid()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(data.gridImg, data.gridX - data.gridRadius, data.gridY - data.gridRadius)
end

local function drawIconSkills()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(data.skillsImg, data.skillsX - data.skillsRadius, data.skillsY - data.skillsRadius)
end

local function drawIconPass()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(data.passImg, data.passX - data.passRadius, data.passY - data.passRadius)
end

function class.draw()
  x = love.mouse.getX()
  y = love.mouse.getY()
  drawOption()
  drawLeave()
  drawGrid()
  drawIconSkills()
  drawIconPass()
  drawHUDSkill()
  if (state.getState() == "skirmish") then
    drawCadrePerso()
  elseif (state.getState() == "tutorial") then
    drawCadrePersoTuto()
  end
  checkDeath()

  if (data.enemyTurnIsVisible) then
    love.graphics.setColor(1, 1, 1, data.enemyOpa)
    animation.draw(data.currentAnimation, data.enemyTurnX, data.enemyTurnY, 0, data.enemyTurnHeight/20)
  end
  if (data.allieTurnIsVisible) then
    love.graphics.setColor(1, 1, 1, data.allieOpa)
    animation.draw(data.currentAnimation, data.allieTurnX, data.allieTurnY, 0, data.allieTurnHeight/20)
  end

  if (player.isTurn()) then
    if (drawingCS) then
      drawHUDSkillDescriptionCS()
    elseif (drawingCD) then
      drawHUDSkillDescriptionCD()
    elseif (drawingCZ) then
      drawHUDSkillDescriptionCZ()
    elseif (drawingS) then
      drawHUDSkillDescriptionS()
    elseif (drawingV1) or (drawingV2) then
      drawHUDSkillDescriptionV()
    end
    if (drawingCSB) then
      drawHUDSkillDescriptionCSBar()
    elseif (drawingCDB) then
      drawHUDSkillDescriptionCDBar()
    elseif (drawingCZB) then
      drawHUDSkillDescriptionCZBar()
    elseif (drawingSB) then
      drawHUDSkillDescriptionSBar()
    end
  else
    if (drawingTS) then
      drawHUDSkillDescriptionTS()
    elseif (drawingTD) then
      drawHUDSkillDescriptionTD()
    elseif (drawingTDP) then
      drawHUDSkillDescriptionTDP()
    elseif (drawingA) then
      drawHUDSkillDescriptionA()
    elseif (drawingV1) or (drawingV2) then
      drawHUDSkillDescriptionV()
    end
    if (drawingTSB) then
      drawHUDSkillDescriptionTSBar()
    elseif (drawingTDB) then
      drawHUDSkillDescriptionTDBar()
    elseif (drawingTDPB) then
      drawHUDSkillDescriptionTDPBar()
    elseif (drawingAB) then
      drawHUDSkillDescriptionABar()
    end
  end
end

local function isCollidingPointRectangle(point, rect)
  if (point.x > rect.x) and (point.x < rect.x + rect.w) and (point.y > rect.y) and (point.y < rect.y + rect.h) then
    return true
  else
    return false  
  end
end

local function isCollidingPointCircle(point, circle)
  local d = ((point.x - circle.x)^2 + (circle.y - point.y)^2)^0.5

  if (d < circle.r) then
    return true
  else
    return false
  end
end

function class.mousepressed(x, y, button)
  local point = {x = x, y = y}
  if (button == 1) then
    if (isCollidingPointCircle(point, class.getLeaveHitbox())) then
      menuQuit.setMenuQuitOn(true)
      sound.getPlay("click")
    elseif (isCollidingPointCircle(point, class.getOptionHitbox())) then
      options.load()
      sound.getPlay("click")
      if (state.getState() == "tutorial") then
        state.setState("tOptions")
      elseif (state.getState() == "skirmish") then
        state.setState("sOptions")
      end
    elseif (isCollidingPointCircle(point, class.getGridHitbox())) then
      if (grid.isShowGrid()) then
        grid.setShowGrid(false)
        sound.getPlay("click")
      else
        grid.setShowGrid(true)
        sound.getPlay("reverse")
      end
    elseif (isCollidingPointCircle(point, class.getSkillsHitbox())) then
      if (not editingSkill.isMenuLock()) then
        if (not editingSkill.getMenuOn()) then
          editingSkill.setMenuOn(true)
          gridBar.resetSelection()
          sound.getPlay("click")
        elseif (editingSkill.getMenuOn()) then
          editingSkill.setMenuOn(false)
          editingSkill.resetSkillSelection()
          gridBar.resetSelection()
          sound.getPlay("reverse")
        end
      end
    elseif (isCollidingPointCircle(point, class.getPassHitbox())) then
      if (not editingSkill.getMenuOn()) then
        if (player.isTurn()) and (player.isAlive()) and (not player.isMoving()) then
          turn.resetStats(player, 1)
          turn.endTurnPlayer()
          sound.getPlay("clickPlay")
          if (state.getState() == "tutorial") and (script.canPass()) then
            script.setPass(true)
            sound.getPlay("tuto")
          end
        elseif (player2.isTurn()) and (player2.isAlive()) and (not player2.isMoving()) then
          turn.resetStats(player2, 2)
          turn.endTurnPlayer2()
          sound.getPlay("clickPlay")
        end
      end
    end
  end
end

function class.update(dt)
  updateArrow(dt)
  updateAnim(dt)

  local x = love.mouse.getX()
  local y = love.mouse.getY()
  local point = {x = x, y = y}

  local hitbox1 = editingSkill.getCoupSimpleHitbox()
  local hitbox2 = editingSkill.getCoupDoubleHitbox()
  local hitbox3 = editingSkill.getSoinHitbox()
  local hitbox4 = editingSkill.getTirSimpleHitbox()
  local hitbox5 = editingSkill.getTirDoubleHitbox()
  local hitbox6 = editingSkill.getTirDePrecisionHitbox()
  local hitbox7 = editingSkill.getAccelerationHitbox()
  local hitbox8 = editingSkill.getCoupZoneHitbox()
  local hitbox9 = editingSkill.getVerrou1Hitbox()
  local hitbox10 = editingSkill.getVerrou2Hitbox()

  --Infos bulle à partir du menu

  if (editingSkill.getMenuOn()) then
    if (isCollidingPointRectangle(point, hitbox1)) then
      drawingCS = true
    else
      drawingCS = false
    end
    if (isCollidingPointRectangle(point, hitbox2)) then
      drawingCD = true
    else
      drawingCD = false
    end
    if (isCollidingPointRectangle(point, hitbox3)) then
      drawingS = true
    else
      drawingS = false
    end
    if (isCollidingPointRectangle(point, hitbox4)) then
      drawingTS = true
    else
      drawingTS = false
    end
    if (isCollidingPointRectangle(point, hitbox5)) then
      drawingTD = true
    else
      drawingTD = false
    end
    if (isCollidingPointRectangle(point, hitbox6)) then
      drawingTDP = true
    else
      drawingTDP = false
    end
    if (isCollidingPointRectangle(point, hitbox7)) then
      drawingA = true
    else
      drawingA = false
    end
    if (isCollidingPointRectangle(point, hitbox8)) then
      drawingCZ = true
    else
      drawingCZ = false
    end
    if (isCollidingPointRectangle(point, hitbox9)) then
      drawingV1 = true
    else
      drawingV1 = false
    end
    if (isCollidingPointRectangle(point, hitbox10)) then
      drawingV2 = true
    else
      drawingV2 = false
    end
  else
    drawingCS = false
    drawingCD = false
    drawingCZ = false
    drawingS = false
    drawingTS = false
    drawingTD = false
    drawingTDP = false
    drawingA = false
    drawingV1 = false
    drawingV2 = false
  end

--Info bulle a partir de la barre de compétence

  local line = gridBar.getLine(point.y)
  local column = gridBar.getColumn(point.x)

  if (gridBar.checkCase(line, column)) then
    local hitboxSkill = gridBar.getHitbox(line, column)
    if (isCollidingPointCircle(point, hitboxSkill)) then
      if (gridBar.getType(line, column) == "coupSimple") then
        drawingCSB = true
      else
        drawingCSB = false
      end
      if (gridBar.getType(line, column) == "coupDouble") then
        drawingCDB = true
      else
        drawingCDB = false
      end
      if (gridBar.getType(line, column) == "coupZone") then
        drawingCZB = true
      else
        drawingCZB = false
      end
      if (gridBar.getType(line, column) == "soin") then
        drawingSB = true
      else
        drawingSB = false
      end
      if (gridBar.getType(line, column) == "tirSimple") then
        drawingTSB = true
      else
        drawingTSB = false
      end
      if (gridBar.getType(line, column) == "tirDouble") then
        drawingTDB = true
      else
        drawingTDB = false
      end
      if (gridBar.getType(line, column) == "tirDePrecision") then
        drawingTDPB = true
      else
        drawingTDPB = false
      end
      if (gridBar.getType(line, column) == "acceleration") then
        drawingAB = true
      else
        drawingAB = false
      end
    end
  else
    drawingCSB = false
    drawingCDB = false
    drawingCZB = false
    drawingSB = false
    drawingTSB = false
    drawingTDB = false
    drawingTDPB = false
    drawingAB = false
  end
end

return class