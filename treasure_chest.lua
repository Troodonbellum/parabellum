

dofile(minetest.get_modpath("parabellum") .. "/utils.lua")

local openedTreasureChestConfigs = {};

local metaStrType = "type";
local metaExpectedType = "traesurechest";
local metaStrOwner = "owner";
local metaIntRefresh = "refresh";
local metaInt0p = "0p";
local metaInt1p = "1p";
local metaInt2p = "2p";
local metaInt3p = "3p";
local metaInt4p = "4p";
local metaInt5p = "5p";

local fieldRefresh = "refresh_interval";
local fieldI0P = "i0p";
local fieldI1P = "i1p";
local fieldI2P = "i2p";
local fieldI3P = "i3p";
local fieldI4P = "i4p";
local fieldI5P = "i5p";
local buttonExit = "exit";

local strDescription = "A chest that gives semi-randomized rewards per player";
local strOneTime = "This is a one-time use chest, and you already got the reward!";
local strTooSoon = "To get another reward come back in ";
local strFromRefreshLabel = "Refresh time, in minutes, integer. E.g.: 60 = 1 hour, 1440 = 1 day, 10080 = 1 week";
local strProbabiltiesLabel = "Item probability of being given, integer, range 0..100: 0 = never, 100 = always";

-- -- --
-- Wood Chest --
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
        local owner = meta:get_string(metaStrOwner);

        if player:get_player_name() == owner or privs.give then
            return true;
        else
            return false;
        end
    end,

    after_place_node =
    function(pos, placer, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos);

        meta:set_string(metaStrOwner, placer:get_player_name());
        meta:set_int(metaIntRefresh, 1);
        meta:set_string(metaStrType, metaExpectedType);
        meta:set_int(metaInt0p, 100);
        meta:set_int(metaInt1p, 100);
        meta:set_int(metaInt2p, 100);
        meta:set_int(metaInt3p, 100);
        meta:set_int(metaInt4p, 100);
        meta:set_int(metaInt5p, 100);

        local inv = meta:get_inventory();
        inv:set_size("main", 6);
    end,

    on_rightclick =
    function(nodePos, node, player, clicker, itemstack, pointed_thing)
        local playerName = player:get_player_name();
        local spos = nodePos.x..","..nodePos.y..","..nodePos.z;
        local gameTime = minetest.get_gametime();
        local privs = minetest.get_player_privs(playerName);

        local meta = minetest.get_meta(nodePos);
        local owner = meta:get_string(metaStrOwner);
        local refresh = meta:get_int(metaIntRefresh);
        local i0p = meta:get_int(metaInt0p);
        local i1p = meta:get_int(metaInt1p);
        local i2p = meta:get_int(metaInt2p);
        local i3p = meta:get_int(metaInt3p);
        local i4p = meta:get_int(metaInt4p);
        local i5p = meta:get_int(metaInt5p);

        -- clean up some metadata
        local tmp = meta:to_table()
        local newMetaTable = tmp
        if refresh > 0 then
            for k,v in pairs(tmp["fields"]) do
                if  k ~= metaStrOwner
                and k ~= metaStrType
                and k ~= metaIntRefresh
                and k ~= metaInt0p
                and k ~= metaInt1p
                and k ~= metaInt2p
                and k ~= metaInt3p
                and k ~= metaInt4p
                and k ~= metaInt5p then
                    local tv = tonumber(v)
                    if tv then
                        diff = gameTime - tv
                        if diff > refresh * 60 then
                            newMetaTable["fields"] = table.removeKey(newMetaTable["fields"], k)
                        end
                    end
                end
            end
            meta:from_table(newMetaTable)
        end
        -- end clean-up

        if privs.server or owner == playerName then
            openedTreasureChestConfigs[playerName] = nodePos;
            minetest.show_formspec(playerName, "parabellum:setup_inventory",
                "size[8,8]" ..

                "field[0.2,0.2;7.0,0.9;"..fieldRefresh..";"..strFromRefreshLabel..";".. refresh .."]"..

                "label[0.2,0.6;"..strProbabiltiesLabel.."]"..

                "field[0.5,1.2;1,1;"..fieldI0P..";;"..i0p.."]"..
                "field[1.5,1.2;1,1;"..fieldI1P..";;"..i1p.."]"..
                "field[2.5,1.2;1,1;"..fieldI2P..";;"..i2p.."]"..
                "field[3.5,1.2;1,1;"..fieldI3P..";;"..i3p.."]"..
                "field[4.5,1.2;1,1;"..fieldI4P..";;"..i4p.."]"..
                "field[5.5,1.2;1,1;"..fieldI5P..";;"..i5p.."]"..

                "list[nodemeta:"..spos..";main;0.2,1.8;6.0,1.0;]"..
                "button_exit[1.0,2.8;3.0,1.0;"..buttonExit..";Save & Close]"..

                "list[current_player;main;0.0,4.0;8.0,4.0;]");

        else
            local lastTime = meta:get_int(playerName);
            local diff;
            if lastTime and lastTime > 0 then
                diff = gameTime - lastTime;
            else
                diff = refresh*60 + 1;
            end

            if refresh < 0 or diff <= refresh * 60 then
                local reason
                if refresh < 0 then
                    reason = strOneTime
                else
                    diff = (lastTime + refresh * 60) - gameTime
                    diff = math.floor(diff / 60 + 0.5)
                    local time = ""
                    if diff <= 1 then
                        time = "1 minute"
                    elseif diff < 60 then
                        time = diff .. " minutes"
                    elseif diff < 1440 then
                        time = math.floor(diff/60 + 0.5) .. " hours"
                    else
                        time = math.floor(diff/1440 + 0.5) .. " days"
                    end
                    reason = strTooSoon .. time
                end

                minetest.chat_send_player(playerName, reason);

            else
                local nodeInv = meta:get_inventory(); --minetest.get_inventory({type="node", pos=nodePos});
                local playerInv = player:get_inventory();
                local wielditem = player:get_wielded_item();
				local wieldname = wielditem:get_name();
                -- bit of hard-coding, relying we only have 6 slots. Consider that the formspec is also hardcoded, it's not a huge deal
                for index=0,5,1 do
                    local metaAccessString = index.."p";
                    local probability = meta:get_int(metaAccessString);
                    print("wield list name = "..player:get_wield_list());
					if wieldname == "parabellum:bronze_key" then
						if (randomCheck(probability)) then
                        local itemStackToAdd = nodeInv:get_stack("main", index+1);  -- +1 for inventory indexing begins at 1
                        itemStackToAdd = playerInv:add_item("main", itemStackToAdd);
                        if not itemStackToAdd:is_empty() then
                            minetest.item_drop(itemStackToAdd, player, player:get_pos());
                        end
						end
					else
						minetest.chat_send_player(playerName, ("You haven't the bronze key!"))
					end
					end
					if not creative.is_enabled_for(playerName) and wieldname == "parabellum:bronze_key" then
						wielditem:take_item()
						player:set_wielded_item(wielditem)
						return wielditem
					end
                end
                meta:set_int(playerName, gameTime)
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
        local owner = meta:get_string(metaStrOwner);

        if player:get_player_name() == owner or privs.give then
            return true;
        else
            return false;
        end
    end,

    after_place_node =
    function(pos, placer, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos);

        meta:set_string(metaStrOwner, placer:get_player_name());
        meta:set_int(metaIntRefresh, 1);
        meta:set_string(metaStrType, metaExpectedType);
        meta:set_int(metaInt0p, 100);
        meta:set_int(metaInt1p, 100);
        meta:set_int(metaInt2p, 100);
        meta:set_int(metaInt3p, 100);
        meta:set_int(metaInt4p, 100);
        meta:set_int(metaInt5p, 100);

        local inv = meta:get_inventory();
        inv:set_size("main", 6);
    end,

    on_rightclick =
    function(nodePos, node, player, clicker, itemstack, pointed_thing)
        local playerName = player:get_player_name();
        local spos = nodePos.x..","..nodePos.y..","..nodePos.z;
        local gameTime = minetest.get_gametime();
        local privs = minetest.get_player_privs(playerName);

        local meta = minetest.get_meta(nodePos);
        local owner = meta:get_string(metaStrOwner);
        local refresh = meta:get_int(metaIntRefresh);
        local i0p = meta:get_int(metaInt0p);
        local i1p = meta:get_int(metaInt1p);
        local i2p = meta:get_int(metaInt2p);
        local i3p = meta:get_int(metaInt3p);
        local i4p = meta:get_int(metaInt4p);
        local i5p = meta:get_int(metaInt5p);

        -- clean up some metadata
        local tmp = meta:to_table()
        local newMetaTable = tmp
        if refresh > 0 then
            for k,v in pairs(tmp["fields"]) do
                if  k ~= metaStrOwner
                and k ~= metaStrType
                and k ~= metaIntRefresh
                and k ~= metaInt0p
                and k ~= metaInt1p
                and k ~= metaInt2p
                and k ~= metaInt3p
                and k ~= metaInt4p
                and k ~= metaInt5p then
                    local tv = tonumber(v)
                    if tv then
                        diff = gameTime - tv
                        if diff > refresh * 60 then
                            newMetaTable["fields"] = table.removeKey(newMetaTable["fields"], k)
                        end
                    end
                end
            end
            meta:from_table(newMetaTable)
        end
        -- end clean-up

        if privs.server or owner == playerName then
            openedTreasureChestConfigs[playerName] = nodePos;
            minetest.show_formspec(playerName, "parabellum:setup_inventory",
                "size[8,8]" ..

                "field[0.2,0.2;7.0,0.9;"..fieldRefresh..";"..strFromRefreshLabel..";".. refresh .."]"..

                "label[0.2,0.6;"..strProbabiltiesLabel.."]"..

                "field[0.5,1.2;1,1;"..fieldI0P..";;"..i0p.."]"..
                "field[1.5,1.2;1,1;"..fieldI1P..";;"..i1p.."]"..
                "field[2.5,1.2;1,1;"..fieldI2P..";;"..i2p.."]"..
                "field[3.5,1.2;1,1;"..fieldI3P..";;"..i3p.."]"..
                "field[4.5,1.2;1,1;"..fieldI4P..";;"..i4p.."]"..
                "field[5.5,1.2;1,1;"..fieldI5P..";;"..i5p.."]"..

                "list[nodemeta:"..spos..";main;0.2,1.8;6.0,1.0;]"..
                "button_exit[1.0,2.8;3.0,1.0;"..buttonExit..";Save & Close]"..

                "list[current_player;main;0.0,4.0;8.0,4.0;]");

        else
            local lastTime = meta:get_int(playerName);
            local diff;
            if lastTime and lastTime > 0 then
                diff = gameTime - lastTime;
            else
                diff = refresh*60 + 1;
            end

            if refresh < 0 or diff <= refresh * 60 then
                local reason
                if refresh < 0 then
                    reason = strOneTime
                else
                    diff = (lastTime + refresh * 60) - gameTime
                    diff = math.floor(diff / 60 + 0.5)
                    local time = ""
                    if diff <= 1 then
                        time = "1 minute"
                    elseif diff < 60 then
                        time = diff .. " minutes"
                    elseif diff < 1440 then
                        time = math.floor(diff/60 + 0.5) .. " hours"
                    else
                        time = math.floor(diff/1440 + 0.5) .. " days"
                    end
                    reason = strTooSoon .. time
                end

                minetest.chat_send_player(playerName, reason);

            else
                local nodeInv = meta:get_inventory(); --minetest.get_inventory({type="node", pos=nodePos});
                local playerInv = player:get_inventory();
                local wielditem = player:get_wielded_item();
				local wieldname = wielditem:get_name();
                -- bit of hard-coding, relying we only have 6 slots. Consider that the formspec is also hardcoded, it's not a huge deal
                for index=0,5,1 do
                    local metaAccessString = index.."p";
                    local probability = meta:get_int(metaAccessString);
                    print("wield list name = "..player:get_wield_list());
					if wieldname == "parabellum:iron_key" then
						if (randomCheck(probability)) then
                        local itemStackToAdd = nodeInv:get_stack("main", index+1);  -- +1 for inventory indexing begins at 1
                        itemStackToAdd = playerInv:add_item("main", itemStackToAdd);
                        if not itemStackToAdd:is_empty() then
                            minetest.item_drop(itemStackToAdd, player, player:get_pos());
                        end
						end
					else
						minetest.chat_send_player(playerName, ("You haven't the iron key!"))
					end
					end
					if not creative.is_enabled_for(playerName) and wieldname == "parabellum:iron_key" then
						wielditem:take_item()
						player:set_wielded_item(wielditem)
						return wielditem
					end
                end
                meta:set_int(playerName, gameTime)
            end
        end
 })
