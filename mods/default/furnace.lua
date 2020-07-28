
local S = default.get_translator


local FURNACE_TIMER = 10


local mold_formspec = "size[8,9]"..
	"list[context;main;.5,.25;2,2;]"..
	"list[context;mold;2.75,.25;1,1;]"..
	"list[context;output;4.0,.25;2,2;]"..
	"list[current_player;main;0,4.75;8,1;]"..
	"list[current_player;main;0,6.0;8,3;8]"..
	"listring[context;main]"..
	"listring[current_player;main]"..
	"listring[context;output]"..
	"listring[current_player;main]"..
	default.get_hotbar_bg(0, 4.75)


--[[
TODO:
	enclose the fire box for more heat
	minimum fire size and heat requirements
	bellows

]]

minetest.register_node("default:furnace", {
	description = S("Furnace"),
	tiles = {
		"default_sandstone.png",
		"default_sandstone.png",
		"default_sandstone.png",
		"default_sandstone.png",
		"default_sandstone.png",
		"default_furnace_front.png",
		"default_sandstone.png",
	},
	drawtype = "nodebox",
	node_box = {
		type="fixed",
		fixed = {
			-- main box
			{-0.5, -0.5, -0.5, .5,  .5, .5},
			-- legs
			{-0.65, -0.5, -0.45, .65,  -.2, .45},
			
			-- chimney
			{-0.3, .5, -0.3, .3, .8, .3},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.65, -0.5, -0.5, 0.65, 0.8, 0.5},
	},
	
	paramtype1 = "light",
	
	groups = {handed = 2},
	sounds = default.node_sound_wood_defaults(),

	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size('main', 2*2)
		inv:set_size('mold', 1)
		inv:set_size('output', 2*2)
		meta:set_string("formspec", mold_formspec)
		minetest.get_node_timer(pos):start(FURNACE_TIMER)
	end,
	
	
	on_timer = function(pos, elapsed)
		local fpos = vector.add(pos, {x=0,y=-1,z=0})
		local fnode = minetest.get_node(fpos)
		local fsz = minetest.get_item_group(fnode.name, "fire")
		
		if fsz < 1 then
-- 			print("no fire")
			return false
		end
		
-- 		print("furnace heat ".. fsz)
		
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		
		local mold_stack = inv:get_stack("mold", 1)
		local mold_name = mold_stack:get_name()
		local mold_def = minetest.registered_nodes[mold_name]
		if not mold_def then
			return true
		end
		
-- 		print("mold name "..mold_name)
		
		local ore_stack = inv:get_stack("main", 1)
		local ore_name = ore_stack:get_name()
		local ore_def = minetest.registered_nodes[ore_name]
		if not ore_def or not ore_def.ore_of then
			return true
		end
		
-- 		print("ore name ".. dump(ore_name))
		
		local ore_cnt = ore_stack:get_count()
		local ore_cont = ore_def.ore_content
		local ore_amt = ore_cnt * ore_cont
		
-- 		print("ore amt ".. ore_amt)
		
		local outname = "default:"..ore_def.ore_of.."_"..mold_def.cast_output
		
		if ore_amt < mold_def.cast_cost then
			print("not enough ore: "..ore_amt.." of "..mold_def.cast_cost)
			return true
		end
		
		local ore_used = math.ceil(mold_def.cast_cost / ore_cont)
		
-- 		print("output "..outname.. " ("..ore_used..")")
		
		ore_stack:take_item(ore_used)
		inv:set_stack("main", 1, ore_stack)
		inv:add_item("output", outname)
		
		local mold_meta = mold_stack:get_meta() 
		local mold_uses = mold_meta:get_int("uses") or 0
		
		mold_uses = mold_uses + 1
-- 		print("mold uses ".. mold_uses)
		
		if mold_uses >= mold_def.cast_max then
			inv:set_stack("mold", 1, "")
		else
			mold_meta:set_int("uses", mold_uses)
			inv:set_stack("mold", 1, mold_stack)
		end
		
		return true
	end,
})


minetest.register_abm({
	nodenames = {"default:furnace"},
	neighbors = {"group:fire"},
	interval  = 10,
	chance = 1,
	catch_up = true,
	action = function(pos, node)
		local timer = minetest.get_node_timer(pos)
		if not timer:is_started() then
			timer:start(FURNACE_TIMER)
		end
	end,
})


-- temporary craft
minetest.register_craft({
	output = "default:furnace",
	recipe = {
		{"group:wet_clay", "",               "group:wet_clay"},
		{"group:wet_clay", "",               "group:wet_clay"},
		{"group:wet_clay", "group:wet_clay", "group:wet_clay"},
	}
})
