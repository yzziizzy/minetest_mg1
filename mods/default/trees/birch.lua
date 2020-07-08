

local birch_speed = {
	retry = 30,
	sapling = 10,
	rand = 2,
	fruiting = 1,
	tree_growth = 10,
}



local birch_stage_data = {
	[1] = {
		ymin = 1, ymax=2, ysquash = 3, yoff = 2,
		xrange = 1, zrange = 1,
		rand = .2,
		dist = 1.1,
		time = 10 * birch_speed.tree_growth,
		root_list = {"default:birch_tree_trunk_root_1"},
		trunk_list = {"default:birch_tree_trunk_1"},
		leaf_list = {"default:birch_leaves_1","default:birch_leaves_2","default:birch_leaves_3",},
	},
	[2] = {
		ymin = 2, ymax=4, ysquash = 3, yoff = 2,
		xrange = 2, zrange = 2,
		rand = .6,
		dist = 1.2,
		time = 15 * birch_speed.tree_growth,
		root_list = {"default:birch_tree_trunk_root_2"},
		trunk_list = {"default:birch_tree_trunk_2"},
		leaf_list = {"default:birch_leaves_1","default:birch_leaves_2","default:birch_leaves_3",},
	},
	[3] = {
		ymin = 3, ymax=6, ysquash = 3, yoff = 3,
		xrange = 3, zrange = 3,
		rand = 1,
		dist = 1.6,
		time = 10 * birch_speed.tree_growth,
		root_list = {"default:birch_tree_trunk_root_3"},
		trunk_list = {"default:birch_tree_trunk_3"},
		leaf_list = {"default:birch_leaves_1","default:birch_leaves_2","default:birch_leaves_3",},
	},
	[4] = {
		ymin = 3, ymax=7, ysquash = 3, yoff = 3,
		xrange = 3, zrange = 3,
		rand = 1,
		dist = 1.9,
		time = 15 * birch_speed.tree_growth,
		root_list = {"default:birch_tree_trunk_root_4"},
		trunk_list = {"default:birch_tree_trunk_4"},
		leaf_list = {"default:birch_leaves_1","default:birch_leaves_2","default:birch_leaves_3",},
	},
	[5] = {
		ymin = 4, ymax = 8, ysquash = 3, yoff = 4,
		xrange = 4, zrange = 4,
		rand = 1,
		dist = 2.1,
		time = 10 * birch_speed.tree_growth,
		root_list = {"default:birch_tree_trunk_root_5"},
		trunk_list = {"default:birch_tree_trunk_5"},
		leaf_list = {"default:birch_leaves_1","default:birch_leaves_2","default:birch_leaves_3",},
	},
	[6] = {
		ymin = 5, ymax = 10, ysquash = 3, yoff = 5,
		xrange = 4, zrange = 4,
		rand = 1.1,
		dist = 2.5,
		root_list = {"default:birch_tree_trunk_root_6"},
		trunk_list = {"default:birch_tree_trunk_6"},
		leaf_list = {"default:birch_leaves_1","default:birch_leaves_2","default:birch_leaves_3",},
	},
}




for sz = 1,6 do
	local q = sz * 1
	minetest.register_node("default:birch_tree_trunk_root_"..sz, {
		description = "Birch Tree Root",
		tiles = {"default_aspen_tree_top.png", "default_aspen_tree_top.png", "default_aspen_tree.png^[colorize:brown:50"},
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
		
		tree_def = birch_stage_data,
		
		on_place = function(itemstack, placer, pointed_thing)
			local stack = minetest.rotate_node(itemstack, placer, pointed_thing)
			
			local m = stage_data[sz]
			if m.time then
				minetest.get_node_timer(pointed_thing.above):start(m.time)
			end
			return stack
		end,
		
		on_timer = function(pos, elapsed)
			default.advance_trunk(pos, elapsed, birch_stage_data)
		end,
	})
	
	minetest.register_node("default:birch_tree_trunk_"..sz, {
		description = "Birch Tree",
		tiles = {"default_aspen_tree_top.png", "default_aspen_tree_top.png", "default_aspen_tree.png^[colorize:brown:50^[colorize:brown:20"},
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
	minetest.register_node("default:birch_leaves_"..i, {
		description = "Birch Tree Leaves",
		drawtype = "allfaces_optional",
		tiles = {"default_aspen_leaves.png^[colorize:green:"..((i-1)*30)},
		waving = 1,
		paramtype = "light",
		is_ground_content = false,
		groups = {snappy = 3, leaf_rot = 1, flammable = 2, leaves = 1},
		drop = "default:birch_leaves_"..i,
		sounds = default.node_sound_leaves_defaults(),
	})
end



minetest.register_node("default:mg_rand_birch_sapling", {
	description = "Birch Tree Sapling",
	drawtype = "plantlike",
	tiles = {"default_aspen_sapling.png^[colorize:green:80"},
	inventory_image = "default_aspen_sapling.png^[colorize:green:80",
	wield_image = "default_aspen_sapling.png^[colorize:green:80",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, 0.5, 3 / 16}
	},
	
	tree_def = birch_stage_data,
	
	groups = {snappy = 2, dig_immediate = 3, flammable = 3, mg_rand_blob_sapling = 1,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
	--[[
	on_place = function(itemstack, placer, pointed_thing)
		
		minetest.set_node(pointed_thing.above, {name="default:birch_sapling", param2 = 0})
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

