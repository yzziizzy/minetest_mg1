-- TODO: replace with real things

minetest.register_node("fractal:stub_dry_shrub", {
	description = "Dry Shrub",
	drawtype = "plantlike",
	waving = 1,
	tiles = {"default_dry_shrub.png"},
	inventory_image = "default_dry_shrub.png",
	wield_image = "default_dry_shrub.png",
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 4,
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 3, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 4 / 16, 6 / 16},
	},
})

minetest.register_node("fractal:stub_gravel", {
	description = "Gravel",
	tiles = {"default_gravel.png"},
	groups = {crumbly = 2, falling_node = 1},
	sounds = default.node_sound_gravel_defaults(),
	drop = {
		max_items = 1,
		items = {
			-- {items = {"default:flint"}, rarity = 16},
			{items = {"fractal:stub_gravel"}}
		}
	}
})

local colorize_dune_grass = "^[colorize:red:50"
minetest.register_node("fractal:stub_dune_grass_3", {
    description = "Dune Grass",
    drawtype = "plantlike",
    waving = 1,
    tiles = {"default_grass_3.png"..colorize_dune_grass},
    -- Use texture of a taller grass stage in inventory
    inventory_image = "default_grass_3.png"..colorize_dune_grass,
    wield_image = "default_grass_3.png"..colorize_dune_grass,
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    buildable_to = true,
    pointable = true,
    groups = {
		snappy = 3,
		flora = 1,
		grass = 1,
		flammable = 1,
		squashable = 1,
	},
    sounds = default.node_sound_leaves_defaults(),
    selection_box = {
        type = "fixed",
        fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, -5 / 16, 6 / 16},
    },
    drop = {},
})

