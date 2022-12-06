handler = {}
handler.sprite_list = {}
handler.static_sprite_path = "resources/sprites/static_sprites/"
handler.anim_sprite_path = "resources/sprites/animated_sprites/"

-- Add the table of sprites in one single table
function add_sprite(sprite)
	table.insert(handler.sprite_list, #handler.sprite_list+1, sprite)
end

-- Update two table of sprites in one function
function handler:update()
	for _, sprite in ipairs(handler.sprite_list) do
		sprite:update() -- Call sprite function from each table
	end
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
add_sprite(AnimSprite( 14.5, 1.5 ))
add_sprite(AnimSprite( 14.5, 4.5 ))
add_sprite(AnimSprite( 14.5, 5.5, handler.anim_sprite_path .. 'red_light/' ))
add_sprite(AnimSprite( 14.5, 7.5, handler.anim_sprite_path .. 'red_light/' ))
add_sprite(AnimSprite( 12.5, 7.5, handler.anim_sprite_path .. 'red_light/' ))