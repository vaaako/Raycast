-- Get all images in a folder and add to a table
function getImages(path)
	image_names = love.filesystem.getDirectoryItems(path)

	images = {}
	for i = 1, #image_names do
		local p = path .. image_names[i]
		images[i] = love.graphics.newImage(p)
	end
	return images
end


function Sprite(sprite) -- Default values of sprites
	sprite.IMAGE_WIDTH = sprite.image:getWidth()
	sprite.IMAGE_HEIGHT = sprite.image:getHeight()
	sprite.IMAGE_HALF_WIDTH = math.floor(sprite.IMAGE_WIDTH/2)
	sprite.IMAGE_RATIO = sprite.IMAGE_WIDTH / sprite.IMAGE_HEIGHT

	sprite.dx, sprite.dy, sprite.theta, sprite.screen_x, sprite.dist, sprite.norm_dist = 0, 0, 0, 0, 1, 1
	sprite.sprite_half_width = 0
end




-- Static sprite object (constructor)
function StaticSprite(x, y, path) -- Function to add a new static sprite
	static_sprite = {}
	
	static_sprite.x, static_sprite.y = x, y -- Sprite location
	
	static_sprite.path = path or "resources/sprites/static_sprites/"
	static_sprite.image = static_sprite.path
	
	static_sprite.SPRITE_SCALE = 0.7 -- Sprite Size
	static_sprite.SPRITE_HEIGHT_SHIFT = 0.27 -- Sprite Z level

	-- Generic variables
	Sprite(static_sprite)

	-- Functions
	-- Call update function with self values
	function static_sprite:update()
		-- With self it is possible to use one function to multiples values
		sprite_update(self) -- Update with self values
	end



	return static_sprite
end


-- Animated sprite object (constructor)
function AnimSprite(x, y, path, scale, shift, time) -- Function to add a new animated sprite
	anim_sprite = {} -- Temp function to store all values
	anim_sprite.x, anim_sprite.y = x, y

	anim_sprite.path = path or "resources/sprites/animated_sprites/green_light/"
	anim_sprite.image = love.graphics.newImage(anim_sprite.path .. "0.png") -- First image to start
	anim_sprite.images = getImages(anim_sprite.path) -- Load all images in folder

	-- Animated Sprites variable
	anim_sprite.SPRITE_SCALE = scale or 0.8 -- Sprite Size
	anim_sprite.SPRITE_HEIGHT_SHIFT = shift or 0.15 -- Sprite Z level
	anim_sprite.animation_time = time or 0.120
	anim_sprite.animation_time_prev = love.timer.getTime() -- getTime is in microsseconds
	anim_sprite.animation_trigger = false

	-- Generic variables
	Sprite(anim_sprite)

	-- Functions
	function anim_sprite:update(sprite) -- Animated Sprites update
		sprite_update(self)
		-- animate(self, self.images)
		-- check_animation_time(self)
		self:animate(self.images)
		self:check_animation_time()
	end

	function anim_sprite:animate(images) -- Change sprite each trigger
		-- Make animation loop
		if self.animation_trigger then
			rotate(images) -- First index to last index
			self.image = images[1]
		end
	end

	function anim_sprite:check_animation_time() -- "Tell" to change sprite each time
		self.animation_trigger = false
		time_now = love.timer.getTime()

		if time_now - self.animation_time_prev > self.animation_time then
			self.animation_time_prev = time_now
			self.animation_trigger = true
		end
	end


	return anim_sprite -- Return table with all values
end

-- function animate(self, images) -- Change sprite each trigger
-- 	-- Make animation loop
-- 	if self.animation_trigger then
-- 		rotate(images) -- First index to last index
-- 		self.image = images[1]
-- 	end
-- end

-- function check_animation_time(self) -- "Tell" to change sprite each time
-- 	self.animation_trigger = false
-- 	time_now = love.timer.getTime()

-- 	if time_now - self.animation_time_prev > self.animation_time then
-- 		self.animation_time_prev = time_now
-- 		self.animation_trigger = true
-- 	end
-- end



function get_sprite_projection(sprite)
	proj = SCREEN_DIST / sprite.norm_dist * sprite.SPRITE_SCALE
	proj_width, proj_height = proj * sprite.IMAGE_RATIO, proj

	
	-- image = pg.transform.scale(.image, (proj_width, proj_height))
	-- love.graphics.scale(proj_width, proj_height)
	image = sprite.image

	sprite.sprite_half_width = math.floor(proj_width / 2)
	height_shift = proj_height * sprite.SPRITE_HEIGHT_SHIFT
	posX = sprite.screen_x - sprite.sprite_half_width
	posY = HALF_HEIGHT - math.floor(proj_height / 2) + height_shift


	-- love.graphics.draw(image, posX, posY, 0, proj_width/image:getWidth(), proj_height/image:getHeight())
	table.insert(raycast.objects_to_render, { sprite.norm_dist, image, posX, posY, 0, proj_width/image:getWidth(), proj_height/image:getHeight(), nil })
end

-- Update function to animated sprites and static sprites
function sprite_update(sprite) -- Self is equals to what function is calling it, if is sprites, then sprite.x is the same as sprites.x
	dx = sprite.x - player.x
	dy = sprite.y - player.y
	sprite.dx, sprite.dy = dx, dy
	sprite.theta = math.atan2(dy, dx)

	delta = sprite.theta - player.angle
	if (dx > 0 and player.angle > math.pi) or (dx < 0 and dy < 0) then
		delta = delta + TAU
	end

	delta_rays = delta / DELTA_ANGLE
	sprite.screen_x = (HALF_NUM_RAYS + delta_rays) * SCALE

	sprite.dist = hypot(dx, dy)
	sprite.norm_dist = sprite.dist * math.cos(delta)

	if -sprite.IMAGE_HALF_WIDTH < sprite.screen_x and -sprite.IMAGE_HALF_WIDTH < (WIDTH + sprite.IMAGE_HALF_WIDTH) and sprite.norm_dist > 0.5 then
		get_sprite_projection(sprite)
	end

end





-- Utils
-- Function to rotate table
function rotate(t)
	t[#t+1] = t[1] -- First index item to last index
	table.remove(t, 1) -- Remove first index
end

function hypot(x, y)
	return math.sqrt(x*x + y*y)
end