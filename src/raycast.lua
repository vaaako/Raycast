raycast = {}
raycast.objects_to_render = {}


function get_objects_to_render()
	raycast.objects_to_render = {}

	for ray, values in ipairs(raycast.result) do
		-- Depth is to know what object is above what
		local depth, id , wall, slice = values[1], values[2], values[3], values[4]
		local proj_height = SCREEN_DIST / (depth + 0.0001)

		if proj_height > 0 then
			if slice > 0 and slice <= 64 then
				table.insert(raycast.objects_to_render, { depth, wallTextures[id], texSlice[slice], ray * SCALE, HALF_HEIGHT - math.floor(proj_height / PLAYER_HEIGHT), 0, SCALE, WALLS_SIZE/depth*hratio() })
			end
		end
	end
end


function raycaster()
	raycast.result = {}
	local ox, oy = player_pos() -- Coordinates of the player on the map
	local x_map, y_map = map_pos() -- Coordinates of his tile
	local texture_vert, texture_hor = 1, 1

	-- Angle for the first ray
	local ray_angle = player.angle - HALF_FOV + 0.0001 -- Add small value to avoid division by zero

	for ray = 0, NUM_RAYS do
		local sin_a = math.sin(ray_angle)
		local cos_a = math.cos(ray_angle)

		-- Horizontals
		if sin_a > 0 then
			y_hor, dy = y_map + 1, 1
		else
			y_hor, dy = y_map - 1e-6, -1
		end


		depth_hor = (y_hor - oy) / sin_a
		x_hor = ox + depth_hor * cos_a

		delta_depth = dy / sin_a
		dx = delta_depth * cos_a

		for i = 0, MAX_DEPTH do
			local tile_hor = { math.floor(x_hor), math.floor(y_hor) }
			local wall = check_wall(tile_hor[1], tile_hor[2])

			if wall~=0 then
				-- texture_hor = map.world_map[wall][2]
				texture_hor = wall
				break
			end

			x_hor = x_hor + dx
			y_hor = y_hor + dy
			depth_hor = depth_hor + delta_depth
		end


		-- Verticals
		if cos_a > 0 then
			x_vert, dx = x_map + 1, 1
		else
			x_vert, dx = x_map - 1e-6, -1
		end


		depth_vert = (x_vert - ox) / cos_a
		y_vert = oy + depth_vert * sin_a

		delta_depth = dx / cos_a
		dy = delta_depth * sin_a

		for i = 0, MAX_DEPTH do
			local tile_vert = { math.floor(x_vert), math.floor(y_vert) }
			local wall = check_wall(tile_vert[1], tile_vert[2])

			-- Stumble on wall
			if wall~=0 then -- Break loop when reach a wall
				texture_vert = map.world_map[wall][2] -- Wall value
				texture_vert = wall -- Wall value
				break
			end

			-- Cast furhter
			x_vert = x_vert + dx
			y_vert = y_vert + dy
			depth_vert = depth_vert + delta_depth
		end


		local wall, id, slice
		if depth_vert < depth_hor then
			depth, wall, id = depth_vert, 1, texture_vert
			-- y_vert = y_vert % 1
		else
			depth, wall, id = depth_hor, 0,  texture_hor
			-- x_hor = x_hor % 1
		end


		if wall == 0 then
			slice = x_hor*64
		elseif wall == 1 then
			slice = y_vert*64
		end
		slice = math.floor(slice%64)+1


		-- Remove fishbowl effect
		-- depth = depth or -1
		depth = depth * math.cos(player.angle - ray_angle)
		table.insert(raycast.result, { depth, id, wall, slice, ray })

			
		-- end


		-- Draw for debug
		-- love.graphics.setColor(0, 0.5, 0)
		-- love.graphics.line(map.size * ox, map.size * oy, -- X1, X2
		-- 					map.size * ox + map.size * depth * cos_a, -- Y1
		-- 					map.size * oy + map.size * depth * sin_a-- Y2
		-- 				)
		-- -- Draw Walls
		-- color =  1 / (1 + depth^5 * 0.00002)
		-- love.graphics.setColor(color, color, color)
		-- love.graphics.rectangle('fill',
		-- 	ray * SCALE, HALF_HEIGHT - math.floor(proj_height / 2), -- X, Y
		-- 	SCALE, proj_height -- WIDTH, HEIGHT
		-- )


		-- raycast.objects_to_render[ray] = depth_hor
		ray_angle = ray_angle + DELTA_ANGLE -- Angle for each ray
	end
end

-- function raycast:draw()
function raycast:update()
	raycaster()
	get_objects_to_render()
end
