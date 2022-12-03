_ = false

-- Digital values = Walls
-- False values = Free space

map = {}
map.world_map = {}
map.size = 64
map.mini_map = {
	{ 1, 2, 3, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
	{ 1, _, _, _, _, _, _, _, _, _, _, _, _, _, _, 1 },
	{ 1, _, _, 1, 2, 4, 1, _, _, _, 1, 1, 1, _, _, 1 },
	{ 1, _, _, _, _, _, 1, _, _, _, _, _, 1, _, _, 1 },
	{ 1, _, _, _, _, _, 1, _, _, _, _, _, 1, _, _, 1 },
	{ 1, _, _, 1, 1, 2, 1, _, _, _, _, _, _, _, _, 1 },
	{ 1, _, _, _, _, _, _, _, _, _, _, _, _, _, _, 1 },
	{ 1, _, _, 1, _, _, _, _, 1, _, _, _, _, _, _, 1 },
	{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
}


function Map()
	for i, row in ipairs(map.mini_map) do
		for j, value in ipairs(row) do
			if value then
				table.insert(map.world_map, {{j-1, i-1}, value})
				-- map.world_map[tostring(j)..'-'..tostring(i)] = value
			end
		end
	end
end



-- Add mini map to world map
function map:draw()

	love.graphics.setColor(1, 1, 1)
	for i, pos in ipairs(map.world_map) do
		local x = pos[1][1] -- -1 -> Start at 0
		local y = pos[1][2]
		-- local value = pos[2]

		love.graphics.rectangle('line',
			x * map.size, y * map.size, -- X, Y
			map.size, map.size -- WIDTH, HEIGHT
		)
	end
end

-- Draw map to the screen
-- def draw(map):
-- 	[pg.draw.rect(map.game.screen, "darkgray", (pos[0] * map.size, pos[1] * map.size, map.size, map.size), 2) for pos in map.world_map]