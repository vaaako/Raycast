function love.load()
	require('./config')
	require('src/map')
	require('src/player')
	require('src/renderer')
	require('src/raycast')

	love.graphics.setLineWidth(wratio())

	love.window.setTitle( "Vako cast (Not a podcast)" )
	love.window.setMode( WIDTH, HEIGHT,
						{ resizable=true, vsync=1, minwidth=400, minheight=300 } )
	-- love.window.setPosition( x, y, displayindex )
	-- love.window.setIcon( imagedata )

	Map() -- Init map
end

function love.update(dt)
	player:update(dt)
	-- raycast:update(dt)
end

function love.draw()
	-- player:draw()
	-- map:draw()
	renderer:draw()
	raycast:draw()

	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end


function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end
