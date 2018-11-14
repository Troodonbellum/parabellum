minetest.register_node("parabellum:paint", {
	description = "Picture of the Parabellum server",
	drawtype = "signlike",
	tiles = {"parabellum_paint.png"},
	visual_scale = 3.0,
	inventory_image = "parabellum_paint.png",
	wield_image = "parabellum_paint.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
groups = {attached_node = 1, oddly_breakable_by_hand = 1, snappy = 3}
})

minetest.register_node("parabellum:banner", {
	description = "Banner of the Parabellum server",
	drawtype = "signlike",
	tiles = {"parabellum_small_paint.png"},
	inventory_image = "parabellum_small_paint.png",
	wield_image = "parabellum_small_paint.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
groups = {attached_node = 1, oddly_breakable_by_hand = 1, snappy = 3}
})
