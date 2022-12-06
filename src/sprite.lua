sprites = {}
sprites.x, sprites.y = 10.5, 3.5

sprites.image = love.graphics.newImage("resources/sprites/static_sprites/candlebra.png")
sprites.IMAGE_WIDTH = sprites.image:getWidth()
sprites.IMAGE_HEIGHT = sprites.image:getHeight()
sprites.IMAGE_HALF_WIDTH = math.floor(sprites.IMAGE_WIDTH / 2)
sprites.IMAGE_RATIO = sprites.IMAGE_WIDTH / sprites.IMAGE_HEIGHT

sprites.dx, sprites.dy, sprites.theta, sprites.screen_x, sprites.dist, sprites.norm_dist = 0, 0, 0, 0, 1, 1

sprites.sprite_half_width = 0
sprites.SPRITE_SCALE = 0.7
sprites.SPRITE_HEIGHT_SHIFT = 0.27

sprites.toRender = {}

function hypot(x, y)
	return math.sqrt(x*x + y*y)
end


function get_sprite_projection()
	sprites.toRender = {}

	proj = SCREEN_DIST / sprites.norm_dist * sprites.SPRITE_SCALE
	proj_width, proj_height = proj * sprites.IMAGE_RATIO, proj

	
	-- image = pg.transform.scale(.image, (proj_width, proj_height))
	-- love.graphics.scale(proj_width, proj_height)
	image = sprites.image

	sprites.sprite_half_width = math.floor(proj_width / 2)
	height_shift = proj_height * sprites.SPRITE_HEIGHT_SHIFT
	posX = sprites.screen_x - sprites.sprite_half_width
	posY = HALF_HEIGHT - math.floor(proj_height / 2) + height_shift


	-- love.graphics.draw(image, posX, posY, 0, proj_width/image:getWidth(), proj_height/image:getHeight())
	table.insert(raycast.objects_to_render, { sprites.norm_dist, image, posX, posY, 0, proj_width/image:getWidth(), proj_height/image:getHeight(), nil })
end

function sprites:update()
	dx = sprites.x - player.x
	dy = sprites.y - player.y
	sprites.dx, sprites.dy = dx, dy
	sprites.theta = math.atan2(dy, dx)

	delta = sprites.theta - player.angle
	if (dx > 0 and player.angle > math.pi) or (dx < 0 and dy < 0) then
		delta = delta + TAU
	end

	delta_rays = delta / DELTA_ANGLE
	sprites.screen_x = (HALF_NUM_RAYS + delta_rays) * SCALE

	sprites.dist = hypot(dx, dy)
	sprites.norm_dist = sprites.dist * math.cos(delta)



	if -sprites.IMAGE_HALF_WIDTH < sprites.screen_x and -sprites.IMAGE_HALF_WIDTH < (WIDTH + sprites.IMAGE_HALF_WIDTH) and sprites.norm_dist > 0.5 then
		get_sprite_projection()
	end

end
