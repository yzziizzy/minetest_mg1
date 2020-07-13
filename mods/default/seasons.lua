
default.seasons = {}


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



local SEASONS_YEARLEN = 60 * 60 * 4
-- local SEASONS_YEARLEN = 90



local between = function(v, a, b)
	if v >= a and v < b then
		return true
	end
	return false
end

default.seasons.abm_list = {}
default.seasons.core_lookup = {}
default.seasons.changes_lookup = {
	spring = {},
	summer = {},
	fall = {},
	winter = {},
}


local abm_list = default.seasons.abm_list
local core_lookup = default.seasons.core_lookup
local changes_lookup = default.seasons.changes_lookup

local function splitname(name)
	local c = string.find(name, ":", 1)
	return string.sub(name, 1, c - 1), string.sub(name, c + 1, string.len(name))
end


function reg_changes(ssn, oldmod, oldname)
	local old = oldmod..":"..oldname
	local new = "seasons:"..ssn.."_"..oldmod.."_"..oldname

	core_lookup[old] = old
	if ssn == "summer" then -- minetest is in "summer" by default
		changes_lookup[ssn][old] = old
		table.insert(abm_list, old)
	else
		core_lookup[new] = old
		changes_lookup[ssn][old] = new
		table.insert(abm_list, new)
	end
	
	
end




function reg_generic(oldmod, oldname, tiles, drops, default_season)
	local old = oldmod..":"..oldname
	local ds = default_season or "summer"
	
	function reg(ssn)
		local new
		if ssn == ds then -- minetest is in "summer" by default
			new = old
		else
			new = "default:"..ssn.."_"..oldmod.."_"..oldname
		end
		
		
		if ssn ~= ds then
			local def = deepclone(minetest.registered_nodes[old])
			def.groups.not_in_creative_inventory = 1
			
			if tiles and tiles[ssn] then
				def.tiles = tiles[ssn]
			else
				def.tiles = {"seasons_"..ssn.."_"..oldmod.."_"..oldname..".png"}
			end
			
			if drops and drops[ssn] then 
				def.drops = drops[ssn]
			end
			
			minetest.register_node(new, def)
		end
		
		
		core_lookup[new] = old
		changes_lookup[ssn][old] = new
		table.insert(abm_list, new)
	end
	
	
	reg("spring")
	reg("summer")
	reg("fall")
	reg("winter")
	
end


default.register_generic_seasons = reg_generic

function default.register_node_seasons(name, ndef)
	local oldmod, oldname = splitname(name)
	
	local default_season = ndef.default_season or "summer"
	
	local function reg(ssn)
		if not ndef[ssn] then
			print(name .. " is missing season '"..ssn.."'")
			return
		end
		
		local newname
		if default_season == ssn then
			newname = name
		else
			newname = "default:"..ssn.."_"..oldmod.."_"..oldname
		end
	
		local cdef = deepclone(ndef)
		cdef.groups.not_in_creative_inventory = 1
		cdef.groups.seasonal = 1
	
		-- override any fields provided
		for k,v in pairs(ndef[ssn]) do
			
			-- groups get combined, not overwritten
			if k == "groups" then
				for kk,vv in pairs(v) do
					cdef.groups[kk] = vv
				end
			else
				cdef[k] = v
			end
		end
		
		
		minetest.register_node(newname, cdef)
	
		core_lookup[newname] = name
		changes_lookup[ssn][name] = newname
	end
	
	
	reg("spring")
	reg("summer")
	reg("fall")
	reg("winter")
end






local get_season_data = function() 
	local t = minetest.get_gametime()
	
	local s = (((t *  math.pi * 2) / (SEASONS_YEARLEN)) + (SEASONS_YEARLEN / 3)) % (math.pi * 2)
	local snorm = (math.sin(s) + 1) * 0.5 
	local cnorm = (math.cos(s) + 1) * 0.5 
	
	local sign = 1
	if cnorm < .5 then
		sign = -1
	end
	
	local season
	if between(s, 0, .2) then 
		season = "winter"
	elseif between(s, .8, 1.0) then
		season = "summer"
	else
		if sign > 0 then
			season = "spring"
		else
			season = "fall"
		end
	end
	
	return season, snorm, sign
end

function default.get_timeofyear()
	local t = minetest.get_gametime()
	return ((t + (SEASONS_YEARLEN / 3)) % SEASONS_YEARLEN) / SEASONS_YEARLEN
end

local get_season = function()
	local season, time
	local s = default.get_timeofyear()
	
	if between(s, 0, .2) then 
		season = "spring"
		time = (s - .0) / .2
	elseif between(s, .2, .5) then
		season = "summer"
		time = (s - .2) / .3
	elseif between(s, .5, .7) then
		season = "fall"
		time = (s - .5) / .2
	elseif between(s, .7, 1.0) then
		season = "winter"
		time = (s - .7) / .3
	end

	return season, time
end

default.get_season = get_season






minetest.register_abm({
	label = "Leaf Change",
	nodenames = {"group:seasonal"},
	interval = 6,
	chance = 120,
-- 	interval = 1,
-- 	chance = 4,
	catch_up = true,
	action = function(pos, node)
		local s, progress = get_season()

		--local name = changes[s][node.name]
		local core = core_lookup[node.name]
		local name = changes_lookup[s][core]

		if name == nil or name == node.name then return end
		
		minetest.set_node(pos, {name = name})
		
	end,
})


