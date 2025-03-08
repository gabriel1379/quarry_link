local mod_name = "technic"
if (not minetest.get_modpath(mod_name.."_worldgen")) then
    return
end

-- Make Technic resource nodes work the same way
-- as the default resource nodes.
local resource_nodes_technic = {
    "mineral_chromium",
    "mineral_lead",
    "mineral_sulfur",
    "mineral_uranium",
    "mineral_zinc",
}
quarry_link.quarrify_resource_nodes(resource_nodes_technic, mod_name)

local stones_to_process = {
    "Granite",
    "Marble",
}
local missing_cobbles = stones_to_process

for _,missing_cobble in ipairs(missing_cobbles) do
    quarry_link.register_cobble(missing_cobble)
end

for _,stone_name in ipairs(stones_to_process) do
    stone = quarry_link.snake_case(stone_name)
    quarry_link.register_cut_variant(stone, stone_name, mod_name)
    -- quarry_link.register_cut_variant(stone_name.." Block", mod_name)
    quarry_link.set_tools_for_stone(stone_name, mod_name, true, true)
    -- quarry_link.set_tools_for_stair_and_slab(stone_name, mod_name, true)
    quarry_link.clear_crafts(stone_name, mod_name)
    -- quarry_link.register_block_craft_recipe(stone_name)
end

local crafts_to_replace = {
    lv_compressor = {
        recipe = {
            {"quarry:cut_stone", "basic_materials:motor", "quarry:cut_stone"},
            {"mesecons:piston", "technic:machine_casing", "mesecons:piston"},
            {"basic_materials:silver_wire", "technic:lv_cable", "basic_materials:silver_wire"},
        },
        replacements = {
            {"basic_materials:silver_wire", "basic_materials:empty_spool"},
            {"basic_materials:silver_wire", "basic_materials:empty_spool"},
        },
    },
    lv_generator = {
        recipe = {
            {"quarry:cut_stone", "default:furnace",        "quarry:cut_stone"},
            {"quarry:cut_stone", "technic:machine_casing", "quarry:cut_stone"},
            {"quarry:cut_stone", "technic:lv_cable",       "quarry:cut_stone"},
        }
    },
    lv_grinder = {
        recipe = {
            {'default:desert_stone',    'default:diamond',        'default:desert_stone'},
		    {'default:desert_stone',    'technic:machine_casing', 'default:desert_stone'},
		    {'quarry_link:cut_granite', 'technic:lv_cable',       'quarry_link:cut_granite'},
        },
    }
}

for craft,details in pairs(crafts_to_replace) do
    if details["replacements"] ~= nil then
        quarry_link.replace_craft(craft, mod_name, details["recipe"], details["replacements"])
    else
        quarry_link.replace_craft(craft, mod_name, details["recipe"])
    end
end

if (not minetest.get_modpath("everness")) then
    return
end

local crafts_to_add_if_everness_also_present = {
    lv_grinder = {
        {
            recipe = {
                {'quarry_link:cut_forsaken_desert_stone', 'default:diamond',        'quarry_link:cut_forsaken_desert_stone'},
                {'quarry_link:cut_forsaken_desert_stone', 'technic:machine_casing', 'quarry_link:cut_forsaken_desert_stone'},
                {'quarry_link:cut_granite',               'technic:lv_cable',       'quarry_link:cut_granite'},
            },
        },
        {
            recipe = {
                {'quarry_link:cut_coral_desert_stone', 'default:diamond',        'quarry_link:cut_coral_desert_stone'},
                {'quarry_link:cut_coral_desert_stone', 'technic:machine_casing', 'quarry_link:cut_coral_desert_stone'},
                {'quarry_link:cut_granite',            'technic:lv_cable',       'quarry_link:cut_granite'},
            },
        },
    }
}

for machine,crafts in pairs(crafts_to_add_if_everness_also_present) do
    minetest.log("action", "[Quarry Link] machine: "..machine)
    machine_craft = {
        output = mod_name..":"..machine,
    }

    for _,details in ipairs(crafts) do
        for key,value in pairs(details) do
            minetest.log("action", "[Quarry Link] Key: "..key)
            machine_craft[key] = value
        end

        minetest.register_craft(machine_craft)
    end
end
