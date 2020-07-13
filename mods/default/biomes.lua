


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
	
	cover = {"default:granite"},
	fill = {"default:granite"},
	fill_min = 1,
	fill_max = 1,
})


default.register_biome({
	name = "ocean_floor",
	description = "Ocean Floor",
	
	y_min = -38000,
	y_max = 0,
	y_rand = 0,
	flatness = 0,
	magic = 0,
	heat = 0,
	humidity = 0,
	lat_center = 0,
	
	cover = {"default:sand"},
	fill = {"default:sand"},
	fill_min = 1,
	fill_max = 6,
})


default.register_biome({
	name = "temperate_grassland",
	description = "Temperate Grassland",
	
	y_min = 2,
	y_max = 30,
	y_rand = 1,
	flatness = 100,
	magic = 0,
	heat = 30,
	humidity = 10,
	lat_center = 50,
	
	cover = {"default:dirt_with_grass_0", "default:dirt_with_grass_6"},
	fill = {"default:dirt"},
	fill_min = 2,
	fill_max = 6,
	
})

default.register_biome({
	name = "temperate_forest",
	description = "Temperate Forest",
	
	y_min = 2,
	y_max = 30,
	y_rand = 1,
	flatness = 100,
	magic = 0,
	heat = 30,
	humidity = 60,
	lat_center = 50,
	
	cover = {"default:dirt_with_grass_9", "default:dirt_with_grass_8"},
	fill = {"default:dirt"},
	fill_min = 2,
	fill_max = 6,
	
})

default.register_biome({
	name = "peat_bog",
	description = "Peat Bog",
	
	y_min = -5,
	y_max = 30,
	y_rand = 1,
	flatness = 100,
	magic = 0,
	heat = 10,
	humidity = 100,
	lat_center = 50,
	
	cover = {"default:peat"},
	fill = {
		{chance = 100, name = "default:peat_with_bog_iron"},
		"default:peat",
	},
	fill_min = 3,
	fill_max = 4,
	
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
		spread = {x=64, y=64, z=64},
		seed = 684,
		octaves = 6,
		persist = 0.7
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
		spread = {x=64, y=64, z=64},
		seed = 5675,
		octaves = 6,
		persist = 0.7
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
		spread = {x=64, y=64, z=64},
		seed = 6564,
		octaves = 6,
		persist = 0.7
	},
	
	layers = { -- this list MUST be sorted ascending
		{0.2, "default:limestone"}, 
		{0.4, "default:sandstone"}, 
		{0.7, "default:mudstone"},
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
		spread = {x=64, y=64, z=64},
		seed = 6564,
		octaves = 6,
		persist = 0.7
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
		spread = {x=64, y=64, z=64},
		seed = 6564,
		octaves = 6,
		persist = 0.7
	},
	
	layers = { -- this list MUST be sorted ascending
		{0.2, "default:slate"}, 
		{0.4, "default:shale"}, 
		{0.6, "default:gypsum"}, 
		{0.8, "default:halite"}, 
		{1.0, "default:chalk"}, 
	},
	
})
