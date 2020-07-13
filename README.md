# minetest_mg1
A fully custom mapgen experiment. WTFPL.

# API
Mg1 builds substantially upon the basic api of minetest.

## General
*`default.get_season_data()`
*`default.get_timeofyear()` Normalized range.
*`default.get_temp(pos)` Returns the temperature at a specific node. Does not 
include the biome noise variation, but that is a minor factor in mg1's mapgen.

## Mapgen
Mg1 uses a fully custom lua map generator. None of the builtin minetest biome and decoration
functions work with it. Use these instead.
*`default.register_biome(def)` 
*`default.register_stone_biome(def)`
*`default.register_surface_deco(def)`
*`default.register_ore(def)`
