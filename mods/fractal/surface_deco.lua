
default.register_surface_deco({
	name = "grass",
	description = "Grass",

	y_min = 1,
	y_max = 200,
	y_rand = 1, -- feather the edges of the y limits
	biomes = {"cool_steppe", "warm_steppe", "cool_wet_forest"}, -- list of biomes to appear in
	lat_min = 0,
	lat_max = 12000,
	lat_rand = 1, -- feather the edges of the lat limits
	lat_abs = true, -- appears in northern and southern hemicubes

	type = "blob",
	chance = 5,
	place_on = {"fractal:dirt_with_grass_T4W2", "fractal:dirt_with_grass_T5W2", "fractal:dirt_with_grass_T4W4"},

	place = {"fractal:grass_1", "fractal:grass_2", "fractal:grass_3", "fractal:grass_4", "fractal:grass_5"}, -- randomly chosen list of nodes to place
	y_offset = 0, -- directly on top of the soil
})
