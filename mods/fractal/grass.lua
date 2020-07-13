function merge_tables(a, b)
	local result = {}
	for k,v in pairs(a) do
		result[k] = v
	end
	for k,v in pairs(b) do
		result[k] = v
	end
	return result
end


local colorize_ripe = "^[colorize:yellow:100"
local colorize_dead = "^[colorize:brown:100"
local grass_form = {
	dead = {},
	ripe = {},
}


local grass = {}
function grass.base_groups()
	return {
		snappy = 3,
		flora = 1,
		grass = 1,
		flammable = 1
	}
end
function grass.lifecycle(spring_grow, summer_grow, summer_ripe, winter_kill)
	return {
		spring_grow = spring_grow,
		summer_grow = summer_grow,
		summer_ripe = summer_ripe,
		winter_kill = winter_kill,
	}
end
function grass.destruct_y(pos, node, offset)
	print("triggering destruct check: " .. offset)
	local np = {x = pos.x, y = pos.y + offset, z = pos.z}
	local nn = minetest.get_node(np)
	if not nn then
		return
	end
	local name = nn.name
	if not minetest.registered_nodes[name] or not minetest.registered_nodes[name].groups["grass"] then
		return
	end
	minetest.remove_node(np)
end

grass.hidden_groups = grass.base_groups()
grass.hidden_groups.not_in_creative_inventory = 1
grass.selection_box = {-6 / 16, -0.5, -6 / 16, 6 / 16, -5 / 16, 6 / 16}

grass.drops = {
	ripe = {
		max_items = 1,
		items = {
			{items = {"fractal:seed_wheat", "fractal:seed_wheat", "fractal:seed_wheat"}, rarity = 30},
			{items = {"fractal:seed_wheat", "fractal:seed_wheat"}, rarity = 20},
			{items = {"fractal:seed_wheat"}, rarity = 10},
		}
	}
}

grass.defaults = {
	ripe_form = 1,
	dead_form = 1,
	dead_groups = grass.base_groups(),
}
grass.node_defs = {
	{
		description = "Short Grass",
		pointable = true,
		ripe_form = 0,
		dead_form = 1,
		stage = 1,
		stage_next = 2,
		groups = merge_tables(grass.base_groups(), grass.lifecycle(1,1,0,0)),
		ripe_groups = merge_tables(grass.base_groups(), grass.lifecycle(0,0,0,1)),
		dead_groups = grass.base_groups(),
	},
	{
		description = "Short Grass",
		pointable = true,
		ripe_form = 0,
		dead_form = 1,
		stage = 2,
		stage_next = 3,
		groups = merge_tables(grass.hidden_groups, grass.lifecycle(1,1,0,0)),
		ripe_groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,0,0,1)),
		dead_groups = grass.hidden_groups,
	},
	{
		description = "Grass",
		pointable = true,
		ripe_form = 0,
		dead_form = 1,
		stage = 3,
		stage_next = 4,
		groups = merge_tables(grass.hidden_groups, grass.lifecycle(1,1,0,1)),
		ripe_groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,0,0,1)),
		dead_groups = grass.hidden_groups,
	},
	{
		description = "Grass",
		pointable = true,
		ripe_form = 1,
		dead_form = 1,
		stage = 4,
		stage_next = 5,
		groups = merge_tables(grass.hidden_groups, grass.lifecycle(1,1,1,1)),
		ripe_groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,0,0,1)),
		dead_groups = grass.hidden_groups,
	},
	{
		description = "Grass",
		pointable = true,
		ripe_form = 1,
		dead_form = 1,
		stage = 5,
		stage_next = {6, 7}, -- magic!
		groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,1,1,1)),
		ripe_groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,0,0,1)),
		dead_groups = grass.hidden_groups,
	},
	{
		description = "Tall Grass",
		pointable = true,
		ripe_form = 1,
		dead_form = 1,
		stage = 6,
		stage_next = 6, -- does not grow, so this should never be used
		groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,0,0,0)),
		ripe_groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,0,0,0)),
		dead_groups = grass.hidden_groups,
		selection_box = {-6 / 16, -0.5, -6 / 16, 6 / 16, 8 / 16, 6 / 16},
	},
	{
		description = "[ERROR] Tall Grass", -- not pointable
		pointable = false,
		ripe_form = 1,
		dead_form = 1,
		stage = 7,
		stage_next = 8,
		groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,1,1,1)),
		ripe_groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,0,0,1)),
		dead_groups = grass.hidden_groups,
	},
	{
		description = "[ERROR] Tall Grass", -- not pointable
		pointable = false,
		ripe_form = 1,
		dead_form = 1,
		stage = 8,
		stage_next = 9,
		groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,1,1,1)),
		ripe_groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,0,0,1)),
		dead_groups = grass.hidden_groups,
	},
	{
		description = "[ERROR] Tall Grass", -- not pointable
		pointable = false,
		ripe_form = 1,
		dead_form = 1,
		stage = 9,
		stage_next = 10,
		groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,1,1,1)),
		ripe_groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,0,0,1)),
		dead_groups = grass.hidden_groups,
	},
	{
		description = "[ERROR] Tall Grass", -- not pointable
		pointable = false,
		ripe_form = 1,
		dead_form = 1,
		stage = 10,
		stage_next = 11,
		groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,1,1,1)),
		ripe_groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,0,0,1)),
		dead_groups = grass.hidden_groups,
	},
	{
		description = "[ERROR] Tall Grass", -- not pointable
		pointable = false,
		ripe_form = 1,
		dead_form = 1,
		stage = 11,
		stage_next = nil,
		groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,0,1,1)),
		ripe_groups = merge_tables(grass.hidden_groups, grass.lifecycle(0,0,0,1)),
		dead_groups = grass.hidden_groups,
	},
}

