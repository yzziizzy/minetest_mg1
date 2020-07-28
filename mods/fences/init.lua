
fences = {}









function fences.register_stick_fence(def)
	
	minetest.register_node(def.name, {
		description = def.Name,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed = {-.05, -.5, -.05, .05, .5, .05},
			connect_front = {-0.02, -0.5, -0.5,  0.02, 0.5, 0},
			connect_left = {-0.5, -0.5, -0.02, 0, 0.5,  0.02},
			connect_back = {-0.02, -0.5,  0,  0.02, 0.5,  0.5},
			connect_right = { 0, -0.5, -0.02,  0.5, 0.5,  0.02},
		},
		collision_box = {
			type = "connected",
			fixed = {-.05, -.5, -.05, .05, .5, .05},
			connect_front = {-0.02, -0.5, -0.5,  0.02, 0.5, 0},
			connect_left = {-0.5, -0.5, -0.02, 0, 0.5,  0.02},
			connect_back = {-0.02, -0.5,  0,  0.02, 0.5,  0.5},
			connect_right = { 0, -0.5, -0.02,  0.5, 0.5,  0.02},
		},
		connects_to = { "group:fence", "group:stone", "group:soil"},
		walkable = true,
		groups = { axed = 3, handed = 1, fence = 1, flammable = 1 },
	})
	
	-- crafts
	minetest.register_craft({
		output = def.name,
		recipe = {
			{ "", "", "" },
			{ def.stick, def.stick,    def.stick},
			{ def.stick, "group:beam", def.stick},
		}
	})
	minetest.register_craft({
		output = def.name,
		recipe = {
			{ "", "", "" },
			{ def.stick, def.stick,   def.stick},
			{ def.stick, "group:log", def.stick},
		}
	})
	
end


fences.register_stick_fence({
	name = "fences:stick_fence",
	Name = "Woven Stick Fence",
	stick = "group:stick",
	tiles = {"fences_fir_woven.png"},
})
