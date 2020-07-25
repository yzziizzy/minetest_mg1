
default.register_surface_deco({
	name = "aspen_trees",
	description = "Aspen Tree Groves",
	
	y_min = 5,
	y_max = 100,
	y_rand = 2, -- feather the edges of the y limits
	biomes = {"temperate_forest", "temperate_grassland"}, -- list of biomes to appear in
	lat_min = 0,
	lat_max = 12000,
	lat_rand = 200, -- feather the edges of the lat limits
	lat_abs = true, -- appears in northern and southern hemicubes
	
	type = "blob",
	chance = 20, -- once every 20 nodes, using math.random()
	noise = { -- filter with these noise params
		-- offset = 0.4, -- offset and scale are set internally to this.
		-- scale = 0.4,    -- the final value is clamped to [0,1]
		spread = {x=600, y=600, z=600},
		seed = 5685,
		octaves = 6,
		persist = 0.89,
		
		threshold = 0.01, -- place a chance random node if the noise value is BELOW this
		                   -- lower values = less area.
	},
	
	place = {"default:mg_rand_aspen_sapling"}, -- randomly chosen list of nodes to place
	y_offset = 0, -- directly on top of the soil
})


default.register_surface_deco({
	name = "birches",
	description = "Birch Tree Groves",
	
	y_min = 5,
	y_max = 100,
	y_rand = 2, -- feather the edges of the y limits
	biomes = {"temperate_forest", "temperate_grassland"}, -- list of biomes to appear in
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
	name = "first",
	description = "Fir Forests",
	
	y_min = 5,
	y_max = 100,
	y_rand = 2, -- feather the edges of the y limits
	biomes = {"alpine_forest"}, -- list of biomes to appear in
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
	name = "granite stones",
	description = "Granite Stones",
	
	y_min = 2,
	y_max = 1200,
	y_rand = 2, -- feather the edges of the y limits
	biomes = "*", -- list of biomes to appear in
	lat_min = 0,
	lat_max = 32000,
	lat_rand = 0, -- feather the edges of the lat limits
	lat_abs = true, -- appears in northern and southern hemicubes
	
	type = "density",
	chance = 20, -- once every 20 nodes, if it would have been placed otherwise
	noise = { -- filter with these noise params
		cap = 100,
		offset = 28, -- nodes are placed when the noise is greater than 1
		scale = 100,     -- according to math.random() == 1 of the noise number
		spread = {x=200, y=200, z=200},
		seed = 58953,
		octaves = 2,
		persist = 0.89,
	},
	
	place = {"group:stones"}, -- randomly chosen list of nodes to place
	y_offset = 0, -- directly on top of the soil
})
