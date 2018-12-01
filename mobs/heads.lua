-- intllib
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

-- Heads system
local sounds
if minetest.get_modpath("default") then
	sounds = default.node_sound_defaults({
		footstep = {name="default_hard_footstep", gain=0.3}
	})
end

local function addhead(mobname, desc, longdesc)
	minetest.register_node("parabellum:head_"..mobname, {
		description = desc,
		_doc_items_longdesc = longdesc,
		drawtype = "nodebox",
		is_ground_content = false,
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.25, -0.5, -0.25, 0.25, 0.0, 0.25, },
			},
		},
		groups = { oddly_breakable_by_hand=3, head=1, },
		-- The head textures are based off the textures of an actual mob.
		-- FIXME: This code assumes 16×16 textures for the mob textures!
		tiles = {
			-- Note: bottom texture is overlaid over top texture to get rid of possible transparency.
			-- This is required for skeleton skull and wither skeleton skull.
			"[combine:16x16:-4,4=parabellum_"..mobname..".png", -- top
			"([combine:16x16:-4,4=parabellum_"..mobname..".png)^([combine:16x16:-12,4=parabellum_"..mobname..".png)", -- bottom
			"[combine:16x16:-12,0=parabellum_"..mobname..".png", -- left
			"[combine:16x16:4,0=parabellum_"..mobname..".png", -- right
			"[combine:16x16:-20,0=parabellum_"..mobname..".png", -- back
			"[combine:16x16:-4,0=parabellum_"..mobname..".png", -- front
		},
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		walkable = true,
		sounds = sounds,
		selection_box = {
			type = "fixed",
			fixed = { -0.25, -0.5, -0.25, 0.25, 0.0, 0.25, },
		},
	on_construct = function(pos, node, _)
			--	Air		 	Air		 	Air--
			--	Tête			Tête			Tête--
			--	Obsi			Obsi			Obsi--
			--	Air			Obsi			Air--
		local node1 = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z}).name
		local node2 = minetest.get_node({x=pos.x+1, y=pos.y+1, z=pos.z}).name
		local node3 = minetest.get_node({x=pos.x-1, y=pos.y+1, z=pos.z}).name
		local node4 = minetest.get_node({x=pos.x, y=pos.y, z=pos.z}).name
		local node5 = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z}).name
		local node6 = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z}).name	
		local node7 = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name	
		local node8 = minetest.get_node({x=pos.x+1, y=pos.y-1, z=pos.z}).name
		local node9 = minetest.get_node({x=pos.x-1, y=pos.y-1, z=pos.z}).name
		local node10 = minetest.get_node({x=pos.x, y=pos.y-2, z=pos.z}).name
		local node11 = minetest.get_node({x=pos.x+1, y=pos.y-2, z=pos.z}).name
		local node12 = minetest.get_node({x=pos.x-1, y=pos.y-2, z=pos.z}).name
		local node13 = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z+1}).name
		local node14 = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z-1}).name
		local node15 = minetest.get_node({x=pos.x, y=pos.y, z=pos.z+1}).name
		local node16 = minetest.get_node({x=pos.x, y=pos.y, z=pos.z-1}).name
		local node17 = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z+1}).name
		local node18 = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z-1}).name
		local node19 = minetest.get_node({x=pos.x, y=pos.y-2, z=pos.z+1}).name
		local node20 = minetest.get_node({x=pos.x, y=pos.y-2, z=pos.z-1}).name
		if node1 == "air" and node4 == "parabellum:head_wither_skeleton" and node7 == "default:obsidian" and node10 == "default:obsidian" then
			if node2 == "air" and node5 == "parabellum:head_wither_skeleton" and node8 == "default:obsidian" and node11 == "air" then
				if node3 == "air" and node6 == "parabellum:head_wither_skeleton" and node9 == "default:obsidian" and node12 == "air" then
		minetest.add_entity(pos, "parabellum:wither")
		minetest.remove_node({x=pos.x, y=pos.y-1, z=pos.z})
		minetest.remove_node({x=pos.x, y=pos.y-2, z=pos.z})
		minetest.remove_node({x=pos.x, y=pos.y, z=pos.z})
		minetest.remove_node({x=pos.x-1, y=pos.y-1, z=pos.z})
		minetest.remove_node({x=pos.x+1, y=pos.y-1, z=pos.z})
		minetest.remove_node({x=pos.x-1, y=pos.y, z=pos.z})
		minetest.remove_node({x=pos.x+1, y=pos.y, z=pos.z})
				end
			end
			if node13 == "air" and node15 == "parabellum:head_wither_skeleton" and node17 == "default:obsidian" and node19 == "air" then
				if node14 == "air" and node16 == "parabellum:head_wither_skeleton" and node18 == "default:obsidian" and node20 == "air" then
		minetest.add_entity(pos, "parabellum:wither")
		minetest.remove_node({x=pos.x, y=pos.y-1, z=pos.z})
		minetest.remove_node({x=pos.x, y=pos.y-2, z=pos.z})
		minetest.remove_node({x=pos.x, y=pos.y, z=pos.z})
		minetest.remove_node({x=pos.x, y=pos.y-1, z=pos.z-1})
		minetest.remove_node({x=pos.x, y=pos.y-1, z=pos.z+1})
		minetest.remove_node({x=pos.x, y=pos.y, z=pos.z-1})
		minetest.remove_node({x=pos.x, y=pos.y, z=pos.z+1})
				end
			end
		end
	end,
	})
end

-- Add heads
addhead("zombie", S("Zombie Head"), S("A zombie head is a small decorative block which resembles the head of a zombie."))
--addhead("creeper", S("Creeper Head"), S("A creeper head is a small decorative block which resembles the head of a creeper."))
addhead("skeleton", S("Skeleton Skull"), S("A skeleton skull is a small decorative block which resembles the skull of a skeleton."))
addhead("wither_skeleton", S("Wither Skeleton Skull"), S("A wither skeleton skull is a small decorative block which resembles the skull of a wither skeleton."))
