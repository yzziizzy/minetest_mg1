
local S = default.get_translator


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


local metals

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
		minetest.get_node_timer(pos):start(2)
	end,

	--[[
	on_metadata_inventory_put = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		
		local input = inv:get_stack("main", 1)
		local avail = (input and input:get_count()) or 0 
		
		if avail > 0 then
			for i,mn in pairs(mold_types) do
				inv:set_stack('output', i, "default:sandmold_"..mn.." "..avail)
			end
		else
			inv:set_list("main", {})
			inv:set_list("output", {})
		end
		
	end,
	
	--[[
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local input = inv:get_stack("main", 1)
		local avail = (input and input:get_count()) or 0 
		local taken = stack:get_count()
			
		local remain = avail - taken
		
		if listname == "output" then
			if remain == 0 then
				inv:set_list("main", {})
				inv:set_list("output", {})
				return
			end
			
			input:set_count(remain)
			inv:set_stack("main", 1, input)
			for i,mn in pairs(mold_types) do
				inv:set_stack('output', i, "default:sandmold_"..mn.." "..remain)
			end
			
		elseif listname == "main" then
			
			if remain > 0 then
				for i,mn in pairs(mold_types) do
					inv:set_stack('output', i, "default:sandmold_"..mn.." "..remain)
				end
			else
				inv:set_list("main", {})
				inv:set_list("output", {})
			end
		end
	end,
--[[
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end
		
		-- only greensand
		local iname = stack:get_name()
		local g = minetest.registered_items[iname]
		if not g.groups.green_sand then
			return 0
		end
		
		-- only into the input
		if listname == "main" then
			return stack:get_count()
		else
			return 0
		end
	end,
	
	allow_metadata_inventory_move = function()
		return 0
	end,
	
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end

		return stack:get_count()
	end,
	]]
	
	on_timer = function(pos, elapsed)
		local fpos = vector.add(pos, {x=0,y=-1,z=0})
		local fnode = minetest.get_node(fpos)
		local fsz = minetest.get_item_group(fnode.name, "fire")
		
		if fsz < 1 then
-- 			print("no fire")
			return true
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
		
		print("mold name "..mold_name)
		
		local ore_stack = inv:get_stack("main", 1)
		local ore_name = ore_stack:get_name()
		local ore_def = minetest.registered_nodes[ore_name]
		if not ore_def or not ore_def.ore_of then
			return true
		end
		
		print("ore name ".. dump(ore_name))
		
		local ore_cnt = ore_stack:get_count()
		local ore_cont = ore_def.ore_content
		local ore_amt = ore_cnt * ore_cont
		
		print("ore amt ".. ore_amt)
		
		local outname = "default:"..ore_def.ore_of.."_"..mold_def.cast_output
		
		if ore_amt < mold_def.cast_cost then
			print("not enough ore")
			return true
		end
		
		local ore_used = math.ceil(mold_def.cast_cost / ore_cont)
		
		print("output "..outname.. " ("..ore_used..")")
		
		ore_stack:take_item(ore_used)
		inv:set_stack("main", 1, ore_stack)
		inv:add_item("output", outname)
		
		mwear = mold_stack:get_wear() * (mold_def.cast_max / 65535)
		if mwear == 0 then
			mwear = mold_def.cast_max
		end
		print(mwear)
		mwear = math.floor(math.max(0, mwear - (1 / mold_def.cast_max)))
		print(mwear)
		if mwear <= 0 then
			inv:set_stack("mold", 1, "")
		else
			mold_stack:set_wear(mwear * (65535 / mold_def.cast_max))
			inv:set_stack("mold", 1, mold_stack)
		end
		
		return true
	end,
})


metals = {
	
}
