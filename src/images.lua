local class = {}
local data = {}

function class.getImage(name)
  return data[name]
end

function class.getFont()
  return data.font
end

function class.getFont10()
  return data.font10
end

function class.getFont15()
  return data.font15
end

function class.getFont20()
  return data.font20
end

function class.getFont30()
  return data.font30
end

function class.getFont40()
  return data.font40
end

function class.getFont50()
  return data.font50
end

local function loadFont()
  data.font = love.graphics.newFont("Assets/Fonts/Font.ttf")
  data.font10 = love.graphics.newFont("Assets/Fonts/Font.ttf", 10)
  data.font15 = love.graphics.newFont("Assets/Fonts/Font.ttf", 15)
  data.font20 = love.graphics.newFont("Assets/Fonts/Font.ttf", 20)
  data.font30 = love.graphics.newFont("Assets/Fonts/Font.ttf", 30)
  data.font40 = love.graphics.newFont("Assets/Fonts/Font.ttf", 40)
  data.font50 = love.graphics.newFont("Assets/Fonts/Font.ttf", 50)
end

local function loadIntro()
  data.creajeuxIntro = love.graphics.newImage("Assets/Images/Intro/LogoCreajeux.png")
  data.lineUpIntro = love.graphics.newImage("Assets/Images/Intro/LineUpStudio.png")
end

local function loadMenu()
  data.creajeux = love.graphics.newImage("Assets/Images/Menu/LogoCreajeux.png")
  data.lineUp = love.graphics.newImage("Assets/Images/Menu/LineUpStudio.png")
  data.newHumanity = love.graphics.newImage("Assets/Images/Menu/NHLogoMenu.png")

  data.cadreMenu = love.graphics.newImage("Assets/Images/Menu/CadreMenu.png")
  data.artMenu = love.graphics.newImage("Assets/Images/Menu/ArtConcept.png")
  data.tuto = love.graphics.newImage("Assets/Images/Menu/TutoButton.png")
  data.tutoOn = love.graphics.newImage("Assets/Images/Menu/TutoButtonOn.png")
  data.play = love.graphics.newImage("Assets/Images/Menu/PlayButton.png")
  data.playOn = love.graphics.newImage("Assets/Images/Menu/PlayButtonOn.png")
  data.options = love.graphics.newImage("Assets/Images/Menu/OptionsButton.png")
  data.optionsOn = love.graphics.newImage("Assets/Images/Menu/OptionsButtonOn.png")
  data.credits = love.graphics.newImage("Assets/Images/Menu/CreditsButton.png")
  data.creditsOn = love.graphics.newImage("Assets/Images/Menu/CreditsButtonOn.png")
  data.leave = love.graphics.newImage("Assets/Images/Menu/LeaveButton.png")
  data.leaveOn = love.graphics.newImage("Assets/Images/Menu/LeaveButtonOn.png")

  data.defeatSheet = love.graphics.newImage("Assets/Images/Menu/DefeatSheet.png")
  data.victorySheet = love.graphics.newImage("Assets/Images/Menu/VictorySheet.png")

  data.moins = love.graphics.newImage("Assets/Images/Menu/Moins.png")
  data.plus = love.graphics.newImage("Assets/Images/Menu/Plus.png")
  data.button = love.graphics.newImage("Assets/Images/Menu/Button.png")
  data.active = love.graphics.newImage("Assets/Images/Menu/Micro.png")
  data.nonActif = love.graphics.newImage("Assets/Images/Menu/SansMicro.png")
  data.cadreOptions = love.graphics.newImage("Assets/Images/Menu/CadreOptions.png")

  data.cadreMenuQuit = love.graphics.newImage("Assets/Images/Menu/CadreMenuQuit.png")
  data.yes = love.graphics.newImage("Assets/Images/Menu/OuiButton.png")
  data.no = love.graphics.newImage("Assets/Images/Menu/NonButton.png")
  data.yesOn = love.graphics.newImage("Assets/Images/Menu/OuiButtonOn.png")
  data.noOn = love.graphics.newImage("Assets/Images/Menu/NonButtonOn.png")

  data.particle1 = love.graphics.newImage("Assets/Images/Menu/Particle1.png")
  data.particle2 = love.graphics.newImage("Assets/Images/Menu/Particle2.png")
  data.particle3 = love.graphics.newImage("Assets/Images/Menu/Particle3.png")
  data.particle4 = love.graphics.newImage("Assets/Images/Menu/Particle4.png")
end

local function loadPlayers()
  data.playerSheet = love.graphics.newImage("Assets/Images/Player/PlayerSheet.png")
  data.player2Sheet = love.graphics.newImage("Assets/Images/Player/Player2Sheet.png")
end

local function loadEnemies()
  data.enemy1Sheet = love.graphics.newImage("Assets/Images/Enemy/Enemy1Sheet.png")
  data.enemy2Sheet = love.graphics.newImage("Assets/Images/Enemy/Enemy2Sheet.png")
  data.enemy3Sheet = love.graphics.newImage("Assets/Images/Enemy/Enemy3Sheet.png")
  data.enemy4Sheet = love.graphics.newImage("Assets/Images/Enemy/Enemy4Sheet.png")
  data.enemy5Sheet = love.graphics.newImage("Assets/Images/Enemy/Enemy5Sheet.png")

  data.bossSheet = love.graphics.newImage("Assets/Images/Enemy/BossSheet.png")
