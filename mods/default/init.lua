-- Minetest 0.4 mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into game_api.txt

-- Load support for MT game translation.
local S = minetest.get_translator("default")

-- Definitions made by this mod that other mods can use too
default = {
	deepest_fill = 1,
	
	noise_params = {},
	biomes = {},
	failsafe_biome = nil,
	failsafe_stone_biome = nil,
	ores = {},
	stone_biomes = {},
	surface_decorations = {},
	placer_ores = {},
	surface_ores = {}, -- NOT IMPLEMENTED
	
	cold = { -- all in degrees C
		base_temp = 10,
		lat_variation = 80,
		day_variation = 15,
		season_variation = 20,
		deg_per_meter = 0.1,
		max_elev = 300,
	},
	
	
	smelts = {}
}

default.LIGHT_MAX = 14
default.get_translator = S

-- GUI related stuff
minetest.register_on_joinplayer(function(player)
	-- Set formspec prepend
	local formspec = [[
			bgcolor[#080808BB;true]
			listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF] ]]
	local name = player:get_player_name()
	local info = minetest.get_player_information(name)
	if info.formspec_version > 1 then
		formspec = formspec .. "background9[5,5;1,1;gui_formbg.png;true;10]"
	else
		formspec = formspec .. "background[5,5;1,1;gui_formbg.png;true]"
	end
	player:set_formspec_prepend(formspec)

	-- Set hotbar textures
	player:hud_set_hotbar_image("gui_hotbar.png")
	player:hud_set_hotbar_selected_image("gui_hotbar_selected.png")
end)

function default.get_hotbar_bg(x,y)
	local out = ""
	for i=0,7,1 do
		out = out .."image["..x+i..","..y..";1,1;gui_hb_bg.png]"
	end
	return out
end

default.gui_survival_form = "size[8,8.5]"..
			"list[current_player;main;0,4.25;8,1;]"..
			"list[current_player;main;0,5.5;8,3;8]"..
			"list[current_player;craft;1.75,0.5;3,3;]"..
			"list[current_player;craftpreview;5.75,1.5;1,1;]"..
			"image[4.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
			"listring[current_player;main]"..
			"listring[current_player;craft]"..
			default.get_hotbar_bg(0,4.25)

-- Load files
local modpath = minetest.get_modpath("default")


local function pre_process_biome(def)
	local max_fill_depth = 0
	
	def.surface_decos = {}
	def.surface_ores = {}
	
-- 		print(dump(def))
	def.cids = {
		fill = {},
	}
	

	for fi,f in ipairs(def.fill) do
		if f.max > 0 then
			local filln = {
				min = f.min,
				max = f.max,
				nodes = {},
				chance_fill = {},
			}
			
			max_fill_depth = max_fill_depth + f.max
			
			def.cids.fill[fi] = filln
			
			for i,v in ipairs(f.nodes) do
				if type(v) == "string" then
					table.insert(filln.nodes, minetest.get_content_id(v))
				else
					filln.chance_fill[i] = {
						chance = v.chance,
						cid = minetest.get_content_id(v.name),
					}
				end
			end
		end
	end
	
	default.deepest_fill = math.max(default.deepest_fill, max_fill_depth)
end


function default.get_all_group_nodes(group, lvl)
	if group:sub(1,6) == "group:" then
		group = group:sub(7)
	end

	local out = {}
	for name,def in pairs(minetest.registered_nodes) do
		if def.groups[group] then
			if lvl == nil or def.groups[group] == lvl then
				table.insert(out, name)
			end
		end
	end
	return out
end

function default.name_is_group(name)
	return type(name) == "string" and name:sub(1,6) == "group:"
end

minetest.register_on_mods_loaded(function()
-- 	print("mapgen init")
	for _,def in pairs(default.biomes) do
		pre_process_biome(def)
	end
	
	pre_process_biome(default.failsafe_biome)	
	
	
	-- pre-process surface decorations
	for k,deco in pairs(default.surface_decorations) do
-- 		if deco.name == "malachite_stones" then
		
		-- cache content id's
		deco.cids = {
			place = {},
		}
		
		for i,v in ipairs(deco.place) do
			if default.name_is_group(v) then
				local nn = default.get_all_group_nodes(v, 1)
				for _,vv in ipairs(nn) do
					table.insert(deco.cids.place, minetest.get_content_id(vv))
				end
			else 
				table.insert(deco.cids.place, minetest.get_content_id(v))
			end
		end
		
		-- fill decorations into biomes
		if deco.biomes == "*" then
			for _,bio in pairs(default.biomes) do
				bio.surface_decos[deco.name] = deco
			end
		else
			for _,biome_name in ipairs(deco.biomes) do
				local bio = default.biomes[biome_name]
				if not bio then
					print("Unknown biome '"..biome_name.."' in decoration '"..deco.name.."'.")
				else
					bio.surface_decos[deco.name] = deco
				end
			end
		end
-- 		end
	end
	
	--[[ NOT IMPLEMENTED
	-- pre-process surface ores
	for k,ore in pairs(default.surface_ores) do
		
		-- cache content id's
		ore.cids = {
			place = {},
		}
		
		for i,v in ipairs(ore.place) do
			ore.cids.place[i] = minetest.get_content_id(v)
		end
		
		-- NOT IMPLEMENTED
		-- fill decorations into biomes
		for _,biome_name in ipairs(ore.biomes) do
			local bio = default.biomes[biome_name]
			if not bio then
				print("Unknown biome '"..biome_name.."' in surface ore '"..ore.name.."'.")
			else
				bio.surface_ores[ore.name] = ore
			end
		end
	end
	]]
	
	
	--
	-- stone biomes
	--
	
	for _,def in pairs(default.stone_biomes) do
		
		def.ores = {}
		--[[
-- 		print(dump(def))
		def.cids = {
			cover = {},
			fill = {},
		}
		
		for i,v in ipairs(def.cover) do
			def.cids.cover[i] = minetest.get_content_id(v)
		end
		for i,v in ipairs(def.fill) do
			def.cids.fill[i] = minetest.get_content_id(v)
		end
		]]
	end
	
	default.failsafe_stone_biome.ores = {}
	
	-- pre-process ore registratoins
	for k,ore in pairs(default.ores) do
		
		-- fill ores into biomes
		if ore.stone_biomes == "*" then
			for _,bio in pairs(default.stone_biomes) do
				bio.ores[ore.name] = ore
			end
		else
			
			for _,biome_name in ipairs(ore.stone_biomes) do
				local bio = default.stone_biomes[biome_name]
				if not bio then
					print("Unknown stone biome '"..biome_name.."' in ore '"..ore.name.."'.")
				else
					bio.ores[ore.name] = ore
				end
			end
		end
	end
end)