for _, def in ipairs(grass.node_defs) do
	local stage_next_name = nil
	if def.stage_next then
		-- print(type(def.stage_next))
		if type(def.stage_next) == "table" then
			stage_next_name = {}
			for i,v in ipairs(def.stage_next) do
				stage_next_name[i] = "fractal:grass_" .. v
			end
		else
			stage_next_name = "fractal:grass_" .. def.stage_next
		end
		-- print(dump(stage_next_name))
	end
	local selection_box = def.selection_box or grass.selection_box
	-- print("registering item: " .. "fractal:grass_" .. def.stage)
	-- print(dump(def))
	minetest.register_node("fractal:grass_" .. def.stage, {
		description = def.description,
		drawtype = "plantlike",
		waving = 1,
		tiles = {"default_grass_" .. def.stage .. ".png"},
		-- Use texture of a taller grass stage in inventory
		inventory_image = "default_grass_3.png",
		wield_image = "default_grass_3.png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		pointable = def.pointable,
		groups = def.groups,
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = selection_box,
		},
		drop = {},
		stage = def.stage,
		stage_next = def.stage_next,
		stage_next_name = stage_next_name,
		after_destruct = function(pos, node)
			grass.destruct_y(pos, node, -1)
			grass.destruct_y(pos, node, 1)
		end,
	})

	if def.ripe_form then
		grass_form["ripe"]["fractal:grass_" .. def.stage] = "fractal:grass_ripe_" .. def.stage
		minetest.register_node("fractal:grass_ripe_" .. def.stage, {
			description = "Ripe " .. def.description,
			drawtype = "plantlike",
			waving = 1,
			tiles = {"default_grass_" .. def.stage .. ".png" .. colorize_ripe},
			-- Use texture of a taller grass stage in inventory
			inventory_image = "default_grass_3.png" .. colorize_ripe,
			wield_image = "default_grass_3.png" .. colorize_ripe,
			paramtype = "light",
			sunlight_propagates = true,
			walkable = false,
			buildable_to = true,
			pointable = def.pointable,
			groups = def.ripe_groups,
			sounds = default.node_sound_leaves_defaults(),
			selection_box = {
				type = "fixed",
				fixed = def.selection_box or grass.selection_box,
			},
			drop = {},
			stage = def.stage,
			after_destruct = function(pos, node)
				grass.destruct_y(pos, node, -1)
				grass.destruct_y(pos, node, 1)
			end,
		})
	end

	if def.dead_form then
		grass_form["dead"]["fractal:grass_" .. def.stage] = "fractal:grass_dead_" .. def.stage
		if def.ripe_form then
			grass_form["dead"]["fractal:grass_ripe_" .. def.stage] = "fractal:grass_dead_" .. def.stage
		end
		minetest.register_node("fractal:grass_dead_" .. def.stage, {
			description = "Dead " .. def.description,
			drawtype = "plantlike",
			waving = 1,
			tiles = {"default_grass_" .. def.stage .. ".png" .. colorize_dead},
			-- Use texture of a taller grass stage in inventory
			inventory_image = "default_grass_3.png" .. colorize_dead,
			wield_image = "default_grass_3.png" .. colorize_dead,
			paramtype = "light",
			sunlight_propagates = true,
			walkable = false,
			buildable_to = true,
			pointable = def.pointable,
			groups = def.dead_groups,
			sounds = default.node_sound_leaves_defaults(),
			selection_box = {
				type = "fixed",
				fixed = def.selection_box or grass.selection_box,
			},
			drop = {},
			stage = def.stage,
			after_destruct = function(pos, node)
				grass.destruct_y(pos, node, -1)
				grass.destruct_y(pos, node, 1)
			end,
		})
	end
end


