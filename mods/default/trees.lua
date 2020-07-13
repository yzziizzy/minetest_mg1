



-- follow tree trunks down to the root
function default.find_tree_bottom(pos)
	local p2 = {x=pos.x, y=pos.y, z=pos.z}
	
	local n = minetest.get_node(p2)
	local name = n.name
	
	for i = 1,10 do
		p2.y = p2.y - 1
		local n = minetest.get_node(p2)
		if n.name ~= name then
			p2.y = p2.y + 1
			return true, p2, n.name
		end
	end
	
	return false, p2, "air"
end

function default.find_tree_root(pos)
	local p2 = {x=pos.x, y=pos.y, z=pos.z}
	
	local n = minetest.get_node(p2)
	local name = n.name
	
	for i = 1,10 do
		p2.y = p2.y - 1
		local n = minetest.get_node(p2)
		if n.name ~= name then
			def = minetest.registered_nodes[n.name]
			if def.groups.tree_trunk_root_fertile then
				return true, p2, n.name
			end
		end
	end
	
	return false, p2, "air"
end




function default.install_tree(pos, stage, meta, tree_def)
	if tree_def.type == "blob" then
		return default.install_blob_tree(pos, stage, meta, tree_def)
		
	elseif tree_def.type == "conifer" then
		return default.install_conifer_tree(pos, stage, meta, tree_def)
	
	end
end

function default.clear_old_leaves(pos, meta)

	local leaves = minetest.deserialize(meta:get_string("leaves"))
	if not leaves then
		return
	end
	
	for _,v in ipairs(leaves) do
		minetest.set_node(v, {name="air"})
	end
end


function default.clear_old_trunks(pos, meta)

	local trunks = minetest.deserialize(meta:get_string("trunks"))
	if not trunks then
		return
	end
	
	for _,v in ipairs(trunks) do
		minetest.set_node(v, {name="air"})
	end
end


function default.install_straight_trunk(pos, height, trunk_list, meta)
	local trunks = {}
	
	for i = 1,height do
		local p = {x=pos.x, y=pos.y+i, z=pos.z}
