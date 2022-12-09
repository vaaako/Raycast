weapon = AnimSprite(0, 0, "resources/sprites/weapon/shotgun/", 0.090) -- All variables from AnimSprite()

weapon.scale = 0.4
weapon.x = HALF_WIDTH - math.floor(weapon.image:getWidth() / 2) / (2 / weapon.scale * 0.5)
weapon.y = HEIGHT - weapon.image:getHeight() / (2 / weapon.scale * 0.5)


weapon.reloading = false
weapon.num_images = #weapon.images
weapon.frame_counter = 0
weapon.damage = 50


function weapon:animate_shot()
	if self.reloading then
		player.shot = false -- Shoted
		if self.animation_trigger then -- Animation loop
			rotateTable(self.images)
			self.image = self.images[1]
			self.frame_counter = self.frame_counter + 1
			if self.frame_counter == self.num_images then -- On ending change variables
				self.reloading = false
				self.frame_counter = 0
			end
		end
	end
end


function weapon:draw()
	love.graphics.draw(weapon.image, weapon.x, weapon.y, 0, weapon.scale, weapon.scale)
end

function weapon:update()
	self:check_animation_time()
	self:animate_shot()
end