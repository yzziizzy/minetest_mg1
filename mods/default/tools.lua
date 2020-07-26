
local S = default.get_translator


minetest.register_item(":", {
	type = "none",
	wield_image = "wieldhand.png",
	wield_scale = {x=1,y=1,z=2.5},
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			shoveled = {times={[2]=3.0, [3]=0.70}, uses=0, maxlevel=1},
			handed = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=0}
		},
		damage_groups = {fleshy=1},
	}
})


local metal_list = {
	copper = {
		Name = "Copper",
	},
	bronze = {
		Name = "Bronze",
	},
	brass = {
		Name = "Brass",
	},
	iron =  {
		Name = "Iron",
	},
	steel =  {
		Name = "Steel",
	},
}


for name,def in pairs(metal_list) do
	def.name = name
	
	
	-- maybe:
	--   splitting wedges
	--   splitting mauls
	--   hinge hardware
	
	------------------
	-- Ingots
	
	--    TODO
	
	
	
	------------------
	-- Chisel
	
	minetest.register_node("default:"..name.."_chisel", {
		description = def.Name.." Chisel",
		tiles = {"default_"..name.."_block.png"},
		inventory_image = "default_tool_"..name.."_chisel.png",
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.2, -0.5, -0.02, 0.2, -0.5+0.04, 0.02},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.3, -0.5, -0.3, 0.3, -0.4, 0.3},
		},
		sunlight_propagates = true,
		groups = {falling_node = 1, handed = 3},
	})
	
	
	------------------
	-- Hammer
	
	minetest.register_node("default:"..name.."_hammer_head", {
		description = def.Name.." Hammer Head",
		tiles = {"default_"..name.."_block.png"},
		inventory_image = "default_tool_"..name.."_hammer_head.png",
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.2, -0.5, -0.1, 0.2, -0.5+0.1, 0.1},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.3, -0.5, -0.3, 0.3, -0.3, 0.3},
		},
		sunlight_propagates = true,
		
		groups = {falling_node = 1, handed = 3},
	})
	
	
	minetest.register_tool("default:"..name.."_hammer", {
		description = S(def.Name.." Hammer"),
		inventory_image = "default_tool_"..name.."_hammer.png",
		tool_capabilities = {
			full_punch_interval = 1.2,
			max_drop_level=0,
			groupcaps={
				hammered={times={[2]=3.00, [3]=1.70}, uses=20, maxlevel=1},
			},
			damage_groups = {fleshy=3},
		},
		sound = {breaks = "default_tool_breaks"},
		groups = {hammer = 1},
	})


	minetest.register_craft({
		output = "default:"..name.."_hammer",
		recipe = {
			{"default:"..name.."_hammer_head"},
			{"group:stick"},
			{"group:stick"},
		}
	})
	
	
	------------------
	-- Axe
	
	minetest.register_node("default:"..name.."_axe_head", {
		description = def.Name.." Axe Head",
		tiles = {"default_"..name.."_block.png"},
		inventory_image = "default_tool_"..name.."_axe_head.png",
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.2, -0.5, -0.1, 0.2, -0.5+0.1, 0.1},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.3, -0.5, -0.3, 0.3, -0.3, 0.3},
		},
		sunlight_propagates = true,
		
		groups = {falling_node = 1, handed = 3},
	})
	
	
	minetest.register_tool("default:"..name.."_axe", {
		description = S(def.Name.." Axe"),
		inventory_image = "default_tool_"..name.."_axe.png",
		tool_capabilities = {
			full_punch_interval = 1.2,
			max_drop_level=0,
			groupcaps={
				axed={times={[2]=3.00, [3]=1.70}, uses=20, maxlevel=1},
			},
			damage_groups = {fleshy=3},
		},
		sound = {breaks = "default_tool_breaks"},
		groups = {axe = 1},
	})


	minetest.register_craft({
		output = "default:"..name.."_axe",
		recipe = {
			{"default:"..name.."_axe_head"},
			{"group:stick"},
			{"group:stick"},
		}
	})
	
	
	------------------
	-- Adz
	
	minetest.register_node("default:"..name.."_adz_head", {
		description = def.Name.." Adz Head",
		tiles = {"default_"..name.."_block.png"},
		inventory_image = "default_tool_"..name.."_adz_head.png",
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.2, -0.5, -0.1, 0.2, -0.5+0.1, 0.1},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.3, -0.5, -0.3, 0.3, -0.3, 0.3},
		},
		sunlight_propagates = true,
		
		groups = {falling_node = 1, handed = 3},
	})
	
	
	minetest.register_tool("default:"..name.."_adz", {
		description = S(def.Name.." Adz"),
		inventory_image = "default_tool_"..name.."_adz.png",
		tool_capabilities = {
			full_punch_interval = 1.2,
			max_drop_level=0,
			groupcaps={
				adzed={times={[2]=3.00, [3]=1.70}, uses=20, maxlevel=1},
			},
			damage_groups = {fleshy=3},
		},
		sound = {breaks = "default_tool_breaks"},
		groups = {adz = 1},
	})


	minetest.register_craft({
		output = "default:"..name.."_adz",
		recipe = {
			{"default:"..name.."_adz_head"},
			{"group:stick"},
			{"group:stick"},
		}
	})
	
	
	------------------
	-- Pick
	
	minetest.register_node("default:"..name.."_pick_head", {
		description = def.Name.." Pick Head",
		tiles = {"default_"..name.."_block.png"},
		inventory_image = "default_tool_"..name.."_pick_head.png",
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.2, -0.5, -0.1, 0.2, -0.5+0.1, 0.1},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.3, -0.5, -0.3, 0.3, -0.3, 0.3},
		},
		sunlight_propagates = true,
		
		groups = {falling_node = 1, handed = 3},
	})
	
	
	minetest.register_tool("default:"..name.."_pick", {
		description = S(def.Name.." Pick"),
		inventory_image = "default_tool_"..name.."_pick.png",
		tool_capabilities = {
			full_punch_interval = 1.2,
			max_drop_level=0,
			groupcaps={
				picked={times={[2]=3.00, [3]=1.70}, uses=20, maxlevel=1},
			},
			damage_groups = {fleshy=3},
		},
		sound = {breaks = "default_tool_breaks"},
		groups = {pick = 1},
	})


	minetest.register_craft({
		output = "default:"..name.."_pick",
		recipe = {
			{"default:"..name.."_pick_head"},
			{"group:stick"},
			{"group:stick"},
		}
	})
	
	
	------------------
	-- Shovel
	
	minetest.register_node("default:"..name.."_shovel_head", {
		description = def.Name.." Shovel Head",
		tiles = {"default_"..name.."_block.png"},
		inventory_image = "default_tool_"..name.."_shovel_head.png",
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.2, -0.5, -0.1, 0.2, -0.5+0.1, 0.1},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.3, -0.5, -0.3, 0.3, -0.3, 0.3},
		},
		sunlight_propagates = true,
		
		groups = {falling_node = 1, handed = 3},
	})
	
	
	minetest.register_tool("default:"..name.."_shovel", {
		description = S(def.Name.." Shovel"),
		inventory_image = "default_tool_"..name.."_shovel.png",
		tool_capabilities = {
			full_punch_interval = 1.2,
			max_drop_level=0,
			groupcaps={
				shoveled={times={[2]=3.00, [3]=1.70}, uses=20, maxlevel=1},
			},
			damage_groups = {fleshy=3},
		},
		sound = {breaks = "default_tool_breaks"},
		groups = {shovel = 1},
	})


	minetest.register_craft({
		output = "default:"..name.."_shovel",
		recipe = {
			{"default:"..name.."_shovel_head"},
			{"group:stick"},
			{"group:stick"},
		}
	})
	
	
	------------------
	-- Saw
	
	minetest.register_node("default:"..name.."_saw_blade", {
		description = def.Name.." Saw Blade",
		tiles = {"default_"..name.."_block.png"},
		inventory_image = "default_tool_"..name.."_saw_blade.png",
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.2, -0.5, -0.1, 0.2, -0.5+0.1, 0.1},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.3, -0.5, -0.3, 0.3, -0.3, 0.3},
		},
		sunlight_propagates = true,
		
		groups = {falling_node = 1, handed = 3},
	})
	
	
	minetest.register_tool("default:"..name.."_saw", {
		description = S(def.Name.." Saw"),
		inventory_image = "default_tool_"..name.."_saw.png",
		tool_capabilities = {
			full_punch_interval = 1.2,
			max_drop_level=0,
			groupcaps={
				sawed={times={[2]=3.00, [3]=1.70}, uses=20, maxlevel=1},
			},
			damage_groups = {fleshy=3},
		},
		sound = {breaks = "default_tool_breaks"},
		groups = {saw = 1},
	})


	minetest.register_craft({
		output = "default:"..name.."_saw",
		recipe = {
			{"group:stick", "group:stick",                  ""},
			{"group:stick", "default:"..name.."_saw_blade", "group:stick"},
		}
	})

