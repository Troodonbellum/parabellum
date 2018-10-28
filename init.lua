-- -- --
-- Echangeur --
-- -- --
minetest.register_craftitem("parabellum:echangeur", {
	description = ("Echangeur des 8 épreuves"),
	inventory_image = "parabellum_echangeur.png",
})

-- -- --
-- Trophée --
-- -- --

minetest.register_node("parabellum:trophy", {
	description = "Trophée des 8 épreuves",
	drawtype = "plantlike",
	waving = 1,
	tiles = {"parabellum_trophee.png"},
	inventory_image = "parabellum_trophee.png",
	wield_image = "parabellum_trophee.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, attached_node = 1},
	sounds = default.node_sound_metal_defaults(),
	light_source = 14,
	selection_box = {
		type = "fixed",
		fixed = {-0.3125, -0.5, -0.1875, 0.3125, 0.125, 0.1875},
	},
})

-- -- -- 
-- spawnpoint --
-- -- --

minetest.register_privilege("setspawn", {
	description = "Can use /setspawn command",
	give_to_singleplayer = false
})

minetest.register_chatcommand("setspawn", {
	params = "<name> <X>,<Y>,<Z>",
	description = "Set spawn of player to <X>,<Y>,<Z>",
	privs = {setspawn=true},
	func = function(name, param)
		local target = nil
		local p = {}
		local target_name = nil
		local lm = 31000
		target_name, p.x, p.y, p.z = param:match(
				"^([^ ]+) +([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+)$")
		if not target_name or not p.x or not p.y or not p.z then
			return false, "Invalid parameters (see /help setspawn)"
		elseif not core.get_auth_handler().get_auth(target_name) then
			return false, "Player " .. target_name .. " does not exist."
		end
		p.x, p.y, p.z = tonumber(p.x), tonumber(p.y), tonumber(p.z)
			if p.x < -lm or p.x > lm or p.y < -lm or p.y > lm or p.z < -lm or p.z > lm then
				return false, "Cannot spawn out of map bounds!"
			end
		if p.x and p.y and p.z then
		if target_name then
					if not core.get_player_by_name(target_name) then
							return false, "The player " .. target_name
										.. " is not online."
					end
			target = core.get_player_by_name(target_name)	
				minetest.register_on_respawnplayer(function(player)
					local player = core.get_player_by_name(target_name)
    					local pos = ({x=p.x, y=p.y, z=p.z})
						if pos then
							target:setpos(pos)
							return true
						end
end)
		end
	end
	return true, "Spawn of " ..target_name.. " set."
end
})
