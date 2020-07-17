plantlife.register_plantlife({
	name = "sagebrush",
	description = "Sagebrush",
	stages = {
		count = 5,
		icon = 3,
	},
	growing = {
		chances = {
			live = 20,
		},
		stages = {1,4},
	},
	heatkill = {
		chances = {
			live = 100,
		},
		stages = {4,5},
		colorize = "^[colorize:white:100",
	},
	shape = "vertical",
	groups = {
		bushes = 1,
	},
	selection_box = {-6 / 16, -0.5, -6 / 16, 6 / 16, 4 / 16, 6 / 16},
})