-- 		local n = minetest.get_node(p)
-- 		if n.name == "air" then
			minetest.set_node(p, {name=trunk_list[math.random(#trunk_list)]})
			table.insert(trunks, p)
-- 		end
	end
	
	meta:set_string("trunks", minetest.serialize(trunks))
end

function default.install_tapered_trunk(pos, height, m, meta)
	local trunks = {}
	local trange = m.trunk.taper_max - m.trunk.taper_min
	
	for i = 1,height do
		local p = {x=pos.x, y=pos.y+i, z=pos.z}
-- 		local n = minetest.get_node(p)
-- 		if n.name == "air" then
			local name = m.trunk_list[math.random(#m.trunk_list)]
			local a = (height - i) / height
			local taper = m.trunk.taper_min + math.floor(trange * a + 0.6) 
			name = string.gsub(name, "#", taper)
			
			minetest.set_node(p, {name=name})
			table.insert(trunks, p)
-- 		end
	end
	
	meta:set_string("trunks", minetest.serialize(trunks))
end


function default.install_conifer_tree(pos, stage, meta, tree_def)

	local m = tree_def.stages[stage]
	
	default.clear_old_leaves(pos, meta)
	local leaves = {} 

	local function install_leaves(h, x, z)
		local p = {x=pos.x+x, y=pos.y+h, z=pos.z+z}
		local n = minetest.get_node(p)
		if n.name == "air" then
			minetest.set_node(p, {name=m.leaf_list[math.random(#m.leaf_list)]})
			table.insert(leaves, p)
		end
	end
	
	local function install_leaf_tier(h, dist)
		install_leaves(h, 0, 1)
		install_leaves(h, 0, -1)
		install_leaves(h, 1, 0)
		install_leaves(h, -1, 0)
	end
	
	local tree_height = m.trunk.min + math.random(m.trunk.max - m.trunk.min)
	
	for i = 0,m.boughs.num-1 do
		install_leaf_tier(tree_height - i, m.boughs.dist)
	end
	
	
	minetest.swap_node({x=pos.x, y=pos.y, z=pos.z}, {name=m.root_list[math.random(#m.root_list)]})
	
	default.install_tapered_trunk(pos, tree_height, m, meta)
	
	meta:set_string("leaves", minetest.serialize(leaves))
	meta:set_int("stage", stage + 1)
	meta:set_int("height", tree_height)
end




function default.install_blob_tree(pos, stage, meta, tree_def)

	local m = tree_def.stages[stage]
	
	default.clear_old_leaves(pos, meta)
	
	local leaves = {}
	
	local vm = minetest.get_voxel_manip()
	local minp, maxp = vm:read_from_map(
		{x=pos.x-m.xrange, y=pos.y-m.ymin, z=pos.z-m.zrange,},
		{x=pos.x+m.xrange, y=pos.y+m.ymax, z=pos.z+m.zrange,}
	)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local c_air = minetest.get_content_id("air")
	
	for x = -m.xrange,m.xrange do
	for y = m.ymin,m.ymax do
	for z = -m.zrange,m.zrange do
		
		local y2 = (y-m.yoff) / m.ysquash
		local d = math.sqrt(x*x + z*z + y2*y2)
-- 		if d  < (stage/2) +  math.random() then
		if d  < m.dist +  math.random() * m.rand then
			local p = {x=pos.x+x, y=pos.y+y, z=pos.z+z}
			local vi = a:index(pos.x+x, pos.y+y, pos.z+z)
			local n = data[vi]
			if n == c_air then
				data[vi] = minetest.get_content_id(m.leaf_list[math.random(#m.leaf_list)])
-- 				minetest.set_node(p, {name=})
				table.insert(leaves, p)
			end
		end
	end
	end
	end
	
	vm:set_data(data)
	vm:write_to_map()
	vm:update_map()
	
	--[[
	for x = -m.xrange,m.xrange do
	for y = m.ymin,m.ymax do
	for z = -m.zrange,m.zrange do
		local y2 = (y-m.yoff) / m.ysquash
		local d = math.sqrt(x*x + z*z + y2*y2)
-- 		if d  < (stage/2) +  math.random() then
		if d  < m.dist +  math.random() * m.rand then
			local p = {x=pos.x+x, y=pos.y+y, z=pos.z+z}
			local n = minetest.get_node(p)
			if n.name == "air" then
				minetest.set_node(p, {name=m.leaf_list[math.random(#m.leaf_list)]})
				table.insert(leaves, p)
			end
		end
	end
	end
	end
	]]
	
	minetest.swap_node({x=pos.x, y=pos.y, z=pos.z}, {name=m.root_list[math.random(#m.root_list)]})
	
	default.install_straight_trunk(pos, stage, m.trunk_list, meta)
	
	meta:set_string("leaves", minetest.serialize(leaves))
	meta:set_int("stage", stage + 1)
	meta:set_int("height", stage)
end



function default.advance_tree(pos, elapsed, tree_def)
	
	local meta = minetest.get_meta(pos)
	
	local stage = meta:get_int("stage")
	if stage == 0 then stage = 1 end
	
	local m = tree_def.stages[stage]
	if stage >= 6 then
		stage = 6
	else
		-- calculate how many steps should have elapsed
		while elapsed > m.time --[[+ aspen_speed.rand]] do
			elapsed = m.time --[[+ aspen_speed.rand]]
			
			stage = stage + 1
			
			if stage >= 6 then
				stage = 6
				break
			end
			
			m = tree_def.stages[stage]
		end
	end
	
	m = tree_def.stages[stage]
	
	default.install_tree(pos, stage, meta, tree_def)
	
	if stage < 6 then
		minetest.get_node_timer(pos):start(m.time * tree_def.speed.tree_growth)
	end
end


function default.install_mapgen_random_tree(pos, tree_def)
	local stage = math.random(#tree_def.stages)
	local meta = minetest.get_meta(pos)
	
	default.install_tree(pos, stage, meta, tree_def)
	
	local m = tree_def.stages[stage]
	if stage < #tree_def.stages then
		minetest.get_node_timer(pos):start(m.time * tree_def.speed.tree_growth)
	end
	
end


minetest.register_lbm({
	name = ":group:mg_rand_blob_sapling",
	nodenames = {"group:mg_rand_blob_sapling"},
	catch_up = true,
	action = function(pos, node)
		local def = minetest.registered_nodes[node.name]
		local sd = def.tree_def
		default.install_mapgen_random_tree(pos, sd)
	end,
})
minetest.register_abm({
	nodenames = {"group:mg_rand_blob_sapling"},
	interval  = 5,
	chance = 1,
	catch_up = true,
	action = function(pos, node)
		local def = minetest.registered_nodes[node.name]
		local sd = def.tree_def
		default.install_mapgen_random_tree(pos, sd)
	end,
})



function default.register_tree_trunks(mod, growth_data)
	local base = mod..":"..growth_data.name.."_"
	local trunk_base = base.."tree_trunk_"
	local root_base = base.."tree_trunk_root_"
	local stump_base = base.."tree_stump_"
	local log_base = base.."log_"
	local nub_base = base.."tree_nub_"
	local plank_base = base.."wood_planks"
	local box_base = base.."wood_box"
	local stick_base = base.."stick"
	
	for sz_ = 1,growth_data.trunk_sizes do
		local sz = sz_
		local q = sz * 1
		minetest.register_node(root_base..sz, {
			description = growth_data.Name.." Tree Root",
			tiles = {growth_data.tiles.top, growth_data.tiles.top, growth_data.tiles.side},
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
				tree = 1, choppy = 1, oddly_breakable_by_hand = 1, flammable = 2, plant = 1,
				tree_trunk = 1, tree_trunk_root_fertile = 1,
			},
			sounds = default.node_sound_wood_defaults(),
			
			tree_def = growth_data,
			log_name = log_base..sz,
			stump_name = stump_base..sz,
			nub_name = nub_base..sz,
			tree_type = growth_data.name,
			
			on_place = function(itemstack, placer, pointed_thing)
				local stack = minetest.rotate_node(itemstack, placer, pointed_thing)
				
				local m = stage_data[sz]
				if m.time then
					minetest.get_node_timer(pointed_thing.above):start(m.time * growth_data.speed.tree_growth)
				end
				return stack
			end,
			
			on_timer = function(pos, elapsed)
				default.advance_tree(pos, elapsed, growth_data)
			end,
		})
		
		-- stumps are dead roots
		minetest.register_node(stump_base..sz, {
			description = growth_data.Name.." Tree Stump",
			tiles = {growth_data.tiles.top, growth_data.tiles.top, growth_data.tiles.side},
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
				tree = 1, choppy = 1, oddly_breakable_by_hand = 1, flammable = 2, plant = 1,
				tree_trunk = 1, tree_stump = 1, rotting = 3
			},
			sounds = default.node_sound_wood_defaults(),
			
			tree_def = growth_data,
			log_name = log_base..sz,
			tree_type = growth_data.name,
			
			on_place = function(itemstack, placer, pointed_thing)
				local stack = minetest.rotate_node(itemstack, placer, pointed_thing)
				return stack
			end,
		})
		
		minetest.register_node(log_base..sz, {
			description = growth_data.Name.." Log",
			tiles = {
				growth_data.tiles.side,
				growth_data.tiles.side,
				growth_data.tiles.side.."^[transformR90",
				growth_data.tiles.side.."^[transformR90",
				growth_data.tiles.top, -- todo: re-center textures
				growth_data.tiles.top, 
				
			},
			paramtype = "light",
			paramtype2 = "facedir",
			drawtype = "nodebox",
			
			node_box = {
				type = "fixed",
				fixed = {-q/16, -0.5, -0.5, q/16, -0.5 + q/8, 0.5},
			},
			sunlight_propagates = true,
			is_ground_content = false,
			groups = {
				tree = 1, choppy = 1, oddly_breakable_by_hand = 1, flammable = 2, plant = 1,
				tree_log = 1, rotting = 1,
			},
			
			tree_type = growth_data.name,
			
			drop = {
				max_items = 1,
				items = {
					{ tools = {"group:axe"}, items = {plank_base.." "..sz}, },
					{ items = {log_base}, },
				},
			},
			sounds = default.node_sound_wood_defaults(),
			on_place = minetest.rotate_node,
		})
		
		minetest.register_node(trunk_base..sz, {
			description = growth_data.Name.." Tree",
			tiles = {growth_data.tiles.top, growth_data.tiles.top, growth_data.tiles.side},
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
				tree = 1, choppy = 1, oddly_breakable_by_hand = 1, flammable = 2, plant = 1,
				tree_trunk = 1, 
			},
			
			log_name = log_base..sz,
			nub_name = nub_base..sz,
			tree_type = growth_data.name,
			
			sounds = default.node_sound_wood_defaults(),
			on_place = minetest.rotate_node,
			on_dig = function(pos, node, digger)
				local wielded = digger and digger:get_wielded_item()
				local tp = wielded:get_tool_capabilities()
				
				if tp.groupcaps.choppy then
					
					if sz > 1 then
						
						minetest.set_node(pos, {name=trunk_base..sz.."_chopped_"..(sz-1)})
						
						if not core.settings:get_bool("creative_mode") then
							wielded:add_wear(dp.wear)
							if wielded:get_count() == 0 and wdef.sound and wdef.sound.breaks then
								core.sound_play(wdef.sound.breaks, {
									pos = pos,
									gain = 0.5
								}, true)
							end
						end
						
						digger:set_wielded_item(wielded)
					else
						default.fell_tree(pos, digger)
	-- 					minetest.node_dig(pos, node, digger)
					end
				end
			end
			
		})
		
		-- post-chopped remainders
		minetest.register_node(nub_base..sz, {
			description = growth_data.Name.." Tree",
			tiles = {growth_data.tiles.top, growth_data.tiles.top, growth_data.tiles.side},
			paramtype = "light",
			paramtype2 = "facedir",
			drawtype = "nodebox",
			
			node_box = {
				type = "fixed",
				fixed = {
					{-q/16, -0.5, -q/16, q/16, -0.3, q/16},
					{-q/24, -0.3, -q/16, q/24, -0.2, q/16},
					{-q/48, -0.2, -q/16, q/48, -0.1, q/16},
				},
			},
			sunlight_propagates = true,
			is_ground_content = false,
			groups = {
				tree = 1, choppy = 1, oddly_breakable_by_hand = 1, flammable = 2, plant = 1,
				tree_trunk = 1, rotting = 1,
			},
			
			log_name = log_base..sz,
			tree_type = growth_data.name,
			
			sounds = default.node_sound_wood_defaults(),
			on_place = minetest.rotate_node,
		})
		
		
		-- chopped versions
		for j_ = sz,1,-1 do
			local j = j_
			minetest.register_node(trunk_base..sz.."_chopped_"..j, {
				description = growth_data.Name.." Tree",
			tiles = {growth_data.tiles.top, growth_data.tiles.top, growth_data.tiles.side},
				paramtype = "light",
				paramtype2 = "facedir",
				drawtype = "nodebox",
				
				node_box = {
					type = "fixed",
					fixed = {
						{-q/16, -0.5, -q/16, q/16, -0.1, q/16}, -- bottom
						{-q/16,  0.1, -q/16, q/16,  0.5, q/16}, -- top
						{-q/16, -0.1, -q/16, q/16,  0.1, j/16}, -- middle chunk negative
					},
				},
				sunlight_propagates = true,
				is_ground_content = false,
				groups = {
					tree = 1, choppy = 1, oddly_breakable_by_hand = 1, flammable = 2, plant = 1,
					tree_trunk = 1, 
				},
				
				log_name = log_base..sz,
				nub_name = nub_base..sz,
				tree_type = growth_data.name,
			
				sounds = default.node_sound_wood_defaults(),
				on_place = minetest.rotate_node,
				on_dig = function(pos, node, digger)
					local wielded = digger and digger:get_wielded_item()
					local tp = wielded:get_tool_capabilities()
					if tp.groupcaps.choppy then
						if j > 1 then
							minetest.set_node(pos, {name=trunk_base..sz.."_chopped_"..(j-1)})
							
							if not core.settings:get_bool("creative_mode") then
								wielded:add_wear(dp.wear)
								if wielded:get_count() == 0 and wdef.sound and wdef.sound.breaks then
									core.sound_play(wdef.sound.breaks, {
										pos = pos,
										gain = 0.5
									}, true)
								end
							end
							
							digger:set_wielded_item(wielded)
						else
							default.fell_tree(pos, digger)
	-- 						minetest.node_dig(pos, node, digger)
						end
					end
				end
				
			})
		end
		
		-- planks
		minetest.register_node(plank_base, {
			description = growth_data.Name.." Planks",
			tiles = {growth_data.tiles.wood},
			paramtype = "light",
			paramtype2 = "facedir",
			drawtype = "nodebox",
			node_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},
			},
			sunlight_propagates = true,
			is_ground_content = false,
			groups = {
				choppy = 2, flammable = 3, wood_planks = 1, 
			},
			
			tree_type = growth_data.name,
			
			sounds = default.node_sound_wood_defaults(),
			on_place = minetest.rotate_node,
		})
		
		-- boxes
		minetest.register_node(box_base, {
			description = growth_data.Name.." Box",
			tiles = {growth_data.tiles.wood},
			paramtype = "light",
			paramtype2 = "facedir",
			drawtype = "nodebox",
			node_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
			sunlight_propagates = true,
			is_ground_content = false,
			groups = {
				choppy = 2, flammable = 3, wood_box = 1,
			},
			
			tree_type = growth_data.name,
			
			drop = {
				max_items = 1,
				items = {
					{ tools = {"group:axe"}, items = {plank_base .. " 8"}, },
					{ items = {box_base}, },
				},
			},
			sounds = default.node_sound_wood_defaults(),
			on_place = minetest.rotate_node,
		})
		
		-- sticks
		minetest.register_node(stick_base, {
			description = growth_data.Name.." Stick",
			tiles = {growth_data.tiles.stick},
			paramtype = "light",
			paramtype2 = "facedir",
			drawtype = "nodebox",
			node_box = {
				type = "fixed",
				fixed = {-0.03, -0.5, -0.5, 0.03, -0.5+0.06, 0.5},
			},
			sunlight_propagates = true,
			is_ground_content = false,
			groups = {
				choppy = 3, flammable = 3, stick = 1, oddly_breakable_by_hand = 1,
			},
			
			tree_type = growth_data.name,
			
			sounds = default.node_sound_wood_defaults(),
			on_place = minetest.rotate_node,
		})
		
		
		--------------
		--  Crafts  --
		--------------
		
		-- planks into a box
		minetest.register_craft({
			output = box_base,
			recipe = {
				{plank_base, plank_base, plank_base},
				{plank_base, "",         plank_base},
				{plank_base, plank_base, plank_base},
			}
		})
		
		
	end -- for trunk_sizes
end -- default.register_tree_trunks()




function default.fell_tree(chopped_pos, player)
	local n = minetest.get_node(chopped_pos)
	local chopped_def = minetest.registered_nodes[n.name]
	
	local found, root_pos = default.find_tree_root(chopped_pos)
	
	if not found then
		print("Could not find tree root")
		return
	end
	
	local meta = minetest.get_meta(root_pos)
	local root_def = minetest.registered_nodes[minetest.get_node(root_pos).name]
	local height = meta:get_int("height") -- above the root
	local felled_h = root_pos.y + height - chopped_pos.y
	
	-- todo: fetch log diameter?
	
-- 	print("Felled height " .. felled_h .. " of " .. height)
	
	-- get log sizes
	local logs = {}
	for y = chopped_pos.y, chopped_pos.y + felled_h do
		local p = {x=chopped_pos.x, y=y, z=chopped_pos.z}
		local n = minetest.get_node(p)
		local def = minetest.registered_nodes[n.name]
		if not def then
			break
		end
		
		if def.log_name then
			table.insert(logs, def.log_name)
			minetest.set_node(p, {name="air"})
		end
	end
	
	-- clear a path
	for x = root_pos.x, root_pos.x + height do
		for y = chopped_pos.y, chopped_pos.y + felled_h do
			-- todo: sin(x - root_pos.x)
			-- todo: wide swath of branches
			minetest.set_node({x=x, y=y, z=root_pos.z}, {name="air"})
		end
	end

	-- place logs
	local x = root_pos.x + 1
	for _,log in ipairs(logs) do
		-- find ground level.
		local lpos = {x=x, y=root_pos.y + 1, z=root_pos.z}
		for y = root_pos.y+felled_h,root_pos.y,-1 do
			lpos.y = y
			local n = minetest.get_node(lpos)
			if n.name ~= "air" then
				lpos.y = lpos.y + 1
				break
			end
		end
		
		minetest.set_node(lpos, {name=log, param2=1})
		x = x + 1
	end
		
	
	default.clear_old_leaves(root_pos, meta)
	
	-- install dead root and chopped nub
	minetest.swap_node(root_pos, {name=root_def.stump_name})
	minetest.set_node(chopped_pos, {name=chopped_def.nub_name})
	
	-- TODO: set remaining part of trunk to rottable
	
	-- TODO: handle chopping more from lower on the trunk
	
	-- TODO: place shattered canopy on ground, with rotting leaves
end





--------------------------
--
--  Conifers
--
--------------------------







minetest.register_lbm({
	name = ":group:mg_rand_conifer_sapling",
	nodenames = {"group:mg_rand_conifer_sapling"},
	catch_up = true,
	action = function(pos, node)
		local def = minetest.registered_nodes[node.name]
		local sd = def.tree_def
		default.install_mapgen_random_conifer_tree(pos, sd)
	end,
})
minetest.register_abm({
	nodenames = {"group:mg_rand_conifer_sapling"},
	interval  = 5,
	chance = 1,
	catch_up = true,
	action = function(pos, node)
		local def = minetest.registered_nodes[node.name]
		local sd = def.tree_def
		default.install_mapgen_random_conifer_tree(pos, sd)
	end,
})
