local S = default.get_translator

fractal.climate_zones = {}
function fractal.register_climate_zone(def)
	for i, zone in ipairs(def.zones) do
		local zone_name = def.name
		if type(zone_name) == "function" then
			zone_name = zone_name(zone)
		end

		fractal.climate_zones[zone_name] = {
			name = zone_name,
			description = def.description,
			temp = zone[1],
			water = zone[2],
		}

		if def.has_dirt then
			local suffix = "T"..zone[1].."W"..zone[2]
			local colorize_temp = "^[colorize:blue:"..(7-zone[1])*25
			local colorize_water = "^[colorize:red:"..(7-zone[2])*25
			minetest.register_node("fractal:dirt_"..suffix, {
				description = "Dirt",
				tiles = {"default_dirt.png"..colorize_temp..colorize_water},
				groups = {crumbly = 3, falling_node = 1, soil = 1},
				drop = "default:dirt",
				sounds = default.node_sound_dirt_defaults(),
			})
			minetest.register_node("fractal:dirt_with_grass_"..suffix, {
				description = "Dirt with Grass",
				tiles = {
					"default_grass.png"..colorize_temp..colorize_water,
					"default_dirt.png",
					{name = "default_dirt.png^default_grass_side.png", tileable_vertical = false}
				},
				groups = {crumbly = 3, soil = 1, falling_node = 1, spreading_grass = 1},
				drop = "default:dirt",
				sounds = default.node_sound_dirt_defaults({
					footstep = {name = "default_grass_footstep", gain = 0.25},
				}),

				walk_speed = 1.2,
			})
			fractal.climate_zones[zone_name].cover = {"fractal:dirt_with_grass_"..suffix}
			fractal.climate_zones[zone_name].fill = {"fractal:dirt_"..suffix}
		else
			fractal.climate_zones[zone_name].cover = def.cover
			fractal.climate_zones[zone_name].fill = def.fill
		end
	end
end

fractal.temp_bands = {
	"polar",
	"polar",
	"subpolar",
	"boreal",
	"cool",
	"warm",
	"subtropic",
	"tropic",
}

-- polar
fractal.register_climate_zone({
	name = "polar_desert",
	description = "Polar Desert",
	zones = {
		{0,0}, {0,1}, {0,2},
		{1,0}, {1,1}, {1,2},
	},
	has_dirt = false,
	cover = {"default:snow"},
	fill = {"default:snow"},
})

-- subpolar
fractal.register_climate_zone({
	name = "dry_tundra",
	description = "Dry Tundra",
	zones = {
		{2,0},
	},
	has_dirt = true,
})
fractal.register_climate_zone({
	name = "moist_tundra",
	description = "Dry Tundra",
	zones = {
		{2,1},
	},
	has_dirt = true,
})
fractal.register_climate_zone({
	name = "wet_tundra",
	description = "Wet Tundra",
	zones = {
		{2,2},
	},
	has_dirt = true,
})
fractal.register_climate_zone({
	name = "rain_tundra",
	description = "Rain Tundra",
	zones = {
		{2,3},
	},
	has_dirt = true,
})

-- desert
fractal.register_climate_zone({
	name = function(pair)
		return fractal.temp_bands[pair[1]] .. "_desert"
	end,
	description = "Desert",
	zones = {
		{3,0},
		{4,0},
		{5,0},
		{6,0},
		{7,0},
	},
	has_dirt = true,
})

-- srub
fractal.register_climate_zone({
	name = function(pair)
		return fractal.temp_bands[pair[1]] .. "_scrub"
	end,
	description = "Scrub",
	zones = {
		{3,1},
		{4,1},
		{5,1},
		{6,1},
		{7,1},
	},
	has_dirt = true,
})

-- forest
fractal.register_climate_zone({
	name = function(pair)
		return fractal.temp_bands[pair[1]] .. "_forest"
	end,
	description = "Forest",
	zones = {
		{3,2},
		{4,3},
		{5,4},
		{6,4},
		{7,5},
	},
	has_dirt = true,
})

-- wet forest
fractal.register_climate_zone({
	name = function(pair)
		return fractal.temp_bands[pair[1]] .. "_wet_forest"
	end,
	description = "Wet Forest",
	zones = {
		{3,3},
		{4,4},
		{5,5},
		{6,5},
		{7,6},
	},
	has_dirt = true,
})

-- rain forest
fractal.register_climate_zone({
	name = function(pair)
		return fractal.temp_bands[pair[1]] .. "_rain_forest"
	end,
	description = "Rain Forest",
	zones = {
		{3,4},
		{4,5},
		{5,6},
		{6,6},
		{7,7},
	},
	has_dirt = true,
})

-- steppe
fractal.register_climate_zone({
	name = function(pair)
		return fractal.temp_bands[pair[1]] .. "_steppe"
	end,
	description = "Steppe",
	zones = {
		{4,2},
		{5,2},
	},
	has_dirt = true,
})

-- steppe
fractal.register_climate_zone({
	name = function(pair)
		return fractal.temp_bands[pair[1]] .. "_steppe"
	end,
	description = "Steppe",
	zones = {
		{4,2},
		{5,2},
	},
	has_dirt = true,
})

-- dry forest
fractal.register_climate_zone({
	name = function(pair)
		return fractal.temp_bands[pair[1]] .. "_dry_forest"
	end,
	description = "Dry Forest",
	zones = {
		{5,3},
		{6,3},
		{7,4},
	},
	has_dirt = true,
})

-- thorn woodland
fractal.register_climate_zone({
	name = "thorn_woodland",
	description = "Thorn Woodland",
	zones = {
		{6,2},
		{7,2},
	},
	has_dirt = true,
})

-- very dry forest
fractal.register_climate_zone({
	name = "arid_forest",
	description = "Arid Forest",
	zones = {
		{7,3},
	},
	has_dirt = true,
})

