


default.register_biome({
	name = "failsafe",
	description = "Failsafe Biome",
	
	y_min = -38000,
	y_max = 38000,
	y_rand = 0,
	flatness = 9999,
	magic = 9999,
	heat = 9999,
	humidity = 9999,
	lat_center = 99999999,
	
	fill = {
		{
			min = 1, max = 1,
			nodes = {"default:granite"},
		},
	},
})

default.register_stone_biome({
	name = "failsafe",
	description = "Failsafe Stone Biome",
	
	y_min = -33000,
	y_max = 33000,
	y_rand = 0,
	flatness = 0,
	magic = 0,
	heat = 0,
	humidity = 0,
	vulcanism = 0,
	lat_center = 0,
	
	solid = "default:granite",
})


default.register_stone_biome({
	name = "igneous",
	description = "Layered Volcanic Rocks",
	
	y_min = -200,
	y_max = 32000,
	y_rand = 1,
	flatness = 100,
	magic = 0,
	heat = 30,
	humidity = 60,
	vulcanism = 100,
	lat_center = 50,
	
	noise = { -- the absolute value of the nose in a rough range of 0,1 is used
		spread = {x=130, y=130, z=130},
		seed = 8464,
		octaves = 4,
		persist = 0.3
	},
	
	layers = { -- this list MUST be sorted ascending
		{0.2, "default:granite"}, -- any value under 0.2 will use granite
		{0.4, "default:basalt"}, -- any value between 0.2 and 0.4 will use basalt
		{0.7, "default:obsidian"},
		{1.0, "default:pumice"}, -- and value over 1.0 will also use pumice
	},
	
})

default.register_stone_biome({
	name = "metamorphic",
	description = "Smushed Rocks",
	
	y_min = -32000,
	y_max = -400,
	y_rand = 1,
	flatness = 100,
	magic = 0,
	heat = 30,
	humidity = 60,
	vulcanism = 50,
	lat_center = 50,
	
	noise = { -- the absolute value of the nose in a rough range of 0,1 is used
		spread = {x=150, y=150, z=150},
		seed = 3456,
		octaves = 4,
		persist = 0.5
	},
	
	layers = { -- this list MUST be sorted ascending
		{0.2, "default:marble"}, 
		{0.4, "default:gneiss"}, 
		{0.7, "default:slate"},
		{1.0, "default:schist"}, 
		{2.0, "default:serpentine"}, -- and value over 1.0 will also use pumice
	},
	
})

default.register_stone_biome({
	name = "sedimentary_1",
	description = "Smushed Sand",
	
	y_min = -1000,
	y_max = 32000,
	y_rand = 1,
	flatness = 100,
	magic = 0,
	heat = 30,
	humidity = 100,
	vulcanism = 0,
	lat_center = 50,
	
	noise = { -- the absolute value of the nose in a rough range of 0,1 is used
		spread = {x=150, y=150, z=150},
		seed = 6564,
		octaves = 3,
		persist = 0.3
	},
	
	layers = { -- this list MUST be sorted ascending
		{0.2, "default:limestone"}, 
		{0.210, "default:sandstone"}, 
		{0.220, "default:limestone"}, 
		{0.4, "default:sandstone"}, 
		{0.420, "default:mudstone"}, 
		{0.440, "default:sandstone"}, 
		{0.460, "default:mudstone"}, 
		{0.480, "default:sandstone"}, 
		{0.7, "default:mudstone"},
		{0.800, "default:sandstone"},
		{0.810, "default:mudstone"},
		{1.0, "default:chalk"}, 
	},
	
})

default.register_stone_biome({
	name = "sedimentary_2",
	description = "Smushed Gravel",
	
	y_min = -1000,
	y_max = 32000,
	y_rand = 1,
	flatness = 100,
	magic = 0,
	heat = 30,
	humidity = 0,
	vulcanism = 0,
	lat_center = 50,
	
	noise = { -- the absolute value of the nose in a rough range of 0,1 is used
		spread = {x=150, y=150, z=150},
		seed = 8943,
		octaves = 3,
		persist = 0.3
	},
	
	layers = { -- this list MUST be sorted ascending
		{0.35, "default:breccia"}, 
		{0.65, "default:conglomerate"}, 
	},
	
})


default.register_stone_biome({
	name = "sedimentary_3",
	description = "Smushed Silt",
	
	y_min = -3000,
	y_max = 10,
	y_rand = 1,
	flatness = 100,
	magic = 0,
	heat = 100,
	humidity = 5,
	vulcanism = 0,
	lat_center = 50,
	
	noise = { -- the absolute value of the nose in a rough range of 0,1 is used
		spread = {x=120, y=120, z=120},
		seed = 7832,
		octaves = 3,
		persist = 0.5
	},
	
	layers = { -- this list MUST be sorted ascending
		{0.2, "default:slate"}, 
		{0.4, "default:shale"}, 
		{0.6, "default:gypsum"}, 
		{0.8, "default:halite"}, 
		{1.0, "default:chalk"}, 
	},
	
})
