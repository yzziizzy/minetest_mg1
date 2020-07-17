plantlife.register_plantlife({
	name = "tall_grass",
	description = "Tall Grass",
	stages = {
		count = 11,
		base = 6,
		icon = 3,
	},
	growing = {
		chances = {
			live = 2,
		},
		stages = {1,10},
	},
	ripening = {
		chances = {
			live = 2,
		},
		stages = {4,11},
		suffix = "ripe",
	},
	frostkill = {
		chances = {
			live = 20,
			ripe = 10,
		},
		stages = {3,11},
		colorize = "^[colorize:brown:100",
	},
	shape = "vertical",
	groups = {
		grass = 1,
	},
	selection_box = {-6 / 16, -0.5, -6 / 16, 6 / 16, -5 / 16, 6 / 16},
})