end

local function loadSkill()
  data.coupSimple       = love.graphics.newImage("Assets/Images/Skill/CoupSimple.png")
  data.coupDouble       = love.graphics.newImage("Assets/Images/Skill/CoupDouble.png")
  data.coupZone         = love.graphics.newImage("Assets/Images/Skill/CoupZone.png")
  data.soin             = love.graphics.newImage("Assets/Images/Skill/Soin.png")

  data.tirSimple        = love.graphics.newImage("Assets/Images/Skill/TirSimple.png")
  data.tirDouble        = love.graphics.newImage("Assets/Images/Skill/TirDouble.png")
  data.tirDePrecision   = love.graphics.newImage("Assets/Images/Skill/TirDePrecision.png")
  data.acceleration     = love.graphics.newImage("Assets/Images/Skill/Acceleration.png")

  data.verrou = love.graphics.newImage("Assets/Images/Skill/Verrou.png")
end

local function loadHit()
  data.hudShotSheet = love.graphics.newImage("Assets/Images/Hit/Shot.png")
  data.hudAttackPlayerSheet = love.graphics.newImage("Assets/Images/Hit/AttackPlayer.png")
  data.hudAttackEnemySheet = love.graphics.newImage("Assets/Images/Hit/AttackEnemy.png")
  data.hudHealSheet = love.graphics.newImage("Assets/Images/Hit/Heal.png")
  data.hudBoostSheet = love.graphics.newImage("Assets/Images/Hit/Boost.png")
end

local function loadHUD()
  data.mouse = love.graphics.newImage("Assets/Images/HUD/Mouse.png")
  
  data.menuSkill = love.graphics.newImage("Assets/Images/HUD/CadreCompetences.png")
  data.hudPlayerSkill = love.graphics.newImage("Assets/Images/HUD/SkillBackground.png")
  data.hudStats = love.graphics.newImage("Assets/Images/HUD/CadreDesStats.png")
  data.infosBar = love.graphics.newImage("Assets/Images/HUD/InfosBar.png")

  data.option = love.graphics.newImage("Assets/Images/HUD/OptionButton.png")
  data.leaveIG = love.graphics.newImage("Assets/Images/HUD/LeaveButtonIG.png")
  data.showGrid = love.graphics.newImage("Assets/Images/HUD/ShowGrid.png")

  data.iconSkills = love.graphics.newImage("Assets/Images/HUD/IconSkills.png")
  data.iconPass = love.graphics.newImage("Assets/Images/HUD/IconPass.png")

  data.cadrePlayer1 = love.graphics.newImage("Assets/Images/HUD/CadreALLIE_1.png")
  data.cadrePlayer2 = love.graphics.newImage("Assets/Images/HUD/CadreALLIE_2.png")
  data.cadreEnemy1 = love.graphics.newImage("Assets/Images/HUD/CadreENNEMI_1.png")
  data.cadreEnemy2 = love.graphics.newImage("Assets/Images/HUD/CadreENNEMI_2.png")
  data.cadreEnemy3 = love.graphics.newImage("Assets/Images/HUD/CadreENNEMI_3.png")
  data.cadreEnemy4 = love.graphics.newImage("Assets/Images/HUD/CadreENNEMI_4.png")
  data.cadreEnemy5 = love.graphics.newImage("Assets/Images/HUD/CadreENNEMI_5.png")
  data.cadreBoss = love.graphics.newImage("Assets/Images/HUD/CadreENNEMI_BOSS.png")
  data.cadreArrow = love.graphics.newImage("Assets/Images/HUD/Fleche_CadrePersonnage.png")
  data.cadreCroix = love.graphics.newImage("Assets/Images/HUD/Croix.png")

  data.turnAllies = love.graphics.newImage("Assets/Images/HUD/AlliesTurn.png")
  data.turnEnemy = love.graphics.newImage("Assets/Images/HUD/EnnemisTurn.png")

  data.arrowSheet = love.graphics.newImage("Assets/Images/HUD/ArrowSheet.png")
end

local function loadTuto()
  data.tutoMove = love.graphics.newImage("Assets/Images/Tuto/Move.png")
  data.tutoCamera = love.graphics.newImage("Assets/Images/Tuto/Camera.png")
  data.tutoSkill = love.graphics.newImage("Assets/Images/Tuto/Skill.png")
  data.tutoPass = love.graphics.newImage("Assets/Images/Tuto/Pass.png")
  data.tutoHit = love.graphics.newImage("Assets/Images/Tuto/Hit.png")
  data.tutoWin = love.graphics.newImage("Assets/Images/Tuto/Win.png")
  data.arrowSheetTuto = love.graphics.newImage("Assets/Images/Tuto/ArrowSheet.png")
end

function class.load()
  loadFont()
  loadIntro()
  loadMenu()
  loadPlayers()
  loadEnemies()
  loadSkill()
  loadHit()
  loadHUD()
  loadTuto()
end

return class