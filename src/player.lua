player = {}

-- Sets player position
player.x, player.y = PLAYER_POS[1], PLAYER_POS[2]
player.angle = PLAYER_ANGLE
player.rel = 0
player.shot = false
-- player.vis = 0

function check_wall(x, y)
	for i, pos in ipairs(map.world_map) do
		local mx = pos[1][1] -- -1 -> Start at 0
		local my = pos[1][2]

		if mx == x and my == y then
			return pos[2] -- Wall reached (Return wall value)
		end
	end

	return 0 -- No wall reached
end


function check_wall_collision(dx, dy)
	-- Check new cords and only allow moviment if there is no wall
	if check_wall(math.floor(player.x + dx), math.floor(player.y)) == 0 then
		player.x = player.x + dx
	end
	
	if check_wall(math.floor(player.x), math.floor(player.y + dy)) == 0 then
		player.y = player.y + dy
	end
end


function player:update(dt)
	sin_a = math.sin(player.angle)
	cos_a = math.cos(player.angle)
	dx, dy = 0, 0
	speed = PLAYER_SPEED * dt -- Speed will be the same in any framerate
	speed_sin = speed * sin_a
	speed_cos = speed * cos_a

	
	if love.keyboard.isDown("w") then
		dx = dx + speed_cos
		dy = dy + speed_sin
	elseif love.keyboard.isDown("s") then
		dx = dx + (-speed_cos)
		dy = dy + (-speed_sin)
	end

	if love.keyboard.isDown("a") then
		dx = dx + speed_sin
		dy = dy + (-speed_cos)
	elseif love.keyboard.isDown("d") then
		dx = dx + (-speed_sin)
		dy = dy + speed_cos
	end


	check_wall_collision(dx, dy)

	if love.keyboard.isDown("left") then
		player.angle = player.angle - (PLAYER_ROT_SPEED * dt)
	elseif love.keyboard.isDown("right") then
		player.angle = player.angle + (PLAYER_ROT_SPEED * dt)

	end

	player.angle = player.angle % TAU -- tau (Full turn in radians)
end

function player:draw()
	-- Angle line
	-- love.graphics.setColor(0, 1, 0)
	-- love.graphics.line(player.x * map.size, player.y *map.size, -- X1, X2
	-- 					player.x * map.size + WIDTH * math.cos(player.angle), -- Y1
	-- 					player.y * map.size + WIDTH * math.sin(player.angle) -- Y2
	-- 				)

	-- Draw player
	love.graphics.setColor(1, 0, 1)
	love.graphics.circle('fill',
						player.x * map.size, player.y * map.size, -- X, Y
						-- math.floor(map.size/6.5) -- Radius
						4 -- Radius
					)
end
	
function player_pos() -- Get players coordinates
	return player.x, player.y
end

function map_pos() -- Wich tile in the map the player is
	return math.floor(player.x), math.floor(player.y)
end


