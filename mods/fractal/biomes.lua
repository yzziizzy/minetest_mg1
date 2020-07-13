fractal.debug("fractal biomes")

default.biomes = {}


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

print(dump(fractal))
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
		heat = climate.temp * 12.5,
		humidity = climate.water * 12.5,
		lat_center = 50,

		cover = climate.cover,
		fill = climate.fill,
		fill_min = 1,
		fill_max = 5,
	})
end