--[[
-- water freezing
local def
def = deepclone(minetest.registered_nodes["default:ice"])
def.groups.not_in_creative_inventory = 1
def.drops = {"default:ice"}
minetest.register_node("default:seasonal_ice_water_source", def)

def = deepclone(minetest.registered_nodes["default:ice"])
def.groups.not_in_creative_inventory = 1
def.drops = {}
minetest.register_node("default:seasonal_ice_water_flowing", def)

def = deepclone(minetest.registered_nodes["default:ice"])
def.groups.not_in_creative_inventory = 1
def.drops = {"default:ice"} -- TODO: riverwater ice
minetest.register_node("default:seasonal_ice_river_water_source", def)

def = deepclone(minetest.registered_nodes["default:ice"])
def.groups.not_in_creative_inventory = 1
def.drops = {}
minetest.register_node("default:seasonal_ice_river_water_flowing", def)

local ice_lookup = {
	["default:water_source"] = "default:seasonal_ice_water_source",
	["default:water_flowing"] = "default:seasonal_ice_water_flowing",
	["default:river_water_source"] = "default:seasonal_ice_river_water_source",
	["default:river_water_flowing"] = "default:seasonal_ice_river_water_flowing",
}
local water_lookup = {
	["default:seasonal_ice_water_source"] = "default:water_source",
	["default:seasonal_ice_water_flowing"] = "default:water_flowing",
	["default:seasonal_ice_river_water_source"] = "default:river_water_source",
	["default:seasonal_ice_river_water_flowing"] = "default:river_water_flowing",
}


minetest.register_abm({
	label = "Water Freeze",
	nodenames = {
		"default:water_source",
		"default:water_flowing",
		"default:river_water_source",
		"default:river_water_flowing",
	},
	neighbors = "air",
	interval = 3,
	chance = 80,
	catch_up = true,
	action = function(pos, node)
		local s, progress = get_season()

		local name
		if s ~= "winter" then
			return
		end
		
		minetest.set_node(pos, {name = ice_lookup[node.name]})
		
	end,
})
minetest.register_abm({
	label = "Water Thaw",
	nodenames = {
		"default:seasonal_ice_water_source",
		"default:seasonal_ice_water_flowing",
		"default:seasonal_ice_river_water_source",
		"default:seasonal_ice_river_water_flowing",
	},
	interval = 3,
	chance = 80,
	catch_up = true,
	action = function(pos, node)
		local s, progress = get_season()

		local name
		if s == "winter" then
			return
		end
		
		minetest.set_node(pos, {name = water_lookup[node.name]})
		
	end,
})
]]

local last_season = {
	spring = "winter",
	summer = "spring",
	fall = "summer",
	winter = "fall",
}

minetest.register_lbm({
	name = "default:seasons_catchup",
	nodenames = {"group:seasonal"},
	run_at_every_load = true,
	action = function(pos, node)
		local s, progress = get_season()
		
		if math.random() > (progress * 1.2) then
			-- use last season's node
			s = last_season[s]
		end

		--local name = changes[s][node.name]
		local core = core_lookup[node.name]
		local name = changes_lookup[s][core]

		if name == nil or name == node.name then return end
		
		minetest.set_node(pos, {name = name})
	end,
})

--[[ -- flowers bloom in spring, not summer

reg_generic("flowers", "rose", nil, 
	{ -- drops
		spring = {"flowers:rose"},
		summer = {}, -- nothin
		fall = {}, -- TODO: rosehip
		winter = {}, -- TODO: rose bud
	}, 
	"spring")


reg_generic("flowers", "tulip", 
	{
		summer = {"seasons_summer_flowers_tulip.png"},
		fall = {"seasons_fall_flowers_tulip.png"},
		winter = {"seasons_winter_flowers_tulip.png"}
	}, 
	{ -- drops
		--spring = {"flowers:tulip"},
		summer = {}, -- nothin
		fall = {}, -- nothin
		winter = {}, -- TODO: bulb
	}, 
	"spring")
	
	
	
	

local def
-- dandelions are done manually because the default ones represent two seasons
-- fall
def = deepclone(minetest.registered_nodes["flowers:dandelion_yellow"])
def.groups.not_in_creative_inventory = 1
def.tiles = {"seasons_fall_flowers_dandelion.png"}
def.drops = {}
minetest.register_node("seasons:fall_flowers_dandelion", def)
-- winter
def = deepclone(minetest.registered_nodes["flowers:dandelion_yellow"])
def.groups.not_in_creative_inventory = 1
def.tiles = {"seasons_winter_flowers_dandelion.png"}
def.drops = {}
minetest.register_node("seasons:winter_flowers_dandelion", def)
-- lookups
core_lookup["seasons:winter_flowers_dandelion"] = "flowers:dandelion_yellow"
core_lookup["seasons:fall_flowers_dandelion"] = "flowers:dandelion_yellow"
core_lookup["flowers:dandelion_yellow"] = "flowers:dandelion_yellow"
core_lookup["flowers:dandelion_white"] = "flowers:dandelion_yellow" -- this is correct
changes_lookup["fall"]["flowers:dandelion_yellow"] = "seasons:fall_flowers_dandelion"
changes_lookup["winter"]["flowers:dandelion_yellow"] = "seasons:winter_flowers_dandelion"
changes_lookup["spring"]["flowers:dandelion_yellow"] = "flowers:dandelion_yellow"
changes_lookup["summer"]["flowers:dandelion_yellow"] = "flowers:dandelion_white"
table.insert(abm_list, "seasons:fall_flowers_dandelion")
table.insert(abm_list, "seasons:winter_flowers_dandelion")
table.insert(abm_list, "flowers:dandelion_yellow")
table.insert(abm_list, "flowers:dandelion_white")

]]
