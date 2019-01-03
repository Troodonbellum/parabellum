-- -- --
-- Bronze Chest --
-- -- --

minetest.register_node("parabellum:bronze_chest", {
    description = ("The Bronze Chest"),

    tiles = {"parabellum_bronzechest.png"},

    groups = {cracky = 3},
    drop = "",
    paramtype2 = "facedir",
    can_dig = function(pos, player)
        local playerName = player:get_player_name();
        local meta = minetest.get_meta(pos);
        local privs = minetest.get_player_privs(playerName);

        if player:get_player_name() == privs.give then
            return true;
        else
            return false;
        end
    end,

	on_rightclick =
    function(nodePos, node, player, clicker, itemstack, pointed_thing)
        local playerName = player:get_player_name();
        local spos = nodePos.x..","..nodePos.y..","..nodePos.z;
        local privs = minetest.get_player_privs(playerName);
		local playerInv = player:get_inventory();
		local wielditem = player:get_wielded_item();
		local wieldname = wielditem:get_name();
		local iba = (item_bronze[math.random(1,#item_bronze)]);
		if wieldname == "parabellum:bronze_key" then
			itemStackToAdd = playerInv:add_item("main", iba);
			if not itemStackToAdd:is_empty() then
				local pos_drop = { x=nodePos.x, y=nodePos.y+1, z=nodePos.z }
				minetest.spawn_item(pos_drop,iba) 
			end
		else
			minetest.chat_send_player(playerName, ("You haven't the bronze key!"))
		end
			if not creative.is_enabled_for(playerName) and wieldname == "parabellum:bronze_key" then
				wielditem:take_item()
				player:set_wielded_item(wielditem)
				return wielditem
			end
	end
})
--------

-- -- --
-- Iron Chest --
-- -- --
minetest.register_node("parabellum:iron_chest", {
    description = ("The Iron Chest"),

    tiles = {"parabellum_ironchest.png"},

    groups = {cracky = 3},
    drop = "",
    paramtype2 = "facedir",
    can_dig = function(pos, player)
        local playerName = player:get_player_name();
        local meta = minetest.get_meta(pos);
        local privs = minetest.get_player_privs(playerName);

        if player:get_player_name() == privs.give then
            return true;
        else
            return false;
        end
    end,

	on_rightclick =
    function(nodePos, node, player, clicker, itemstack, pointed_thing)
        local playerName = player:get_player_name();
        local spos = nodePos.x..","..nodePos.y..","..nodePos.z;
        local privs = minetest.get_player_privs(playerName);
		local playerInv = player:get_inventory();
		local wielditem = player:get_wielded_item();
		local wieldname = wielditem:get_name();
		local ibi = (item_steel[math.random(1,#item_steel)]);
		if wieldname == "parabellum:iron_key" then
			itemStackToAdd = playerInv:add_item("main", ibi);
			if not itemStackToAdd:is_empty() then
				local pos_drop = { x=nodePos.x, y=nodePos.y+1, z=nodePos.z }
				minetest.spawn_item(pos_drop,ibi) 
			end
		else
			minetest.chat_send_player(playerName, ("You haven't the iron key!"))
		end
			if not creative.is_enabled_for(playerName) and wieldname == "parabellum:iron_key" then
				wielditem:take_item()
				player:set_wielded_item(wielditem)
				return wielditem
			end
	end
})
-------

-- -- --
-- Palladium Chest --
-- -- --
minetest.register_node("parabellum:palladium_chest", {
    description = ("The Palladium's Chest"),

    tiles = {"parabellum_palladiumchest.png"},

    groups = {cracky = 3},
    drop = "",
    paramtype2 = "facedir",
    can_dig = function(pos, player)
        local playerName = player:get_player_name();
        local meta = minetest.get_meta(pos);
        local privs = minetest.get_player_privs(playerName);

        if player:get_player_name() == privs.give then
            return true;
        else
            return false;
        end
    end,

	on_rightclick =
    function(nodePos, node, player, clicker, itemstack, pointed_thing)
        local playerName = player:get_player_name();
        local spos = nodePos.x..","..nodePos.y..","..nodePos.z;
        local privs = minetest.get_player_privs(playerName);
		local playerInv = player:get_inventory();
		local wielditem = player:get_wielded_item();
		local wieldname = wielditem:get_name();
		local ibp = (item_palladium[math.random(1,#item_palladium)]);
		if wieldname == "parabellum:palladium_key" then
			itemStackToAdd = playerInv:add_item("main", ibp);
			if not itemStackToAdd:is_empty() then
				local pos_drop = { x=nodePos.x, y=nodePos.y+1, z=nodePos.z }
				minetest.spawn_item(pos_drop,ibp) 
			end
		else
			minetest.chat_send_player(playerName, ("You haven't the palladium key!"))
		end
			if not creative.is_enabled_for(playerName) and wieldname == "parabellum:palladium_key" then
				wielditem:take_item()
				player:set_wielded_item(wielditem)
				return wielditem
			end
	end
})
 ------
 
-- -- --
-- Ultimate Chest --
-- -- --
minetest.register_node("parabellum:ultimate_chest", {
    description = ("The Ultimate Chest"),

    tiles = {"parabellum_ultimatechest.png"},

    groups = {cracky = 3},
    drop = "",
    paramtype2 = "facedir",
    can_dig = function(pos, player)
        local playerName = player:get_player_name();
        local meta = minetest.get_meta(pos);
        local privs = minetest.get_player_privs(playerName);

        if player:get_player_name() == privs.give then
            return true;
        else
            return false;
        end
    end,

	on_rightclick =
    function(nodePos, node, player, clicker, itemstack, pointed_thing)
        local playerName = player:get_player_name();
        local spos = nodePos.x..","..nodePos.y..","..nodePos.z;
        local privs = minetest.get_player_privs(playerName);
		local playerInv = player:get_inventory();
		local wielditem = player:get_wielded_item();
		local wieldname = wielditem:get_name();
		local ibu = (item_ulti[math.random(1,#item_ulti)]);
		if wieldname == "parabellum:ulti_key" then
			itemStackToAdd = playerInv:add_item("main", ibu);
			if not itemStackToAdd:is_empty() then
				local pos_drop = { x=nodePos.x, y=nodePos.y+1, z=nodePos.z }
				minetest.spawn_item(pos_drop,ibu) 
			end
		else
			minetest.chat_send_player(playerName, ("You haven't the ulti key!"))
		end
			if not creative.is_enabled_for(playerName) and wieldname == "parabellum:ulti_key" then
				wielditem:take_item()
				player:set_wielded_item(wielditem)
				return wielditem
			end
	end
})
--------
