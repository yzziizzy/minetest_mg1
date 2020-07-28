
function default.register_crumbling(name, info)
	local def = minetest.registered_nodes[name]
	
	info = info or {}
	info.corner = info.corner or {}
	info.edge = info.edge or {}
	
	minetest.register_node(name.."_crumbling_corner", {
		description = "Crumbling "..def.description,
		tiles = def.tiles,
		drawtype = "mesh",
		visual = "mesh",
		mesh = "crumbled_corner.obj",
		paramtype = "light",
		paramtype2 = "facedir",
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = info.corner.drop or def.drop,
		is_ground_content = false,
		groups = default.extend(def.groups, info.corner.groups),
		on_place = minetest.rotate_node,
	})
	
	minetest.register_node(name.."_crumbling_edge", {
		description = "Crumbling "..def.description,
		tiles = def.tiles,
		drawtype = "mesh",
		visual = "mesh",
		mesh = "crumbled_edge.obj",
		paramtype = "light",
		paramtype2 = "facedir",
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		is_ground_content = false,
		drop = info.edge.drop or def.drop,
		groups = default.extend(def.groups, info.edge.groups),
		on_place = minetest.rotate_node,
	})
	
	local gr = def.groups
	gr.crumbling = 1
	minetest.override_item(name, {
		crumbling = {
			corner = name.."_crumbling_corner",
			edge = name.."_crumbling_edge",
		},
		groups = gr,
	})
end

local crumble_lookup = {
	["010101"] = {name = "corner", param2 = 3},
	["010110"] = {name = "corner", param2 = 0},
	["100110"] = {name = "corner", param2 = 1},
	["100101"] = {name = "corner", param2 = 2},
	["000101"] = {name = "edge", param2 =  3},
	["010100"] = {name = "edge", param2 =  0},
	["000110"] = {name = "edge", param2 =  1},
	["100100"] = {name = "edge", param2 = 16},
	["011000"] = {name = "edge", param2 = 12},
	["001010"] = {name = "edge", param2 = 21},
	["101000"] = {name = "edge", param2 = 20},
	["001001"] = {name = "edge", param2 = 23},
	["010001"] = {name = "edge", param2 =  4},
	["010010"] = {name = "edge", param2 =  8},
	["100010"] = {name = "edge", param2 = 10},
	["100001"] = {name = "edge", param2 = 19},
}


function default.crumble_node(pos, node)
	if not node then
		node = minetest.get_node(pos)
	end
	
	local positions = {
			{x=1,y=0,z=0},
			{x=-1,y=0,z=0},
			{x=0,y=1,z=0},
			{x=0,y=-1,z=0},
			{x=0,y=0,z=1},
			{x=0,y=0,z=-1},
		}
		
	local id = ""
	for _,p in ipairs(positions) do
		local n = minetest.get_node(vector.add(pos, p))
		if n.name ~= "air" then
			id = id.."1"
		else
			id = id.."0"
		end
	end
	
	local def = minetest.registered_nodes[node.name]
--  		print(id)
	
	local c = crumble_lookup[id]
	if c then
		minetest.set_node(pos, {name = def.crumbling[c.name], param2 = c.param2})
-- 		else
-- 			print(id)
	end

end



-- weathering
minetest.register_abm({
	nodenames = {"group:crumbling"},
	neighbors = {"air"},
	interval = 60,
	chance = 300,
	catch_up = true,
	action = function(pos, node)
		local def = minetest.registered_nodes[node.name]
		
		if not def.crumbling then 
			return 
		end
		
		if not def.crumbling.weather_chance or 1 == math.random(def.crumbling.weather_chance) then
			default.crumble_node(pos, node)
		end
		
	end,
})
