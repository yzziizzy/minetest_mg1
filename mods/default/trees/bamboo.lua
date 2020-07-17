-- yes, it's a grass, but whatever


local function regbox(sz, pos)
	local q = sz / 2
	return {pos[1]-q, -0.5, pos[2]-q, pos[1]+q, 1.5, pos[2]+q}
end

local function tallbox(sz, pos)
	local q = sz / 2
	return {pos[1]-q, -0.5, pos[2]-q, pos[1]+q, 1.5, pos[2]+q}
end

local function shootbox1(sz, pos)
	local q = sz / 2
	return {pos[1]-q, -0.5, pos[2]-q, pos[1]+q, -0.4, pos[2]+q}
end
local function shootbox2(sz, pos)
	local q = sz / 4
	return {pos[1]-q, -0.4, pos[2]-q, pos[1]+q, -0.35, pos[2]+q}
end




function default.register_bamboo(def)
	
	for szi,sz in ipairs(def.culm_sizes) do
		for cci,cloc in ipairs(def.culm_locations) do
			
			local reg_culms = {}
			local tall_culms = {}
			local shoot_culms = {}
			for i = 1,cci do
				table.insert(reg_culms, regbox(sz, def.culm_locations[i]))
				table.insert(tall_culms, tallbox(sz, def.culm_locations[i]))
				table.insert(shoot_culms, shootbox1(sz, def.culm_locations[i]))
				table.insert(shoot_culms, shootbox2(sz, def.culm_locations[i]))
			end
			
			minetest.register_node("default:"..def.name.."_"..szi.."_"..cci, {
				description = def.Name,
				tiles = {"default_bamboo.png"},
				paramtype = "light",
				paramtype2 = "facedir",
				drawtype = "nodebox",
				
				node_box = {
					type = "fixed",
					fixed = reg_culms,
				},
				groups = {choppy = 1, bamboo = 1},
				sounds = default.node_sound_wood_defaults(),
			})

			minetest.register_node("default:"..def.name.."_tall_"..szi.."_"..cci, {
				description = def.Name,
				tiles = {"default_bamboo.png"},
				paramtype = "light",
				paramtype2 = "facedir",
				drawtype = "nodebox",
				
				node_box = {
					type = "fixed",
					fixed = tall_culms,
				},
				groups = {choppy = 1, bamboo = 2,},
				sounds = default.node_sound_wood_defaults(),
			})
			
			minetest.register_node("default:"..def.name.."_shoots_"..szi.."_"..cci, {
				description = def.Name.." Shoots",
				tiles = {"default_pine_wood.png"},
				paramtype = "light",
				paramtype2 = "facedir",
				drawtype = "nodebox",
				
				node_box = {
					type = "fixed",
					fixed = shoot_culms,
				},
				groups = {choppy = 1, bamboo = 2,},
				sounds = default.node_sound_wood_defaults(),
			})
			
			
			minetest.register_node("default:"..name.."_rhisome_"..szi.."_"..cci, {
				description = def.Name.." Rhisome"),
				tiles = {
					"default_coniferous_litter.png",
					"default_dirt.png",
					{name = "default_dirt.png^default_coniferous_litter_side.png", tileable_vertical = false}
				},
				
				groups = {choppy = 1, soil = 1, bamboo_rhisome = szi},
				sounds = default.node_sound_dirt_defaults({
					footstep = {name = "default_grass_footstep", gain = 0.4},
				}),
				
				on_timer = function(pos)
					grow_bamboo(pos, def, szi, cci)
				end,
			})
			
		end
	end


	minetest.register_node("default:"..def.name.."_top", {
		description = "Bamboo Top",
		drawtype = "plantlike",
		waving = 1,
		visual_scale = 3,
		tiles = {"default_bamboo_top.png"},
		inventory_image = "default_bamboo_top.png",
		wield_image = "default_bamboo_top.png",
		paramtype = "light",
			paramtype2 = "meshoptions",
		place_param2 = 4,
		sunlight_propagates = false,
		walkable = false,
		buildable_to = true,
		groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1},
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 0.5, 6 / 16},
		},
	})
end


local green_bamboo_def = {
	name = "green_bamboo",
	Name = "Green Bamboo",
	culm_locations = {
		{0.1, 0.2},
		{-0.15, 0.3},
		{0.2, -0.2},
		{-0.3, -0.1},
	},
	culm_sizes = {0.05, 0.1, 0.15},
}

