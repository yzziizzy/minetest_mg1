-- See README.txt for licensing and other information.

-- Load support for MT game translation.
local S = minetest.get_translator("fractal")

fractal = {}

-- Load initial files
local modpath = minetest.get_modpath("fractal")

dofile(modpath.."/config.lua")
dofile(modpath.."/functions.lua")
dofile(modpath.."/stubs.lua")
dofile(modpath.."/soil.lua")
dofile(modpath.."/biomes.lua")
dofile(modpath.."/grass.lua")
dofile(modpath.."/surface_deco.lua")

