local modpath = minetest.get_modpath("parabellum")

-- Load files


dofile(modpath .. "/functions.lua")
dofile(modpath .. "/epreuve.lua")
dofile(modpath .. "/paint.lua")
dofile(modpath .. "/box.lua")
dofile(modpath .. "/treasure_chest.lua")
dofile(modpath .. "/utils.lua")
--MOB ITEMS SELECTOR SWITCH

--Mob heads
dofile(modpath .. "/heads.lua")

--Monsters
dofile(modpath .. "/wither.lua")

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
