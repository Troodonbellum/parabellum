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

minetest.register_node("parabellum:trophee", {
tiles = {"parabellum_trophee.png"},
description = "Trophée des 8 épreuves",
inventory_image = "parabellum_trophee.png",
groups={snappy=2,choppy=2,oddly_breakable_by_hand=2},
light_source = 14,
})
