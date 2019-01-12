mobs:register_mob("parabellum:minotaur", {
	-- animal, monster, npc, barbarian
	type = "monster",
	-- aggressive, deals 11 damage to player when hit
	passive = false,
	attacks_monsters = false,
	attack_type = "dogfight",
	damage = 10,
	-- health & armor
	hp_min = 80,
	hp_max = 100,
	armor = 70,
	-- textures and model
collisionbox = {-0.9,-0.01,-0.9, 0.9,2.5,0.9},
	visual = "mesh",
	mesh = "parabellum_minotaur.b3d",
	textures = {
		{"parabellum_minotaur.png"},
	},
	visual_size = {x=1, y=1},
	blood_texture = "parabellum_blood.png",
	-- sounds
	makes_footstep_sound = true,
	sounds = {
		random = "parabellum_zombie",
		damage = "parabellum_zombie_hit",
		attack = "parabellum_zombie_attack",
		death = "parabellum_zombie_death",
	},
	-- speed and jump
	walk_velocity = 3,
	run_velocity = 4,
	jump = true,
	floats = 1,
	view_range = 16,
	--knock_back = 0.05,	--this is a test
	-- drops desert_sand and coins when dead
   drops = {
      {name = "throwing:bow_minotaur_horn",chance = 1, min = 1, maw = 1},	
      {name = "parabellum:minotaur_fur", chance = 50, min = 1, max = 1},
      {name = "parabellum:minotaur_eye", chance = 20, min = 1, max = 1},
      {name = "parabellum:minotaur_horn", chance = 50, min = 1, max = 1},
},
	water_damage = 1,
	lava_damage = 5,
	acid_damage = 5,
	light_damage = 0,
	-- model animation
	animation = {
		speed_normal = 15,		speed_run = 15,
		stand_start  = 0,		stand_end = 19,
		walk_start = 20,		walk_end  = 39,
		run_start  = 20,		run_end = 39,
		punch_start = 40,		punch_end = 50,
	},
})
-- spawns on desert sand between -1 and 20 light, 1 in 20000 chance, 1 Minotaur in area up to 31000 in height
mobs:spawn_specific("parabellum:minotaur", {"watershed:drygrass"}, {"air"}, -1, 20, 30, 100000, 1, -31000, 31000, false)
-- register spawn egg
mobs:register_egg("parabellum:minotaur", "Minotaur", "default_desert_sand.png", 1)

minetest.register_craftitem("parabellum:minotaur_eye", {
	description = "Minotaur Eye",
	inventory_image = "parabellum_minotaur_eye.png",
	groups = {magic = 1},
})

minetest.register_craftitem("parabellum:minotaur_horn", {
	description = "Minotaur Horn",
	inventory_image = "parabellum_minotaur_horn.png",
	groups = {magic = 1},
})

minetest.register_craftitem("parabellum:minotaur_fur", {
	description = "Minotaur Fur",
	inventory_image = "parabellum_minotaur_fur.png",
	groups = {magic = 1},
})

minetest.register_craftitem("parabellum:minotaur_lots_of_fur", {
	description = "Lot of Minotaur Fur",
	inventory_image = "parabellum_minotaur_lots_of_fur.png",
	groups = {magic = 1},
})

minetest.register_craft({
	output = "parabellum:minotaur_lots_of_fur",
	recipe = {{"parabellum:minotaur_fur", "parabellum:minotaur_fur"},
		{"parabellum:minotaur_fur", "parabellum:minotaur_fur"},
	},
})
