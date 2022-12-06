renderer = {}
renderer.sky_image = love.graphics.newImage('resources/textures/sky.png')
renderer.sky_offset = 0

function renderer:draw()
	-- Draw sky
	love.graphics.setColor(1, 0, 1) -- Paint sky of purple
	renderer.sky_offset = (renderer.sky_offset + 4.5 * player.rel) % WIDTH

	-- Draw two times to repeat the image when one ends
	love.graphics.draw(renderer.sky_image, -renderer.sky_offset, 0)
	love.graphics.draw(renderer.sky_image, -renderer.sky_offset + WIDTH, 0)

	-- Draw Floor
	love.graphics.setColor(FLOOR_COLOR)
	love.graphics.rectangle("fill", 0, HALF_HEIGHT, WIDTH, HEIGHT)

	-- Draw walls and sprites
	-- Objects with higher depth draw first
	table.sort(raycast.objects_to_render, function(a,b) return a[1] > b[1] end) -- First index higher in crescent order
	love.graphics.reset() -- Reset color
	
	for _, obj in pairs(raycast.objects_to_render) do
		local c = 1 - obj[1]/20
		love.graphics.setColor(c, c, c) -- Shadow

		love.graphics.draw(obj[2], obj[3], obj[4], obj[5], obj[6], obj[7], obj[8])
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
for i=1, 64 do
	texSlice[i] = love.graphics.newQuad(i-1, 0, 1, 64, 64, 64)
end

-- Load textures
wallTextures = {
	-- If map number is 1, texture number 1
	love.graphics.newImage('resources/textures/1.png'),
	love.graphics.newImage('resources/textures/2.png'),
	love.graphics.newImage('resources/textures/3.png'),
	love.graphics.newImage('resources/textures/4.png'),
	love.graphics.newImage('resources/textures/5.png'),
	love.graphics.newImage('resources/textures/6.png'),
	love.graphics.newImage('resources/textures/7.png'),
	love.graphics.newImage('resources/textures/8.png'),
}
