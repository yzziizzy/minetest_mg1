
default.players = {}
default.player_objs = {}


-- thaw out the player data storage
local mod_storage = minetest.get_mod_storage()

if mod_storage ~= nil and false then
	default.players = minetest.deserialize(mod_storage:get_string("players"))
	print(dump(default.players))
end

if not default.players then
	default.players = {}
end


local function set_bar_pct(player, bar_name, pct)
	local obj = default.player_objs[player:get_player_name()]
	if obj then
		local bar = obj.ui[bar_name]
		if bar.orient == "h" then
			player:hud_change(bar.bar, "scale", {x = pct, y = 1})
		else
			player:hud_change(bar.bar, "scale", {x = 1, y = pct})
		end
	end
end

minetest.register_playerevent(function(player, event)

	local name = player:get_player_name()
	local info = default.players[name]
	if name == "" or not info then
		return
	end
	
	
	if event == "health_changed" then
		local hp = player:get_hp()
		local max = player:get_properties().hp_max
		set_bar_pct(player, "hp", hp / max)
		
	elseif event == "breath_changed" then
		local br = player:get_breath()
		local max = player:get_properties().breath_max
		set_bar_pct(player, "breath", br / max)
		
	elseif event == "hud_changed" then
		print("hud changed event")
	end

end)

local function create_bar(player, def)
	local bar, border
	
	if def.orient and def.orient == "v" then
		bar = player:hud_add({
			hud_elem_type = "image",
			position  = def.pos,
			offset    = def.off,
			text      = def.image,
			scale     = { x = 1, y = def.pct},
			alignment = def.align,
		})
		border = player:hud_add({
			hud_elem_type = "image",
			position  = def.pos,
			offset    = def.off,
			text      = "default_manna_border.png",
			scale     = { x = 1, y = 1 },
			alignment = def.align
		})
	
	else
		bar = player:hud_add({
			hud_elem_type = "image",
			position  = def.pos,
			offset    = def.off,
			text      = def.image,
			scale     = { x = def.pct, y = 1},
			alignment = def.align,
		})
		border = player:hud_add({
			hud_elem_type = "image",
			position  = def.pos,
			offset    = def.off,
			text      = "default_hp_border.png",
			scale     = { x = 1, y = 1 },
			alignment = def.align
		})
	end
	
	local obj = default.player_objs[player:get_player_name()]
	obj.ui[def.name] = {
		orient = def.orient or "h",
		bar = bar,
		border = border,
	}
	
	return obj.ui[def.name]
end

minetest.register_on_respawnplayer(function(player)
	player:hud_set_flags({healthbar = false, breathbar = false})
end)

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local info = default.players[name] 
	
	if not info then
		-- stuff that should be serialized and saved
		info = {
			connected = true,
			name = name, 
			speed_mods = {},
			base_speed = 1.0,
			run_speed = 2.0,
			
			manna = 10,
			max_manna = 100,
			stamina = 10,
			max_stamina = 10,
			coldness = 10,
			max_coldness = 100,
			food = 100,
			max_food = 100,
			
			max_breath = player:get_properties().breath_max,
			max_hp = player:get_properties().hp_max,
		}
		
		default.players[name] = info
	else
		info.connected = true
	end
	
		-- stuff that shouldn't be serialized
	default.player_objs[name] = {
		player = player,
		ui = {},
	}
	
	
	player:hud_set_flags({healthbar = false, breathbar = false})
	
	
	create_bar(player, {
		name = "manna",
		orient = "v",
		pos   = {x = 0, y = 1},
		off   = {x = 10, y = -120},
		image = "default_manna_bar.png",
		align = { x = 0, y = -1 },
		pct = info.manna / info.max_manna,
	})
	
	
	create_bar(player, {
		name = "hp",
		pos   = {x = 0.5, y = 1},
		off   = {x = -214, y = -100},
		image = "default_hp_bar.png",
		align = { x = 1, y = 0 },
		pct = player:get_hp() / info.max_hp,
	})
	
	create_bar(player, {
		name = "stamina",
		pos   = {x = 0.5, y = 1},
		off   = {x = -214, y = -130},
		image = "default_stamina_bar.png",
		align = { x = 1, y = 0 },
		pct = info.stamina / info.max_stamina,
	})

	create_bar(player, {
		name = "cold",
		pos   = {x = 0.5, y = 1},
		off   = {x = 0-64, y = -115},
		image = "default_cold_bar.png",
		align = { x = 1, y = 0 },
		pct = info.coldness / info.max_coldness,
	})

	create_bar(player, {
		name = "breath",
		pos   = {x = 0.5, y = 1},
		off   = {x = 150-64, y = -100},
		image = "default_breath_bar.png",
		align = { x = 1, y = 0 },
		pct = player:get_breath() / info.max_breath,
	})
	create_bar(player, {
		name = "hunger",
		pos   = {x = 0.5, y = 1},
		off   = {x = 150-64, y = -130},
		image = "default_hunger_bar.png",
		align = { x = 1, y = 0 },
		pct = info.food / info.max_food,
	})

	


