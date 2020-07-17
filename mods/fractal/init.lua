-- See README.txt for licensing and other information.

-- Load support for MT game translation.
local S = minetest.get_translator("fractal")

fractal = {}

-- Load initial files
local modpath = minetest.get_modpath("fractal")

dofile(modpath.."/functions.lua")
dofile(modpath.."/stubs.lua")
dofile(modpath.."/soil.lua")
dofile(modpath.."/biomes.lua")
dofile(modpath.."/plantlife.lua")
dofile(modpath.."/surface_deco.lua")

-- [ Plantlife Definitions] --
dofile(modpath.."/plantlife/tall_grass.lua")
dofile(modpath.."/plantlife/sagebrush.lua")

