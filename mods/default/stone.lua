


--[[
Igneous
	granite
	basalt
	obsidian
	pumice

sedimentary
	limestone
	sandstone
	laterite
	gypsum
	halite
	shale
	conglomerate
	chalk
	breccia
	mudstone

metamorphic
	marble
	gneiss
	slate
	schist
	serpentine
	

underground lava tubes
native metals vs ores
grades of coal
sand, mud, clay, dirt, topsoil and composting
swamps
shades of grass
firewood
grades of planks
aspen (spread underground), birch, alder
oak, maple
cypress
spruce, pine (ponderosa and lodgepole), fir, cedar
cottonwood by certain rivers


items:
wood chips


]]
--[[
minetest.register_node("default:mg_aspen_sapling", {
	description = "Mapgen Aspen Placeholder (You should not see this)",
-- 	tiles = {"default_"..def.n.."_cobble.png"},
	tiles = {"default_stone.png^[colorize:orange:200"},
	groups = {cracky = 1, stone = 1,},
	sounds = default.node_sound_stone_defaults(),
})
]]
minetest.register_node("default:mg_oak_sapling", {
	description = "Mapgen Oak Placeholder (You should not see this)",
-- 	tiles = {"default_"..def.n.."_cobble.png"},
	tiles = {"default_stone.png^[colorize:pink:200"},
	groups = {cracky = 1, stone = 1,},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:mg_stone", {
	description = "Mapgen Stone Placeholder (You should not see this)",
-- 	tiles = {"default_"..def.n.."_cobble.png"},
	tiles = {"default_stone.png^[colorize:red:230"},
	groups = {cracky = 1, stone = 1,},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:mg_glass", {
	description = "Mapgen Glass",
	drawtype = "glasslike_framed_optional",
	tiles = {"default_glass.png", "default_glass_detail.png"},
	paramtype = "light",
	paramtype2 = "glasslikeliquidlevel",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
})


local stonedefs = {
	{n="granite", d="Granite", t="i"},
	{n="basalt", d="Basalt", t="i"},
	{n="obsidian", d="Obsidian", t="i"},
	{n="pumice", d="Pumice", t="i"},

	{n="limestone", d="Limestone", t="s"},
	{n="sandstone", d="Sandstone", t="s"},
	{n="laterite", d="Laterite", t="s"},
	{n="gypsum", d="Gypsum", t="s"},
	{n="halite", d="Halite", t="s"},
	{n="shale", d="Shale", t="s"},
	{n="conglomerate", d="Conglomerate", t="s"},
	{n="chalk", d="Chalk", t="s"},
	{n="breccia", d="Breccia", t="s"},
	{n="mudstone", d="Mudstone", t="s"},
	
	{n="marble", d="Marble", t="m"},
	{n="gneiss", d="Gneiss", t="m"},
	{n="slate", d="Slate", t="m"},
	{n="schist", d="Schist", t="m"},
	{n="serpentine", d="Serpentine", t="m"},
}

local stone_types = {
	["i"] = 1,
	["s"] = 2,
	["m"] = 3,
}

local colors = {
	["i"] = "red",
	["s"] = "yellow",
	["m"] = "orange",
}

for i,def in pairs(stonedefs) do
	minetest.register_node("default:"..def.n.."_cobble", {
		description = def.d.." Cobble",
-- 		tiles = {"default_"..def.n.."_cobble.png"},
		tiles = {"default_stone.png^[colorize:"..colors[def.t]..":"..i*15},
		groups = {cracky = 1, cobble = 1, stone_type = stone_types[def.t]},
		sounds = default.node_sound_stone_defaults(),
	})
	
	minetest.register_node("default:"..def.n, {
		description = def.d,
-- 		tiles = {"default_"..def.n..".png"},
		tiles = {"default_stone.png^[colorize:"..colors[def.t]..":"..i*15},
		groups = {cracky = 3, stone = 1, stone_type = stone_types[def.t]},
		drop = "default:"..def.n.."_cobble",
		sounds = default.node_sound_stone_defaults(),
	})
end









minetest.register_node("default:snow", {
	description = "Snow",
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

	on_construct = function(pos)
		pos.y = pos.y - 1
		if minetest.get_node(pos).name == "default:dirt_with_grass" then
			minetest.set_node(pos, {name = "default:dirt_with_snow"})
		end
	end,
})

minetest.register_node("default:snowblock", {
	description = "Snow Block",
	tiles = {"default_snow.png"},
	groups = {crumbly = 3, cools_lava = 1, snowy = 1},
	sounds = default.node_sound_snow_defaults(),

	on_construct = function(pos)
		pos.y = pos.y - 1
		if minetest.get_node(pos).name == "default:dirt_with_grass" then
			minetest.set_node(pos, {name = "default:dirt_with_snow"})
		end
	end,
})


minetest.register_node("default:lava_source", {
	description = "Lava Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "default_lava_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
		{
			name = "default_lava_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
	},
	paramtype = "light",
	light_source = default.LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:lava_flowing",
	liquid_alternative_source = "default:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 3, liquid = 2, igniter = 1},
})

minetest.register_node("default:lava_flowing", {
	description = "Flowing Lava",
	drawtype = "flowingliquid",
	tiles = {"default_lava.png"},
	special_tiles = {
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = default.LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:lava_flowing",
	liquid_alternative_source = "default:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 3, liquid = 2, igniter = 1,
		not_in_creative_inventory = 1},
})