default.register_bamboo(green_bamboo_def)


minetest.register_node("default:bamboo_seed", {
	description = "Bamboo Seed",
	tiles = {"default_bamboo.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	
	node_box = {
		type = "fixed",
		fixed = {
			tallbox(0.1, {0.1, 0.2}),
			tallbox(0.1, {-0.15, 0.3}),
			tallbox(0.1, {0.2, -0.2}),
			tallbox(0.1, {-0.3, -0.1}),
		}
	},
	groups = {choppy =1, bamboo_seed=1},
	sounds = default.node_sound_stone_defaults(),
})



for sz_ = 1,4 do
	local sz = sz_
	local q = sz / 16
	minetest.register_node("default:bamboo_rhisome_"..sz, {
		description = "Bamboo Rhisome",
		tiles = {"default_bamboo.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		
		node_box = {
			type = "connected",
			disconnected = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
	-- 		disconnected_left = {
	-- 			{-0.2, -0.5, -0.2, 0.0, 0.5, 0.0},
	-- 		},
			connect_right = {
				{-q, -q, -q, 0.5, q, q},
			},
			connect_left = {
				{-0.5, -q, -q, q, q, q},
			},
			connect_back = {
				{-q, -q, -q, q, q, 0.5},
			},
			connect_front = {
				{-q, -q, -0.5, q, q, 0.0},
			},
			connect_top = {
				{-q, -q, -q, q, 0.5, q},
			},
			connect_bottom = {
				{-q, -0.5, -q, q, q, q},
			},
		},
		collision_box = {
			type = "connected",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "connected",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
		},
		connects_to = {"group:bamboo_rhisome"},
		groups = {choppy =1, bamboo_rhisome =1},
		sounds = default.node_sound_stone_defaults(),
	})
end


local function find_surface_up(pos)
	local p = vector.new(pos)

	
end


minetest.register_abm({
	nodenames = {"default:bamboo_rhisome_1"},
	neighbors = {"group:bamboo_rhisome"},
	interval  = 3,
	chance = 4,
	catch_up = true,
	action = function(pos, node)
		local family = minetest.find_nodes_in_area(
			{x=pos.x - 1, y=pos.y - 1, z=pos.z - 1},
			{x=pos.x + 1, y=pos.y + 1, z=pos.z + 1},
			"group:bamboo_rhisome"
		)
		
		if #family > 2 then
			minetest.set_node(pos, {name="default:bamboo_rhisome_2"})
		end
	end
})


minetest.register_abm({
	nodenames = {"default:bamboo_rhisome_1"},
	interval  = 3,
	chance = 4,
	catch_up = true,
	action = function(pos, node)
		
		local function checkpos(p)
			local n = minetest.get_node(p)
			if minetest.get_item_group(n.name, "soil") > 0 then
				minetest.set_node(p, {name="default:bamboo_rhisome_1"})
				
				return true
			end
			
			return false
		end
		
		
		local positions = {
			{x=1, y=0, z=0},
			{x=-1, y=0, z=0},
			{x=0, y=0, z=-1},
			{x=0, y=0, z=1},
		}
		
		checkpos(vector.add(pos, positions[math.random(#positions)])) 
		
	end
})




local function grow_bamboo(pos, def, sz, culms)
	
	minetest.set_node({x=pos.x, y=pos.y-1, z=pos.z}, {name="default:"..def.name.."_rhisome_"..sz.."_"..culms})
	
	local h = math.random(4,6)
	local h2 = math.random(1,2)
	
	for i = 1,h do
		minetest.set_node(pos, {name="default:"..def.name.."_"..sz.."_"..culms})
		pos.y = pos.y + 1
	end
	
	for i = 1,h2 do
		minetest.set_node(pos, {name="default:"..def.name.."_tall_"..sz.."_"..culms})
		pos.y = pos.y + 1
		minetest.set_node(pos, {name="default:"..def.name.."_top", param2 = 4})
		pos.y = pos.y + 1
	end
end
	




minetest.register_abm({
	nodenames = {"group:bamboo_seed"},
	interval  = 2,
	chance = 1,
	catch_up = true,
	action = function(pos, node)
		grow_bamboo(pos, green_bamboo_def, math.random(3), math.random(4))
	end
})
