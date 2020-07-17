
plantlife = {}
function plantlife.base_groups()
	return {
		snappy = 3,
		flora = 1,
		plantlife = 1,
		flammable = 1,
		squashable = 1,
	}
end

function plantlife.get_destruct_self_group(plant_self_group)
    return function(pos, node, offset)
        fractal.debug("triggering destruct check: " .. offset)
        local np = {x = pos.x, y = pos.y + offset, z = pos.z}
        local nn = minetest.get_node(np)
        if not nn then
            return
        end
        local name = nn.name
        if not minetest.registered_nodes[name] or not minetest.registered_nodes[name].groups[plant_self_group] then
            return
        end
        minetest.remove_node(np)
    end
end

function plantlife.stage_name(name, suffix, stage)
    if suffix and suffix ~= "" then
        suffix = "_"..suffix
    end
    return "fractal:"..name.."_"..stage..suffix
end

function plantlife.stage_names(name, suffix, first, last)
    local names = {}
    for i = first, last do
        table.insert(names, plantlife.stage_name(name, suffix, i))
    end
    return names
end

function plantlife.texture_name(name, suffix, stage)
    if suffix and suffix ~= "" then
        suffix = "_"..suffix
    end
    return "fractal_"..name.."_"..stage..suffix..".png"
end


