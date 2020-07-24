campfire = {}


local MAX_FUEL = 6
local BURN_RATE = .001

function campfire.add_fuel(pos, amt)
	local meta = minetest.get_meta(pos)
	local fuel = meta:get_float("fuel") or 0
	if fuel + amt > MAX_FUEL then
		return false
	end
	
	local old_fuel = math.ceil(fuel)
	fuel = math.min(MAX_FUEL, fuel + amt)
	meta:set_float("fuel", fuel)
	
	local new_fuel = math.min(math.max(1, math.ceil(fuel)), 6)
	if old_fuel ~= new_fuel then
		minetest.swap_node(pos, {name = "campfire:coals_"..new_fuel})
	end
	
	return true
end







for sz_ = 1,4 do
	local sz = sz_
	
	minetest.register_node("campfire:flame_"..sz, {
		description = "Fire",
		drawtype = "plantlike",
		paramtype2 = "meshoptions",
		place_param2 = 4,
		tiles = {{
			name = "fire_basic_flame_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1
			}}
		},
		visual_scale = sz / 4,
		inventory_image = "fire_basic_flame.png",
		paramtype = "light",
		light_source = 2 + sz*3,
		groups = {igniter = 2, fire = sz},
		drop = "",
		walkable = false,
		damage_per_second = sz,
		floodable = true,
		pointable = false,
		--on_flood =
	})
end



minetest.register_node("campfire:kindling", {
	description = "Kindling Pile",
	tiles = {"default_wood.png"},
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-.35, -.5, -.3, .35, -.45, -.25},
			{-.35, -.5, .25, .35, -.45, .3},
			
			{-.3, -.5+.05, -.35, -.25, -.45+.05, .35},
			{.25, -.5+.05, -.35, .3,   -.45+.05, .35},
			
			{-.35, -.5+.1, -.3, .35, -.45+.1, -.25},
			{-.35, -.5+.1, .25, .35, -.45+.1, .3},
			
			{-.3, -.5+.15, -.35, -.25, -.45+.15, .35},
			{.25, -.5+.15, -.35, .3,   -.45+.15, .35},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-.4, -.5, -.4, .4, -.25, .4},
	},
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {
		choppy = 3, flammable = 3, oddly_breakable_by_hand = 1,
	},
	
	on_punch = function(pos, node, puncher, pointed_thing)
		if math.random(20) == 1 then
			minetest.set_node(pos, {name="campfire:flame_1", param2=4})
			pos.y=pos.y - 1
			minetest.set_node(pos, {name="campfire:coals_2"})
			local meta = minetest.get_meta(pos)
			meta:set_float("fuel", 2)
			minetest.get_node_timer(pos):start(2)
		end
	end,
	
	sounds = default.node_sound_wood_defaults(),
})



local function coals_on_timer(pos, elapsed)
	local fpos = {x=pos.x, y=pos.y+1, z=pos.z}
	local fnode = minetest.get_node(fpos)
	local fsz = minetest.get_item_group(fnode.name, "fire")
	
	if fsz == 0 then
		return false-- the fire is out
	end
	
	local meta = minetest.get_meta(pos)
	local fuel = meta:get_float("fuel") or 0
	
	if fuel == 0 then -- ran out of fuel
		minetest.swap_node(pos, {name="campfire:coals_1"})
		minetest.set_node(fpos, {name="air"})
		return false
	end
	
	-- flame size
	if fsz < 4 and fuel > MAX_FUEL * .6 then
		if 1 == math.random(2) then -- grow the flame
			minetest.set_node(fpos, {name="campfire:flame_"..(fsz+1), param2 = 4})
		end
	elseif fsz > 1 and fuel < MAX_FUEL * .2 then
		if 1 == math.random(2) then -- shrink the flame
			minetest.set_node(fpos, {name="campfire:flame_"..(fsz-1), param2 = 4})
		end
	end
	
	-- fuel burn
	local old_fuel = fuel
	fuel = math.max(0, fuel - (fsz * BURN_RATE))
	meta:set_float("fuel", fuel)
	
	fuel = math.min(math.max(1, math.ceil(fuel)), 6)
	if old_fuel ~= fuel then
		minetest.swap_node(pos, {name = "campfire:coals_"..fuel})
	end
	
	return true
end





local fire_logs = {
	{-.5, -.5, -.5, .5, .5, .5}, -- base block
	
	{-.5, .5, -.4, .5, .65, -.25},
	{-.5, .5, .25, .5, .65, .4},
	
	{-.4, .5+.15, -.5, -.25, .65+.15, .5},
	{.25, .5+.15, -.5, .4,   .65+.15, .5},
	
	{-.5, .5+.3, -.4, .5, .65+.3, -.25},
	{-.5, .5+.3, .25, .5, .65+.3, .4},
}

for i = 1,6 do
	local nb = {}
	for j = 1,i+1 do
		table.insert(nb, fire_logs[j])
	end
		
	minetest.register_node("campfire:coals_"..i, {
		description = "Coals",
		tiles = {"default_coal_block.png", "default_wood.png"},
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = nb
		},
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {
			choppy = 3, flammable = 3, stick = 1, oddly_breakable_by_hand = 1,
		},
		
		sounds = default.node_sound_wood_defaults(),
		on_timer = coals_on_timer,
		
		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			if pointed_thing == nil then
				return
			end
			
			local name = itemstack:get_name()
			local def = minetest.registered_nodes[name]
			if def and def.groups.burnable then
				-- add fuel to the fire
				if campfire.add_fuel(pos, def.fuel_value or 1) then
					itemstack:take_item(1)
				end
			end
			
			return itemstack
		end,
	})
	

end





minetest.register_craft({
	output = "campfire:kindling",
	recipe = {
		{"group:stick", "group:stick"},
		{"group:stick", "group:stick"},
	},
})



--[[
minetest.register_craft({
	output = firewood_base.."_bundle",
	type = "shapeless",
	recipe = { 
		firewood_base, firewood_base, firewood_base, firewood_base, 
		firewood_base, firewood_base, firewood_base, firewood_base, 
	},
})
]]
