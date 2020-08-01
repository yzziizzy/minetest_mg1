




minetest.register_node("fire:short_flame", {
	description = "Short Fire", 
	drawtype = "firelike",
	tiles = {{
		name = "fire_short_flame_animated.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1
		}}
	},
	inventory_image = "fire_basic_flame.png",
	visual_scale = 1.0,
	paramtype = "light",
	light_source = 14,
	walkable = false,
	sunlight_propagates = true,
	floodable = true,
	groups = {handed = 3, fire=1, --[[not_in_creative_inventory=1]]},
	drop = "",
	on_flood = function(pos)
		minetest.set_node(pos, {name="air"})
	end,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(45, 120))
	end,
	on_timer = function(pos, elapsed)
		minetest.set_node(pos, {name="fire:small_flame"})
	end,
})

minetest.register_node("fire:small_flame", {
	description = "Small Fire", 
	drawtype = "firelike",
	tiles = {{
		name = "fire_basic_flame_animated.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1
		}}
	},
	inventory_image = "fire_basic_flame.png",
	visual_scale = 1.0,
	paramtype = "light",
	light_source = 14,
	walkable = false,
	sunlight_propagates = true,
	floodable = true,
	groups = {handed = 3, fire=1, --[[not_in_creative_inventory=1]]},
	drop = "",
	on_flood = function(pos)
		minetest.set_node(pos, {name="air"})
	end,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(45, 120))
	end,
	on_timer = function(pos, elapsed)
		minetest.set_node(pos, {name="fire:big_flame"})
	end,
})

minetest.register_node("fire:big_flame", {
	description = "Big Fire", 
	drawtype = "firelike",
	tiles = {{
		name = "fire_basic_flame_animated.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1
		}}
	},
	inventory_image = "fire_basic_flame.png",
	visual_scale = 3.0,
	paramtype = "light",
	light_source = 14,
	walkable = false,
	sunlight_propagates = true,
	floodable = true,
	groups = {handed = 3, fire=1, --[[not_in_creative_inventory=1]]},
	drop = "",
	on_flood = function(pos)
		minetest.set_node(pos, {name="air"})
	end,
})




-- go up in flames anywhere near a big flame 
minetest.register_abm({
	nodenames = {"fire:big_flame"},
	interval = 5,
	chance   = 4,
	catch_up = true,
	action = function(pos, node)
		
		local air_nodes = minetest.find_nodes_in_area(
			{x=pos.x - 3, y=pos.y - 2, z=pos.z - 3},
			{x=pos.x + 3, y=pos.y + 4, z=pos.z + 3},
			{"group:flammable"}
		)
		
		if #air_nodes > 0 then
			
			local off = math.random(#air_nodes)
			local num = math.random(#air_nodes / 2)
			
			for i = 1,num do
				--local theirlevel = minetest.get_node_level(fp)
				local fp = air_nodes[((i + off) % #air_nodes) + 1]
				
				minetest.set_node(fp, {name="fire:small_flame"})
			end
		end
		
	end
})


minetest.register_abm({
	nodenames = {"group:flammable", "group:shriveled"},
	neighbors = {"group:fire"},
	interval = 7,
	chance = 12,
	catch_up = true,
	action = function(pos)
		local air_nodes = minetest.find_nodes_in_area(
			{x=pos.x - 1, y=pos.y - 1, z=pos.z - 1},
			{x=pos.x + 1, y=pos.y + 1, z=pos.z + 1},
			{"air"}
		)
		
		local r = math.random(#air_nodes)
		
		local p = minetest.find_node_near(pos, 1, {"air"})
		if p then
			minetest.set_node(p, {name = "fire:small_flame"})
		end
	end
})





minetest.register_abm({
	nodenames = {"fire:short_flame"},
	interval = 5,
	chance = 12,
	catch_up = true,
	action = function(pos, node)
		minetest.set_node(pos, {name="air"})
	end
})

minetest.register_abm({
	nodenames = {"group:smolderable_surface_grass"},
 	neighbors = {"group:fire"},
	interval = 2,
	chance = 12,
	catch_up = true,
	action = function(pos, node)
		pos.y = pos.y + 1
		local n = minetest.get_node(pos)
		if n.name ~= "air" then
			return
		end
		
		minetest.set_node(pos, {name="fire:short_flame"})
		
		pos.y = pos.y - 1
		local def = minetest.registered_nodes[node.name]
		if def and def.charred_node then
			minetest.set_node(pos, {name=def.charred_node, param2=node.param2})
		end
	end,
})




-- compatibility with Minetest Game's fire mod
minetest.register_alias("fire:basic_flame", "fire:small_flame")
