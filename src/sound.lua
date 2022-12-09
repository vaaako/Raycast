sound = {}
sound.path = "resources/sound/"

shotgun_sound = love.audio.newSource(sound.path.."shotgun.wav", "static") -- stream for music
naldorock = love.audio.newSource(sound.path.."naldorock.mp3", "stream") -- stream for music