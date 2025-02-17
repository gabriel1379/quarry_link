local mod_name = "everness"
if (not minetest.get_modpath(mod_name)) then
    return
end

-- Resource nodes
local resource_nodes_everness = {
    {mod_name..":stone_with_pyrite", "default:cobble"},
    {mod_name..":quartz_ore", "default:cobble"},
    {mod_name..":coral_desert_stone_with_coal", mod_name..":coral_desert_cobble"},
    {mod_name..":crystal_stone_with_coal", mod_name..":crystal_cobble"},
    -- {mod_name..":cursed_stone_carved_with_coal"}, has no cobble (yet)
    {mod_name..":mineral_stone_with_coal", mod_name..":mineral_stone_cobble"},
}
for _,resource_node in ipairs(resource_nodes_everness) do
    quarry_link.override_resource_node(resource_node[1], resource_node[2])
end
-- Resource nodes END

local stones_with_block_variant_everness = {
    "Coral Desert Stone",
    "Mineral Stone",
}
for _,stone_name in pairs(stones_with_block_variant_everness) do
    quarry_link.register_cut_stone_or_block(stone_name, mod_name)
    quarry_link.register_cut_stone_or_block(stone_name.." Block", mod_name)
    quarry_link.set_tools_for_stone(stone_name, mod_name, false, false)
    quarry_link.set_tools_for_stair_and_slab(stone_name, mod_name, false)
    quarry_link.clear_crafts(stone_name, mod_name)
    quarry_link.register_block_craft_recipe(stone_name)
end
