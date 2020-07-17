-- [ Sand ] --
default.register_surface_deco({
	name = "dune_grass",
	description = "Dune Grass",

	y_min = 0,
	y_max = 20,
	y_rand = 1, -- feather the edges of the y limits
	biomes = {"sand_dunes"}, -- list of biomes to appear in
	lat_min = 0,
	lat_max = 12000,
	lat_rand = 1, -- feather the edges of the lat limits
	lat_abs = true, -- appears in northern and southern hemicubes

	type = "density",
	chance = 4,
	noise = fractal.get_plant_noise(),
	place_on = {"default:sand"},

	place = {"fractal:stub_dune_grass_3"}, -- randomly chosen list of nodes to place
	y_offset = 0, -- directly on top of the soil
})


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

	type = "density",
	chance = 5,
	noise = fractal.get_plant_noise(),
	place_on = {"group:spreading_grass"},

	place = plantlife.stage_names("tall_grass", "live", 1, 5),
	y_offset = 0, -- directly on top of the soil
})


-- [ Shrublands ] --
default.register_surface_deco({
	name = "shrubland_grass",
	description = "Grass",

	y_min = 1,
	y_max = 200,
	y_rand = 1, -- feather the edges of the y limits
	biomes = {
		"boreal_scrub",
		"cool_scrub",
		"warm_scrub",
		"subtropic_scrub",
		"tropic_scrub",
	}, -- list of biomes to appear in
	lat_min = 0,
	lat_max = 12000,
	lat_rand = 1, -- feather the edges of the lat limits
	lat_abs = true, -- appears in northern and southern hemicubes

	type = "density",
	chance = 20,
	noise = fractal.get_plant_noise(),
	place_on = {"group:spreading_grass"},

	place = plantlife.stage_names("tall_grass", "live", 1, 2),
	y_offset = 0, -- directly on top of the soil
})

default.register_surface_deco({
	name = "dead_sagebrush",
	description = "Dead Sagebrush",

	y_min = 1,
	y_max = 200,
	y_rand = 1, -- feather the edges of the y limits
	biomes = {
		"boreal_scrub",
		"cool_scrub",
		"warm_scrub",
		"subtropic_scrub",
		"tropic_scrub"
	}, -- list of biomes to appear in
	lat_min = 0,
	lat_max = 12000,
	lat_rand = 1, -- feather the edges of the lat limits
	lat_abs = true, -- appears in northern and southern hemicubes

	type = "density",
	chance = 20,
	noise = fractal.get_plant_noise(),
	place_on = {"group:spreading_grass"},

	place = plantlife.stage_names("sagebrush", "dead", 4, 5),
	y_offset = 0, -- directly on top of the soil
})

default.register_surface_deco({
	name = "sagebrush",
	description = "Sagebrush",

	y_min = 1,
	y_max = 200,
	y_rand = 1, -- feather the edges of the y limits
	biomes = {
		"boreal_scrub",
		"cool_scrub",
		"warm_scrub",
		"subtropic_scrub"
	}, -- list of biomes to appear in
	lat_min = 0,
	lat_max = 12000,
	lat_rand = 1, -- feather the edges of the lat limits
	lat_abs = true, -- appears in northern and southern hemicubes

	type = "density",
	chance = 10,
	noise = fractal.get_plant_noise(),
	place_on = {"group:spreading_grass"},

	place = plantlife.stage_names("sagebrush", "live", 1, 5),
	y_offset = 0, -- directly on top of the soil
})


-- [ Forests ] --
default.register_surface_deco({
	name = "aspen_forest",
	description = "Aspen Tree Groves",

	y_min = 30,
	y_max = 200,
	y_rand = 2, -- feather the edges of the y limits
	biomes = {"boreal_forest", "cool_forest"}, -- list of biomes to appear in
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

	place = {"default:mg_rand_aspen_sapling"}, -- randomly chosen list of nodes to place
	y_offset = 0, -- directly on top of the soil
})

default.register_surface_deco({
	name = "birch_forest",
	description = "Birch Tree Groves",

	y_min = 2,
	y_max = 40,
	y_rand = 2, -- feather the edges of the y limits
	biomes = {"boreal_wet_forest", "boreal_rain_forest", "cool_rain_forest"}, -- list of biomes to appear in
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

	y_min = 10,
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

default.register_surface_deco({
	name = "larch_forest",
	description = "Larch Forests",

	y_min = 20,
	y_max = 200,
	y_rand = 2, -- feather the edges of the y limits
	biomes = {"boreal_forest", "boreal_wet_forest", "cool_wet_forest"}, -- list of biomes to appear in
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

	place = {"default:mg_rand_larch_sapling"}, -- randomly chosen list of nodes to place
	y_offset = 0, -- directly on top of the soil
})

