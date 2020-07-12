


function default.register_water(def)
	local src_name = def.mod..":"..def.name.."_source"
	local flow_name = def.mod..":"..def.name.."_flowing"
	
	minetest.register_node(src_name, {
		description = def.desc,
		drawtype = "liquid",
		waving = def.waving,
		tiles = {
			{
				name = def.tiles.source,
				backface_culling = false,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 2.0,
				},
			},
			{
				name = def.tiles.source,
				backface_culling = true,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 2.0,
				},
			},
		},
		alpha = def.alpha,
		paramtype = "light",
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		is_ground_content = false,
		drop = "",
		drowning = 1,
		liquidtype = "source",
		liquid_alternative_flowing = flow_name,
		liquid_alternative_source = src_name,
		liquid_viscosity = def.viscosity,
		liquid_renewable = def.renewable,
		liquid_range = def.range,
		post_effect_color = def.post_effect,
		groups = def.src_groups,
		sounds = default.node_sound_water_defaults(),
	})

	minetest.register_node(flow_name, {
		description = def.desc,
		drawtype = "flowingliquid",
		waving = def.waving,
		tiles = {def.tiles.flowing_inv},
		special_tiles = {
			{
				name = def.tiles.flowing,
				backface_culling = false,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 0.5,
				},
			},
			{
				name = def.tiles.flowing,
				backface_culling = true,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 0.5,
				},
			},
		},
		alpha = def.alpha,
		paramtype = "light",
		paramtype2 = "flowingliquid",
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		is_ground_content = false,
		drop = "",
		drowning = 1,
		liquidtype = "flowing",
		liquid_alternative_flowing = flow_name,
		liquid_alternative_source = src_name,
		liquid_viscosity = 1,
		liquid_renewable = def.renewable,
		liquid_range = def.range,
		post_effect_color = def.post_effect,
		groups = def.flow_groups,
		sounds = def.sounds,
	})
end


-- definitions

default.register_water({
	mod = "default",
	name = "sea_water",
	desc = "Sea Water",
	waving = 3,
	tiles = {
		source = "default_water_source_animated.png",
		flowing_inv = "default_water.png",
		flowing = "default_water_flowing_animated.png",
	},
	alpha = 191,
	viscosity = 1,
	renewable = true,
	range = 7,
	post_effect = {a = 103, r = 30, g = 60, b = 90},
	sounds = default.node_sound_water_defaults(),
	src_groups = {water = 3, liquid = 3, cools_lava = 1},
	flow_groups = {water = 3, liquid = 3, cools_lava = 1, not_in_creative_inventory = 1},
})



default.register_water({
	mod = "default",
	name = "river_water",
	desc = "River Water",
	waving = 0,
	tiles = {
		source = "default_river_water_source_animated.png",
		flowing_inv = "default_water.png",
		flowing = "default_river_water_flowing_animated.png",
	},
	alpha = 160,
	viscosity = 1,
	renewable = false,
	range = 2,
	post_effect = {a = 103, r = 30, g = 76, b = 90},
	sounds = default.node_sound_water_defaults(),
	src_groups = {water = 3, liquid = 3, cools_lava = 1},
	flow_groups = {water = 3, liquid = 3, cools_lava = 1, not_in_creative_inventory = 1},
})

default.register_water({
	mod = "default",
	name = "lake_water",
	desc = "Lake Water",
	waving = 0,
	tiles = {
		source = "default_river_water_source_animated.png^[colorize:green:40",
		flowing_inv = "default_water.png^[colorize:green:40",
		flowing = "default_river_water_flowing_animated.png^[colorize:green:40",
	},
	alpha = 160,
	viscosity = 1,
	renewable = false,
	range = 2,
	post_effect = {a = 93, r = 20, g = 86, b = 70},
	sounds = default.node_sound_water_defaults(),
	src_groups = {water = 3, liquid = 3, cools_lava = 1},
	flow_groups = {water = 3, liquid = 3, cools_lava = 1, not_in_creative_inventory = 1},
})


minetest.register_node("default:glacial_water_source", {
	description = "Glacial Water Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "default_river_water_source_animated.png^[colorize:white:120",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "default_river_water_source_animated.png^[colorize:white:120",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	alpha = 160,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:glacial_water_flowing",
	liquid_alternative_source = "default:glacial_water_source",
	liquid_viscosity = 1,
	-- Not renewable to avoid horizontal spread of water sources in sloping
	-- rivers that can cause water to overflow riverbanks and cause floods.
	-- River water source is instead made renewable by the 'force renew'
	-- option used in the 'bucket' mod by the river water bucket.
	liquid_renewable = false,
	liquid_range = 2,
	post_effect_color = {a = 103, r = 30, g = 76, b = 90},
	groups = {water = 3, liquid = 3, cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
})

minetest.register_node("default:glacial_water_flowing", {
	description = "Glacial River Water",
	drawtype = "flowingliquid",
	tiles = {"default_river_water.png^[colorize:white:120"},
	special_tiles = {
		{
			name = "default_river_water_flowing_animated.png^[colorize:white:120",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
		{
			name = "default_river_water_flowing_animated.png^[colorize:white:120",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
	},
	alpha = 160,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:glacial_water_flowing",
	liquid_alternative_source = "default:glacial_water_source",
	liquid_viscosity = 1,
	liquid_renewable = false,
	liquid_range = 2,
	post_effect_color = {a = 103, r = 30, g = 76, b = 90},
	groups = {water = 3, liquid = 3, not_in_creative_inventory = 1,
		cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
})
