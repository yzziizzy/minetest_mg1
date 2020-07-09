



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
		minetest.set_node(p, {name=trunk_list[math.random(#trunk_list)]})
		table.insert(trunks, p)
	end
	
	meta:set_string("trunks", minetest.serialize(trunks))
end

function default.install_tapered_trunk(pos, height, m, meta)
	local trunks = {}
	local trange = m.trunk.taper_max - m.trunk.taper_min
	
	for i = 1,height do
		local p = {x=pos.x, y=pos.y+i, z=pos.z}
		local name = m.trunk_list[math.random(#m.trunk_list)]
		local taper = m.trunk.taper_min + math.floor((trange / i)) 
		name = string.gsub(name, "#", taper)
		
		minetest.set_node(p, {name=name})
		table.insert(trunks, p)
	end
	
	meta:set_string("trunks", minetest.serialize(trunks))
end


function default.install_conifer_tree(pos, stage, meta, tree_def)

	local m = tree_def.stages[stage]
	
	default.clear_old_leaves(pos, meta)
	local leaves = {} 
	
	local function install_leaf_tier(h, dist)
		local dd = math.max(dist)
		for x = -dd,dd do
		for z = -dd,dd do
			local d = math.sqrt(x*x + z*z)
			if d < dist +  math.random() * m.boughs.rand then
				local p = {x=pos.x+x, y=pos.y+h, z=pos.z+z}
				local n = minetest.get_node(p)
				if n.name == "air" then
					minetest.set_node(p, {name=m.leaf_list[math.random(#m.leaf_list)]})
					table.insert(leaves, p)
				end
			end
		end
		end
	end
	
	local tree_height = m.trunk.min + math.random(m.trunk.max - m.trunk.min)
	
	for i = 0,m.boughs.num-1 do
		install_leaf_tier(tree_height - i * 2, m.boughs.dist)
	end
	
	
	minetest.swap_node({x=pos.x, y=pos.y, z=pos.z}, {name=m.root_list[math.random(#m.root_list)]})
	
	default.install_tapered_trunk(pos, tree_height, m, meta)
	
	meta:set_string("leaves", minetest.serialize(leaves))
	meta:set_int("stage", stage + 1)
end




function default.install_blob_tree(pos, stage, meta, tree_def)

	local m = tree_def.stages[stage]
	
	default.clear_old_leaves(pos, meta)
	
	local leaves = {}
	
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
	
	
	minetest.swap_node({x=pos.x, y=pos.y, z=pos.z}, {name=m.root_list[math.random(#m.root_list)]})
	
	default.install_straight_trunk(pos, stage, m.trunk_list, meta)
	
	meta:set_string("leaves", minetest.serialize(leaves))
	meta:set_int("stage", stage + 1)
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
