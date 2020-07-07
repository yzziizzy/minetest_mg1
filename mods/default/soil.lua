
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
	minetest.register_node("default:dirt_with_grass_"..i, {
		description = "Dirt with Grass",
		tiles = {"default_grass.png^[colorize:blue:"..i*5, "default_dirt.png",
			{name = "default_dirt.png^default_grass_side.png^[colorize:blue:"..i*4,
				tileable_vertical = false}},
		groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
		drop = "default:dirt",
		sounds = default.node_sound_dirt_defaults({
			footstep = {name = "default_grass_footstep", gain = 0.25},
		}),
	})
end