-------

-- -- --
-- Palladium Chest --
-- -- --
minetest.register_node("parabellum:palladium_chest", {
    description = ("The Parabellum's Chest"),

    tiles = {"parabellum_palladiumchest.png"},

    groups = {cracky = 3},
    drop = "",
    paramtype2 = "facedir",
    can_dig = function(pos, player)
        local playerName = player:get_player_name();
        local meta = minetest.get_meta(pos);
        local privs = minetest.get_player_privs(playerName);
        local owner = meta:get_string(metaStrOwner);

        if player:get_player_name() == owner or privs.give then
            return true;
        else
            return false;
        end
    end,

    after_place_node =
    function(pos, placer, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos);

        meta:set_string(metaStrOwner, placer:get_player_name());
        meta:set_int(metaIntRefresh, 1);
        meta:set_string(metaStrType, metaExpectedType);
        meta:set_int(metaInt0p, 100);
        meta:set_int(metaInt1p, 100);
        meta:set_int(metaInt2p, 100);
        meta:set_int(metaInt3p, 100);
        meta:set_int(metaInt4p, 100);
        meta:set_int(metaInt5p, 100);

        local inv = meta:get_inventory();
        inv:set_size("main", 6);
    end,

    on_rightclick =
    function(nodePos, node, player, clicker, itemstack, pointed_thing)
        local playerName = player:get_player_name();
        local spos = nodePos.x..","..nodePos.y..","..nodePos.z;
        local gameTime = minetest.get_gametime();
        local privs = minetest.get_player_privs(playerName);

        local meta = minetest.get_meta(nodePos);
        local owner = meta:get_string(metaStrOwner);
        local refresh = meta:get_int(metaIntRefresh);
        local i0p = meta:get_int(metaInt0p);
        local i1p = meta:get_int(metaInt1p);
        local i2p = meta:get_int(metaInt2p);
        local i3p = meta:get_int(metaInt3p);
        local i4p = meta:get_int(metaInt4p);
        local i5p = meta:get_int(metaInt5p);

        -- clean up some metadata
        local tmp = meta:to_table()
        local newMetaTable = tmp
        if refresh > 0 then
            for k,v in pairs(tmp["fields"]) do
                if  k ~= metaStrOwner
                and k ~= metaStrType
                and k ~= metaIntRefresh
                and k ~= metaInt0p
                and k ~= metaInt1p
                and k ~= metaInt2p
                and k ~= metaInt3p
                and k ~= metaInt4p
                and k ~= metaInt5p then
                    local tv = tonumber(v)
                    if tv then
                        diff = gameTime - tv
                        if diff > refresh * 60 then
                            newMetaTable["fields"] = table.removeKey(newMetaTable["fields"], k)
                        end
                    end
                end
            end
            meta:from_table(newMetaTable)
        end
        -- end clean-up

        if privs.server or owner == playerName then
            openedTreasureChestConfigs[playerName] = nodePos;
            minetest.show_formspec(playerName, "parabellum:setup_inventory",
                "size[8,8]" ..

                "field[0.2,0.2;7.0,0.9;"..fieldRefresh..";"..strFromRefreshLabel..";".. refresh .."]"..

                "label[0.2,0.6;"..strProbabiltiesLabel.."]"..

                "field[0.5,1.2;1,1;"..fieldI0P..";;"..i0p.."]"..
                "field[1.5,1.2;1,1;"..fieldI1P..";;"..i1p.."]"..
                "field[2.5,1.2;1,1;"..fieldI2P..";;"..i2p.."]"..
                "field[3.5,1.2;1,1;"..fieldI3P..";;"..i3p.."]"..
                "field[4.5,1.2;1,1;"..fieldI4P..";;"..i4p.."]"..
                "field[5.5,1.2;1,1;"..fieldI5P..";;"..i5p.."]"..

                "list[nodemeta:"..spos..";main;0.2,1.8;6.0,1.0;]"..
                "button_exit[1.0,2.8;3.0,1.0;"..buttonExit..";Save & Close]"..

                "list[current_player;main;0.0,4.0;8.0,4.0;]");

        else
            local lastTime = meta:get_int(playerName);
            local diff;
            if lastTime and lastTime > 0 then
                diff = gameTime - lastTime;
            else
                diff = refresh*60 + 1;
            end

            if refresh < 0 or diff <= refresh * 60 then
                local reason
                if refresh < 0 then
                    reason = strOneTime
                else
                    diff = (lastTime + refresh * 60) - gameTime
                    diff = math.floor(diff / 60 + 0.5)
                    local time = ""
                    if diff <= 1 then
                        time = "1 minute"
                    elseif diff < 60 then
                        time = diff .. " minutes"
                    elseif diff < 1440 then
                        time = math.floor(diff/60 + 0.5) .. " hours"
                    else
                        time = math.floor(diff/1440 + 0.5) .. " days"
                    end
                    reason = strTooSoon .. time
                end

                minetest.chat_send_player(playerName, reason);

            else
                local nodeInv = meta:get_inventory(); --minetest.get_inventory({type="node", pos=nodePos});
                local playerInv = player:get_inventory();
                local wielditem = player:get_wielded_item();
				local wieldname = wielditem:get_name();
                -- bit of hard-coding, relying we only have 6 slots. Consider that the formspec is also hardcoded, it's not a huge deal
                for index=0,5,1 do
                    local metaAccessString = index.."p";
                    local probability = meta:get_int(metaAccessString);
                    print("wield list name = "..player:get_wield_list());
					if wieldname == "parabellum:parabellum_key" then
						if (randomCheck(probability)) then
                        local itemStackToAdd = nodeInv:get_stack("main", index+1);  -- +1 for inventory indexing begins at 1
                        itemStackToAdd = playerInv:add_item("main", itemStackToAdd);
                        if not itemStackToAdd:is_empty() then
                            minetest.item_drop(itemStackToAdd, player, player:get_pos());
                        end
						end
					else
						minetest.chat_send_player(playerName, ("You haven't the parabellum key!"))
					end
					end
					if not creative.is_enabled_for(playerName) and wieldname == "parabellum:palladium_key" then
						wielditem:take_item()
						player:set_wielded_item(wielditem)
						return wielditem
					end
                end
                meta:set_int(playerName, gameTime)
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
        local owner = meta:get_string(metaStrOwner);

        if player:get_player_name() == owner or privs.give then
            return true;
        else
            return false;
        end
    end,

    after_place_node =
    function(pos, placer, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos);

        meta:set_string(metaStrOwner, placer:get_player_name());
        meta:set_int(metaIntRefresh, 1);
        meta:set_string(metaStrType, metaExpectedType);
        meta:set_int(metaInt0p, 100);
        meta:set_int(metaInt1p, 100);
        meta:set_int(metaInt2p, 100);
        meta:set_int(metaInt3p, 100);
        meta:set_int(metaInt4p, 100);
        meta:set_int(metaInt5p, 100);

        local inv = meta:get_inventory();
        inv:set_size("main", 6);
    end,

    on_rightclick =
    function(nodePos, node, player, clicker, itemstack, pointed_thing)
        local playerName = player:get_player_name();
        local spos = nodePos.x..","..nodePos.y..","..nodePos.z;
        local gameTime = minetest.get_gametime();
        local privs = minetest.get_player_privs(playerName);

        local meta = minetest.get_meta(nodePos);
        local owner = meta:get_string(metaStrOwner);
        local refresh = meta:get_int(metaIntRefresh);
        local i0p = meta:get_int(metaInt0p);
        local i1p = meta:get_int(metaInt1p);
        local i2p = meta:get_int(metaInt2p);
        local i3p = meta:get_int(metaInt3p);
        local i4p = meta:get_int(metaInt4p);
        local i5p = meta:get_int(metaInt5p);

        -- clean up some metadata
        local tmp = meta:to_table()
        local newMetaTable = tmp
        if refresh > 0 then
            for k,v in pairs(tmp["fields"]) do
                if  k ~= metaStrOwner
                and k ~= metaStrType
                and k ~= metaIntRefresh
                and k ~= metaInt0p
                and k ~= metaInt1p
                and k ~= metaInt2p
                and k ~= metaInt3p
                and k ~= metaInt4p
                and k ~= metaInt5p then
                    local tv = tonumber(v)
                    if tv then
                        diff = gameTime - tv
                        if diff > refresh * 60 then
                            newMetaTable["fields"] = table.removeKey(newMetaTable["fields"], k)
                        end
                    end
                end
            end
            meta:from_table(newMetaTable)
        end
        -- end clean-up

        if privs.server or owner == playerName then
            openedTreasureChestConfigs[playerName] = nodePos;
            minetest.show_formspec(playerName, "parabellum:setup_inventory",
                "size[8,8]" ..

                "field[0.2,0.2;7.0,0.9;"..fieldRefresh..";"..strFromRefreshLabel..";".. refresh .."]"..

                "label[0.2,0.6;"..strProbabiltiesLabel.."]"..

                "field[0.5,1.2;1,1;"..fieldI0P..";;"..i0p.."]"..
                "field[1.5,1.2;1,1;"..fieldI1P..";;"..i1p.."]"..
                "field[2.5,1.2;1,1;"..fieldI2P..";;"..i2p.."]"..
                "field[3.5,1.2;1,1;"..fieldI3P..";;"..i3p.."]"..
                "field[4.5,1.2;1,1;"..fieldI4P..";;"..i4p.."]"..
                "field[5.5,1.2;1,1;"..fieldI5P..";;"..i5p.."]"..

                "list[nodemeta:"..spos..";main;0.2,1.8;6.0,1.0;]"..
                "button_exit[1.0,2.8;3.0,1.0;"..buttonExit..";Save & Close]"..

                "list[current_player;main;0.0,4.0;8.0,4.0;]");

        else
            local lastTime = meta:get_int(playerName);
            local diff;
            if lastTime and lastTime > 0 then
                diff = gameTime - lastTime;
            else
                diff = refresh*60 + 1;
            end

            if refresh < 0 or diff <= refresh * 60 then
                local reason
                if refresh < 0 then
                    reason = strOneTime
                else
                    diff = (lastTime + refresh * 60) - gameTime
                    diff = math.floor(diff / 60 + 0.5)
                    local time = ""
                    if diff <= 1 then
                        time = "1 minute"
                    elseif diff < 60 then
                        time = diff .. " minutes"
                    elseif diff < 1440 then
                        time = math.floor(diff/60 + 0.5) .. " hours"
                    else
                        time = math.floor(diff/1440 + 0.5) .. " days"
                    end
                    reason = strTooSoon .. time
                end

                minetest.chat_send_player(playerName, reason);

            else
                local nodeInv = meta:get_inventory(); --minetest.get_inventory({type="node", pos=nodePos});
                local playerInv = player:get_inventory();
                local wielditem = player:get_wielded_item();
				local wieldname = wielditem:get_name();
                -- bit of hard-coding, relying we only have 6 slots. Consider that the formspec is also hardcoded, it's not a huge deal
                for index=0,5,1 do
                    local metaAccessString = index.."p";
                    local probability = meta:get_int(metaAccessString);
                    print("wield list name = "..player:get_wield_list());
					if wieldname == "parabellum:ulti_key" then
						if (randomCheck(probability)) then
                        local itemStackToAdd = nodeInv:get_stack("main", index+1);  -- +1 for inventory indexing begins at 1
                        itemStackToAdd = playerInv:add_item("main", itemStackToAdd);
                        if not itemStackToAdd:is_empty() then
                            minetest.item_drop(itemStackToAdd, player, player:get_pos());
                        end
						end
					else
						minetest.chat_send_player(playerName, ("You haven't the ultimate key!"))
					end
					end
					if not creative.is_enabled_for(playerName) and wieldname == "parabellum:ulti_key" then
						wielditem:take_item()
						player:set_wielded_item(wielditem)
						return wielditem
					end
                end
                meta:set_int(playerName, gameTime)
            end
        end
 })
