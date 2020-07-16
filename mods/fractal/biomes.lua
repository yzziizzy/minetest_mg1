fractal.debug("fractal biomes")

default.biomes = {}
default.cold.base_temp = 0

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

	fill = {
		{
			min = 2, max = 6,
			nodes = {"default:wet_sand"},
		},
	},
})

default.register_biome({
	name = "sand_dunes",
	description = "Sand Dunes",

	y_min = 0,
	y_max = 1,
	y_rand = 0,
	flatness = 100,
	magic = 0,
	heat = 0,
	humidity = 0,
	lat_center = 0,

	fill = {
		{
			min = 1, max = 5,
			nodes = {"default:sand"},
		},
	},
})

default.register_biome({
	name = "gravel_beach",
	description = "Gravely Beach",

	y_min = 0,
	y_max = 1,
	y_rand = 0,
	flatness = 100,
	magic = 0,
	heat = 0,
	humidity = 100,
	lat_center = 0,

	fill = {
		{
			min = 1, max = 5,
			nodes = {"fractal:stub_gravel"},
		},
	},
})

for _, climate in pairs(fractal.climate_zones) do
	fractal.debug("registering climate: "..climate.name)
	default.register_biome({
		name = climate.name,
		description = climate.description,

		y_min = 1,
		y_max = 200,
		y_rand = 1,
		flatness = 100,
		magic = 0,
		heat = climate.temp * 4.5,
		humidity = ( climate.water + 0.5 ) * ( 100 / (climate.temp * 5/7 + 3 ) ),
		lat_center = 50,

		fill = climate.fill,
	})
end

