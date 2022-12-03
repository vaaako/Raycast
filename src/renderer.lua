renderer = {}
-- renderer.wall_textures = load_wall_textures()
renderer.sky_image = love.graphics.newImage('resources/textures/sky.png')
renderer.sky_offset = 0

-- function render_game_obects()

--[[
def render_game_obects(self):
	list_objects = self.game.raycasting.objects_to_render
	for depth, image, pos in list_objects:
		self.screen.blit(image, pos)
--]]

function renderer:draw()

	renderer.sky_offset = (renderer.sky_offset + 4.5 * player.rel) % WIDTH
	love.graphics.draw(renderer.sky_image, -renderer.sky_offset, 0)
	-- love.graphics.draw(renderer.sky_image, -renderer.sky_offset + WIDTH, 0)
	
	-- love.graphics.setColor(FLOOR_COLOR)
	-- love.graphics.rectangle("fill", 0, HALF_HEIGHT, WIDTH, HEIGHT)



	-- list_objects = raycast.objects_to_render
	-- for _, obj in pairs(list_objects) do
	-- 	-- depth, image, pos = obj[1], obj[2], obj[3]
	-- 	img, quad, pos = obj[1], obj[2], obj[3]

	-- 	-- print(img)
	-- 	-- love.graphics.draw(img, bottom_left, 50, 200)
	-- 	love.graphics.draw(img, quad, pos[1], pos[2])

		-- love.graphics.draw(img, quad, pos[1], pos[2], 0, scale[1], scale[2])

		-- love.graphics.pop()
	-- end
end

-- Path to the texture and resolution
function get_texture(path)
	texture = love.graphics.newImage(path) --.convertAplha()
	return texture
end


texSlice = {}
-- for i=1, 64 do
for i=1, TEXTURE_SIZE do
	
	texSlice[i] = love.graphics.newQuad(i-1, 0, 1, TEXTURE_SIZE, TEXTURE_SIZE, TEXTURE_SIZE)
	-- texSlice[i] = love.graphics.newQuad(i-1, 0, 1, 64, 64, 64)
end


wallTextures = {
	-- If map number is 1, texture number 1
	get_texture('resources/textures/1.png'),
	get_texture('resources/textures/2.png'),
	get_texture('resources/textures/3.png'),
	get_texture('resources/textures/4.png'),
	get_texture('resources/textures/5.png')
}


function sratio()
	return wratio(), hratio()
end

function wratio()
	return love.graphics.getWidth()/WIDTH
end

function hratio()
	return love.graphics.getHeight()/HEIGHT
end




-- somewhere, outside of a callback
-- plane = love.graphics.newImage("plane.png")

-- -- somewhere, probably in love.draw
-- love.graphics.push()
-- love.graphics.scale(0.5, 0.5)
-- love.graphics.draw(plane, 200/0.5, 200/0.5) -- '/ 0.5' because scale affects everything, including position obviously
-- love.graphics.pop() -- so the scale doesn't affect anything else