--------

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname == "parabellum:setup_inventory" then
        local playerName = player:get_player_name();

        if (not fields[fieldRefresh]) then
            -- User cancelled, quit now
            return true;
        end

        local pos = openedTreasureChestConfigs[playerName];
        if pos == nil then
            return;
        end
        openedTreasureChestConfigs[playerName] = nil;

        local meta = minetest.get_meta(pos);
        if meta:get_string(metaStrType) ~= metaExpectedType then
            return;
        end

        meta:set_int(metaIntRefresh, clamp(toNum(fields[fieldRefresh], meta:get_int(metaIntRefresh)), -1, nil) );
        meta:set_int(metaInt0p, clamp(toNum(fields[fieldI0P], meta:get_int(metaInt0p)), 0, 100));
        meta:set_int(metaInt1p, clamp(toNum(fields[fieldI1P], meta:get_int(metaInt1p)), 0, 100));
        meta:set_int(metaInt2p, clamp(toNum(fields[fieldI2P], meta:get_int(metaInt2p)), 0, 100));
        meta:set_int(metaInt3p, clamp(toNum(fields[fieldI3P], meta:get_int(metaInt3p)), 0, 100));
        meta:set_int(metaInt4p, clamp(toNum(fields[fieldI4P], meta:get_int(metaInt4p)), 0, 100));
        meta:set_int(metaInt5p, clamp(toNum(fields[fieldI5P], meta:get_int(metaInt5p)), 0, 100));
        return true
    end
    return false
end)

minetest.register_on_leaveplayer(function(player)
    local playerName = player:get_player_name()
    openedTreasureChestConfigs[playerName] = nil;
end)
