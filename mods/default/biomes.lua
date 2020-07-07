


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