end)

function default.save_player_data()
	mod_storage:set_string("players", minetest.serialize(default.players))
end


function default.use_stamina(player, info, amt)
	info.stamina = math.min(math.max(0, info.stamina - amt), info.max_stamina)
	set_bar_pct(player, "stamina", info.stamina / info.max_stamina)
end
function default.add_stamina(player, info, amt)
	info.stamina = math.min(math.max(0, info.stamina + amt), info.max_stamina)
	set_bar_pct(player, "stamina", info.stamina / info.max_stamina)
end



local function set_player_speed(player, info)
	local bs = info.base_speed
	if info.is_running then
		bs = info.run_speed
	end
	
	local bonus = 0
	for _,v in pairs(info.speed_mods) do
		bonus = bonus + bs * v
	end
	
	player:set_physics_override({
		speed = bs + bonus,
	})
end


function default.set_player_speed_mod(player, modname, amt)
	local pname = player:get_player_name()
	local info = default.players[pname]
	
	info.speed_mods[modname] = amt
	
	set_player_speed(player, info)
end


function default.set_player_base_speed(player, speed)
	local pname = player:get_player_name()
	local info = default.players[pname]
	
	info.base_speed = speed
	
	set_player_speed(player, info)
end


-- running 

local function check_run(player)
	local controls = player:get_player_control()
	local pname = player:get_player_name()
	local info = default.players[pname]
	
	if info.is_running then
		default.use_stamina(player, info, 1)
	end
	
	if info.stamina <= 0 then
		is_running = false
	end
	
	if info.stamina > 3 and controls.aux1 then -- fast
		info.is_running = true
	else
		info.is_running = false
		default.add_stamina(player, info, .15)
	end
	
	set_player_speed(player, info)
end


local function run_update()
	for _, player in ipairs(minetest.get_connected_players()) do
		check_run(player)
	end
	minetest.after(.25, run_update)
end

if not minetest.settings:get_bool("creative_mode") then
	minetest.after(.25, run_update)
end



--
-- coldness
--

local function check_cold(player)
	local pname = player:get_player_name()
	local info = default.players[pname]
	
	local pos = player:get_pos()
	
	local t = default.get_temp(pos)
	
	-- TODO cold/heat damage
-- 	print("temp: "..t)
end

local function cold_update()
	for _, player in ipairs(minetest.get_connected_players()) do
		check_cold(player)
	end
	minetest.after(10, cold_update)
end

-- if not minetest.settings:get_bool("creative_mode") then
	minetest.after(10, cold_update)
-- end
--
-- manna code
--

-- bumps manna slowly, updates ui, and triggers any functions
local function update_player_manna(player, info, increase)
	local pname = player:get_player_name()
	
	info.manna = math.min(info.manna + increase, info.max_manna)
	default.save_player_data(player)
	
	local mpct = info.manna / info.max_manna
	
	player:hud_change(default.player_objs[pname].ui.manna_bar, "scale", {x = 1, y = mpct})
end

local function update_all_manna() 
	for pname,info in pairs(default.players) do
		update_player_manna(default.player_objs[pname].player, info, 20) -- HACK manna regenerates quickly for debugging
	end
	
	minetest.after(2, update_all_manna)
end

function trigger_negative_manna(player, m)
	return false
end

minetest.after(1, update_all_manna)


-- manna api

default.use_manna = function(player, amt) 
	local pname = player:get_player_name()
	local info = default.players[pname]
	local om = info.manna or 0
	local remm = om - amt
	local used = amt
	
	if remm < 0 then
		local res = trigger_negative_manna(player, m)
		if res ~= false then
			return res
		end
		
		used = om
		remm = 0
	end
	
	
	info.manna = remm
	update_player_manna(player, info, 0)
	
	return used
end

default.get_manna = function(player) 
	return default.players[player:get_player_name()].manna or 0
end

default.set_manna = function(player, amt) 
	local pname = player:get_player_name()
	local info = default.players[pname]
	
	local max = info.max_manna or 100
	info.manna = math.max(0, math.min(max, amt))
	
	update_player_manna(player, info, 0)
end

default.add_manna = function(player, amt) 
	local info = default.players[player:get_player_name()]
	update_player_manna(player, info, amt)
end

default.set_max_manna = function(player, amt) 
	local info = default.players[player:get_player_name()]
	info.max_manna = math.max(0, amt)
	update_player_manna(player, info, 0)
end



