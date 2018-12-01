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
