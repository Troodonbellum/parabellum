local player = minetest.get_player_by_name()

local dig_range_increase = {}
dig_range_increase["parabellum:hammer"] = 1

local dig_hand_digable = true

minetest.register_craftitem("parabellum:super_stick", {
	description = "Super Stick",
	inventory_image = "parabellum_superstick.png",
	groups = {stick = 1},
})

minetest.register_tool("parabellum:hammer", {
   description = "Parabellum Hammer",
   inventory_image = "parabellum_hammer.png",
   tool_capabilities = {
      full_punch_interval = 0.9,
      max_drop_level=3,
      groupcaps={
         cracky = {times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=500, maxlevel=2},
      },
      damage_groups = {fleshy=5},
   },
   sound = {breaks = "default_tool_breaks"},
})

minetest.register_on_dignode(function(pos, oldnode, digger)
   if not digger then
      return
   end

   if digger:get_player_control().sneak then
      return
   end
   
   local wielded = digger:get_wielded_item()
   local wielded_name = wielded:get_name()
   local dri = dig_range_increase[wielded_name]
   if not dri then
      return
   end
   
   if digger:get_attribute("already_dried") == "true" then
      return
   else

      digger:set_attribute("already_dried", "true")
   end

   local l = digger:get_look_dir()
   local d = "x"
   if math.abs(l.x) < math.abs(l.y) then
      d = "y"
   else
      d = "x"
   end
   if math.abs(l[d]) < math.abs(l.z) then
      d = "z"
   end
   
   local node_poses = {}
   local yddri = dri
   local yudri = dri
   if yddri > 1 then
      yddri = 1
      yudri = dri*2-1
   end
   for x= -dri, dri do
      if x == 0 or d ~= "x" then
         for y = -yddri, yudri do
            if y == 0 or d ~= "y" then
               for z = -dri, dri do
                  if z == 0 or d ~= "z" then
                     local dig_pos = {x = pos.x+x, y = pos.y+y, z = pos.z+z}
                     table.insert(node_poses, dig_pos)
                  end
               end
            end
         end
      end
   end
   
   local tool_capabilities = wielded:get_tool_capabilities().groupcaps
   if dig_hand_digable then
      for i, e in pairs(ItemStack(":"):get_tool_capabilities().groupcaps) do
         if not tool_capabilities[i] then
            tool_capabilities[i] = e
         end
      end
   end
   
   for _, dig_pos in pairs(node_poses) do
      local node = minetest.get_node(dig_pos)
      for i, e in pairs(tool_capabilities) do
         if e.times[minetest.get_item_group(node.name, i)] and
               minetest.get_item_group(node.name, "level") <= e.maxlevel then
            minetest.node_dig(dig_pos, node, digger)
            break
         end
      end
   end
   
   digger:set_attribute("already_dried", "false")
end)

minetest.register_on_joinplayer(function(player)
   player:set_attribute("already_dried", "false")
end)

minetest.register_craft({
	output = 'parabellum:hammer',
	recipe = {
		{'xtraores:palladium_bar', 'xtraores:palladium_bar', 'xtraores:palladium_bar'},
		{'', 'parabellum:super_stick', ''},
		{'', 'parabellum:super_stick', ''},
	}
})
minetest.register_craft({
	output = 'parabellum:super_stick',
	recipe = {
		{'xtraores:platinium_bar', 'xtraores:platinium_bar', 'xtraores:platinium_bar'},
		{'', '', ''},
		{'', '', ''},
	}
})
