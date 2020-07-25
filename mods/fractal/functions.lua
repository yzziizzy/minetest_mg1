
local disable_debug = true

function fractal.debug(s)
	if not disable_debug then
		print("[fractal] "..s)
	end
end

function fractal.get_plant_noise()
	return { -- filter with these noise params
		cap = 15,
		offset = 135, -- nodes are placed when the noise is greater than 1
		scale = 10,     -- according to math.random() == 1 of the noise number
		spread = {x=600, y=600, z=600},
		seed = math.random(1, 6000),
		octaves = 4,
		persist = 0.6,
	}
end

function fractal.merge_tables(a, b)
	local result = {}
	for k,v in pairs(a) do
		result[k] = v
	end
	for k,v in pairs(b) do
		result[k] = v
	end
	return result
end
