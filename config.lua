-- Game Settings
WIDTH  = 960
HEIGHT = 640

-- WIDTH  = love.graphics.getWidth()
-- HEIGHT = love.graphics.getHeight()

-- = WIDTH, HEIGHT = 1600, 900
HALF_WIDTH  = math.floor(WIDTH  / 2)
HALF_HEIGHT = math.floor(HEIGHT / 2)
FPS = 60

PLAYER_POS       = { 1.5, 5 } -- Mini map
PLAYER_ANGLE     = 0
-- PLAYER_SPEED     = 0.004
PLAYER_SPEED     = 4
-- PLAYER_ROT_SPEED = 0.002
PLAYER_ROT_SPEED = 2
-- PLAYER_SIZE_SCALE = 60

FLOOR_COLOR = { 0.3, 0.3, 0.3 }

FOV           = math.pi / 3
HALF_FOV      = FOV / 2
NUM_RAYS      = math.floor(WIDTH / 2)
HALF_NUM_RAYS = math.floor(NUM_RAYS / 2)
DELTA_ANGLE   = FOV / NUM_RAYS
MAX_DEPTH     = 20

SCREEN_DIST = HALF_WIDTH / math.tan(HALF_FOV)
SCALE       = math.floor(WIDTH / NUM_RAYS)

TEXTURE_SIZE = 256
HALF_TEXTURE_SIZE = math.floor(TEXTURE_SIZE / 2)