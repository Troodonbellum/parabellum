-- intllib
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

--dofile(minetest.get_modpath("mobs").."/api.lua")

-- -- --
-- Wither --
-- -- --

mobs:register_mob("parabellum:wither", {
	type = "monster",
	passive = false,
	attacks_monsters = true,
	hp_max = 300,
	hp_min = 300,
	armor = 80,
	-- This deviates from MC Wiki's size, which makes no sense
	collisionbox = {-0.9, 0.4, -0.9, 0.9, 2.45, 0.9},
	visual = "mesh",
	mesh = "parabellum_wither.b3d",
	textures = {
		{"parabellum_wither.png"},
	},
	visual_size = {x=4, y=4},
	makes_footstep_sound = true,
	view_range = 16,
	fear_height = 4,
	walk_velocity = 2,
	run_velocity = 4,
	stepheight = 1.2,
	sounds = {
		shoot_attack = "parabellum_ender_dragon_shoot",
		attack = "parabellum_ender_dragon_attack",
		distance = 60,
	},
	jump = true,
	jump_height = 10,
	jump_chance = 98,
	fly = true,
	dogshoot_switch = 1,
	dogshoot_count_max =1,
	attack_animals = true,
	floats=1,
   drops = {
      {name = "default:diamond", chance = 1, min = 1, max = 1},
},
	water_damage = 8,
	lava_damage = 8,
	acid_damage = 8,
	light_damage = 0,
	attack_type = "dogshoot",
	explosion_radius = 3,
	explosion_fire = false,
	dogshoot_stop = true,
	arrow = "parabellum:fireball",
	reach = 5,
	shoot_interval = 0.5,
	shoot_offset = -1,
	animation = {
		walk_speed = 12, run_speed = 12, stand_speed = 12,
		stand_start = 0,		stand_end = 20,
		walk_start = 0,		walk_end = 20,
		run_start = 0,		run_end = 20,
	},
	blood_amount = 0,
})

local mobs_griefing = true --minetest.settings:get_bool("mobs_griefing") ~= false

mobs:register_arrow("parabellum:roar_of_the_dragon", {
	visual = "sprite",
	visual_size = {x = 1, y = 1},
	textures = {"blank.png"},
	velocity = 10,

	on_step = function(self, dtime)

		local pos = self.object:getpos()

		local n = minetest.get_node(pos).name

		if self.timer == 0 then
			self.timer = os.time()
		end

		if os.time() - self.timer > 8 or minetest.is_protected(pos, "") then
			self.object:remove()
		end

		local objects = minetest.get_objects_inside_radius(pos, 1)
	    for _,obj in ipairs(objects) do
			local name = self.name
			if name~="parabellum:roar_of_the_dragon" and name ~= "parabellum:wither" then
		        obj:set_hp(obj:get_hp()-0.05)
		        if (obj:get_hp() <= 0) then
		            if (not obj:is_player()) and name ~= self.object:get_luaentity().name then
		                obj:remove()
		            end
		        end
			end
	    end

		if mobs_griefing then
			minetest.set_node(pos, {name="air"})
			if math.random(1,2)==1 then
				local dx = math.random(-1,1)
				local dy = math.random(-1,1)
				local dz = math.random(-1,1)
				local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
				minetest.set_node(p, {name="air"})
			end
		end
	end
})
--GOOD LUCK LOL!
-- fireball (weapon)
local factions = minetest.get_modpath("factions") and factions

mobs:register_arrow(":parabellum:fireball", {
	visual = "sprite",
	visual_size = {x = 0.75, y = 0.75},
	-- TODO: 3D projectile, replace tetxture
	textures = {"parabellum_TEMP_wither_projectile.png"},
	velocity = 6,

	-- direct hit, no fire... just plenty of pain
	hit_player = function(self, player)
		minetest.sound_play("tnt_explode", {pos = self.object:getpos(), gain = 1.5, max_hear_distance = 16})
		player:punch(self.object, 1.0, {
			full_punch_interval = 0.5,
			damage_groups = {fleshy = 8},
		}, nil)

	end,

	hit_mob = function(self, player)
	minetest.sound_play("tnt_explode", {pos = self.object:getpos(), gain = 1.5,max_hear_distance = 16})
		player:punch(self.object, 1.0, {
			full_punch_interval = 0.5,
			damage_groups = {fleshy = 8},
		}, nil)
		
	end,

	-- node hit, bursts into flame
	hit_node = function(self, pos, node)
		-- FIXME: Deprecated, switch to mobs:boom instead
		if factions and factions.get_parcel_faction(factions.get_parcel_pos(pos)) then
			tnt.boom(
				pos,
				{
					radius = 2.5,
					damage_radius = 3,
					sound = self.sounds and self.sounds.explode,
					explode_center = true,
					ignore_protection = true,
				})
		else
			--mobs:explosion(pos, 2.5, 0, 1)
			mobs:boom(self, pos, 2.5)
		end
	end
})
--Spawn egg
mobs:register_egg("parabellum:wither", S("Wither"), "parabellum_spawn_icon_wither.png", 0)

--Compatibility
mobs:alias_mob("nssm:mese_dragon", "parabellum:wither") 
