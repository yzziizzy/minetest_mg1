local ore_defs = {
-- 	{n="iron", d="Iron", native = 0, ore = 1, ngrades = 2, ogrades = 3},
-- 	{n="copper", d="Copper", native = 1, ore = 1, },
-- 	{n="tin", d="Tin", native = 1, ore = 1, },
-- 	{n="zinc", d="Zinc", native = 1, ore = 1, },
}


for _,def in ipairs(ore_defs) do
	if def.native then
		minetest.register_node("default:stone_with_"..def.n.."_cobble", {
			description = "Stone with native " .. def.d.. " cobble",
	-- 		tiles = {"default_"..def.n..".png"},
			tiles = {"default_cobble.png^default_"..def.n..".png"},
			groups = {cracky = 3, cobble = 1, native_ore = 1},
			ore_of = def.n,
			sounds = default.node_sound_stone_defaults(),
		})
		minetest.register_node("default:stone_with_"..def.n, {
			description = "Stone with native " .. def.d,
	-- 		tiles = {"default_"..def.n..".png"},
			tiles = {"default_stone.png^default_"..def.n..".png"},
			groups = {cracky = 3, stone = 1, native_ore = 1},
			ore_of = def.n,
			drop = "default:stone_with_"..def.n.."_cobble",
			sounds = default.node_sound_stone_defaults(),
		})
	end
	
	if def.ore then
		minetest.register_node("default:"..def.n.."_ore_cobble", {
			description = def.d .. " ore cobble",
	-- 		tiles = {"default_"..def.n..".png"},
			tiles = {"default_"..def.n.."_ore_cobble.png"},
			groups = {cracky = 3, cobble = 1, mixed_ore = 1},
			ore_of = def.n,
			sounds = default.node_sound_stone_defaults(),
		})
		minetest.register_node("default:"..def.n.."_ore", {
			description = def.d .. " ore",
	-- 		tiles = {"default_"..def.n..".png"},
			tiles = {"default_"..def.n.."_ore.png"},
			groups = {cracky = 3, stone = 1, mixed_ore = 1},
			ore_of = def.n,
			drop = "default:"..def.n.."_ore_cobble",
			sounds = default.node_sound_stone_defaults(),
		})
	end
end


default.register_ore({
	name = "native_copper_veins",
	type = "vein",
	
	y_min = -32000,
	y_max = 140,
	lat_min = 0,
	lat_max = 32000,
	lat_abs = true,
	
	noise_1 = {
		spread = {x=64, y=64, z=64},
		seed = 564356,
		octaves = 1,
		persist = 0.67
	},
	noise_2 = {
		spread = {x=64, y=64, z=64},
		seed = 346535,
		octaves = 1,
		persist = 0.67
	},
	threshold = 0.0025, -- should be tiny
	depth_scaler = 4, -- NYI
	
	place_in = {
-- 		["default:granite"] = {"default:native_copper_in_granite"},
-- 		["default:basalt"] = {"default:native_copper_in_basalt"},
		["*"] = {"default:dirt"}, -- is also available as a fallback
	},
	stone_biomes = "*",
	
})


default.register_ore({
	name = "magnetite_blobs",
	type = "blob",
	
	y_min = -32000,
	y_max = 140,
	lat_min = 0,
	lat_max = 32000,
	lat_abs = true,
	
	noise = {
		spread = {x=600, y=600, z=600},
		seed = 346535,
		octaves = 3,
		persist = 0.35,
	},
	threshold = 1.12, -- place if the noise is GREATER than this; larger value = smaller blob
	
	place_in = {
-- 		["default:limestone"] = {"default:magnetite"},
-- 		["default:sandstone"] = {"default:magnetite"},
		["*"] = {"default:mg_glass"},
	},
	stone_biomes = "*",

})

default.register_ore({
	name = "malachite_blobs", -- a copper ore
	type = "blob",
	
	y_min = -32000,
	y_max = 140,
	lat_min = 0,
	lat_max = 32000,
	lat_abs = true,
	
	noise = {
		spread = {x=400, y=400, z=400},
		seed = 67435,
		octaves = 3,
		persist = 0.35,
	},
	threshold = 1.12, -- place if the noise is GREATER than this; larger value = smaller blob
	
	place_in = {
		["default:limestone"] = {"default:limestone_with_malachite"},
	},
	stone_biomes = {"sedimentary_1"},

})

--[[ not implemented
default.register_surface_ore({
	name = "bog_iron",
	type = "random",
	
	y_min = -5,
	y_max = 30,
	lat_min = 0,
	lat_max = 32000,
	lat_abs = true,
	
	chance = 100,
	
	place_in = {
		["default:peat"] = {"default:peat_with_bog_iron"},
	},
	
	biomes = "peat_bog",
})
--]]

