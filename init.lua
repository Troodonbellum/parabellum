local modpath = minetest.get_modpath("parabellum")

-- Load files
dofile(modpath .. "/functions.lua")
dofile(modpath .. "/utils.lua")

--Box
dofile(modpath .. "/box/box.lua")
dofile(modpath .. "/box/item_list.lua")
dofile(modpath .. "/box/treasure_chest.lua")

--Hammer
dofile(modpath .. "/hammer/hammer.lua")

--Mobs
dofile(modpath .. "/mobs/heads.lua")
dofile(modpath .. "/mobs/wither.lua")
dofile(modpath .. "/mobs/minotaur.lua")

--Parabellum_Nodes
dofile(modpath .. "/parabellum_nodes/epreuve.lua")				--Echangeur & Trophé
dofile(modpath .. "/parabellum_nodes/paint.lua")					--Bannière

if not minetest.get_modpath("parabellum_gameconfig") then
	parabellum = {}
end

-- For utility functions
parabellum.tools = {}

-- This function checks if the item ID has been overwritten and returns true if it is unchanged
if minetest.get_modpath("parabellum_gameconfig") and parabellum.override and parabellum.override.items then
	parabellum.is_item_variable_overridden = function(id)
		return parabellum.override.items[id] == nil
	end
else
	-- No items are overwritten, so always return true
	parabellum.is_item_variable_overridden = function(id)
		return true
	end
end


if minetest.settings:get_bool("log_mods") then
	minetest.log("action", "[MOD] Mobs Redo 'MC' loaded")
end
