


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

water-beating rock, aquifers, water tables and saturated soil

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
	groups = {cracky = 3, handed = 3},
	sounds = default.node_sound_glass_defaults(),
})


local stonedefs_ = {
	-- hardness: higher is harder
	-- n_ame, d_escription, t_ype, h_ardness, cr_umbling
	{n="granite", d="Granite", t="i", h=3, cr=1, g={tool_grade=1}}, --
	{n="basalt", d="Basalt", t="i", h=3, cr=1, g={tool_grade=1}}, --
	{n="obsidian", d="Obsidian", t="i", h=4, g={tool_grade=1}}, --
	{n="pumice", d="Pumice", t="i", h=1, cr=1}, --

	{n="limestone", d="Limestone", t="s", h=2, cr=1}, --
	{n="sandstone", d="Sandstone", t="s", h=2, cr=1}, --
	{n="gypsum", d="Gypsum", t="s", h=1, cr=1}, --
	{n="halite", d="Halite", t="s", h=2, cr=1}, --
	{n="shale", d="Shale", t="s", h=2, cr=1}, --
	{n="conglomerate", d="Conglomerate", t="s", h=2, cr=1}, --
	{n="chalk", d="Chalk", t="s", h=1, cr=1}, --
	{n="breccia", d="Breccia", t="s", h=2, cr=1}, --
	{n="mudstone", d="Mudstone", t="s", h=3, cr=1}, --
	
	{n="marble", d="Marble", t="m", h=3}, --
	{n="gneiss", d="Gneiss", t="m", h=3, g={tool_grade=1}}, --
	{n="slate", d="Slate", t="m", h=4}, --
	{n="schist", d="Schist", t="m", h=3, g={tool_grade=1}}, --
	{n="serpentine", d="Serpentine", t="m", h=3}, --
	
	-- fossil rocks
	{n="lignite", d="Lignite", t="f", h=1, cr=1}, 
	{n="bitumenous_coal", d="Coal", t="f", h=2, cr=1},
	{n="anthracite", d="Anthracite Coal", t="f", h=3, cr=1},
	{n="graphite", d="Graphite", t="f", h=4}, 
-- 	{n="oil_shale", d="Oil Shale", t="f", h=2},
-- 	{n="tar_sand", d="tar_sand", t="f", h=1}, -- remove, not being stone?


	-- ores
	{
		n="limestone_with_malachite", d="Limestone with Malachite", t="s", h=2, 
		tile="default_limestone.png^default_malachite.png",
		ex = {
			ore_of = "copper",
			ore_content = 1,
		},
		g = {ore = 1, copper_ore = 1},
	}, --
	
}

default.stonedefs = {}
local stonedefs = default.stonedefs

for _,v in ipairs(stonedefs_) do
	stonedefs[v.n] = {
		name = v.n,
		Name = v.d,
		type = v.t,
		groups = v.g,
		hardness = v.h,
		extra_def = v.ex,
		crumbling = v.cr,
	}
end
-- print(dump(stonedefs))



local stone_types = {
	["i"] = 1,
	["s"] = 2,
	["m"] = 3,
	["f"] = 4,
}
local stone_info = {
	[1] = {
		name = "igneous",
		Name = "Igneous",
		type = 1,
	},
	[2] = {
		name = "sedimentary",
		Name = "Sedimentary",
		type = 2,
	},
	[3] = {
		name = "conglomerate",
		Name = "Conglomerate",
		type = 3,
	},
	[4] = {
		name = "fossil",
		Name = "Fossil",
		type = 4,
	},
}
default.stone_type_info = stone_info


local function mkbox(x,y,z, szx, szy, szz)
	if szy <= 0 then
		return {}
	end
	return {x, y, z, x+szx, y+szy, z+szz}
end

local function ct(a, b, c)
	local o = {}
	          for k,v in pairs(a or {}) do o[k] = v end
	          for k,v in pairs(b or {}) do o[k] = v end
	if c then for k,v in pairs(c or {}) do o[k] = v end end
	return o
end

local function et(a, b, c)
	if b then for k,v in pairs(b or {}) do a[k] = v end end
	if c then for k,v in pairs(c or {}) do a[k] = v end end
	return a
