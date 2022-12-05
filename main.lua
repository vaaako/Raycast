function love.load()
	require "config"
	require "src/map"
	require "src/player"
	require "src/renderer"
	require "src/raycast"

	-- Window Config
	love.window.setTitle( "Vako cast (Not a podcast)" )
	love.window.setMode( WIDTH, HEIGHT,
						{ resizable=false, vsync=1, minwidth=400, minheight=300 } )
						-- { resizable=true, vsync=1, minwidth=640, minheight=600 } )

	-- love.window.setFullscreen(false) -- Disable full screen

	love.graphics.setDefaultFilter("nearest", "nearest") -- Anti alising
	-- love.graphics.setNewFont(40) -- Font Size

	-- love.graphics.setBackgroundColor(0.7, 0.7, 0.7) -- Clear Screen
	love.graphics.setLineWidth(wratio())
end

function love.update(dt)
	player:update(dt)


end

function love.draw()
	renderer:draw()
	raycast:draw()

	-- Debug
	-- map:draw()
	-- player:draw()

	love.graphics.setColor(1, 1, 1)
	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end




function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

-- function love.mousemoved(x, y, dx, dy)
-- 	local mx, my = love.mouse.getPosition()
-- 	if mx < MOUSE_BORDER_LEFT or mx > MOUSE_BORDER_RIGHT then
-- 		love.mouse.setPosition( HALF_WIDTH, HALF_HEIGHT )
-- 	end

-- 	player.rel = dx
-- 	player.rel = math.max(-MOUSE_MAX_REL, math.min(MOUSE_MAX_REL, player.rel))
-- 	player.angle = player.angle + player.rel * MOUSE_SENSITIVITY
-- end