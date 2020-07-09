
local S = default.get_translator


local fir_growth_data = {
	type = "conifer",
	speed = {
		retry = 30,
		sapling = 10,
		rand = 2,
		fruiting = 1,
		tree_growth = 1,
	},
	stages = {
		[1] = {
			trunk = { min = 2, max = 2, taper_min = 1, taper_max = 1 },
			boughs = { dist = 1.6, dist_divisor = 1, num = 1, rand = 0, },
			time = 10,
			root_list = {"default:fir_tree_trunk_root_1"},
			trunk_list = {"default:fir_tree_trunk_#"},
			leaf_list = {"default:fir_leaves_1","default:fir_leaves_2","default:fir_leaves_3",},
		},
		[2] = {
			trunk = { min = 3, max = 4, taper_min = 1, taper_max = 2 },
			boughs = { dist = 1.6, dist_divisor = 1, num = 2, rand = 0, },
			time = 15,
			root_list = {"default:fir_tree_trunk_root_2"},
			trunk_list = {"default:fir_tree_trunk_#"},
			leaf_list = {"default:fir_leaves_1","default:fir_leaves_2","default:fir_leaves_3",},
		},
		[3] = {
			trunk = { min = 5, max = 7, taper_min = 1, taper_max = 3 },
			boughs = { dist = 2, dist_divisor = 1, num = 3, rand = 0, },
			time = 10,
			root_list = {"default:fir_tree_trunk_root_3"},
			trunk_list = {"default:fir_tree_trunk_#"},
			leaf_list = {"default:fir_leaves_1","default:fir_leaves_2","default:fir_leaves_3",},
		},
		[4] = {
			trunk = { min = 7, max = 9, taper_min = 1, taper_max = 4 },
			boughs = { dist = 2, dist_divisor = 1, num = 3, rand = 0, },
			time = 15,
			root_list = {"default:fir_tree_trunk_root_4"},
			trunk_list = {"default:fir_tree_trunk_#"},
			leaf_list = {"default:fir_leaves_1","default:fir_leaves_2","default:fir_leaves_3",},
		},
		[5] = {
			trunk = { min = 9, max = 10, taper_min = 1, taper_max = 5 },
			boughs = { dist = 2, dist_divisor = 1, num = 4, rand = 0, },
			time = 10,
			root_list = {"default:fir_tree_trunk_root_5"},
			trunk_list = {"default:fir_tree_trunk_#"},
			leaf_list = {"default:fir_leaves_1","default:fir_leaves_2","default:fir_leaves_3",},
		},
		[6] = {
			trunk = { min = 10, max = 11, taper_min = 1, taper_max = 6 },
			boughs = { dist = 2, dist_divisor = 1, num = 5, rand = 0, },
			root_list = {"default:fir_tree_trunk_root_6"},
			trunk_list = {"default:fir_tree_trunk_#"},
			leaf_list = {"default:fir_leaves_1","default:fir_leaves_2","default:fir_leaves_3",},
		},
	}
}



minetest.register_craftitem("default:fir_stick", {
	description = S("Fir Stick"),
	inventory_image = "default_stick.png^[colorize:brown:40",
	groups = {stick = 1, flammable = 2},
})

for sz = 1,6 do
	local q = sz * 1
	minetest.register_node("default:fir_tree_trunk_root_"..sz, {
		description = "Fir Tree Root",
		tiles = {"default_pine_tree_top.png", "default_pine_tree_top.png", "default_pine_tree.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		
		node_box = {
			type = "fixed",
			fixed = {-q/16, -0.5, -q/16, q/16, 0.5, q/16},
		},
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {
			tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, plant = 1,
			tree_trunk = 1, tree_trunk_root_fertile = 1,
		},
		sounds = default.node_sound_wood_defaults(),
		
		tree_def = fir_growth_data,
		
		on_place = function(itemstack, placer, pointed_thing)
			local stack = minetest.rotate_node(itemstack, placer, pointed_thing)
			
			local m = stage_data[sz]
			if m.time then
				minetest.get_node_timer(pointed_thing.above):start(m.time * fir_growth_data.speed.tree_growth)
			end
			return stack
		end,
		
		on_timer = function(pos, elapsed)
			default.advance_tree(pos, elapsed, fir_growth_data)
		end,
	})
	
	minetest.register_node("default:fir_tree_trunk_"..sz, {
		description = "Fir Tree",
		tiles = {"default_pine_tree_top.png", "default_pine_tree_top.png", "default_pine_tree.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		
		node_box = {
			type = "fixed",
			fixed = {-q/16, -0.5, -q/16, q/16, 0.5, q/16},
		},
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {
			tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, plant = 1,
			tree_trunk = 1, 
		},
		sounds = default.node_sound_wood_defaults(),
		on_place = minetest.rotate_node,
		
	})
	
end


for i = 1,3 do
	minetest.register_node("default:fir_leaves_"..i, {
		description = "Fir Needles",
		drawtype = "allfaces_optional",
		tiles = {"default_pine_needles.png^[colorize:green:"..((i-1)*10)},
		waving = 1,
		paramtype = "light",
		is_ground_content = false,
		groups = {snappy = 3, leaf_rot = 1, flammable = 2, leaves = 1},
		sounds = default.node_sound_leaves_defaults(),
	})
end



minetest.register_node("default:mg_rand_fir_sapling", {
	description = "Fir Tree Sapling",
	drawtype = "plantlike",
	tiles = {"default_pine_sapling.png"},
	inventory_image = "default_pine_sapling.png",
	wield_image = "default_pine_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, 0.5, 3 / 16}
	},
	
	tree_def = fir_growth_data,
	
	groups = {snappy = 2, dig_immediate = 3, flammable = 3, mg_rand_blob_sapling = 1,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
	--[[
	on_place = function(itemstack, placer, pointed_thing)
		
		minetest.set_node(pointed_thing.above, {name="default:fir_sapling", param2 = 0})
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