end













minetest.register_tool("default:wood_hammer", {
	description = S("Wood Hammer"),
	inventory_image = "default_tool_wood_hammer.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			hammered={times={[2]=6.00, [3]=3.70}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {hammer = 1}
})


minetest.register_craft({
	output = "default:wood_hammer",
	recipe = {
		{"group:beam"},
		{"group:stick"},
		{"group:stick"},
	}
})





minetest.register_tool("default:stone_axe", {
	description = S("Stone Axe"),
	inventory_image = "default_tool_stone_axe.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			axed={times={[1]=3.00, [2]=2.00, [3]=.70}, uses=20, maxlevel=1},
			choppy={times={[1]=3.00, [2]=2.00, [3]=.70}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {axe = 1}
})


minetest.register_craft({
	output = "default:stone_axe",
	recipe = {
		{"group:stones", "group:stones", ""},
		{"group:stones", "group:stick",  ""},
		{"",             "group:stick",  ""},
	}
})



minetest.register_tool("default:stone_adz", {
	description = S("Stone Adz"),
	inventory_image = "default_tool_stone_adz.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			adzed={times={ [2]=2.80, [3]=1.70}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {adz = 1}
})


minetest.register_craft({
	output = "default:stone_adz",
	recipe = {
		{"group:stones", "group:stones", ""},
		{"",             "group:stick",  ""},
		{"",             "group:stick",  ""},
	}
})





minetest.register_tool("default:wood_shovel", {
	description = S("Wooden Shovel"),
	inventory_image = "default_tool_wood_shovel.png",
	wield_image = "default_tool_wood_shovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			shoveled = {times={[1]=3.00, [2]=1.60, [3]=0.60}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {shovel = 1, flammable = 2}
})


minetest.register_craft({
	output = "default:wood_shovel",
	recipe = {
		{"group:wood_plank",},
		{"group:stick",     },
		{"group:stick",     },
	}
})
