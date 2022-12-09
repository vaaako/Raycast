function NPCSprite(x, y)
	NPC = AnimSprite(x, y, "resources/sprites/npc/soldier/idle/", 0.180, 0.6, 0.38) -- From AnimSprite

	-- npc.attack_images = getImages(npc.path .. "attack/")
	-- npc.death_images = getImages(npc.path .. "death/")
	-- npc.idle_images = getImages(npc.path .. "idle/")
	-- npc.pain_images = getImages(npc.path .. "pain/")
	-- npc.walk_images = getImages(npc.path .. "walk/")

	NPC.attack_dist = math.random(3, 6)
	NPC.speed = 0.03
	NPC.size = 10
	NPC.health = 100
	NPC.attack_damage = 10
	NPC.accuracy = 0.15
	NPC.alive = true
	NPC.pain = false -- Receiving damage


	function NPC:update()
		print("npc")
		self:check_animation_time()
		self:get_sprite()
	end
end