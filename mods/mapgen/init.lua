
--
-- Average Temp
--

--[[
minetest.register_decoration({
	deco_type = "simple",
	place_on = "default:dirt_with_grass",
	fill_ratio = 1.0,
	sidelen = 1,
	biomes = {"tempplain"},
	height = 3,
	decoration = "default:wood"
})]]

--[[
minetest.register_decoration({
	deco_type = "simple",
	place_on = "default:dirt_with_grass",

	fill_ratio = .01,
	sidelen = 10,
	height = 1,
	biomes = {"temperate"},
	decoration = "default:sapling"
})


minetest.register_decoration({
	deco_type = "simple",
	place_on = "default:dirt",

	fill_ratio = .01,
	sidelen = 10,
	height = 1,
--     biomes = {"tempplain"},
	decoration = "default:sapling"
})]]



--dofile(minetest.get_modpath("mapgen").."/simple_biomes.lua")
--dofile(minetest.get_modpath("mapgen").."/trees.lua")

local function round(x)
	return math.floor(x + 0.5)
end


local vc = 64
local vc2 = 64


local np_caves = {
	offset = 0,
	scale = 1,
	spread = {x=300, y=300, z=300}, 
	seed = 54333,
	octaves = 3,
	persist = 0.67
}
local np_caves2 = {
	offset = 0,
	scale = 1,
	spread = {x=300, y=300, z=300},
	seed = 453467,
	octaves = 3,
	persist = 0.67
}

local np_cave_size = {
	offset = .02,
	scale = .04,
	spread = {x=200, y=200, z=200},
	seed = 4746,
	octaves = 4,
	persist = 0.7
}


local np_stone = {
	offset = .5,
	scale = 1,
	spread = {x=256, y=128, z=256}, --squash the layers a bit
	seed = 34033,
	octaves = 2,
	persist = 0.67
}

local np_terrain1 = {
	offset = 0,
	scale = 1,
	spread = {x=vc, y=vc, z=vc},
	seed = 5900033,
	octaves = 1,
	persist = 0.67
}
local np_terrain2 = {
	offset = 0,
	scale = 1,
	spread = {x=vc, y=vc, z=vc},
	seed = 59002,
	octaves = 1,
	persist = 0.67
}
local np_terrain3 = {
	offset = 0,
	scale = 1,
	spread = {x=vc, y=vc, z=vc},
	seed = 5900232,
	octaves = 1,
	persist = 0.67
}
local np_terrain4 = {
	offset = 0,
	scale = 1,
	spread = {x=vc, y=vc, z=vc},
	seed = 334502,
	octaves = 1,
	persist = 0.67
}
local np_terrain5 = {
	offset = 0,
	scale = 1,
	spread = {x=vc, y=vc, z=vc},
	seed = 756742,
	octaves = 1,
	persist = 0.67
}


local np_river1 = {
	offset = 0,
	scale = 1,
	spread = {x=350, y=350, z=350},
	seed = 7843,
	octaves = 4,
	persist = 0.55
}
local np_river2 = {
	offset = 0,
	scale = 1,
	spread = {x=600, y=600, z=600},
	seed = 45346,
	octaves = 3,
	persist = 0.35
}


local np_heat = {
	offset = 0,
	scale = 10,
	spread = {x=500, y=500, z=500},
	seed = 76783,
	octaves = 3,
	persist = 0.3
}
default.set_noise_params("heat", np_heat)

local np_humidity = {
	offset = 50,
	scale = 50,
	spread = {x=700, y=700, z=700},
	seed = 23567,
	octaves = 3,
	persist = 0.3
}
default.set_noise_params("humidity", np_humidity)

local np_magic = {
	offset = 50,
	scale = 50,
	spread = {x=400, y=400, z=400},
	seed = 226426,
	octaves = 3,
	persist = 0.5
}
default.set_noise_params("magic", np_magic)


local np_plains1 = {
	offset = 4,
	scale = 30,
	spread = {x=1000, y=1000, z=1000},
	seed = 82341,
	octaves = 3,
	persist = 0.5
}

