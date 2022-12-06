function love.load()
	require "config"
	require "src/map"
	require "src/player"
	require "src/renderer"
	require "src/raycast"
	require "src/sprite"
	require "src/handler"

	-- Window Config
	love.window.setTitle( "Vako cast (Not a podcast)" )
	love.window.setMode( WIDTH, HEIGHT,
						{ fullscreen=false, resizable=false, vsync=1, minwidth=640, minheight=600, centered=true} )
	love.graphics.setDefaultFilter("nearest", "nearest") -- Anti alising
	love.mouse.setRelativeMode(true) -- Mouse invisible and realtive to window
	-- love.mouse.setVisible(true)

	-- love.graphics.setBackgroundColor(0.7, 0.7, 0.7) -- Clear Screen
	-- love.graphics.setLineWidth(wratio())
end

function love.update(dt)
	player:update(dt)
	raycast:update()
	handler:update() -- Update the all sprites in one function
	-- static_sprites:update()
	-- animated_sprites:update()
end

function love.draw()
	renderer:draw()
	-- raycast:draw()

	-- Debug
	-- map:draw()
	-- player:draw()

	love.graphics.setColor(1, 1, 1)
	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)

	love.graphics.print("PX: "..tostring(player.x), 10, 25)
	love.graphics.print("PY: "..tostring(player.y), 10, 40)
	love.graphics.print("PA: "..tostring(player.angle), 10, 55)

end



function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end

	if key == 'tab' then
		local state = not love.mouse.getRelativeMode()   -- the opposite of whatever it currently is
		love.mouse.setRelativeMode(state)
	end
end


function love.mousemoved(x, y, dx, dy)
	local mx, my = love.mouse.getPosition()
	-- if mx < MOUSE_BORDER_LEFT or mx > MOUSE_BORDER_RIGHT then
	-- 	love.mouse.setPosition( HALF_WIDTH, HALF_HEIGHT )
	-- end

	-- player.vis = player.vis + dy

	player.rel = dx
	player.rel = math.max(-MOUSE_MAX_REL, math.min(MOUSE_MAX_REL, player.rel))
	player.angle = player.angle + player.rel * MOUSE_SENSITIVITY
end