raycast = {}
raycast.result = {}
raycast.objects_to_render = {}


--[[
def get_objects_to_render(self):
	self.objects_to_render = []
	for ray, values in enumerate(self.ray_casting_result):
		depth, proj_height, texture, offset = values

		print("Depth: "+str(depth)+"\nproj_height: "+str(proj_height)+"\ntexture: "+str(texture)+"\noffset: "+str(offset))

		wall_column = self.textures[texture].subsurface(
			offset * (TEXTURE_SIZE - SCALE), 0, SCALE, TEXTURE_SIZE
		)
		wall_column = pg.transform.scale(wall_column, (SCALE, proj_height))
		wall_pos = (ray * SCALE, HALF_HEIGHT - proj_height // 2)


		self.objects_to_render.append((depth, wall_column, wall_pos))
--]]

-- Bascically calculations to make rays :P
-- function raycast:draw()


function shootRay(theta)
	local tan = math.tan(theta)

	local distV, distH = nil,nil
	local idV,idH

	local x,y = player.pos.x,player.pos.y
	local dirX, dirY = math.cos(theta), math.sin(theta)

	local dx, dy = 0,0
	if dirX > 0 then
		dx = math.ceil(x)-x
	elseif dirX < 0 then
		dx = math.floor(x)-x
	end

	if dirY > 0 then
		dy = math.ceil(y)-y
	elseif dirY < 0 then
		dy = math.floor(y)-y
	end
	

	local curXH,curXV,curYH,curYV

	--distH, checking for horizontally aligned walls
	if dirY ~= 0 then
		local nx, ny = dy/tan,dy
		local stepX, stepY = 1/tan,1
		local offset=0

		if dirY < 0 then
			stepX = -1*stepX
			stepY = -1*stepY
			offset = 1
		end

		curXH, curYH = x+nx, y+ny
		for _=1,dof do
			local intX, intY = math.floor(curXH),curYH-offset
			if intX > 0 and intX <= mapWidth and intY > 0 and intY <= mapHeight and map[intY][intX] > 0 then
				distH = dist(x,y,curXH,curYH)
				idH = map[intY][intX]
				break
			end
			curXH = curXH + stepX
			curYH = curYH + stepY
		end
	end

	--distV, check for vertically aligned walls
	if dirX ~= 0 then
		local nx, ny = dx, dx*tan
		local stepX, stepY = 1,tan
		local offset=0
		if dirX < 0 then
			stepX = -1*stepX
			stepY = -1*stepY
			offset = 1
		end


		curXV, curYV = x+nx, y+ny
		for _=1, dof do
			local intX, intY = curXV-offset,math.floor(curYV)
			if intX > 0 and intX <= mapWidth and intY > 0 and intY <= mapHeight and map[intY][intX] > 0 then
				distV = dist(x,y,curXV,curYV)
				idV = map[intY][intX]
				break
			end
			curXV = curXV + stepX
			curYV = curYV + stepY
		end
	end

	--return shortest existing distance or -1
	--also return 0 if horizontal wall hit or 1 if vertical wall hit
	--also return id of wall
	--also return slice of wall hit (1-64)
	local dist,wall,id,slice

	if not distV then
		dist = distH
		wall = 0
		id=idH

	elseif not distH then
		dist = distV
		wall = 1
		id=idV

	elseif distV < distH then
		dist = distV
		wall = 1
		id=idV

	else
		dist = distH
		wall = 0
		id=idH
	end

	dist = dist or -1

	if wall == 0 then
		slice = curXH*64
	elseif wall == 1 then
		slice = curYV*64
	end
	slice = math.floor(slice%64)+1


	return dist, wall, id, slice
end



function raycasting()
	renderer.result = {}
	ox, oy = player_pos() -- Coordinates of the player on the map
	x_map, y_map = map_pos() -- Coordinates of his tile

	texture_vert, texture_hor = 1, 1

	-- Angle for the first ray
	ray_angle = player.angle - HALF_FOV + 0.0001 -- Add small value to avoid division by zero

	for ray = 0, NUM_RAYS do
		sin_a = math.sin(ray_angle)
		cos_a = math.cos(ray_angle)

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
			tile_hor = { math.floor(x_hor), math.floor(y_hor) }
			local wall = check_wall(tile_hor[1], tile_hor[2])

			if wall~=0 then
				texture_hor = map.world_map[wall][2]
				break
			end
			-- if tile_hor in self.game.map.world_map then
			-- 	break
			-- end

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
			tile_vert = { math.floor(x_vert), math.floor(y_vert) }
			local wall = check_wall(tile_vert[1], tile_vert[2])

			-- Stumble on wall
			if wall~=0 then -- Break loop when reacha wall
				texture_vert = map.world_map[wall][2] -- Wall value
				break
			end

			-- if tile_vert in self.game.map.world_map then
			-- 	break
			-- end

			-- Cast furhter
			x_vert = x_vert + dx
			y_vert = y_vert + dy
			depth_vert = depth_vert + delta_depth
		end

		-- Depth
		-- if depth_vert < depth_hor then
		-- 	depth = depth_vert
		-- else
		-- 	depth = depth_hor
		-- end

		-- Depth, Texture offset
		-- if depth_vert < depth_hor then
		-- 	depth, texture = depth_vert, texture_vert
		-- 	y_vert = y_vert % 1
		-- 	offset = (cos_a > 0) and y_vert or (1 - y_vert)
		-- else
		-- 	depth, texture = depth_hor, texture_hor
		-- 	x_hor = x_hor % 1
		-- 	offset = (sin_a > 0) and (1 - x_hor) or x_hor
		-- end




		-- TEXTURE STARTS HERE

		local wall,id,slice
		if depth_vert < depth_hor then
			depth, wall, id = depth_vert, 1, texture_vert
			y_vert = y_vert % 1
		else
			depth, wall, id = depth_hor, 0,  texture_hor
			x_hor = x_hor % 1
		end


		-- if not depth_vert then
		-- 	depth = depth_hor
		-- 	wall = 0
		-- 	id=texture_hor

		-- elseif not depth_hor then
		-- 	depth = depth_vert
		-- 	wall = 1
		-- 	id=texture_vert

		-- elseif depth_vert < depth_hor then
		-- 	depth = depth_vert
		-- 	wall = 1
		-- 	id=texture_vert

		-- else
		-- 	depth = depth_hor
		-- 	wall = 0
		-- 	id=texture_hor
		-- end


		depth = depth or -1

		-- if wall == 0 then
		-- 	slice = curXH*64
		-- elseif wall == 1 then
		-- 	slice = curYV*64
		-- end
		-- slice = math.floor(slice%64)+1

		if wall == 0 then
			slice = x_hor*64
		elseif wall == 1 then
			slice = y_vert*64
		end
		slice = math.floor(slice%64)+1


		-- Remove fishbowl effect
		depth = depth * math.cos(player.angle - ray_angle)

		-- Projection
		proj_height = SCREEN_DIST / (depth + 0.0001)


		-- for i=1, WIDTH do
		
			if proj_height > 0 then
				local c = 1 - depth/20
				-- if texture == 1 then
				-- 	c = c-0.1
				-- 	love.graphics.setColor(c,0,0)
				-- elseif texture == 2 then
				-- 	love.graphics.setColor(0,0,c)
				-- end
				
				love.graphics.setColor(c, c, c) -- Shadow
				if slice > 0 and slice <= 64 then
					-- DEFAULT
					-- love.graphics.draw(
					-- 	wallTextures[id], texSlice[slice],
					-- 	(i-1)*wratio()+wratio()/2, (100-HEIGHT/depth)*hratio(),
					-- 	0,
					-- 	wratio(),6.25/depth*hratio()
					-- )

					love.graphics.draw(
						wallTextures[id], texSlice[slice],
						ray * SCALE, HALF_HEIGHT - math.floor(proj_height / 2),
						0,
						SCALE, 6.25/depth*hratio()
						-- wratio(), 6.25/depth*hratio()
					)

					-- ADAPTED
					-- love.graphics.draw(
					-- 	wallTextures[texture], texSlice[slice], -- Texture, Quad
					-- 	ray * SCALE, HALF_HEIGHT - math.floor(proj_height / 2), -- X, Y
					-- 	0, -- Rotation
					-- 	-- wratio(), 6.25/depth*hratio()
					-- 	SCALE, 6.25/depth*hratio()
					-- )
				end

			end
		-- end

		-- Draw for debug
		-- love.graphics.setColor(0, 1, 1)
		-- love.graphics.line(map.size * ox, map.size * oy, -- X1, X2
		-- 					map.size * ox + map.size * depth * cos_a, -- Y1
		-- 					map.size * oy + map.size * depth * sin_a-- Y2
		-- 				)
		-- Draw Walls
		-- color =  1 / (1 + depth^5 * 0.00002)
		-- love.graphics.setColor(color, color, color)
		-- love.graphics.rectangle('fill',
		-- 	ray * SCALE, HALF_HEIGHT - math.floor(proj_height / 2), -- X, Y
		-- 	SCALE, proj_height -- WIDTH, HEIGHT
		-- )


		ray_angle = ray_angle + DELTA_ANGLE -- Angle for each ray
	end

end


function raycast:draw()
	raycasting()
	-- get_objects_to_render()
end