local S = default.get_translator



minetest.register_node("default:sand", {
	description = S("Sand"),
	tiles = {"default_sand.png"},
	groups = {shoveled = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("default:wet_sand", {
	description = S("Sand"),
	tiles = {"default_sand.png^[colorize:gray:20"},
	groups = {shoveled = 2, falling_node = 1, wet_sand = 1, causes_rot = 1},
	sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("default:desert_sand", {
	description = S("Desert Sand"),
	tiles = {"default_desert_sand.png"},
	groups = {shoveled = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("default:silver_sand", {
	description = S("Silver Sand"),
	tiles = {"default_silver_sand.png"},
	groups = {shoveled = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults(),
})


minetest.register_node("default:dirt", {
	description = "Dirt",
	tiles = {"default_dirt.png"},
	groups = {shoveled = 3, falling_node = 1, soil = 1, causes_rot = 1},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("default:topsoil", {
	description = "Topsoil",
	tiles = {"default_dirt.png^[colorize:black:20"},
	groups = {shoveled = 3, falling_node = 1, soil = 2, causes_rot = 1},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("default:compost", {
	description = "Topsoil",
	tiles = {"default_dirt.png^[colorize:brown:40"},
	groups = {shoveled = 3, falling_node = 1, soil = 2, causes_rot = 1},
	sounds = default.node_sound_dirt_defaults(),
})



default.register_water({
	mod = "default",
	name = "mud",
	desc = "Mud",
	waving = 0,
	tiles = {
		source = "default_river_water_source_animated.png^[colorize:brown:220",
		flowing_inv = "default_water.png^[colorize:brown:220",
		flowing = "default_river_water_flowing_animated.png^[colorize:brown:220",
	},
	alpha = 255,
	viscosity = 12,
	renewable = false,
	range = 1,
	post_effect = {a = 255, r = 20, g = 20, b = 0},
	sounds = default.node_sound_water_defaults(),
	src_groups = { liquid = 3, falling_node = 1, causes_rot = 1},
	flow_groups = { liquid = 3, causes_rot = 1, not_in_creative_inventory = 1},
})


minetest.register_node("default:wet_clay", {
	description = S("Wet Clay"),
	tiles = {"default_clay.png"},
	groups = {shoveled = 3, falling_node = 1, wet_clay = 1, causes_rot = 1},
	sounds = default.node_sound_dirt_defaults(),
})
minetest.register_node("default:dry_clay", {
	description = S("Dry Clay"),
	tiles = {"default_dry_dirt.png"},
	groups = {axed = 1, adzed=1, picked = 3, shoveled = 2, dry_clay = 1},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_abm({
	nodenames = {"default:dry_clay"},
	neighbors = {"group:water"},
	interval = 20,
	chance = 20,
	catch_up = true,
	action = function(pos, node)
		minetest.set_node(pos, {name = "default:wet_clay"})
	end,
})





minetest.register_node("default:snow", {
	description = S("Snow"),
	tiles = {"default_snow.png"},
	inventory_image = "default_snowball.png",
	wield_image = "default_snowball.png",
	paramtype = "light",
	buildable_to = true,
	floodable = true,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -7 / 16, 0.5},
		},
	},
	groups = {crumbly = 3, falling_node = 1, snowy = 1},
	sounds = default.node_sound_snow_defaults(),
})

minetest.register_node("default:snowblock", {
	description = S("Snow Block"),
	tiles = {"default_snow.png"},
	groups = {shoveled = 2, cools_lava = 1, snowy = 1},
	sounds = default.node_sound_snow_defaults(),

})



minetest.register_node("default:permafrost", {
	description = S("Permafrost"),
	tiles = {"default_permafrost.png"},
	groups = {shoveled = 1, },
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("default:permafrost_with_stones", {
	description = S("Permafrost with Stones"),
	tiles = {"default_permafrost.png^default_stones.png",
		"default_permafrost.png",
		"default_permafrost.png^default_stones_side.png"},
	groups = {shoveled = 1,},
	sounds = default.node_sound_gravel_defaults(),
})

minetest.register_node("default:permafrost_with_moss", {
	description = S("Permafrost with Moss"),
	tiles = {"default_moss.png", "default_permafrost.png",
		{name = "default_permafrost.png^default_moss_side.png",
			tileable_vertical = false}},
	groups = {shoveled = 1, surface_grass=1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
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
		groups = {shoveled = 2, soil = 1, falling_node = 1, spreading_grass = 1, surface_grass=1},
		drop = "default:dirt",
		sounds = default.node_sound_dirt_defaults({
			footstep = {name = "default_grass_footstep", gain = 0.25},
		}),
		
		walk_speed = 1.2,
	})
end



minetest.register_node("default:peat", {
	description = S("Peat"),
	tiles = {
		"default_moss.png", 
		"default_dirt.png",
		{name = "default_dirt.png^default_moss_side.png", tileable_vertical = false}
	},
	groups = {shoveled = 2, surface_grass=1},
})


minetest.register_node("default:iron_ore", {
	description = S("Iron Ore"),
	tiles = {
		"default_iron_lump.png", 
	},
	groups = {crumbly = 1, },
})


minetest.register_node("default:peat_with_bog_iron", {
	description = S("Peat with Bog Iron"),
	tiles = {
		"default_moss.png^default_iron_lump.png", 
		"default_dirt.png",
		{name = "default_dirt.png^default_moss_side.png", tileable_vertical = false}
	},
	drop = {
		max_items = 2,
		items = {
			{items = {"default:peat"}},
			{items = {"default:iron_ore"}},
		},
	},
	groups = {shoveled=2, surface_grass=1},
})



