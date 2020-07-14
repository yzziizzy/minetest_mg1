
local S = default.get_translator





local aspen_growth_data = {
	type = "blob",
	name = "aspen",
	Name = "Aspen",
	trunk_sizes = 6,
	tiles = {
		side = "default_aspen_tree.png",
		top = "default_aspen_tree_top.png",
		wood = "default_aspen_wood.png",
		stick = "default_aspen_tree.png",
	},
	speed = {
		retry = 30,
		sapling = 10,
		rand = 2,
		fruiting = 1,
		tree_growth = 60*60*0.25,
	},
	stages = {
		[1] = {
			ymin = 1, ymax=3, ysquash = 3, yoff = 2,
			xrange = 1, zrange = 1,
			rand = .2,
			dist = 1.1,
			time = 10,
			root_list = {"default:aspen_tree_trunk_root_1"},
			trunk_list = {"default:aspen_tree_trunk_1"},
			leaf_list = {"default:aspen_leaves_1","default:aspen_leaves_2","default:aspen_leaves_3",},
		},
		[2] = {
			ymin = 2, ymax=5, ysquash = 3, yoff = 2,
			xrange = 2, zrange = 2,
			rand = .6,
			dist = 1.2,
			time = 15,
			root_list = {"default:aspen_tree_trunk_root_2"},
			trunk_list = {"default:aspen_tree_trunk_2"},
			leaf_list = {"default:aspen_leaves_1","default:aspen_leaves_2","default:aspen_leaves_3",},
		},
		[3] = {
			ymin = 3, ymax=7, ysquash = 3, yoff = 3,
			xrange = 3, zrange = 3,
			rand = 1,
			dist = 1.6,
			time = 10,
			root_list = {"default:aspen_tree_trunk_root_3"},
			trunk_list = {"default:aspen_tree_trunk_3"},
			leaf_list = {"default:aspen_leaves_1","default:aspen_leaves_2","default:aspen_leaves_3",},
		},
		[4] = {
			ymin = 3, ymax=8, ysquash = 3, yoff = 3,
			xrange = 3, zrange = 3,
			rand = 1,
			dist = 1.9,
			time = 15,
			root_list = {"default:aspen_tree_trunk_root_4"},
			trunk_list = {"default:aspen_tree_trunk_4"},
			leaf_list = {"default:aspen_leaves_1","default:aspen_leaves_2","default:aspen_leaves_3",},
		},
		[5] = {
			ymin = 4, ymax = 9, ysquash = 3, yoff = 4,
			xrange = 4, zrange = 4,
			rand = 1,
			dist = 2.1,
			time = 10,
			root_list = {"default:aspen_tree_trunk_root_5"},
			trunk_list = {"default:aspen_tree_trunk_5"},
			leaf_list = {"default:aspen_leaves_1","default:aspen_leaves_2","default:aspen_leaves_3",},
		},
		[6] = {
			ymin = 5, ymax = 11, ysquash = 3, yoff = 5,
			xrange = 4, zrange = 4,
			rand = 1.1,
			dist = 2.5,
			root_list = {"default:aspen_tree_trunk_root_6"},
			trunk_list = {"default:aspen_tree_trunk_6"},
			leaf_list = {"default:aspen_leaves_1","default:aspen_leaves_2","default:aspen_leaves_3",},
		},
	}
}



default.register_tree_trunks("default", aspen_growth_data)


for i = 1,3 do
	default.register_node_seasons("default:aspen_leaves_"..i, {
		description = "Aspen Tree Leaves",
		drawtype = "allfaces_optional",
		spring = {
			tiles = {"default_aspen_leaves_spring.png^[colorize:yellow:"..((i-1)*20)},
		},
		summer = {
			tiles = {"default_aspen_leaves.png^[colorize:yellow:"..((i-1)*20)},
		},
		fall = {
			tiles = {"default_aspen_leaves_fall.png^[colorize:orange:"..((i-1)*30)},
		},
		winter = {
			tiles = {"default_aspen_leaves_winter.png^[colorize:yellow:"..((i-1)*20)},
			drop = "default:aspen_stick"
		},
		waving = 1,
		paramtype = "light",
		is_ground_content = false,
		groups = {snappy = 3, leaf_rot = 1, flammable = 2, leaves = 1},
		sounds = default.node_sound_leaves_defaults(),
	})
end



minetest.register_node("default:mg_rand_aspen_sapling", {
	description = "Aspen Tree Sapling",
	drawtype = "plantlike",
	tiles = {"default_aspen_sapling.png"},
	inventory_image = "default_aspen_sapling.png",
	wield_image = "default_aspen_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, 0.5, 3 / 16}
	},
	
	tree_def = aspen_growth_data,
	
	groups = {snappy = 2, dig_immediate = 3, flammable = 3, mg_rand_sapling = 1,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
	--[[
	on_place = function(itemstack, placer, pointed_thing)
		
		minetest.set_node(pointed_thing.above, {name="default:aspen_sapling", param2 = 0})
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