function plantlife.register_plantlife(def)
    local stage_defs = {}
    local plant_self_group = "plantlife_"..def.name
    for i = 1, def.stages.count do
        stage_defs[i] = {
            name = def.name,
            description = def.description,
            icon = plantlife.texture_name(def.name, "", def.stages.icon),
            forms = {
                live = {
                    stage = i,
                    form = "live",
                    name = plantlife.stage_name(def.name, "live", i),
                    texture = plantlife.texture_name(def.name, "", i),
                    no_self_action = {},
                },
            },
            groups = def.groups or {},
            selection_box = def.selection_box,
            self_group = plant_self_group,
        }
        stage_defs[i].groups[plant_self_group] = 1
        if i ~= def.stages.icon then
            stage_defs[i].groups.not_in_creative_inventory = 1
        end

        if def.stages.base and i > def.stages.base then
            stage_defs[i].pointable = false
        end
    end

    if def.growing then
        for i = def.growing.stages[1], def.growing.stages[2] do
            for grow_form, chance in pairs(def.growing.chances) do
                stage_defs[i].forms[grow_form].grow_to = plantlife.stage_name(def.name, "live", i + 1)
                stage_defs[i].forms[grow_form].grow_chance = chance

                if def.stages.base and i + 1 == def.stages.base then
                    stage_defs[i].forms[grow_form].grow_to = {
                        plantlife.stage_name(def.name, "live", i + 1),
                        plantlife.stage_name(def.name, "live", i + 2)
                    }
                end
            end
        end
    end

    if def.ripening then
        for i = def.ripening.stages[1], def.ripening.stages[2] do
            stage_defs[i].forms.ripe = {
                stage = i,
                form = "ripe",
                name = plantlife.stage_name(def.name, "ripe", i),
                texture = plantlife.texture_name(def.name, def.suffix or "", i),
                no_self_action = {},
            }
            if def.ripening.colorize then
                stage_defs[i].forms.ripe.texture = stage_defs[i].forms.ripe.texture .. def.ripening.colorize
            end

            for ripen_form, chance in pairs(def.ripening.chances) do
                stage_defs[i].forms[ripen_form].ripen_to = plantlife.stage_name(def.name, "ripe", i)
                stage_defs[i].forms[ripen_form].ripen_chance = chance

                if def.stages.base and i == def.stages.base then
                    stage_defs[i].forms[ripen_form].no_self_action.ripen = true
                elseif def.stages.base and i > def.stages.base then
                    stage_defs[i].forms[ripen_form].ripen_base_to = plantlife.stage_name(def.name, "ripe", def.stages.base)
                end
            end
        end
    end

    if def.frostkill then
        for i = def.frostkill.stages[1], def.frostkill.stages[2] do
            stage_defs[i].forms.dead = stage_defs[i].forms.dead or {
                stage = i,
                form = "dead",
                name = plantlife.stage_name(def.name, "dead", i),
                texture = plantlife.texture_name(def.name, def.suffix or "", i),
                no_self_action = {},
            }
            if def.frostkill.colorize then
                stage_defs[i].forms.dead.texture = stage_defs[i].forms.dead.texture .. def.frostkill.colorize
            end

            for dying_form, chance in pairs(def.frostkill.chances) do
                stage_defs[i].forms[dying_form].frostkill_to = plantlife.stage_name(def.name, "dead", i)
                stage_defs[i].forms[dying_form].frostkill_chance = chance

                if def.stages.base and i == def.stages.base then
                    stage_defs[i].forms[dying_form].no_self_action.frostkill = true
                elseif def.stages.base and i > def.stages.base then
                    stage_defs[i].forms[dying_form].frostkill_base_to = plantlife.stage_name(def.name, "dead", def.stages.base)
                end
            end
        end
    end

    if def.heatkill then
        for i = def.heatkill.stages[1], def.heatkill.stages[2] do
            stage_defs[i].forms.dead = stage_defs[i].forms.dead or {
                stage = i,
                form = "dead",
                name = plantlife.stage_name(def.name, "dead", i),
                texture = plantlife.texture_name(def.name, def.suffix or "", i),
                no_self_action = {},
            }
            if def.heatkill.colorize then
                stage_defs[i].forms.dead.texture = stage_defs[i].forms.dead.texture .. def.heatkill.colorize
            end

            for dying_form, chance in pairs(def.heatkill.chances) do
                stage_defs[i].forms[dying_form].heatkill_to = plantlife.stage_name(def.name, "dead", i)
                stage_defs[i].forms[dying_form].heatkill_chance = chance

                if def.stages.base and i == def.stages.base then
                    stage_defs[i].forms[dying_form].no_self_action.heatkill = true
                elseif def.stages.base and i > def.stages.base then
                    stage_defs[i].forms[dying_form].heatkill_base_to = plantlife.stage_name(def.name, "dead", def.stages.base)
                end
            end
        end
    end


    for i, def in ipairs(stage_defs) do
        for form, form_def in pairs(def.forms) do
            local registration = {
                description = def.description,
                drawtype = "plantlike",
                waving = 1,
                tiles = {form_def.texture},
                inventory_image = def.icon,
                wield_image = def.icon,
                paramtype = "light",
                sunlight_propagates = true,
                walkable = false,
                buildable_to = true,
                pointable = def.pointable,
                groups = fractal.merge_tables(plantlife.base_groups(), def.groups),
                sounds = default.node_sound_leaves_defaults(),
                selection_box = {
                    type = "fixed",
                    fixed = def.selection_box,
                },
                drop = {},
                after_destruct = plantlife.get_destruct_self_group(def.self_group),
                plantlife = form_def,
            }

            if form_def.grow_to then
                registration.groups.plantlife_grow = 1
            end

            if form_def.ripen_to then
                registration.groups.plantlife_ripen = 1
            end

            if form_def.frostkill then
                registration.groups.plantlife_frostkill = 1
            end

            if form_def.heatkill then
                registration.groups.plantlife_heatkill = 1
            end

            fractal.debug("registering node: "..form_def.name)
            minetest.register_node(form_def.name, registration)
        end
    end
end


