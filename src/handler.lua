handler = {}

-- Static and Anim
handler.sprite_list = {}
handler.static_sprite_path = "resources/sprites/static_sprites/"
handler.anim_sprite_path = "resources/sprites/animated_sprites/"

-- NPC
handler.npc_list = {}
handler.npc_sprite_path = "resources/sprites/npc/"


-- Add the table of sprites in one single table
function add_sprite(sprite)
	table.insert(handler.sprite_list, #handler.sprite_list+1, sprite)
end


function add_npc(npc)
	table.insert(handler.npc_list, #handler.npc_list+1, npc)
end


-- Update two table of sprites in one function
function handler:update()
	for _, sprite in ipairs(self.sprite_list) do
		sprite:update() -- Call sprite function from each table
	end

	-- for _, npc in ipairs(self.npc_list) do
	-- 	npc:udpate()
	-- end
end


-- Sprite map

-- Just to show how it works
-- add_sprite(StaticSprite( 10.5, 3.5, handler.static_sprite_path .. "candlebra.png" ))
-- add_sprite(AnimSprite( 11.5, 3.5, handler.anim_sprite_path .. "green_light/" ))

add_sprite(AnimSprite( 1.5, 1.5 ))
add_sprite(AnimSprite( 1.5, 7.5 ))

add_sprite(AnimSprite( 5.5, 3.25 ))
add_sprite(AnimSprite( 5.5, 4.75 ))

add_sprite(AnimSprite( 7.5, 2.5 ))
add_sprite(AnimSprite( 7.5, 5.5 ))

add_sprite(AnimSprite( 14.5, 1.5, handler.anim_sprite_path .. 'naldo/', 0.090, 0.3, 1 ))
-- add_sprite(AnimSprite( 14.5, 1.5 ))
add_sprite(AnimSprite( 14.5, 4.5 ))

add_sprite(AnimSprite( 14.5, 5.5, handler.anim_sprite_path .. 'red_light/' ))
add_sprite(AnimSprite( 14.5, 7.5, handler.anim_sprite_path .. 'red_light/' ))

add_sprite(AnimSprite( 12.5, 7.5, handler.anim_sprite_path .. 'red_light/' ))

-- NPC Map
-- add_npc(NPCSprite(10.5, 5.5))