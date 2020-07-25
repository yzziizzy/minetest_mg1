
local S = default.get_translator


local larch_growth_data = {
	type = "conifer",
	name = "larch",
	Name = "Larch",
	trunk_sizes = 6,
	trunk_thickness = .6,
	tiles = {
		side = "default_pine_tree.png^[colorize:black:30",
		top = "default_pine_tree_top.png^[colorize:brown:30",
		wood = "default_pine_wood.png^[colorize:brown:30",
		stick = "default_pine_tree.png^[colorize:brown:30",
	},
	speed = {
		retry = 30,
		sapling = 10,
		rand = 2,
		fruiting = 1,
		tree_growth = 60*60*0.5,
	},
	stages = {
		[1] = {
			trunk = { min = 2, max = 2, taper_min = 1, taper_max = 1 },
			boughs = { dist = 1.6, dist_divisor = 1, num = 2, rand = 0, },
			time = 10,
			root_list = {"default:larch_tree_trunk_root_1"},
			trunk_list = {"default:larch_tree_trunk_#"},
			leaf_list = {"default:larch_leaves_#"},
		},
		[2] = {
			trunk = { min = 3, max = 4, taper_min = 1, taper_max = 2 },
			boughs = { dist = 1.6, dist_divisor = 1, num = 3, rand = 0, },
			time = 15,
			root_list = {"default:larch_tree_trunk_root_2"},
			trunk_list = {"default:larch_tree_trunk_#"},
			leaf_list = {"default:larch_leaves_#"},
		},
		[3] = {
			trunk = { min = 5, max = 7, taper_min = 1, taper_max = 3 },
			boughs = { dist = 2, dist_divisor = 1, num = 5, rand = 0, },
			time = 10,
			root_list = {"default:larch_tree_trunk_root_3"},
			trunk_list = {"default:larch_tree_trunk_#"},
			leaf_list = {"default:larch_leaves_#"},
		},
		[4] = {
			trunk = { min = 7, max = 9, taper_min = 1, taper_max = 4 },
			boughs = { dist = 2, dist_divisor = 1, num = 7, rand = 0, },
			time = 15,
			root_list = {"default:larch_tree_trunk_root_4"},
			trunk_list = {"default:larch_tree_trunk_#"},
			leaf_list = {"default:larch_leaves_#"},
		},
		[5] = {
			trunk = { min = 9, max = 10, taper_min = 1, taper_max = 5 },
			boughs = { dist = 2, dist_divisor = 1, num = 9, rand = 0, },
			time = 10,
			root_list = {"default:larch_tree_trunk_root_5"},
			trunk_list = {"default:larch_tree_trunk_#"},
			leaf_list = {"default:larch_leaves_#"},
		},
		[6] = {
			trunk = { min = 10, max = 11, taper_min = 1, taper_max = 6 },
			boughs = { dist = 2, dist_divisor = 1, num = 10, rand = 0, },
			root_list = {"default:larch_tree_trunk_root_6"},
			trunk_list = {"default:larch_tree_trunk_#"},
			leaf_list = {"default:larch_leaves_#"},
		},
	}
}





default.register_tree_trunks("default", larch_growth_data)

--[[
for i = 1,3 do
	minetest.register_node("default:larch_leaves_"..i, {
		description = "Larch Needles",
		drawtype = "allfaces_optional",
		tiles = {"default_pine_needles.png^[colorize:green:"..((i-1)*10)},
		waving = 1,
		paramtype = "light",
		is_ground_content = false,
		groups = {snappy = 3, leaf_rot = 1, flammable = 2, leaves = 1},
		sounds = default.node_sound_leaves_defaults(),
	})
end
]]


minetest.register_node("default:mg_rand_larch_sapling", {
	description = "Larch Tree Sapling",
	drawtype = "plantlike",
	tiles = {"default_pine_sapling.png^[colorize:brown:30"},
	inventory_image = "default_pine_sapling.png^[colorize:brown:30",
	wield_image = "default_pine_sapling.png^[colorize:brown:30",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, 0.5, 3 / 16}
	},
	
	tree_def = larch_growth_data,
	
	groups = {snappy = 2, dig_immediate = 3, flammable = 3, mg_rand_sapling = 1,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
	--[[
	on_place = function(itemstack, placer, pointed_thing)
		
		minetest.set_node(pointed_thing.above, {name="default:larch_sapling", param2 = 0})
		local timer = minetest.get_node_timer(pointed_thing.above)
		timer:start(orange_speed.sapling + gr())
		
		itemstack:take_item(1)
		return itemstack
	end,
	
	on_timer = function(pos, elapsed)
		default.advance_trunk(pos, 0)
	end,
	]]
})

local function boxrot(def, n)
	local t = {}
	for _,q in ipairs(def) do
		if n == "right" then
			table.insert(t, {q[1], q[2], q[3], q[4], q[5], q[6]})
		elseif n == "left" then
			table.insert(t, {-q[1], q[2], q[3], -q[4], q[5], q[6]})
		elseif n == "back" then
			table.insert(t, {q[3], q[2], q[1], q[6], q[5], q[4]})
		elseif n == "front" then
			table.insert(t, {q[3], q[2], -q[1], q[6], q[5], -q[4]})
		end
	end
	
	return t
