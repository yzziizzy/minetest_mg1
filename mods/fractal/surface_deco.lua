-- [ Steppes ] --
default.register_surface_deco({
	name = "grass",
	description = "Grass",

	y_min = 1,
	y_max = 200,
	y_rand = 1, -- feather the edges of the y limits
	biomes = {"cool_steppe", "warm_steppe"}, -- list of biomes to appear in
	lat_min = 0,
	lat_max = 12000,
	lat_rand = 1, -- feather the edges of the lat limits
	lat_abs = true, -- appears in northern and southern hemicubes

	type = "blob",
	chance = 5,
	place_on = {"fractal:dirt_with_grass_T4W2", "fractal:dirt_with_grass_T5W2"},

	place = {"fractal:grass_1", "fractal:grass_2", "fractal:grass_3", "fractal:grass_4", "fractal:grass_5"}, -- randomly chosen list of nodes to place
	y_offset = 0, -- directly on top of the soil
})



-- [ Forests ] --
default.register_surface_deco({
	name = "birch_forest",
	description = "Birch Tree Groves",

	y_min = 5,
	y_max = 100,
	y_rand = 2, -- feather the edges of the y limits
	biomes = {"boreal_forest", "boreal_wet_forest", "boreal_rain_forest"}, -- list of biomes to appear in
	lat_min = 0,
	lat_max = 12000,
	lat_rand = 200, -- feather the edges of the lat limits
	lat_abs = true, -- appears in northern and southern hemicubes

	type = "density",
	chance = 20, -- once every 20 nodes, if it would have been placed otherwise
	noise = { -- filter with these noise params
		offset = -98, -- nodes are placed when the noise is greater than 1
		scale = 100,     -- according to math.random() == 1 of the noise number
		spread = {x=600, y=600, z=600},
		seed = 5685,
		octaves = 6,
		persist = 0.89,
	},

	place = {"default:mg_rand_birch_sapling"}, -- randomly chosen list of nodes to place
	y_offset = 0, -- directly on top of the soil
})

default.register_surface_deco({
	name = "fir_forest",
	description = "Fir Forests",

	y_min = 5,
	y_max = 100,
	y_rand = 2, -- feather the edges of the y limits
	biomes = {"boreal_forest", "cool_forest", "boreal_wet_forest", "cool_wet_forest"}, -- list of biomes to appear in
	lat_min = 0,
	lat_max = 12000,
	lat_rand = 200, -- feather the edges of the lat limits
	lat_abs = true, -- appears in northern and southern hemicubes

	type = "density",
	chance = 20, -- once every 20 nodes, if it would have been placed otherwise
	noise = { -- filter with these noise params
		offset = -98, -- nodes are placed when the noise is greater than 1
		scale = 100,     -- according to math.random() == 1 of the noise number
		spread = {x=600, y=600, z=600},
		seed = 5685,
		octaves = 6,
		persist = 0.89,
	},

	place = {"default:mg_rand_fir_sapling"}, -- randomly chosen list of nodes to place
	y_offset = 0, -- directly on top of the soil
})