renderer = {}
renderer.sky_image = love.graphics.newImage('resources/textures/sky.png')
renderer.sky_offset = 0


function renderer:draw()
	-- Draw sky
	love.graphics.setColor(1, 0, 1) -- Paint sky of purple

	renderer.sky_offset = (renderer.sky_offset + 4.5 * player.rel) % WIDTH
	
	-- Draw two times to repeat the image when one ends
	love.graphics.draw(renderer.sky_image, -renderer.sky_offset, 0)
	love.graphics.draw(renderer.sky_image, -self.sky_offset + WIDTH, 0)

	-- Draw Floor
	love.graphics.setColor(FLOOR_COLOR)
	love.graphics.rectangle("fill", 0, HALF_HEIGHT, WIDTH, HEIGHT)
end


function renderer:walls(depth, id , wall, slice, ray)
	-- Projection
	proj_height = SCREEN_DIST / (depth + 0.0001)

	if proj_height > 0 then
		local c = 1 - depth/20
		love.graphics.setColor(c, c, c) -- Shadow


		if slice > 0 and slice <= TEXTURE_SIZE then
			love.graphics.draw(
				wallTextures[id], texSlice[slice], -- Texture, Quad
				ray * SCALE, HALF_HEIGHT - math.floor(proj_height / PLAYER_HEIGHT), -- X, Y
				0, -- Rot
				SCALE, WALLS_SIZE/depth*hratio() -- Width, Height
			)
		end
	end
end


function wratio()
	return love.graphics.getWidth()/WIDTH
end

function hratio()
	return love.graphics.getHeight()/HEIGHT
end


-- Add slices
texSlice = {}
for i=1, TEXTURE_SIZE do
	texSlice[i] = love.graphics.newQuad(i-1, 0, 1, TEXTURE_SIZE, TEXTURE_SIZE, TEXTURE_SIZE)
end


-- Load textures
wallTextures = {
	-- If map number is 1, texture number 1
	love.graphics.newImage('resources/textures/1.png'),
	love.graphics.newImage('resources/textures/2.png'),
	love.graphics.newImage('resources/textures/3.png'),
	love.graphics.newImage('resources/textures/4.png'),
	love.graphics.newImage('resources/textures/5.png')
}