end

local function boxrotdim(def, dim)
	local t = {}
	for _,q in ipairs(def) do
		if dim.x == 1 then
			table.insert(t, {q[2], q[4], q[3], q[5], q[1], q[6]})
		elseif dim.x == -1 then
			table.insert(t, {-q[1], q[2], q[3], -q[4], q[5], q[6]})
		elseif dim.z == 1 then
			table.insert(t, {q[2], q[4], q[3], q[5], q[1], q[6]})
		elseif dim.z == -1 then
			table.insert(t, {q[3], q[2], -q[1], q[6], q[5], -q[4]})
		end
	end
	
	return t
end

local function boxtrans(def, amt)
	for _,q in ipairs(def) do
		q[1] = q[1] + amt.x
		q[2] = q[2] + amt.y
		q[3] = q[3] + amt.z
		q[4] = q[4] + amt.x
		q[5] = q[5] + amt.y
		q[6] = q[6] + amt.z
	end
	
	return def
end

local function box_shell(def)
	local w = {99,99,99,-99,-99,-99}
	
	for _,q in ipairs(def) do
		w[1] = math.min(w[1], q[1])
		w[2] = math.min(w[2], q[2])
		w[3] = math.min(w[3], q[3])
		w[4] = math.max(w[4], q[4])
		w[5] = math.max(w[5], q[5])
		w[6] = math.max(w[6], q[6])
	end
	
	return w
end


local needle_boxen = {
	{ -- 1
		{.89,  0.45, -0.11, 1.0, 0.81,  0.11}, -- lvl 1
		{.7,  0.15, -0.15, 1.0, 0.501,  0.15}, -- lvl 1
		{.5,  0.05, -0.25, 1.0, 0.15,   0.25}, -- lvl 2
	},
	{ -- 2
		{.7,  0.25, -0.15, 1.0, 0.499,  0.15}, -- lvl 1
		{.5,  0.15, -0.25, 1.0, 0.25,   0.25}, -- lvl 2
		{.35, -0.05, -0.35, 1.0, 0.15,   0.35}, -- lvl 2
	},
	{ -- 3
		{.7,  0.25, -0.15, 1.0, 0.499,  0.15}, -- lvl 1
		{.5,  0.15, -0.25, 1.0, 0.25,   0.25}, -- lvl 2
		{.35, -0.05, -0.35, 1.0, 0.15,   0.35}, -- lvl 2
		{.15, -0.15, -0.55, 0.7, -.05,   0.55}, -- lvl 2
	},
	{ -- 4
-- 		{.7,  0.25, -0.15, 1.0, 0.499,  0.15}, -- lvl 1
		{.5,  0.15, -0.251, 1.0, 0.25,   0.251}, -- lvl 2
		{.25, -0.05, -0.45, 1.0, 0.15,   0.45}, -- lvl 2
		{0.0, -0.2, -0.7, 0.7, -.05,   0.7}, -- lvl 2
	},
	{ -- 5
		{.5,  0.15, -0.251, 1.0, 0.25,   0.251}, -- lvl 2
		{.25, -0.05, -0.45, 1.0, 0.15,   0.45}, -- lvl 2
		{0.0, -0.2, -0.83, 0.7, -.05,   0.83}, -- lvl 2
		{-.25, -0.2, -0.55, 0.5, -.10,   0.55}, -- lvl 2
	},
	{ -- 6
		{-0.45, -0.2, -0.75, 0.3, 0.1, 0.75}, -- base
		{-0.6, -0.2, -0.4, 0.3, -0.0, 0.4}, -- base 2
		{-0.05, -0.2, -0.95, 0.35, -0.0, 0.95}, -- base 3
		{-0.3,  0.1, -0.5, 0.8, 0.25, 0.5}, -- lvl 1
		{ 0.1,  0.25, -0.3, 1.0, 0.35, 0.3}, -- lvl 2
		{ 0.3,  0.35, -0.2, 1.0, 0.45, 0.2}, -- lvl 3
		{ 0.4,  0.45, -0.15, 1.0, 0.499,  0.15}, -- lvl 4
	},
}

