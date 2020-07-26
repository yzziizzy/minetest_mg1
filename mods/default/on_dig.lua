



function new_get_node_drops(node, toolname)
	-- Compatibility, if node is string
	local nodename = node
	local param2 = 0
	-- New format, if node is table
	if (type(node) == "table") then
		nodename = node.name
		param2 = node.param2
	end
	
	local tool_def = minetest.registered_items[toolname]
	local tool_caps = {}
	if tool_def and tool_def.tool_capabilities then
		tool_caps = tool_def.tool_capabilities
	end
	
	
	local def = core.registered_nodes[nodename]
	local drop = def and def.drop
	local ptype = def and def.paramtype2
	-- get color, if there is color (otherwise nil)
	local palette_index = core.strip_param2_color(param2, ptype)
	if drop == nil then
		-- default drop
		if palette_index then
			local stack = ItemStack(nodename)
			stack:get_meta():set_int("palette_index", palette_index)
			return {stack:to_string()}
		end
		return {nodename}
	elseif type(drop) == "string" then
		-- itemstring drop
		return drop ~= "" and {drop} or {}
	elseif drop.items == nil then
		-- drop = {} to disable default drop
		return {}
	end

	local got_items = {}
	local got_count = 0
	
	-- tool-specific drops
	if drop.tools and toolname then
		local good_tool = false
		
		for _, tool_drop in ipairs(drop.tools) do
			local td = tool_drop
		
			for _, tool in ipairs(tool_drop.tools) do
				
				if tool:sub(1, 6) == "group:" then
					local tool_group = tool:sub(7)
					if tool_def and tool_def.groups[tool_group] then
						good_tool = true
					end
					
				elseif tool:sub(1, 1) == '~' then
					good_tool = toolname:find(tool:sub(2)) ~= nil
				
				else
					good_tool = toolname == tool
				end
				
				if good_tool then 
					drop = td -- this table takes over
					break
				end
			end
			
			if good_tool then break end
		end
		
	end
	
	
	local bounty_base = math.floor(tool_caps.bounty or 1) 
	local bounty_rand = ((tool_caps.bounty or 1) - bounty_base) * 1000 
	
	-- calculate actual drops
	for _, item in ipairs(drop.items) do
		local good_rarity = true
		if item.rarity ~= nil then
			good_rarity = item.rarity < 1 or math.random(item.rarity) == 1
		end

		if good_rarity then
			got_count = got_count + 1
			
			for _, add_item in ipairs(item.items) do
				local stack = ItemStack(add_item)
				
				-- add color, if necessary
				if item.inherit_color and palette_index then
					stack:get_meta():set_int("palette_index", palette_index)
				end
				
				-- bounty calculation
				local icnt = stack:get_count()
				local icnt2 = icnt * bounty_base
				if math.random(1000) <= bounty_rand then
					icnt2 = icnt2 + icnt
				end
				
				add_item = stack:to_string()
				
				got_items[#got_items+1] = add_item
			end
			
			
			
			if drop.max_items ~= nil and got_count == drop.max_items then
				break
			end
		end
	end
	return got_items
end



default.old_get_node_drops = minetest.get_node_drops
minetest.get_node_drops = new_get_node_drops



--[[
function new_node_dig(pos, node, digger)
	local diggername = user_name(digger)
	local log = make_log(diggername)
	local def = core.registered_nodes[node.name]
	if def and (not def.diggable or
			(def.can_dig and not def.can_dig(pos, digger))) then
		log("info", diggername .. " tried to dig "
			.. node.name .. " which is not diggable "
			.. core.pos_to_string(pos))
		return
	end

	if core.is_protected(pos, diggername) then
		log("action", diggername
				.. " tried to dig " .. node.name
				.. " at protected position "
				.. core.pos_to_string(pos))
		core.record_protection_violation(pos, diggername)
		return
	end

	log('action', diggername .. " digs "
		.. node.name .. " at " .. core.pos_to_string(pos))

	local wielded = digger and digger:get_wielded_item()
	local drops = core.get_node_drops(node, wielded and wielded:get_name())

	if wielded then
		local wdef = wielded:get_definition()
		local tp = wielded:get_tool_capabilities()
		local dp = core.get_dig_params(def and def.groups, tp)
		if wdef and wdef.after_use then
			wielded = wdef.after_use(wielded, digger, node, dp) or wielded
		else
			-- Wear out tool
			if not core.settings:get_bool("creative_mode") then
				wielded:add_wear(dp.wear)
				if wielded:get_count() == 0 and wdef.sound and wdef.sound.breaks then
					core.sound_play(wdef.sound.breaks, {
						pos = pos,
						gain = 0.5
					}, true)
				end
			end
		end
		digger:set_wielded_item(wielded)
	end

	-- Check to see if metadata should be preserved.
	if def and def.preserve_metadata then
		local oldmeta = core.get_meta(pos):to_table().fields
		-- Copy pos and node because the callback can modify them.
		local pos_copy = {x=pos.x, y=pos.y, z=pos.z}
		local node_copy = {name=node.name, param1=node.param1, param2=node.param2}
		local drop_stacks = {}
		for k, v in pairs(drops) do
			drop_stacks[k] = ItemStack(v)
		end
		drops = drop_stacks
		def.preserve_metadata(pos_copy, node_copy, oldmeta, drops)
	end

	-- Handle drops
	core.handle_node_drops(pos, drops, digger)

	local oldmetadata = nil
	if def and def.after_dig_node then
		oldmetadata = core.get_meta(pos):to_table()
	end

	-- Remove node and update
	core.remove_node(pos)

	-- Play sound if it was done by a player
	if diggername ~= "" and def and def.sounds and def.sounds.dug then
		core.sound_play(def.sounds.dug, {
			pos = pos,
			exclude_player = diggername,
		}, true)
	end

	-- Run callback
	if def and def.after_dig_node then
		-- Copy pos and node because callback can modify them
		local pos_copy = {x=pos.x, y=pos.y, z=pos.z}
		local node_copy = {name=node.name, param1=node.param1, param2=node.param2}
		def.after_dig_node(pos_copy, node_copy, oldmetadata, digger)
	end

	-- Run script hook
	for _, callback in ipairs(core.registered_on_dignodes) do
		local origin = core.callback_origins[callback]
		if origin then
			core.set_last_run_mod(origin.mod)
		end

		-- Copy pos and node because callback can modify them
		local pos_copy = {x=pos.x, y=pos.y, z=pos.z}
		local node_copy = {name=node.name, param1=node.param1, param2=node.param2}
		callback(pos_copy, node_copy, digger)
	end
end



default.old_node_dig = minetest.node_dig
minetest.node_dig = new_node_dig
]]




