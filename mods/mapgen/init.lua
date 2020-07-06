

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

local vc = 64
local vc2 = 64


local np_caves = {
	offset = 0,
	scale = 1,
	spread = {x=64, y=64, z=64}, --squash the layers a bit
	seed = 54333,
	octaves = 3,
	persist = 0.67
}
local np_caves2 = {
	offset = 0,
	scale = 1,
	spread = {x=64, y=64, z=64}, --squash the layers a bit
	seed = 453467,
	octaves = 5,
	persist = 0.67
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
	scale = 10,
	spread = {x=1500, y=1500, z=1500},
	seed = 7843,
	octaves = 4,
	persist = 0.65
}
local np_river2 = {
	offset = 0,
	scale = 10,
	spread = {x=1700, y=1700, z=1700},
	seed = 45346,
	octaves = 4,
	persist = 0.65
}

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
	offset = -2,
	scale = 20,
	spread = {x=350, y=350, z=350},
	seed = 67824,
	octaves = 3,
	persist = 0.2
}

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

-- minetest.register_on_respawnplayer(function(player)
--     player:setpos({x=571, y=50, z=70})
--     return true
-- end)

local scaler = 4


minetest.register_on_generated(function(minp, maxp, seed)
--      if maxp.y > 0 then
--          return
--      end


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
	local c_s_water = minetest.get_content_id("default:water_source")
	local c_r_water = minetest.get_content_id("default:river_water_source")
	local c_g_water = minetest.get_content_id("default:glacial_water_source")
	
	-- igneous
	local c_granite = minetest.get_content_id("default:granite")
	local c_basalt = minetest.get_content_id("default:basalt")
	local c_obsidian = minetest.get_content_id("default:obsidian")
	local c_pumice = minetest.get_content_id("default:pumice")
	
	-- sedimentary
	local c_limestone = minetest.get_content_id("default:limestone")
	local c_sandstone = minetest.get_content_id("default:sandstone")
	local c_laterite = minetest.get_content_id("default:laterite")
	local c_gypsum = minetest.get_content_id("default:gypsum")
	local c_halite = minetest.get_content_id("default:halite")
	local c_shale = minetest.get_content_id("default:shale")
	local c_conglomerate = minetest.get_content_id("default:conglomerate")
	local c_chalk = minetest.get_content_id("default:chalk")
	local c_breccia = minetest.get_content_id("default:breccia")
	local c_mudstone = minetest.get_content_id("default:mudstone")
	
	-- metamorphic
	local c_marble = minetest.get_content_id("default:marble")
	local c_gneiss = minetest.get_content_id("default:gneiss")
	local c_slate = minetest.get_content_id("default:slate")
	local c_schist = minetest.get_content_id("default:schist")
	local c_serpentine = minetest.get_content_id("default:serpentine")
	
-- 	local c_wood = minetest.get_content_id("default:wood")
-- 	local c_glass = minetest.get_content_id("default:glass")
-- 	local c_dirt = minetest.get_content_id("default:dirt")

	-- ores
	--[[
	local c_mese = minetest.get_content_id("default:stone_with_mese")
	local c_iron = minetest.get_content_id("default:stone_with_iron")
	local c_coal = minetest.get_content_id("default:stone_with_coal")
	local c_coalblock = minetest.get_content_id("default:coalblock")
	local c_copper = minetest.get_content_id("default:stone_with_copper")
	local c_diamond = minetest.get_content_id("default:stone_with_diamond")
	local c_gold = minetest.get_content_id("default:stone_with_gold")
	local c_uranium = minetest.get_content_id("technic:mineral_uranium")
	local c_chromium = minetest.get_content_id("technic:mineral_chromium")
	local c_zinc = minetest.get_content_id("technic:mineral_zinc")
	local c_silver = minetest.get_content_id("moreores:mineral_silver")
	local c_tin = minetest.get_content_id("moreores:mineral_tin")
	local c_mithril = minetest.get_content_id("moreores:mineral_mithril")
	]]

	local sidelen = x1 - x0 + 1
	local chulens = {x=sidelen, y=sidelen, z=sidelen}
	local minposxyz = {x=x0, y=y0, z=z0}
	local minposxz = {x=x0, y=z0}

--    local nvals_caves = minetest.get_perlin_map(np_caves, chulens):get3dMap_flat(minposxyz)
--    local nvals_caves2 = minetest.get_perlin_map(np_caves2, chulens):get3dMap_flat(minposxyz)
-- 	local nvals_terrain_s = minetest.get_perlin_map(np_stone, chulens):get3dMap_flat(minposxyz)
-- 	local nvals_terrain1 = minetest.get_perlin_map(np_terrain1, chulens):get3dMap_flat(minposxyz)
-- 	local nvals_terrain2 = minetest.get_perlin_map(np_terrain2, chulens):get3dMap_flat(minposxyz)
-- 	local nvals_terrain3 = minetest.get_perlin_map(np_terrain3, chulens):get3dMap_flat(minposxyz)
-- 	local nvals_terrain4 = minetest.get_perlin_map(np_terrain4, chulens):get3dMap_flat(minposxyz)
-- 	local nvals_terrain5 = minetest.get_perlin_map(np_terrain5, chulens):get3dMap_flat(minposxyz)
	--[[
	local nvals_river1 = minetest.get_perlin_map(np_river1, chulens):get2dMap_flat(minposxz)
	local nvals_river2 = minetest.get_perlin_map(np_river2, chulens):get2dMap_flat(minposxz)
	local nvals_plains = minetest.get_perlin_map(np_plains1, chulens):get2dMap_flat(minposxz)
	local nvals_plains2 = minetest.get_perlin_map(np_plains2, chulens):get2dMap_flat(minposxz)
	]]
	local nvals_continents = minetest.get_perlin_map(np_continents, chulens):get2dMap_flat(minposxz)
	local nvals_hills = minetest.get_perlin_map(np_hills, chulens):get2dMap_flat(minposxz)
	
	local nvals_mountains = minetest.get_perlin_map(np_mtns3, chulens):get2dMap_flat(minposxz)
	local nvals_vulcanism = minetest.get_perlin_map(np_mtns2, chulens):get2dMap_flat(minposxz)
	local nvals_squiggle = minetest.get_perlin_map(np_sq1, chulens):get3dMap_flat(minposxyz)
	local nvals_squiggle2 = minetest.get_perlin_map(np_sq2, chulens):get3dMap_flat(minposxyz)
	--[[
	.008 # holy fuck way too much
	.005 # thick consistent vein a few nodes in diameter
	.003 # continuous one node thick vein, occasinoally skips a node or becomes 2 thick
	.0015 # ores are spaced several nodes apart. easy to lose but easy to find again.

	]]
	local thickness_abundant = .0025*scaler
	local thickness_normal = .0020*scaler
	local thickness_scarce = .0016*scaler
	local thickness_rare = .0011*scaler
	
	local lx = x1 - x0 + 1

	local nixyz = 1 -- 3D noise index
	local nixz = 1 -- 3D noise index
	for x = x0, x1 do -- for each node do
		for z = z0, z1 do -- for each xy plane progressing northwards
			for y = y0, y1 do -- for each x row progressing upwards
				local vi = area:index(x, y, z)
				local bi = area:index(x, y-1, z)
				
				local xx = lx - (x1 - x) - 1
				local yy = lx - (y1 - y) - 1
				local zz = lx - (z1 - z) - 1
				
				local nixz = zz * lx + xx + 1
				local nixyz = zz * lx * lx + yy * lx + xx + 1
				
				--print("nixz: "..nixz..", lz: ".. lz..", zz: "..zz..", lx: "..lx..", xx: "..xx)
				
-- 				local ht = math.abs(nvals_mountains[nixz])
				--local plains1 = nvals_plains[nixz]
				--local plains2 = nvals_plains2[nixz]
				local continents = nvals_continents[nixz]
				local hills = nvals_hills[nixz]
				local ht = math.abs(nvals_mountains[nixz])
				--local vu = nvals_vulcanism[nixz]
				--local dn = nvals_squiggle[nixyz]
				--local dn2 = nvals_squiggle2[nixyz]
				
				--local r_tmp1 = nvals_river1[nixz]
				--local r_tmp2 = nvals_river2[nixz]
				--local rv = math.abs(r_tmp1 - r_tmp2)
				
				-- 				print(dn)
--				print(dump(ht))
				--local q = plains2 / plains1
				--local r = q * plains1 + (1-q) * ht * math.abs(plains2 / plains1)
				--[[
				if y < r then
					if q > 0.5 then
						data[vi] = c_pumice
					else
						data[vi] = c_granite
					end
				elseif y <= 0 then
					data[vi] = c_water
				end
				]]
				--[[
				if y < hills then
					data[vi] = c_granite
				end
				]]
				
				if y < continents then
					
					data[vi] = c_pumice
				elseif y <= 0 then
					data[vi] = c_s_water
				end
				
				if continents > 2 then
					local m = continents - 2
					local p = m / 4
					local q = hills / 8
					local n = math.pow(clamp(0, m, 6) / 7, 2)
					local o = 2 + m  --[[+ n*ht*q]] + hills * p
					
					local r = clamp(0, hills - 5, 6) / 5
					local s = 1 / (1 + math.exp(-p)) 
					
					o = o + s * ht * r
					
					if y < o then
						data[vi] = c_pumice
					end
				end
				
				
				--[[
				if y < 2 and rv < .28 then -- rivers
					 local a = .1
					 local b = 1 - math.exp(-math.pow(rv / a, 2))
-- 					 print(b)
					 if y > b * 3 then
						data[vi] = c_basalt
					 end
				end
				]]
				--[[
				if y > ht then -- where land meets sky
					 data[vi] = c_air
				else
					local ht2 = ht + dn2 * 0.1
					if vu > -1000 and ht2 > 100 then -- volcanos
						
						if y <= 95 and (ht2 > 106 or y > (100 - (math.pow((ht2 - 106) / 15, 12) / 30))) then
							data[vi] = c_lava
--							data[vi] = c_air
							
						elseif y > (100 - ((ht2 - 100) / 2.5)) then
							
							data[vi] = c_air
						else
							if data[bi] ~= c_air then
								
								data[vi] = c_basalt
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
--                 -- cave stuff
--                local cave_density = math.abs(nvals_caves[nixyz])
--                local cave_density2 = math.abs(nvals_caves2[nixyz])
--                local cave_density = nvals_caves[nixyz]
--                --local cave_density2 = nvals_caves2[nixyz]
--
--                 if data[vi] == c_air
--                     and cave_density > .7
--                     and cave_density2 > .7
--                     then
--                     data[vi] = c_schist
--                 end


--[[

				if data[vi] == c_air and y < 0 then
					if math.random() < 0.1 and (data[vi+1] ~= c_air or data[vi-1] ~= c_air)  then
						data[vi] = c_shroom
					end
				end



				if data[vi] == c_stone then
					local density_s = nvals_terrain_s[nixyz]
					local density1_f = nvals_terrain1[nixyz]
					local density1 = math.abs(nvals_terrain1[nixyz])
					local density2 = math.abs(nvals_terrain2[nixyz])
					local density3 = math.abs(nvals_terrain3[nixyz])
					local density4 = math.abs(nvals_terrain4[nixyz])
					local density5 = math.abs(nvals_terrain5[nixyz])

					-- ore veins first
					if     density1 < thickness_normal and density2 < thickness_normal then
						data[vi] = c_mese
					elseif density1 < thickness_abundant and density3 < thickness_abundant then
						data[vi] = c_iron
					elseif density1 < thickness_normal and density4 < thickness_normal then
						data[vi] = c_copper
					elseif density1 < thickness_rare and density5 < thickness_rare then
						data[vi] = c_mithril
					elseif density2 < thickness_rare and density3 < thickness_rare then
						data[vi] = c_diamond
					elseif density2 < thickness_scarce and density4 < thickness_scarce then
						data[vi] = c_silver
					elseif density2 < thickness_normal and density5 < thickness_normal then
						data[vi] = c_tin
					elseif density3 < thickness_scarce and density4 < thickness_scarce then
						data[vi] = c_gold
					elseif density3 < thickness_normal and density5 < thickness_normal then
						data[vi] = c_chromium
					elseif density4 < thickness_normal and density5 < thickness_normal then
						data[vi] = c_zinc
				
--                     end
--                 end
--                 if data[vi] == c_stone then
--                     if false then
					-- then ore pockets
					elseif density1_f > 1.4 then
						data[vi] = c_uranium


					-- normal rocks
					elseif density_s > 1.25 then
						data[vi] = c_jade
					elseif density_s > 1.10 then
						data[vi] = c_serpentine
					elseif density_s > 1.00 then
						data[vi] = c_shale
					elseif density_s > 0.90 then
						data[vi] = c_granite
					elseif density_s > 0.80 then
						data[vi] = c_basalt
					elseif density_s > 0.708 then
						data[vi] = c_slate
					elseif density_s > 0.70 then
						data[vi] = c_anthracite
					elseif density_s > 0.60 then
						data[vi] = c_marble
					elseif density_s > 0.50 then
						data[vi] = c_gneiss
					elseif density_s > 0.40 then
						data[vi] = c_desstone
					elseif density_s > 0.30 then
						data[vi] = c_sandstone
					elseif density_s > 0.202 then
						data[vi] = c_schist

					elseif density_s > 0.20 then
						data[vi] = c_gravel
					elseif density_s > 0.19 then
						data[vi] = c_coalblock
					elseif density_s > 0.188 then
						data[vi] = c_gravel

					elseif density_s > 0.10 then
						data[vi] = c_chalk
					elseif density_s > 0.00 then
						data[vi] = c_clay
					elseif density_s > -0.10 then
						data[vi] = c_ors
					else
						data[vi] = c_stone

					end


				end
]]


				nixyz = nixyz + 1 -- increment 3D noise index
			end
			
-- 			nixz = nixz + 1 -- increment 3D noise index
		end
	end




	vm:set_data(data)
	vm:set_lighting({day=0, night=0})
	vm:calc_lighting()
	vm:write_to_map(data)
end)