function grass.get_grow_abm(day_start, day_end)
	return function(pos, node, active_object_count, active_object_count_wider)
		local def = minetest.registered_nodes[node.name]
		if not def then
			print("unknown node: " .. node.name)
			return
		end

		local time = minetest.get_timeofday()

		local day_of_year = minetest.get_day_count() % 12 -- stub year length
		-- print("day is: " .. day_of_year)
		if (day_of_year < day_start) or (day_of_year > day_end) then
			print("not in day range [" .. day_start .. ", " .. day_end .. "]")
			return
		end

		-- only grow in the daytime, times are a bit arbitrary 5500 to 19500
		if (time < 0.2292) or (time > 0.8125) then
			return
		end

		if type(def.stage_next) == "table" then
			for i = 2, #def.stage_next do
				local p = {x=pos.x, y=pos.y+(i-1), z=pos.z}
				local n = minetest.get_node(p)
				if n.name ~= "air" then
					print("hit not air")
					return -- cannot grow into other things
				end
			end
			minetest.swap_node(pos, {name = def.stage_next_name[1]})
			for i = 2, #def.stage_next_name do
				local p = {x=pos.x, y=pos.y+(i-1), z=pos.z}
				minetest.set_node(p, {name=def.stage_next_name[i]})
			end
		elseif def.stage_next then
			minetest.swap_node(pos, {name = def.stage_next_name})
		end
	end
end


function grass.get_ripen_abm(day_start, day_end)
	return function(pos, node, active_object_count, active_object_count_wider)
		local def = minetest.registered_nodes[node.name]
		if not def then
			print("unknown node: " .. node.name)
			return
		end

		local time = minetest.get_timeofday()

		local day_of_year = minetest.get_day_count() % 12 -- stub year length
		-- print("day is: " .. day_of_year)
		if (day_of_year < day_start) or (day_of_year > day_end) then
			print("not in day range [" .. day_start .. ", " .. day_end .. "]")
			return
		end

		-- only ripen in the daytime, times are a bit arbitrary 5500 to 19500
		if (time < 0.2292) or (time > 0.8125) then
			return
		end

		if grass_form.ripe[node.name] then
			minetest.swap_node(pos, {name=grass_form.ripe[node.name]})

			-- also ripen the node below if it is grass
			local pos_below = {x=pos.x, y=pos.y-1, z=pos.z}
			local node_below = minetest.get_node(pos_below)
			if grass_form.ripe[node_below.name] then
				minetest.swap_node(pos_below, {name=grass_form.ripe[node_below.name]})
			end
		end
	end
end


function grass.get_kill_abm(day_start, day_end)
	return function(pos, node, active_object_count, active_object_count_wider)
		local def = minetest.registered_nodes[node.name]
		if not def then
			print("unknown node: " .. node.name)
			return
		end

		local time = minetest.get_timeofday()

		local day_of_year = minetest.get_day_count() % 12 -- stub year length
		day_of_year = day_of_year or 12 -- fix modulo range for 1-indexed months
		-- print("day is: " .. day_of_year)
		if (day_of_year < day_start) or (day_of_year > day_end) then
			print("not in day range [" .. day_start .. ", " .. day_end .. "]")
			return
		end

		-- kill plants any time, times are a bit arbitrary 5500 to 19500
		-- if (time < 0.2292) or (time > 0.8125) then
		-- 	return
		-- end

		if grass_form.dead[node.name] then
			minetest.swap_node(pos, {name=grass_form.dead[node.name]})

			-- also ripen the node below if it is grass
			local pos_below = {x=pos.x, y=pos.y-1, z=pos.z}
			local node_below = minetest.get_node(pos_below)
			if grass_form.dead[node_below.name] then
				minetest.swap_node(pos_below, {name=grass_form.dead[node_below.name]})
			end
		end
	end
end

-- debug settings
-- local abm_interval = 3.0
-- local abm_chance   = 10

-- real settings
local abm_interval = 6.0
local abm_chance   = 30

minetest.register_abm({
	nodenames = {"group:spring_grow"},
	interval = abm_interval, -- Run every 10 seconds
	chance = abm_chance, -- Select every 1 in 20 nodes
	action = grass.get_grow_abm(1, 3)
})

minetest.register_abm({
	nodenames = {"group:summer_grow"},
	interval = abm_interval, -- Run every 10 seconds
	chance = abm_chance, -- Select every 1 in 20 nodes
	action = grass.get_grow_abm(4, 6)
})

minetest.register_abm({
	nodenames = {"group:summer_ripe"},
	interval = abm_interval, -- Run every 10 seconds
	chance = abm_chance, -- Select every 1 in 20 nodes
	action = grass.get_ripen_abm(4, 6)
})


minetest.register_abm({
	nodenames = {"group:winter_kill"},
	interval = abm_interval, -- Run every 10 seconds
	chance = abm_chance, -- Select every 1 in 20 nodes
	action = grass.get_kill_abm(10, 12)
})