function default.register_casting(def)
	if default.smelts[def.name] ~= nil then
		print("Overwriting casting definition for "..def.name)
	end
	default.smelts[def.name] = def
end

function default.get_smelt(mold_name, metal)
	
end



-- NOT IMPLEMENTED
default.register_surface_ore = function(def)
	
	-- todo: fill in missing defaults
	-- TODO: warnings for invalid data
	
	if def.noise then
		def.noise.offset = 0.4
		def.noise.scale = 0.4
	end
	
	default.surface_ores[def.name] = def
end




-- shallow copy
function default.extend(a, b)
	b = b or {}
	local c = {}
	for k,v in pairs(a) do
		c[k] = v
	end
	
	for k,v in pairs(b) do
		c[k] = v
	end
	
	return c
end
-- temp



minetest.register_node("default:lake_magic", {
	description = "Lake Magic Block",
	tiles = {"default_snow.png"},
	groups = {crumbly = 3, cools_lava = 1, snowy = 1},
	on_timer = function(pos)
		minetest.set_node(pos, {name = "default:lake_water_source"})
	end
})


local function check_node(pos, dir, cnt)
	local n = minetest.get_node(pos)
	if n.name == "default:lake_magic" then
		minetest.set_node(pos, {name="air"})
		
		return check_node(vector.add(pos, dir), dir, cnt + 1)
	end
	
	return cnt
end


local function check_node_1(pos, dir, cnt)
	local n = minetest.get_node(vector.add(pos, dir))
	if n.name == "air" then
		return check_node(pos, vector.multiply(dir, -1), cnt)
	end
	
	return cnt
end

minetest.register_abm({
	nodenames = {"default:lake_magic"},
	neighbors = {"air"},
	interval  = 1,
	chance = 1,
	catch_up = true,
	action = function(pos, node)
		
		while 1==1 do
			if 0 ~= check_node_1(pos, {x=1, y=0, z=0}, 0) then break end
			if 0 ~= check_node_1(pos, {x=0, y=0, z=1}, 0) then break end
			if 0 ~= check_node_1(pos, {x=-1, y=0, z=0}, 0) then break end
			if 0 ~= check_node_1(pos, {x=0, y=0, z=-1}, 0) then break end
			
			local timer = minetest.get_node_timer(pos)
			if not timer:is_started() then
				timer:start(15)
			end
			
			return
		end
		
	end,
})


minetest.register_abm({
	nodenames = {"default:lake_magic"},
	neighbors = {"default:lake_water_source"},
	interval  = 1,
	chance = 1,
	catch_up = true,
	action = function(pos, node)
		minetest.set_node(pos, {name="default:lake_water_source"})
	end
})


-- /temp


-- monkey patches
dofile(modpath.."/on_dig.lua")


-- files with no deps
dofile(modpath.."/crumbling.lua")
dofile(modpath.."/rot.lua")


-- files that are deps
dofile(modpath.."/functions.lua")
dofile(modpath.."/environment.lua")
dofile(modpath.."/water.lua")
dofile(modpath.."/seasons.lua")
dofile(modpath.."/player.lua")
dofile(modpath.."/soil.lua")
dofile(modpath.."/stone.lua")


dofile(modpath.."/biomes.lua")
dofile(modpath.."/surface_deco.lua")
dofile(modpath.."/ores.lua")
dofile(modpath.."/trees.lua")

-- files that have deps
dofile(modpath.."/furnace.lua")
dofile(modpath.."/tools.lua")
dofile(modpath.."/trees/aspen.lua")
dofile(modpath.."/trees/birch.lua")
dofile(modpath.."/trees/fir.lua")
dofile(modpath.."/trees/larch.lua")
-- dofile(modpath.."/trees/red_oak.lua")
-- dofile(modpath.."/trees/redwood.lua")
-- dofile(modpath.."/trees/rain_tree.lua")
dofile(modpath.."/trees/bamboo.lua")

dofile(modpath.."/casting.lua")

