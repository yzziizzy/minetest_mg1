
minetest.register_node("default:sand", {
	description = "Sand",
	tiles = {"default_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("default:dirt", {
	description = "Dirt",
	tiles = {"default_dirt.png"},
	groups = {crumbly = 3, soil = 1},
	sounds = default.node_sound_dirt_defaults(),
})

for i = 0, 9 do
	default.register_node_seasons("default:dirt_with_grass_"..i, {
		description = "Dirt with Grass",
		spring = {
			tiles = {
				"default_grass_spring.png^[colorize:blue:"..i*5, 
				"default_dirt.png", 
				{name = "default_dirt.png^default_grass_side_spring.png^[colorize:blue:"..i*4, tileable_vertical = false}
			},
		},
		summer = {
			tiles = {
				"default_grass.png^[colorize:blue:"..i*5, 
				"default_dirt.png", 
				{name = "default_dirt.png^default_grass_side.png^[colorize:blue:"..i*4, tileable_vertical = false}
			},
		},
		fall = {
			tiles = {
				"default_grass_fall.png^[colorize:yellow:"..i*5, 
				"default_dirt.png", 
				{name = "default_dirt.png^default_grass_side_fall.png^[colorize:yellow:"..i*4, tileable_vertical = false}
			},
		},
		winter = {
			tiles = {
				"default_grass_winter.png^[colorize:brown:"..i*5, 
				"default_dirt.png", 
				{name = "default_dirt.png^default_grass_side_winter.png^[colorize:brown:"..i*4, tileable_vertical = false}
			},
		},
		groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
		drop = "default:dirt",
		sounds = default.node_sound_dirt_defaults({
			footstep = {name = "default_grass_footstep", gain = 0.25},
		}),
		
		walk_speed = 1.2,
	})
end
