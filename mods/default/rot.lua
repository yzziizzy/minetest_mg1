

default.rot = {
	downgrades = {},
	chances = {},
}
local rot = default.rot


function deepclone(t)
	if type(t) ~= "table" then 
		return t 
	end
	
	local meta = getmetatable(t)
	local target = {}
	
	for k, v in pairs(t) do
		if type(v) == "table" then
			target[k] = deepclone(v)
		else
			target[k] = v
		end
	end
	
	setmetatable(target, meta)
	
	return target
end

local function splitname(name)
	local c = string.find(name, ":", 1)
	return string.sub(name, 1, c - 1), string.sub(name, c + 1, string.len(name))
end






-- "old" is the full name of the node
default.register_rot = function(old, info) 
	local oldmod, oldname = splitname(old)
	local olddef = minetest.registered_nodes[old]
	
	
	local function reg_lvl(max, lvl, extra)
		local def = deepclone(olddef)
		def.groups.not_in_creative_inventory = 1
		def.groups.rotten = lvl
		def.groups.rots = nil -- only used for starting the process
		def.description = "Rotting " .. def.description
		def.rot_chance = extra.chance
		
		local name1 = "default:rotten_"..oldmod.."_"..oldname.."_"..lvl
		
		if extra.tiles then
			def.tiles = extra.tiles
		else
			for k, v in pairs(def.tiles) do
				def.tiles[k] = def.tiles[k].."^[colorize:black:"..((lvl)*40)
-- 				print(lvl .. " - " ..def.tiles[k])
			end
		end
		
		if extra.drops then 
			def.drops = extra.drops
		else
			def.drops = name1
		end
		
		if extra.groups then
			for k,v in pairs(extra.groups) do
				def.groups[k] = v
			end
		end
		
		
		local name2
		if lvl >= max then
			local final
			if info.final then
				final = info.final
			else
				final = "default:compost"
			end
			rot.downgrades[name1] = final
		else
			rot.downgrades[name1] = "default:rotten_"..oldmod.."_"..oldname.."_"..(lvl+1)
		end
		
		minetest.register_node(":"..name1, def)
	end
	
	
	-- register nodes
	for lvl,ex in ipairs(info.levels) do
		reg_lvl(#info.levels, lvl, ex)
	end
	
	rot.downgrades[old] = "default:rotten_"..oldmod.."_"..oldname.."_1"
	
end



-- BUG: stairs has complicated images
-- for _,v in ipairs(stairlist) do
-- 	rot.register_node("stairs:stair_"..v)
-- 	rot.register_node("stairs:stair_outer_"..v)
-- 	rot.register_node("stairs:stair_inner_"..v)
-- 	rot.register_node("stairs:slab_"..v)
-- end

-- todo: stairs/slabs, chests, doors, beds



minetest.register_on_mods_loaded(function()
	
	for n,def in pairs(minetest.registered_nodes) do
		if def.rot_chance then
			rot.chances[n] = def.rot_chance
		end
	end
	
-- 	print(dump(rot.downgrades))
end)


-- start rotting
minetest.register_abm({
	nodenames = {"group:rots"},
 	neighbors = {"group:causes_rot"},
	interval = 30,
	chance = 100,
	catch_up = true,
	action = function(pos, node)
		local n = rot.downgrades[node.name]
		if n then
			local c = rot.chances[node.name]
			if not c or 1 == math.random(c) then
				minetest.set_node(pos, {name = n, param2=node.param2})
				minetest.check_for_falling(pos)
			end
		end
	end,
})


-- keep rotting, accelerated
minetest.register_abm({
	nodenames = {"group:rotten"},
 	neighbors = {"group:causes_rot", "group:rotten"},
	interval = 30,
	chance = 100,
	catch_up = true,
	action = function(pos, node)
		local n = rot.downgrades[node.name]
		if n then
			local c = rot.chances[node.name]
			if not c or 1 == math.random(c) then
				minetest.set_node(pos, {name = n, param2=node.param2})
				minetest.check_for_falling(pos)
			end
		end
	end,
})

-- keep rotting, alone
minetest.register_abm({
	nodenames = {"group:rotten"},
-- 	interval = 30,
	chance = 100,
	catch_up = true,
	action = function(pos, node)
		local n = rot.downgrades[node.name]
		if n then
			local c = rot.chances[node.name]
			if not c or 1 == math.random(c) then
				minetest.set_node(pos, {name = n, param2=node.param2})
				minetest.check_for_falling(pos)
			end
		end
	end,
})



-- warm and humid climates cause notes to randomly rot
minetest.register_abm({
	nodenames = {"group:rots"},
	interval = 45,
	chance = 200,
	catch_up = true,
	action = function(pos, node)
		
		if default.get_humidity(pos) + math.random(-5, 5) > 70 then 
			if default.get_average_temp(pos) + math.random(-5, 5) > 26 then
			
				local n = rot.downgrades[node.name]
				if n then
					local c = rot.chances[node.name]
					if not c or 1 == math.random(c) then
						minetest.set_node(pos, {name = n, param2=node.param2})
						minetest.check_for_falling(pos)
					end
				end
			end
		end
	end,
})
