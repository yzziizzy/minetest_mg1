



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




function default.install_blob_tree(pos, stage, meta, tree_def)

	local m = tree_def[stage]
	
	local raw_trunks = meta:get_string("trunks")
	local trunks = minetest.deserialize(raw_trunks)
	local raw_leaves = meta:get_string("leaves")
	local leaves = minetest.deserialize(raw_leaves)
	if not leaves then
		leaves = {}
	end
	
	for _,v in ipairs(leaves) do
		minetest.set_node(v, {name="air"})
	end
	
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
	
	for i = 1,stage do
		minetest.set_node({x=pos.x, y=pos.y+i, z=pos.z}, {name=m.trunk_list[math.random(#m.trunk_list)]})
	end
	
	meta:set_string("leaves", minetest.serialize(leaves))
	meta:set_int("stage", stage + 1)

end



function default.advance_trunk(pos, elapsed, tree_def)
	
	local meta = minetest.get_meta(pos)
	
	local stage = meta:get_int("stage")
	if stage == 0 then stage = 1 end
	
	local m = tree_def[stage]
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
			
			m = tree_def[stage]
		end
	end
	
	m = tree_def[stage]
	
	default.install_blob_tree(pos, stage, meta, tree_def)
	
	if stage < 6 then
		minetest.get_node_timer(pos):start(m.time)
	end
end



function default.install_mapgen_random_blob_tree(pos, tree_def)
	local stage = math.random(#tree_def)
	local meta = minetest.get_meta(pos)
	
	default.install_blob_tree(pos, stage, meta, tree_def)
	
	local m = tree_def[stage]
	if stage < 6 then
		minetest.get_node_timer(pos):start(m.time)
	end
	
end


minetest.register_lbm({
	name = ":group:mg_rand_blob_sapling",
	nodenames = {"group:mg_rand_blob_sapling"},
	catch_up = true,
	action = function(pos, node)
		local def = minetest.registered_nodes[node.name]
		local sd = def.tree_def
		default.install_mapgen_random_blob_tree(pos, sd)
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
		default.install_mapgen_random_blob_tree(pos, sd)
	end,
})
