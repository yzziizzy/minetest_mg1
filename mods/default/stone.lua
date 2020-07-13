


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
random blob ores and decorations
shades of grass - hardware?
firewood
grades of planks
aspen (spread underground), birch, alder
oak, maple
cypress
spruce, pine (ponderosa and lodgepole), fir, cedar
cottonwood by certain rivers
magic ancient stone circles
placer deposits in rivers

firedamp in coal mines

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
	-- hardness: higher is harder
	-- n_ame, d_escription, t_ype, h_ardness 
	{n="granite", d="Granite", t="i", h=3}, --
	{n="basalt", d="Basalt", t="i", h=3}, --
	{n="obsidian", d="Obsidian", t="i", h=4}, --
	{n="pumice", d="Pumice", t="i", h=1}, --

	{n="limestone", d="Limestone", t="s", h=2}, --
	{n="sandstone", d="Sandstone", t="s", h=2}, --
	{n="gypsum", d="Gypsum", t="s", h=1}, --
	{n="halite", d="Halite", t="s", h=2}, --
	{n="shale", d="Shale", t="s", h=2}, --
	{n="conglomerate", d="Conglomerate", t="s", h=2}, --
	{n="chalk", d="Chalk", t="s", h=1}, --
	{n="breccia", d="Breccia", t="s", h=2}, --
	{n="mudstone", d="Mudstone", t="s", h=2}, --
	
	{n="marble", d="Marble", t="m", h=3}, --
	{n="gneiss", d="Gneiss", t="m", h=3}, --
	{n="slate", d="Slate", t="m", h=4}, --
	{n="schist", d="Schist", t="m", h=3}, --
	{n="serpentine", d="Serpentine", t="m", h=3}, --
	
	-- fossil rocks
	{n="lignite", d="Lignite", t="f", h=1}, 
	{n="bituminous_coal", d="Coal", t="f", h=2},
	{n="anthracite_coal", d="Anthracite Coal", t="f", h=3},
	{n="graphite", d="Graphite", t="f", h=4}, 
	{n="oil_shale", d="Oil Shale", t="f", h=2},
	{n="tar_sand", d="tar_sand", t="f", h=1}, -- remove, not being stone?
}

local stone_types = {
	["i"] = 1,
	["s"] = 2,
	["m"] = 3,
	["f"] = 4,
}

local function mkbox(x,y,z, szx, szy, szz)
	return {x, y, z, x+szx, y+szy, z+szz}
end

for i,def in pairs(stonedefs) do
	minetest.register_node("default:"..def.n.."_cobble", {
		description = def.d.." Cobble",
		tiles = {"default_"..def.n..".png^default_cobble.png"},
-- 		tiles = {"default_stone.png^[colorize:"..colors[def.t]..":"..i*15},
		groups = {cracky = 1, cobble = 1, stone_type = stone_types[def.t]},
		sounds = default.node_sound_stone_defaults(),
	})
	
	minetest.register_node("default:"..def.n, {
		description = def.d,
		tiles = {"default_"..def.n..".png"},
-- 		tiles = {"default_stone.png^[colorize:"..colors[def.t]..":"..i*15},
		groups = {cracky = 3, stone = 1, stone_type = stone_types[def.t]},
		drop = "default:"..def.n.."_cobble",
		sounds = default.node_sound_stone_defaults(),
	})
	
	-- pile of stones on the ground
	minetest.register_node("default:"..def.n.."_stones", {
		description = def.d .. " Stones",
		tiles = {"default_"..def.n..".png"},
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				mkbox(-0.3, -0.5, -0.3, 0.2, 0.1, 0.2),
				mkbox(0.05, -0.5, 0.3, 0.1, 0.1, 0.1),
				mkbox(-0.1, -0.5, -0.1, 0.2, 0.2, 0.2),
				mkbox(0.2, -0.5, 0.1, 0.1, 0.1, 0.1),
				mkbox(0.0, -0.5, 0.0, -0.3, 0.07, 0.3),
				mkbox(0.3, -0.5, -0.3, 0.1, 0.05, 0.1),
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},
		},
		sunlight_propagates = true,
		groups = {stones = 1, stone_type = stone_types[def.t], oddly_breakable_by_hand = 1},
		sounds = default.node_sound_stone_defaults(),
	})
	
	-- stone/cobble crafts
	minetest.register_craft({
		output = "default:"..def.n.."_stones 9",
		type = "shapeless",
		recipe = {"default:"..def.n.."_cobble"}
	})
	
	minetest.register_craft({
		output = "default:"..def.n.."_cobble",
		recipe = {
			{"default:"..def.n.."_stones", "default:"..def.n.."_stones", "default:"..def.n.."_stones"},
			{"default:"..def.n.."_stones", "default:"..def.n.."_stones", "default:"..def.n.."_stones"},
			{"default:"..def.n.."_stones", "default:"..def.n.."_stones", "default:"..def.n.."_stones"},
		},
	})
	
	
	-- TODO: native metals in various rocks
	-- TODO: mossy versions
	-- TODO: gravels
	-- TODO: porous rocks that leak groundwater
	-- TODO: drilling and blasting
	-- TODO: quality glass production
	-- TODO: stone hardness
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