function plantlife.get_action_abm(action, day_start, day_end, daylight_only)
	return function(pos, node, active_object_count, active_object_count_wider)
		local def = minetest.registered_nodes[node.name]
		if not def then
			fractal.debug("unknown node in action abm ["..action.."]: " .. node.name)
			return
        end

        if def.plantlife.no_self_action and def.plantlife.no_self_action[action] then
            return
        end

		local time = minetest.get_timeofday()

		local day_of_year = minetest.get_day_count() % 12 -- stub year length
		-- print("day is: " .. day_of_year)
		if (day_of_year < day_start) or (day_of_year > day_end) then
			fractal.debug("not in day range [" .. day_start .. ", " .. day_end .. "]")
			return
		end

		-- only ripen in the daytime, times are a bit arbitrary 5500 to 19500
		if daylight_only and (time < 0.2292) or (time > 0.8125) then
			return
		end

        if
            action == "grow"
            and def.plantlife.grow_to
            and math.random(1, def.plantlife.grow_chance) == 1
        then
            if type(def.plantlife.ripen_to) == "table" then
                for i = 2, #def.plantlife.ripen_to do
                    local p = {x=pos.x, y=pos.y+(i-1), z=pos.z}
                    local n = minetest.get_node(p)
                    if n.name ~= "air" then
                        fractal.debug("vertical grow hit not air")
                        return -- cannot grow into other things
                    end
                end
                minetest.swap_node(pos, {name=def.plantlife.ripen_to[1]})
                for i = 2, #def.plantlife.ripen_to do
                    local p = {x=pos.x, y=pos.y+(i-1), z=pos.z}
                    minetest.set_node(p, {name=def.plantlife.ripen_to[i]})
                end
            elseif def.stage_next then
                minetest.swap_node(pos, {name=def.plantlife.ripen_to})
            end
        elseif
            action == "ripen"
            and def.plantlife.ripen_to
            and math.random(1, def.plantlife.ripen_chance) == 1
        then
            minetest.swap_node(pos, {name=def.plantlife.ripen_to})
            if def.plantlife.ripen_base_to then
                local pos_below = {x=pos.x, y=pos.y-1, z=pos.z}
                local node_below = minetest.get_node(pos_below)
                if plantlife_form.ripe[node_below.name] then
                    minetest.swap_node(pos_below, {name=def.plantlife.ripen_base_to})
                end
            end
        elseif
            action == "frostkill"
            and def.plantlife.frostkill_to
            and math.random(1, def.plantlife.frostkill_chance) == 1
        then
            minetest.swap_node(pos, {name=def.plantlife.frostkill_to})
            if def.plantlife.frostkill_base_to then
                local pos_below = {x=pos.x, y=pos.y-1, z=pos.z}
                local node_below = minetest.get_node(pos_below)
                if plantlife_form.dead[node_below.name] then
                    minetest.swap_node(pos_below, {name=def.plantlife.frostkill_base_to})
                end
            end
        elseif
            action == "frostkill"
            and def.plantlife.heatkill_to
            and math.random(1, def.plantlife.heatkill_chance) == 1
        then
            minetest.swap_node(pos, {name=def.plantlife.heatkill_to})
            if def.plantlife.heatkill_base_to then
                local pos_below = {x=pos.x, y=pos.y-1, z=pos.z}
                local node_below = minetest.get_node(pos_below)
                if plantlife_form.dead[node_below.name] then
                    minetest.swap_node(pos_below, {name=def.plantlife.heatkill_base_to})
                end
            end
        end

	end
end


-- debug settings
-- local abm_interval = 3.0
-- local abm_chance   = 10

-- real settings
local abm_interval = 6.0
local abm_chance   = 30

minetest.register_abm({
	nodenames = {"group:plantlife_grow"},
	interval = abm_interval, -- Run every 10 seconds
	chance = abm_chance, -- Select every 1 in 20 nodes
	action = plantlife.get_action_abm("grow", 1, 3, true)
})

minetest.register_abm({
	nodenames = {"group:plantlife_ripen"},
	interval = abm_interval, -- Run every 10 seconds
	chance = abm_chance, -- Select every 1 in 20 nodes
	action = plantlife.get_action_abm("ripen", 4, 6, true)
})

minetest.register_abm({
	nodenames = {"group:plantlife_frostkill"},
	interval = abm_interval, -- Run every 10 seconds
	chance = abm_chance, -- Select every 1 in 20 nodes
	action = plantlife.get_action_abm("frostkill", 10, 12, false)
})


minetest.register_abm({
	nodenames = {"group:plantlife_heatkill"},
	interval = abm_interval, -- Run every 10 seconds
	chance = abm_chance, -- Select every 1 in 20 nodes
	action = plantlife.get_action_abm("heatkill", 4, 6, true)
})
