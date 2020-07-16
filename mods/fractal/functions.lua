
function fractal.debug(s)
	print("[fractal] "..s)
end

function fractal.get_plant_noise()
	return { -- filter with these noise params
		offset = -98, -- nodes are placed when the noise is greater than 1
		scale = 100,     -- according to math.random() == 1 of the noise number
		spread = {x=600, y=600, z=600},
		seed = math.random(1, 6000),
		octaves = 6,
		persist = 0.89,
	}
end

