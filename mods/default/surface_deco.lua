
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
	
	place = {"default:mg_aspen_sapling"}, -- randomly chosen list of nodes to place
	y_offset = 0, -- directly on top of the soil
})