local np_plains2 = {
	offset = 4,
	scale = 30,
	spread = {x=1500, y=1500, z=1500},
	seed = 67824,
	octaves = 3,
	persist = 0.4
}
local np_continents = {
-- 	offset = -2,
	offset = 4,
	scale = 20,
	spread = {x=350, y=350, z=350},
	seed = 67824,
	octaves = 3,
	persist = 0.2
}
default.set_noise_params("flatness_1", np_continents)

local np_hills = {
	offset = 0,
	scale = 10,
	spread = {x=150, y=150, z=150},
	seed = 345346,
	octaves = 4,
	persist = 0.4
}

local np_mtns1 = {
	offset = 4,
	scale = 120,
	spread = {x=1300, y=1300, z=1300},
	seed = 82341,
	octaves = 6,
	persist = 0.7
}
local np_mtns2 = {
	offset = 4,
	scale = 70,
	spread = {x=1000, y=1000, z=1000},
	seed = 5834,
	octaves = 3,
	persist = 0.6
}
default.set_noise_params("vulcanism", np_mtns2)

local np_mtns3 = {
	offset = 0,
	scale = 70,
	spread = {x=400, y=400, z=400},
	seed = 5834,
	octaves = 6,
	persist = 0.8
}

local np_sq1 = {
	offset = 4,
	scale = 70,
	spread = {x=100, y=100, z=100},
	seed = 5834,
	octaves = 5,
	persist = 0.65
}



local np_lake_chance = {
	offset = -9.0,
	scale = 10,
	spread = {x=100, y=100, z=100},
	seed = 69566,
	octaves = 6,
	persist = 0.6
}
local np_lake_floor = {
	offset = 5,
	scale = 10,
	spread = {x=60, y=60, z=60},
	seed = 3734,
	octaves = 4,
	persist = 0.85
}



local np_fill_depth = {
	offset = 0.5,
	scale = 1,
	spread = {x=32, y=32, z=32},
	seed = 3546,
	octaves = 6,
	persist = 0.9
}

--[[ large v7 mountains
local np_sq2 = {
	offset = 0,
	scale = 20,
	spread = {x=120, y=120, z=120},
	seed = 3247,
	octaves = 6,
	persist = 0.35
}]]
--[[ good for large caverns
local np_sq2 = {
	offset = 0,
	scale = 20,
	spread = {x=400, y=400, z=400},
	seed = 3247,
	octaves = 6,
	persist = 0.5
}]]

-- very dense random noise
local np_sq2 = {
	offset = 0,
	scale = 20,
	spread = {x=32, y=32, z=32},
	seed = 3247,
	octaves = 6,
	persist = 0.9
}

--mgv7_np_terrain_base = 4,    120,  (1300, 1300, 1300), 82341, 6, 0.7
--mgv7_np_terrain_alt = 4,    70,  (1000, 1000, 1000), 5934,  3, 0.6


--[[ 

mgv7_np_terrain_base = 4,    520,  (1300, 1300, 1300), 82341, 3, 0.7
mgv7_np_terrain_alt = 4,    525,  (1228, 1228, 1228), 5934,  1, 0.6
mgv7_np_height_select = -1, 100,  (1250, 1250, 1250), 4213,  5, 0.7

mgv7_np_mount_height    = 400,  700,  (500, 500, 500), 72449, 4, 0.6


]]

local function logb(b, x)
	return math.log(x) / math.log(b)
end
local function nclamp(x)
	return math.min(1, math.max(x, 0))
end
local function clamp(l, x, h)
	return math.min(h, math.max(x, l))
end




local function calc_heat(y, lat, nval)

	local y2 = math.max(0, math.min(y, default.cold.max_elev))
	local elev_factor = -(y2 * default.cold.deg_per_meter)
	
	local alat = math.abs(lat)
	local lat_factor = (math.cos((math.pi / 31000) * alat) - 1) * 0.5 * default.cold.lat_variation
	
	return default.cold.base_temp + 
		elev_factor + 
		lat_factor + 
		nval +
		(default.cold.day_variation / 2) +
		(default.cold.season_variation / 2)