end

for i,def in pairs(stonedefs_) do
	local tile = def.tile or ("default_"..def.n..".png")
	local sid = stone_types[def.t]
	local sinfo = stone_info[sid]
	
	local stone_groups = {
		stone = 1,
		stone_type = sid,
		
		picked = def.h,
	}
	stone_groups["stone_"..sinfo.name] = 1
	
	local cobble_groups = {
		cobble = 1,
		falling_node = 1,
		stone_type = sid,
		
		shoveled = 2,
		handed = 1,
	}
	cobble_groups["cobble_"..sinfo.name] = 1
	
	local stones_groups = {
		--stones = i, -- added lower in loop
		falling_node = 1,
		stone_type = sid,
		
		shoveled = 2,
		handed = 1,
	}
	stones_groups["stones_"..sinfo.name] = 1
	
	
	
	
	local cobble_def = {
		description = def.d.." Cobble",
		tiles = {tile.."^default_cobble.png"},
		groups = ct(cobble_groups, def.g),
		sounds = default.node_sound_stone_defaults(),
		
		ore_of = def.ore_of,
		ore_content = def.ore_content,
-- 		node_placement_prediction = "default:"..def.n.."_cobble_2",
-- 		on_dig = function(pos, node, digger)
-- 			minetest.set_node(pos, {name="default:"..def.n.."_cobble_2"})
-- 		end
	}
	et(cobble_def, def.ex)
	minetest.register_node("default:"..def.n.."_cobble", cobble_def)
	
	
	
	
	local stone_def = {
		description = def.d,
		tiles = {tile},
	
		ore_of = def.ore_of,
		ore_content = def.ore_content,
		
		cobble = "default:"..def.n.."_cobble",
		
		groups = ct(stone_groups, def.g),
		drop = "default:"..def.n.."_stones 9",
		node_placement_prediction = "default:"..def.n.."_2",
		sounds = default.node_sound_stone_defaults(),
		on_dig = function(pos, node, digger)
			local b = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z})
			
			default.player_add_inv(digger, "default:"..def.n.."_stones 3")
			
			if b.name ~= "air" and 0 == minetest.get_item_group(b.name, "partial_stone") then
				minetest.set_node(pos, {name="default:"..def.n.."_2"})
				return
			end
			local u = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z})
			if u.name ~= "air" then
				minetest.set_node(pos, {name="default:"..def.n.."_2", param2 = 20})
				return
			end
			
			minetest.set_node(pos, {name="default:"..def.n.."_2"})
		end
	}
	et(stone_def, def.ex)
	minetest.register_node("default:"..def.n, stone_def)
	
	local stone_def_2 = {
		description = def.d,
		tiles = {tile},
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, .16667, 0.5},
		},
		
		
		ore_of = def.ore_of,
		ore_content = (def.ore_content or 0) * (2 / 3),
		
		cobble = "default:"..def.n.."_stones_6",
		
		groups = ct(stone_groups, def.g, {partial_stone=2}),
		drop = "default:"..def.n.."_stones 6",
		node_placement_prediction = "default:"..def.n.."_3",
		sounds = default.node_sound_stone_defaults(),
		on_dig = function(pos, node, digger)
			
			default.player_add_inv(digger, "default:"..def.n.."_stones 3")
			
			local b = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z})
			if b.name ~= "air" and 0 == minetest.get_item_group(b.name, "partial_stone") then
				minetest.set_node(pos, {name="default:"..def.n.."_3"})
				return
			end
			local u = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z})
			if u.name ~= "air" then
				minetest.set_node(pos, {name="default:"..def.n.."_3", param2 = 20})
				return
			end
			
			minetest.set_node(pos, {name="default:"..def.n.."_3"})
		end
	}
	et(stone_def_2, def.ex)
	minetest.register_node("default:"..def.n.."_2", stone_def_2)
	
	
	local stone_def_3 = {
		description = def.d,
		tiles = {tile},
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -0.16667, 0.5},
		},
		
		cobble = "default:"..def.n.."_stones_3",
		
		ore_of = def.ore_of,
		ore_content = (def.ore_content or 0) / 3,
		
		groups = ct(stone_groups, def.g, {partial_stone=3}),
		drop = "default:"..def.n.."_stones 3",
		sounds = default.node_sound_stone_defaults(),
	}
	et(stone_def_3, def.ex)
	minetest.register_node("default:"..def.n.."_3", stone_def_3)
	
	
	-- pile of stones on the ground
	for i_ = 1,8 do
		local i = i_
		local g = ""
		if i > 1 then
			g = "_"..i
		end
		
		local h = (i - 1) * 0.105
		
		local stones_def = {
			description = def.d .. " Stones",
			tiles = {tile, tile.."^default_cobble.png"},
			paramtype = "light",
			drawtype = "nodebox",
			node_box = {
				type = "fixed",
				fixed = {
					mkbox(-0.3, -0.5+h,-0.3, 0.2, 0.1,  0.2),
					mkbox(0.05, -0.5+h, 0.3, 0.1, 0.1,  0.1),
					mkbox(-0.1, -0.5+h,-0.1, 0.2, 0.2,  0.2),
					mkbox(0.2,  -0.5+h,  0.1, 0.1, 0.1,  0.1),
					mkbox(0.0,  -0.5+h,  0.0,-0.3, 0.07, 0.3),
					mkbox(0.3,  -0.5+h, -0.3, 0.1, 0.05, 0.1),
					
					mkbox(-0.5, -0.5, -0.5, 1, h, 1),
				},
			},
			selection_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, -0.5, 0.5, -0.4+h, 0.5},
			},
			sunlight_propagates = true,
			num_stones = i,
			drop = "default:"..def.n.."_stones "..i,
			
			ore_of = def.ex and def.ex.ore_of,
			ore_content = def.ex and ((def.ex.ore_content or 0) * (i/9)),
			
			groups = ct(stones_groups, def.g, {stones = i}),
			sounds = default.node_sound_stone_defaults(),
		}
		et(stones_def, def.ex)
		if stones_def.ore_content then
			stones_def.ore_content = stones_def.ore_content * (i/9)
		end
		stones_def.groups["stones_"..sinfo.name.."_"..i] = 1
		minetest.register_node("default:"..def.n.."_stones"..g, stones_def)
		
		
		if i > 1 then
			minetest.register_craft({
				output = "default:"..def.n.."_stones "..i,
				type = "shapeless",
				recipe = {"default:"..def.n.."_stones_"..i}
			})
			
			local w = {}
			for j = 1,i do
				w[j] = "default:"..def.n.."_stones"
			end
			minetest.register_craft({
				output = "default:"..def.n.."_stones_"..i,
				type = "shapeless",
				recipe = w,
			})
		end
	end
	
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
	
	
	-- crumbling
	
	if def.cr then
		default.register_crumbling("default:"..def.n, {
			corner = { drop = "default:"..def.n.."_stones 7" },
			edge = { drop = "default:"..def.n.."_stones 6" },
		})
	end
	
	
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

minetest.register_node("default:sandstone_with_cassiterite", {
	description = "Sandtone with Cassiterite",
	tiles = {"default_snow.png"},
	groups = {crumbly = 3, cools_lava = 1, snowy = 1},
	sounds = default.node_sound_snow_defaults(),
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



-- collapsing
minetest.register_abm({
	nodenames = {"group:stone"},
	neightbors = {"air"},
	interval  = 5000000000,
	chance = 100,
	catch_up = true,
	action = function(pos, node)
		
		pos.y = pos.y - 1
		local n = minetest.get_node(pos)
		if n.name ~= "air" then
			return
		end
		pos.y = pos.y + 1
		
		
		airs = minetest.find_nodes_in_area(
			{x=pos.x - 1, y=pos.y - 1, z=pos.z - 1},
			{x=pos.x + 1, y=pos.y - 1, z=pos.z + 1},
			"air"
		)
		
		if #airs > 5 and 1 == math.random(10 - #airs) then
			local def = minetest.registered_nodes[node.name]
			minetest.set_node(pos, {name = def.cobble})
			minetest.spawn_falling_node(pos)
		end
		
		
	end,
})