for sz = 1,6 do
	
	local sh = -0.5 + (sz * larch_growth_data.trunk_thickness / 16) 
	
	default.register_node_seasons("default:larch_leaves_"..sz, {
		description = "Larch Needles",
		tiles = {"default_pine_needles.png"},
		paramtype = "light",
		drawtype = "nodebox",
		
		spring = {
			tiles = {"default_larch_needles_spring.png"},
		},
		summer = {
			tiles = {"default_larch_needles_summer.png"},
		},
		fall = {
			tiles = {"default_larch_needles_fall.png"},
		},
		winter = {
			tiles = {"default_larch_needles_winter.png"},
			drop = "default:larch_stick"
		},
		
		node_box = {
			type = "connected",
			disconnected = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			connect_left = boxrot(needle_boxen[sz], "left"),
			connect_right = boxrot(needle_boxen[sz], "right"),
			connect_front = boxrot(needle_boxen[sz], "front"),
			connect_back = boxrot(needle_boxen[sz], "back"),
		
		},
		collision_box = {
			type = "connected",
			disconnected = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
			connect_left = boxrot({box_shell(needle_boxen[sz])}, "left"),
			connect_right = boxrot({box_shell(needle_boxen[sz])}, "right"),
			connect_front = boxrot({box_shell(needle_boxen[sz])}, "front"),
			connect_back = boxrot({box_shell(needle_boxen[sz])}, "back"),
		},
		selection_box = {
			type = "connected",
			disconnected = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
			connect_left = boxrot({box_shell(needle_boxen[sz])}, "left"),
			connect_right = boxrot({box_shell(needle_boxen[sz])}, "right"),
			connect_front = boxrot({box_shell(needle_boxen[sz])}, "front"),
			connect_back = boxrot({box_shell(needle_boxen[sz])}, "back"),
		},
		connects_to = {"group:tree_trunk"},
		drop = "default:larch_stick "..math.ceil(sz/2),
		sunlight_propagates = true,
		groups = {axed = 3, oddly_breakable_by_hand = 2, larch_leaves=1, leaves=1, flammable = 2, plant = 1},
		sounds = default.node_sound_wood_defaults(),
	})
	
	
	minetest.register_node("default:fallen_larch_leaves_"..sz.."_t", {
		description = "Dead Larch Needles",
		tiles = {"default_larch_needles_fall.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		
		node_box = {
			type = "fixed",
			fixed = boxtrans(boxrotdim(boxrot(needle_boxen[sz], "left"), {x=1, z=0}), {x=0, y=sh, z=0}),
		},
		collision_box = {
			type = "fixed",
			fixed = boxtrans(boxrotdim(boxrot(needle_boxen[sz], "left"), {x=1, z=0}), {x=0, y=sh, z=0}),
		},
		selection_box = {
			type = "fixed",
			fixed = boxtrans(boxrotdim(boxrot(needle_boxen[sz], "left"), {x=1, z=0}), {x=0, y=sh, z=0}),
		},
		drop = "default:larch_stick "..math.ceil(sz/2),
		sunlight_propagates = true,
		groups = {axed = 3, oddly_breakable_by_hand = 1, falling_node=1, larch_leaves=1, leaves=1, flammable = 2, plant = 1},
		sounds = default.node_sound_wood_defaults(),
	})
	minetest.register_node("default:fallen_larch_leaves_"..sz.."_l", {
		description = "Dead Larch Needles Side X",
		tiles = {"default_larch_needles_fall.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		
		node_box = {
			type = "fixed",
			fixed = boxtrans(boxrotdim(boxrot(needle_boxen[sz], "front"), {x=1, z=0}), {x=0, y=sh, z=0}),
		},
		collision_box = {
			type = "fixed",
			fixed = boxtrans(boxrotdim(boxrot(needle_boxen[sz], "front"), {x=1, z=0}), {x=0, y=sh, z=0}),
		},
		selection_box = {
			type = "fixed",
			fixed = {-.5, -.5, -.5, .5,.5,.5},
-- 			fixed = boxtrans(boxrotdim(boxrot(needle_boxen[sz], "left"), {x=1, z=0}), {x=0, y=sh, z=0}),
		},
		drop = "default:larch_stick "..math.ceil(sz/2),
		sunlight_propagates = true,
		groups = {axed = 3, oddly_breakable_by_hand = 1, falling_node=1, larch_leaves=1, leaves=1, flammable = 2, plant = 1},
		sounds = default.node_sound_wood_defaults(),
	})
	minetest.register_node("default:fallen_larch_leaves_"..sz.."_r", {
		description = "Dead Larch Needles Side Z",
		tiles = {"default_larch_needles_fall.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		
		node_box = {
			type = "fixed",
			fixed = boxtrans(boxrotdim(boxrot(needle_boxen[sz], "back"), {x=1, z=0}), {x=0, y=sh, z=0}),
		},
		collision_box = {
			type = "fixed",
			fixed = boxtrans(boxrotdim(boxrot(needle_boxen[sz], "back"), {x=1, z=0}), {x=0, y=sh, z=0}),
		},
		selection_box = {
			type = "fixed",
			fixed = {-.5, -.5, -.5, .5,.5,.5},
-- 			fixed = boxtrans(boxrotdim(boxrot(needle_boxen[sz], "left"), {x=1, z=0}), {x=0, y=sh, z=0}),
		},
		drop = "default:larch_stick "..math.ceil(sz/2),
		sunlight_propagates = true,
		groups = {axed = 3, oddly_breakable_by_hand = 1, falling_node=1, larch_leaves=1, leaves=1, flammable = 2, plant = 1},
		sounds = default.node_sound_wood_defaults(),
	})
end


minetest.register_craft({
	output = "default:larch_stick",
	type = "shapeless",
	recipe = {"group:larch_leaves"}
})
