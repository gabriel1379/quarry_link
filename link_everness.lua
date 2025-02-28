local mod_name = "everness"
if (not minetest.get_modpath(mod_name)) then
    return
end

-- Resource nodes
local resource_nodes_everness = {
    {"stone_with_pyrite", "default:cobble"},
    {"quartz_ore", "default:cobble"},
    {"coral_desert_stone_with_coal", mod_name..":coral_desert_cobble"},
    {"crystal_stone_with_coal", mod_name..":crystal_cobble"},
    -- {"cursed_stone_carved_with_coal"}, has no cobble (yet)
    {"mineral_stone_with_coal", mod_name..":mineral_stone_cobble"},
}
for _,resource_node in ipairs(resource_nodes_everness) do
    quarry_link.override_resource_node(mod_name..":"..resource_node[1], resource_node[2])
end
-- Resource nodes END


local conversions_by_tool = {
    hammer = {
        "coral_bones_block",
        "coral_deep_ocean_sandstone_block",
        "coral_desert_stone",
        "coral_desert_stone_block",
        "coral_sandstone",
        "coral_sandstone_chiseled",
        "coral_sandstone_carved_1",
        "coral_white_sandstone",
        "coral_white_sandstone_pillar",
        "cursed_dream_stone",
        "cursed_lands_deep_ocean_sandstone_block",
        "cursed_sandstone_block",
        "cursed_stone",
        "cursed_stone_carved",
        "crystal_forest_deep_ocean_sandstone_block",
        "crystal_sandstone",
        "crystal_sandstone_chiseled",
        "crystal_stone",
        "forsaken_desert_stone",
        "forsaken_desert_chiseled_stone",
        "forsaken_desert_engraved_stone",
        "forsaken_tundra_stone",
        "mineral_sandstone",
        "mineral_stone",
        "quartz_block", -- MISSING
        "quartz_chiseled", -- MISSING
        "quartz_pillar", -- MISSING
        "soul_sandstone",
        "soul_sandstone_veined",
        "sulfur_stone",
    },
    mortar = {
        "coral_desert_cobble", -- MISSING
        "coral_desert_mossy_cobble", -- MISSING
        "coral_deep_ocean_sandstone_rubble",
        "coral_white_sandstone_rubble",
        "crystal_cobble",
        "crystal_mossy_cobble",
        "cursed_cobble", -- MISSING
        "cursed_cobble_with_growth", -- MISSING
        "cursed_sandstone_cobble", -- MISSING
        "cut_coral_bones_block",
        "cut_coral_deep_ocean_sandstone_block",
        "cut_coral_desert_stone",
        "cut_coral_desert_stone_block",
        "cut_coral_sandstone",
        "cut_coral_sandstone_carved_1",
        "cut_coral_sandstone_chiseled",
        "cut_coral_white_sandstone",
        "cut_coral_white_sandstone_pillar",
        "cut_cursed_dream_stone",
        "cut_cursed_lands_deep_ocean_sandstone_block",
        "cut_cursed_sandstone_block",
        "cut_cursed_stone",
        "cut_cursed_stone_carved",
        "cut_crystal_forest_deep_ocean_sandstone_block",
        "cut_crystal_sandstone",
        "cut_crystal_sandstone_chiseled",
        "cut_crystal_stone",
        "cut_forsaken_desert_stone",
        "cut_forsaken_desert_chiseled_stone",
        "cut_forsaken_desert_engraved_stone",
        "cut_forsaken_tundra_stone",
        "cut_mineral_cave_stone",
        "cut_mineral_lava_stone_dry",
        "cut_mineral_lava_stone",
        "cut_mineral_sandstone_block",
        "cut_mineral_sandstone",
        "cut_mineral_stone",
        "cut_quartz_block",
        "cut_quartz_chiseled",
        "cut_quartz_pillar",
        "cut_soul_sandstone",
        "cut_soul_sandstone_veined",
        "cut_sulfur_stone",
        "cut_volcanic_rock",
        "cut_volcanic_rock_with_magma",
        "forsaken_desert_cobble",
        "forsaken_desert_cobble_red",
        "forsaken_tundra_cobble",
        "magmacobble",
        "mineral_stone_cobble",
        "quartz_rubble", -- MISSING
    },
    pick = { -- BRICK ONLY!!!!
        "coral_bones_brick",
        "coral_sandstone_brick",
        "coral_white_sandstone_brick",
        "crystal_forest_deep_ocean_sandstone_brick",
        "crystal_mossy_brick",
        "crystal_stone_brick",
        "coral_deep_ocean_sandstone_brick", -- MISSING
        "coral_desert_stone_brick", -- MISSING
        "cursed_brick", -- MISSING
        "cursed_brick_with_growth", -- MISSING
        "cursed_lands_deep_ocean_sandstone_brick",
        "cursed_sandstone_brick", -- MISSING
        "forsaken_desert_brick",
        "forsaken_desert_brick_red",
        "forsaken_tundra_brick",
        "magmabrick",
        "mineral_cave_stone_brick", -- MISSING
    },
}

local irregularly_named_pairs = {
    coral_desert_cobble = "coral_desert_stone_brick",
    coral_desert_stone_brick = "coral_desert_cobble",
    crystal_cobble = "crystal_stone_brick",
    crystal_stone = "crystal_cobble",
    crystal_stone_brick = "crystal_cobble",
}

quarry_link.link(mod_name, conversions_by_tool, irregularly_named_pairs)

-- cursed_stone_carved
-- quartz_block

--[[ local stones_with_block_variant_everness = {
    "Coral Desert Stone",
    "Mineral Stone",
}

for _,stone_name in ipairs(stones_with_block_variant_everness) do
    quarry_link.register_cut_stone_or_block(stone_name, mod_name)
    quarry_link.register_cut_stone_or_block(stone_name.." Block", mod_name)
    quarry_link.set_tools_for_stone(stone_name, mod_name, false, false)
    quarry_link.set_tools_for_stair_and_slab(stone_name, mod_name, false, conversions_by_tool)
    quarry_link.clear_crafts(stone_name, mod_name)
    quarry_link.register_block_craft_recipe(stone_name)
end ]]
