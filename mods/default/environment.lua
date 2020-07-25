
function default.get_noise(name, pos)
	local n = minetest.get_perlin_map(default.noise_params[name], {x=1,y=1,z=1}):get2dMap_flat(pos)
	return n[1]
end




function default.get_elev_temp_factor(y)
	local y2 = math.max(0, math.min(pos.y, default.cold.max_elev))
	return -(y2 * default.cold.deg_per_meter)
end


-- WITHOUT the noise component
function default.get_temp(pos)
	local y = math.max(0, math.min(pos.y, default.cold.max_elev))
	local elev_factor = -(y * default.cold.deg_per_meter)
	
	local lat = math.abs(pos.z)
	local lat_factor = (math.cos((math.pi / 31000) * lat) - 1) * 0.5 * default.cold.lat_variation
	
	local time = minetest.get_timeofday()
	local day_factor = math.sin(math.pi * time) * default.cold.day_variation
	
	local season_factor = math.sin(math.pi * default.get_timeofyear()) * default.cold.season_variation
-- 	print("  ")
-- 	print("  day factor: ".. day_factor)
-- 	print("  ele factor: ".. elev_factor)
-- 	print("  lat factor: ".. lat_factor)
-- 	print("  sea factor: ".. season_factor)
	return default.cold.base_temp + elev_factor + lat_factor + day_factor + season_factor
end


-- identical with what the mapgen uses
-- includes noise
function default.get_average_temp(pos)
	local nval = default.get_noise("heat", pos)
	
	local y2 = math.max(0, math.min(pos.y, default.cold.max_elev))
	local elev_factor = -(y2 * default.cold.deg_per_meter)
	
	local alat = math.abs(pos.z)
	local lat_factor = (math.cos((math.pi / 31000) * alat) - 1) * 0.5 * default.cold.lat_variation
	
	return default.cold.base_temp + 
		elev_factor + 
		lat_factor + 
		nval +
		(default.cold.day_variation / 2) +
		(default.cold.season_variation / 2)
end



-- only the noise component
function default.get_temp_noise(pos)
	return default.get_noise("heat", pos)
end


-- full heat value including noise
function default.get_temp_with_noise(pos)
	return default.get_temp(pos) + default.get_temp_noise(pos)
end

-- get humidity noise
function default.get_humidity(pos)
	return default.get_noise("humidity", pos)
end

-- get background magic levels (just noise atm)
function default.get_background_magic(pos)
	return default.get_noise("magic", pos)
end

-- might be very broken
-- more of "not(is_mountainous)" and still only partially accurate
function default.get_flatness(pos)
	local continents = default.get_noise("flatness_1", pos)
	
	if continents <= 2 then return 0 end -- might be wrong
	
	local m = continents - 2
	local p = m / 4
	local s = 1 / (1 + math.exp(-p)) -- when to get mountainous
	
	return s
end



-- should be nearly identical to the mapgen
--    "flatness" might be wrong internally
-- very slow
function default.get_biome(pos)
	return default.select_biome(pos.x, pos.y, pos.z,
		default.get_average_temp(pos),
		default.get_noise("humidity", pos),
		default.get_noise("magic", pos),
		default.get_noise("flatness", pos)
	)
end

-- return the biome for the given factors.
-- not exactly fast
function default.select_biome(x, y, z, heat, humidity, magic, flatness)
-- 	print("   y="..y)
	local best = nil
	local best_d = 99999999999999999999
	
	for _,def in pairs(default.biomes) do
		local y_r = y + math.random(-def.y_rand, def.y_rand) 
-- 		print(def.name.." "..y_r.. " "..def.y_min.. " "..def.y_max )
		if def.y_min <= y_r and def.y_max >= y_r then
			local he = heat - def.heat
			local hu = humidity - def.humidity
			local ma = magic - def.magic
			local fl = flatness - def.flatness
			local la = math.abs(z / 320) - def.lat_center 
			local d = he * he + hu * hu + ma * ma + fl * fl + la * la
			
-- 			print(" "..def.name.. " d: "..d)
			if d < best_d then
				
				best = def
				best_d = d
			end
		end
	end
	
	local b = best or default.failsafe_biome
-- 	print("  "..b.name)
	return b
end


-- return the stone biome for the given factors.
-- not exactly fast
function default.select_stone_biome(x, y, z, heat, humidity, magic, flatness, vulcanism)
-- 	print("   y="..y)
	local best = nil
	local best_d = 99999999999999999999
	
	for _,def in pairs(default.stone_biomes) do
		local y_r = y + math.random(-def.y_rand, def.y_rand) 
-- 		print(def.name.." "..y_r.. " "..def.y_min.. " "..def.y_max )
		if def.y_min <= y_r and def.y_max >= y_r then
			local he = heat - def.heat
			local hu = humidity - def.humidity
			local ma = magic - def.magic
			local fl = flatness - def.flatness
			local vu = vulcanism - def.vulcanism
			local la = math.abs(z / 320) - def.lat_center 
			local d = he*he + hu*hu + ma*ma + fl*fl + la*la + vu*vu
			
-- 			print(" "..def.name.. " d: "..d)
			if d < best_d then
				
				best = def
				best_d = d
			end
		end
	end
	
	local b = best or default.failsafe_stone_biome
-- 	print("  "..b.name)
	return b
end




----------------------------
-- Registration Functions --
----------------------------

default.register_biome = function(def)
-- 	print("registering biome")
	if def.name == "failsafe" then
		default.failsafe_biome = def
	else
		default.biomes[def.name] = def
	end
end


default.register_stone_biome = function(def)
-- 	print("registering biome")
	if def.noise then
		def.noise.offset = 0.4
		def.noise.scale = 0.4
	end

	if def.name == "failsafe" then
		default.failsafe_stone_biome = def
	else
		default.stone_biomes[def.name] = def
	end
end


default.register_surface_deco = function(def)
	
	-- todo: fill in missing defaults
	-- TODO: warnings for invalid data
	if def.noise then
		if not def.noise.cap then
			def.noise.cap = 10
		end
	end
	
	if def.noise and def.type ~= "density" then
		def.noise.offset = 0.4
		def.noise.scale = 0.4
	end
	
	default.surface_decorations[def.name] = def
end



default.register_ore = function(def)
-- 	print("registering ore")
	if def.noise then
		def.noise.offset = 0
		def.noise.scale = 1
	end
	if def.noise_1 then
		def.noise_1.offset = 0
		def.noise_1.scale = 1
	end
	if def.noise_2 then
		def.noise_2.offset = 0
		def.noise_2.scale = 1
	end

	default.ores[def.name] = def
end




default.register_placer = function(def)
	
	-- todo: fill in missing defaults
	-- TODO: warnings for invalid data
	
	if def.noise then
		def.noise.offset = 0.4
		def.noise.scale = 0.4
	end
	
	default.placer_ores[def.name] = def
end








---------------------
-- Don't Use These --
---------------------

function default.set_noise_params(name, params)
	default.noise_params[name] = params
end