end


-- minetest.register_on_respawnplayer(function(player)
--     player:setpos({x=571, y=50, z=70})
--     return true
-- end)

local scaler = 4


minetest.register_on_generated(function(minp, maxp, seed)
--      if maxp.y > 0 then
--          return
--      end
	local chunk_flatness_lookup = {}
	local biome_immune = {}
	local ground_surface = {}
	local lake_surface = {}
	local river_surface = {}
	local rock_surface = {}
	local surface_biome = {}
	local biome_cache = {}
	
	local noise_cache = {}
	
	local x1 = maxp.x
	local y1 = maxp.y
	local z1 = maxp.z
	local x0 = minp.x
	local y0 = minp.y
	local z0 = minp.z

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()

	-- general
	local c_air = minetest.get_content_id("air")
	local c_lava = minetest.get_content_id("default:lava_source")
	local c_stone = minetest.get_content_id("default:mg_stone")
	local c_glass = minetest.get_content_id("default:mg_glass")
	local c_s_water = minetest.get_content_id("default:sea_water_source")
	local c_r_water = minetest.get_content_id("default:river_water_source")
	local c_g_water = minetest.get_content_id("default:glacial_water_source")
	local c_l_water = minetest.get_content_id("default:lake_magic")
	local c_wetsand = minetest.get_content_id("default:wet_sand")
	
	-- igneous
	local c_granite = minetest.get_content_id("default:granite")
	local c_basalt = minetest.get_content_id("default:basalt")
	local c_obsidian = minetest.get_content_id("default:obsidian")
	local c_pumice = minetest.get_content_id("default:pumice")
	
	local sidelen = x1 - x0 + 1
	local chulens = {x=sidelen, y=sidelen, z=sidelen}
	local minposxyz = {x=x0, y=y0, z=z0}
	local minposxz = {x=x0, y=z0}

-- 	local nvals_caves = minetest.get_perlin_map(np_caves, chulens):get3dMap_flat(minposxyz)
-- 	local nvals_caves2 = minetest.get_perlin_map(np_caves2, chulens):get3dMap_flat(minposxyz)
-- 	local nvals_cave_size = minetest.get_perlin_map(np_cave_size, chulens):get3dMap_flat(minposxyz)
	
	local nvals_river1 = minetest.get_perlin_map(np_river1, chulens):get2dMap_flat(minposxz)
	local nvals_river2 = minetest.get_perlin_map(np_river2, chulens):get2dMap_flat(minposxz)
	--[[
	local nvals_plains = minetest.get_perlin_map(np_plains1, chulens):get2dMap_flat(minposxz)
	local nvals_plains2 = minetest.get_perlin_map(np_plains2, chulens):get2dMap_flat(minposxz)
	]]
	local nvals_continents = minetest.get_perlin_map(np_continents, chulens):get2dMap_flat(minposxz)
	local nvals_hills = minetest.get_perlin_map(np_hills, chulens):get2dMap_flat(minposxz)
	local nvals_lake_chance = minetest.get_perlin_map(np_lake_chance, chulens):get2dMap_flat(minposxz)
-- 	local nvals_lake_floor = minetest.get_perlin_map(np_lake_floor, chulens):get2dMap_flat(minposxz)
	
	local nvals_heat = minetest.get_perlin_map(np_heat, chulens):get2dMap_flat(minposxz)
	local nvals_humidity = minetest.get_perlin_map(np_humidity, chulens):get2dMap_flat(minposxz)
	local nvals_magic = minetest.get_perlin_map(np_magic, chulens):get2dMap_flat(minposxz)
	
	local nvals_mountains = minetest.get_perlin_map(np_mtns3, chulens):get2dMap_flat(minposxz)
	local nvals_vulcanism = minetest.get_perlin_map(np_mtns2, chulens):get2dMap_flat(minposxz)
-- 	local nvals_squiggle = minetest.get_perlin_map(np_sq1, chulens):get3dMap_flat(minposxyz)
-- 	local nvals_squiggle2 = minetest.get_perlin_map(np_sq2, chulens):get3dMap_flat(minposxyz)
	

	local thickness_abundant = .0025*scaler
	local thickness_normal = .0020*scaler
	local thickness_scarce = .0016*scaler
	local thickness_rare = .0011*scaler
	
	local lx = x1 - x0 + 1
	
	-- skip some expensive calculations otherwise
	local chunk_has_surface = false
	local chunk_has_underground = false

	-- first calculate the general ground height
	for x = x0, x1 do 
		for z = z0, z1 do 
			
			local xx = lx - (x1 - x) - 1
			local zz = lx - (z1 - z) - 1
			
			local nixz = zz * lx + xx + 1
			
			local continents = nvals_continents[nixz]
			local hills = nvals_hills[nixz]
			local ht = math.abs(nvals_mountains[nixz])
			local vu = nvals_vulcanism[nixz]
-- 				local dn = nvals_squiggle[nixyz]
-- 			local dn2 = nvals_squiggle2[nixyz]
		
			local o = continents
		
			if continents < -2 then
				o = -math.pow(math.abs(continents), 1.8)
			end
			
			if continents > 2 then
				local m = continents - 2
				local p = m / 4
				local q = hills / 8
				local n = math.pow(clamp(0, m, 6) / 7, 2)
				o = 2 + m  --[[+ n*ht*q]] + hills * p
				
				local r = clamp(0, hills - 5, 6) / 5 -- blend with hills
				local s = 1 / (1 + math.exp(-p)) -- when to get mountainous
				
				o = o + s * ht * r
				
				-- TODO: improve
				chunk_flatness_lookup[nixz] = s
			end
			
			
			
			-- this rounding is VERY important
			-- you get all sorts of random noise errors from
			--   calculations done later if it is omitted
-- 			print("y0: "..y0.."o: "..o.." y1: "..y1)
			
			
			-- lakes
			local lake_chance = nvals_lake_chance[nixz]
			if o > 2 then
-- 				local lake_floor = math.abs(nvals_lake_floor[nixz])
				if lake_chance > 0 then
					lake_surface[nixz] = round(o)
					local k = lake_chance
					o = o - k * 4 --(k * lake_floor)
				end
			end
			
			-- rivers
			if o > -4 then
				local delta = 1
				if o < 0 then
					delta = 1 - (-o / 4)
				end
				
				local rivers1 = math.abs(nvals_river1[nixz])
				local rivers2 = math.abs(nvals_river2[nixz])
				local river = math.abs(rivers1 - rivers2) 
				if  river * math.max(1, (o / 10)) < 0.03 then
					river_surface[nixz] = round(o)
					o = o - clamp(0, 5 - (river * 60), 5) * delta
					
				end
			end
			
			o = round(o)

			-- ground_surface is the highest non-air node of the terrain
			-- g_s+1 is the first air node above the ground
			ground_surface[nixz] = o
			
			if y0 <= o and o - default.deepest_fill <= y1 then
				chunk_has_surface = true
			end
			if o >= y1 then
				chunk_has_underground = true
			end
			
			-- fill in water and stone debugging placeholders
			for y = y0, y1 do
				local ls = lake_surface[nixz] or -33000
				local rs = river_surface[nixz] or -33000
				local ws = math.max(ls, rs)
				if y < o then
					data[area:index(x, y, z)] = c_stone
				else 
					if y > 0 then
						if ws > y then
							if ls > rs then
								data[area:index(x, y, z)] = c_l_water
							else
								data[area:index(x, y, z)] = c_r_water
							end
						else
							data[area:index(x, y, z)] = c_air
						end
					else
						if ws > y then
							if ls > rs then
								data[area:index(x, y, z)] = c_l_water
							else
								data[area:index(x, y, z)] = c_r_water
							end
						else
							data[area:index(x, y, z)] = c_s_water
						end
					end
				end
			end
			
			
		end
	end
	
-- 	chunk_has_surface = false
	-- surface biome calculation and filling
	if chunk_has_surface then
		local nvals_fill_depth = minetest.get_perlin_map(np_fill_depth, chulens):get2dMap_flat(minposxz)
		
		for x = x0, x1 do 
			for z = z0, z1 do
				local xx = lx - (x1 - x) - 1
				local zz = lx - (z1 - z) - 1
				
				local nixz = zz * lx + xx + 1
				
				local surf = ground_surface[nixz]
				
				local river_surf = river_surface[nixz] or -33000
				local lake_surf = lake_surface[nixz] or -33000
				local ws = math.max(river_surf, lake_surf)
				
				-- don't place normal biome stuff under rivers and lakes
				-- bugged
				if ws < surf then
					
					local heat = calc_heat(surf, z, nvals_heat[nixz])
					local humidity = nvals_humidity[nixz]
					local magic = nvals_magic[nixz]
					local flatness = chunk_flatness_lookup[nixz] or 0
					
					local bio = default.select_biome(x,surf,z, heat, humidity, magic, flatness)
					
					surface_biome[nixz] = bio 
					if not biome_cache[bio.name] then
						biome_cache[bio.name] = {
							def = bio,
	-- 						node_count = 1,
						}
	-- 				else
	-- 					biome_cache[bio.name].node_count = biome_cache[bio.name].node_count + 1
					end
					
					local drand = nclamp(nvals_fill_depth[nixz])
					
					local d = surf -- current depth
					
					if d - default.deepest_fill <= y1 then
						for _,fill in ipairs(bio.cids.fill) do
							local depth = fill.min + round(drand * (fill.max - fill.min))
							
							if d < y0 then break end
							
							local ed = d - depth
							if ed <= y1 then -- we have nodes to place
								
								-- process chances and place nodes
								for y = math.min(d, y1), ed, -1 do
									local ncid = fill.nodes[math.random(#fill.nodes)]
									
									for _,v in pairs(fill.chance_fill) do
										if 1 == math.random(v.chance) then
											ncid = v.cid
											break
										end
									end
								
									data[area:index(x, y, z)] = ncid
								end
								
							end -- if ed >= y0
							
							d = ed
							
						end -- for bio.fills
					end -- if surf-deepest <= y1
					
					
					-- the highest node below the cover and fill
					rock_surface[nixz] = d
					if rock_surface[nixz] >= y0 then
						chunk_has_underground = true
					end
					
					-- place decorations
					for dname,deco in pairs(bio.surface_decos) do
						local y_feather = math.random(deco.y_rand) - (deco.y_rand / 2)
						local min_y = deco.y_min + y_feather
						local max_y = deco.y_max + y_feather
						
						local lat_feather = math.random(deco.lat_rand) - (deco.lat_rand / 2)
						local min_lat = deco.lat_min + lat_feather
						local max_lat = deco.lat_max + lat_feather
						local lat_z = z
						
						if deco.lat_abs then
							min_lat = math.abs(min_lat)
							max_lat = math.abs(max_lat)
							lat_z = math.abs(lat_z)
						end
						
						if (min_y <= surf and surf <= max_y) and (min_lat <= lat_z and lat_z <= max_lat) then
							local py = surf + 1 + deco.y_offset
							
							if y0 <= py and py <= y1 then
								
								-- even filling inside a noise-defined 2d blob
								if deco.type == "blob" then
									if deco.noise then
										-- initialize and cache the noise values 
										if not noise_cache[deco.name] then
			-- 								print(minposxz.x .. " " ..minposxz.y)
											noise_cache[deco.name] = minetest.get_perlin_map(deco.noise, chulens):get2dMap_flat(minposxz)
										end
										
										-- sample and place nodes
										local n = nclamp(noise_cache[deco.name][nixz])
			-- 							print(n)
										if n <= deco.noise.threshold then
											if 1 == math.random(deco.chance) then
												data[area:index(x, py, z)] = deco.cids.place[math.random(#deco.cids.place)]
												break -- no more decorations in this column
											end
										end
										
									elseif deco.chance then
										if 1 == math.random(deco.chance) then
											data[area:index(x, py, z)] = deco.cids.place[math.random(#deco.cids.place)]
										end
										break -- no more decorations in this column
									end
									
								elseif deco.type == "density" then
									-- deco.noise is required in "density" types
									if not noise_cache[deco.name] then
										noise_cache[deco.name] = minetest.get_perlin_map(deco.noise, chulens):get2dMap_flat(minposxz)
									end
									
									-- sample and place nodes
									local n = noise_cache[deco.name][nixz]
		-- 							
									--if deco.name == "malachite_stones" then
-- 										print(n)
									--end
									
									if n > 0 then
										local q = math.max(1, math.min(deco.noise.cap, n))
										
										local r = math.random(math.abs(math.ceil(deco.noise.cap - q)))
										
										if 1 == r then
											if not deco.chance or 1 == math.random(deco.chance) then
												data[area:index(x, py, z)] = deco.cids.place[math.random(#deco.cids.place)]
												break -- no more decorations in this column
											end
										end
									else
-- 										print(n)
									end
								
								end
							end
						end
					end
				
				else -- if ws < ground
					
					if y0 <= surf and surf <= y1 then
						data[area:index(x, surf, z)] = c_wetsand
					end
					
					rock_surface[nixz] = surf - 1
					if rock_surface[nixz] >= y0 then
						chunk_has_underground = true
					end
				
				end -- if ws < ground
				
			end
		end
		
	end
	
	
	
	local stone_noise_cache = {}
	local ore_noise_cache = {}
	
-- 	chunk_has_underground = false
	
	-- underground stone biomes
	if chunk_has_underground then
		for x = x0, x1 do 
			local xx = lx - (x1 - x) - 1
			for z = z0, z1 do
				local zz = lx - (z1 - z) - 1
				local nixz = zz * lx + xx + 1
				
				local rs = rock_surface[nixz]
				if not rs then
					rs = y1
				end
				
				rs = math.min(y1, rs)
				
				if rs and rs >= y0 then
					
					for y = rs, y0, -1 do
						
						-- stone biome selection
						local heat = calc_heat(y, z, nvals_heat[nixz])
						local humidity = nvals_humidity[nixz]
						local magic = nvals_magic[nixz]
						local vulcanism = nvals_vulcanism[nixz]
						local flatness = chunk_flatness_lookup[nixz] or 0
				
						local sbio = default.select_stone_biome(x,y,z, heat, humidity, magic, flatness, vulcanism)
						
						local yy = lx - (y1 - y) - 1
						local nixyz = zz * lx * lx + yy * lx + xx + 1
						
						-- determine base stone
						local base_stone = nil
						
						if sbio.solid then
							base_stone = sbio.solid
							
						elseif sbio.noise then
							if not stone_noise_cache[sbio.name] then
								stone_noise_cache[sbio.name] = minetest.get_perlin_map(sbio.noise, chulens):get3dMap_flat(minposxyz)
							end
							
							base_stone = sbio.layers[#sbio.layers][2]
							
							local n = math.abs(stone_noise_cache[sbio.name][nixyz])
							
							for _,sp in pairs(sbio.layers) do
								if n < sp[1] then
									base_stone = sp[2]
									break
								end
							end
						end
					
						
						-- check for ore
						for oname,ore in pairs(sbio.ores) do
							
							-- check if there is an ore node for the base stone
							local choices = ore.place_in[base_stone]
							if not choices then
								choices = ore.place_in["*"]
							end
							
							if choices then
								-- TODO: optimize early bail on y
								local lat_z = z
								
								if ore.lat_abs then
									lat_z = math.abs(lat_z)
								end
								
								if (ore.y_min <= y and y <= ore.y_max) and (ore.lat_min <= lat_z and lat_z <= ore.lat_max) then
									
									-- winding veins of ore made from the intersection
									--   of two 3d noise sets
									if ore.type == "vein" then
-- 										
										-- initialize and cache the noise values 
										if not ore_noise_cache[ore.name] then
											ore_noise_cache[ore.name] = {
												minetest.get_perlin_map(ore.noise_1, chulens):get3dMap_flat(minposxyz),
												minetest.get_perlin_map(ore.noise_2, chulens):get3dMap_flat(minposxyz),
											}
										end
										
										-- sample and place nodes
										local n1 = math.abs(ore_noise_cache[ore.name][1][nixyz])
										local n2 = math.abs(ore_noise_cache[ore.name][2][nixyz])
										
										if n1 <= ore.threshold and n2 <= ore.threshold then
											base_stone = choices[math.random(#choices)]
										end
										
									-- huge noise-generated ore blobs
									elseif ore.type == "blob" then
										if not ore_noise_cache[ore.name] then
											ore_noise_cache[ore.name] = minetest.get_perlin_map(ore.noise, chulens):get3dMap_flat(minposxyz)
										end
										
										-- sample and place nodes
										local n = math.abs(ore_noise_cache[ore.name][nixyz])
										
										if n >= ore.threshold then
											base_stone = choices[math.random(#choices)]
										end
										
									elseif ore.type == "random" then
										if 0 == math.random(ore.chance) then
											base_stone = choices[math.random(#choices)]
										end
									end
									
								end -- if y/lat
								
							end -- if choices
						end -- for sbio.ores
						
						
						-- filling in the chosen stone node
						if base_stone then
							data[area:index(x, y, z)] = minetest.get_content_id(base_stone)
						end
						
					end -- y loop
				end -- if rs
				
			
				
			end -- z loop
		end -- x loop
	end -- if chunk_has_underground
	
	
--[[
	--- caves
	for x = x0, x1 do 
		for z = z0, z1 do 
			for y = y0, y1 do 
				
				local xx = lx - (x1 - x) - 1
				local yy = lx - (y1 - y) - 1
				local zz = lx - (z1 - z) - 1
				
				local nixz = zz * lx + xx + 1
				local nixyz = zz * lx * lx + yy * lx + xx + 1
				local cave_density = math.abs(nvals_caves[nixyz])
				local cave_density2 = math.abs(nvals_caves2[nixyz])
				local cave_size = 0.007 + math.abs(nvals_cave_size[nixyz])

				if cave_density < cave_size and cave_density2 < cave_size then
					data[area:index(x, y, z)] = c_air
				end
			end
		end
	end
	]]
	
	--[[ slices cut into the terrain for debugging
	for x = x0, x1 do 
		for z = z0, z1 do 
			for y = y1, y0, -1 do 
		
				if x < x0 + 3 or z < z0 + 3 or y < y0 + 3 then 
					data[area:index(x, y, z)] = c_air
				end
			end
			
		end
	end
	--]]
	
	
	vm:set_data(data)
	vm:set_lighting({day=0, night=0})
	vm:calc_lighting()
	vm:write_to_map(data)
end)





--[[ --  volcano code, pre-optimization 

if y < o then
	
	local ht2 = o + dn2 * 0.1
	if vu > -1000 and ht2 > 100 + hills then -- volcanos
		
		if y <= 97 + hills and (ht2 > 106 + hills or y > (100 + hills - (math.pow((ht2 - 106 + hills) / 15, 12) / 30))) then
			data[vi] = c_lava
			--data[vi] = c_air
			biome_immune[nixz] = 1
			
		elseif y > (100 + hills - ((ht2 - 100 - hills) / 2.5)) then
			
			data[vi] = c_air
		else
			if data[bi] ~= c_air then
				
				data[vi] = c_basalt
				biome_immune[nixz] = 1
			else 
				data[vi] = c_air
			end
		end
	else
		if data[bi] ~= c_air then
			data[vi] = c_granite
		else 
			data[vi] = c_air
		end
	end
end
]]
