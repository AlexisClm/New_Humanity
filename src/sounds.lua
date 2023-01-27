local state = require ("state")


local data = {}

local function initSounds()


  data.soundPlay = love.audio.newSource("Assets/Sounds/Music/NHFightTheme.mp3","static")
  data.soundMenu = love.audio.newSource("Assets/Sounds/Music/NHMenuTheme.mp3","static")
  data.defeat = love.audio.newSource("Assets/Sounds/Music/NHDefeat.mp3","static")
  data.victory = love.audio.newSource("Assets/Sounds/Music/NHVictory.mp3","static")

  data.volume = 0.5
  data.volumeSE = 0.5

end

local function initVoice()

  data.atkCroco = love.audio.newSource("Assets/Sounds/Other/AtkCroco.wav","static")
  data.atkSnipe = love.audio.newSource("Assets/Sounds/Other/AtkSnipe.wav","static")
  data.dmgCroco = love.audio.newSource("Assets/Sounds/Other/DmgCroco.wav","static")
  data.dmgSnipe = love.audio.newSource("Assets/Sounds/Other/DmgSnipe.wav","static")

  data.atkEnemy1 = love.audio.newSource("Assets/Sounds/Other/AtkE1.wav","static")
  data.atkEnemy2 = love.audio.newSource("Assets/Sounds/Other/AtkE2.wav","static")
  data.atkEnemy3 = love.audio.newSource("Assets/Sounds/Other/AtkE3.wav","static")
  data.atkBoss = love.audio.newSource("Assets/Sounds/Other/AtkBoss.wav","static")

  data.deadEnemy1 = love.audio.newSource("Assets/Sounds/Other/DeadE1.wav","static")
  data.deadEnemy2 = love.audio.newSource("Assets/Sounds/Other/DeadE2.wav","static")
  data.deadEnemy3 = love.audio.newSource("Assets/Sounds/Other/DeadE3.wav","static")
  data.deadBoss = love.audio.newSource("Assets/Sounds/Other/DeadBoss.wav","static")

  data.sword = love.audio.newSource("Assets/Sounds/Other/Sword.wav","static")
  data.snipe = love.audio.newSource("Assets/Sounds/Other/Snipe.wav","static")
  data.upStatut = love.audio.newSource("Assets/Sounds/Other/UpStatut.wav","static")
  data.heal = love.audio.newSource("Assets/Sounds/Other/Heal.wav","static")

  data.clickPlay = love.audio.newSource("Assets/Sounds/Other/ClickPlay.wav","static")
  data.click = love.audio.newSource("Assets/Sounds/Other/Click.wav","static")
  data.reverse = love.audio.newSource("Assets/Sounds/Other/Retour.wav","static")
  data.volumeBtn = love.audio.newSource("Assets/Sounds/Other/Volume.wav","static")
  data.tuto = love.audio.newSource("Assets/Sounds/Other/Tuto.wav","static")

  data.selectSkill = love.audio.newSource("Assets/Sounds/Other/SelectSkill.wav","static")
  data.affectSkill = love.audio.newSource("Assets/Sounds/Other/AffectSkill.wav","static")

end

local function newVolume()

  data.soundPlay:setVolume(data.volume)
  data.soundMenu:setVolume(data.volume)
  data.victory:setVolume(data.volume)
  data.defeat:setVolume(data.volume)

  data.atkCroco:setVolume(data.volumeSE)
  data.atkSnipe:setVolume(data.volumeSE)
  data.dmgCroco:setVolume(data.volumeSE)
  data.dmgSnipe:setVolume(data.volumeSE)

  data.atkEnemy1:setVolume(data.volumeSE)
  data.atkEnemy2:setVolume(data.volumeSE)
  data.atkEnemy3:setVolume(data.volumeSE)
  data.atkBoss:setVolume(data.volumeSE)

  data.deadEnemy1:setVolume(data.volumeSE)
  data.deadEnemy2:setVolume(data.volumeSE)
  data.deadEnemy3:setVolume(data.volumeSE)
  data.deadBoss:setVolume(data.volumeSE)

  data.sword:setVolume(data.volumeSE)
  data.snipe:setVolume(data.volumeSE)
  data.upStatut:setVolume(data.volumeSE)
  data.heal:setVolume(data.volumeSE)

  data.clickPlay:setVolume(data.volumeSE)
  data.click:setVolume(data.volumeSE)
  data.reverse:setVolume(data.volumeSE)
  data.volumeBtn:setVolume(data.volumeSE)

  data.selectSkill:setVolume(data.volumeSE)
  data.affectSkill:setVolume(data.volumeSE)

  data.tuto:setVolume(data.volumeSE)
end

local class = {}

function class.load()

  initSounds()
  initVoice()

end

function class.update(dt)

  newVolume()

  if (state.getState() == "tutorial") then
    data.soundMenu:stop()
    data.soundPlay:play()
  elseif (state.getState() == "skirmish") then
    data.soundMenu:stop()
    data.soundPlay:play()
  elseif (state.getState() == "menu") then
    data.soundMenu:play()
    data.soundPlay:stop()
    data.defeat:stop()
    data.victory:stop()
  elseif (state.getState() == "options") or (state.getState() == "credit") then
    data.soundMenu:play()
  elseif (state.getState() == "sOptions") or (state.getState() == "tOptions") then
    data.soundPlay:play()
  end
end

function class.getPlay(name)
  return data[name]:play()
end

function class.getSound(name)
  return data[name]
end

function class.getVolumeM()
  return data.volume
end

function class.setVolumeM(value)
  data.volume = value
end

function class.getVolumeS()
  return data.volumeSE
end

function class.setVolumeS(value)
  data.volumeSE = value
end

return class

