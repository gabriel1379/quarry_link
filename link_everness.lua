if (not minetest.get_modpath("everness")) then
    return
end

-- Resource nodes
local resource_nodes_everness = {
    "everness:stone_with_pyrite",
    "everness:quartz_ore",
}
quarry_link.override_resource_nodes(resource_nodes_everness)
-- Resource nodes END

local stones_with_block_variant_everness = {
    "Coral Desert Stone",
    "Mineral Stone",
}
for _,stone_name in pairs(stones_with_block_variant_everness) do
    quarry_link.register_cut_stone_or_block(stone_name, "everness")
    quarry_link.register_cut_stone_or_block(stone_name.." Block", "everness")
    quarry_link.set_tools_for_stone(stone_name, "everness")
    quarry_link.set_tools_for_stair_and_slab(stone_name, "everness")

    local base_stone = quarry_link.snake_case(stone_name)
    minetest.clear_craft({output = "everness:"..base_stone})
    minetest.clear_craft({output = "everness:"..base_stone.."_block"})
    minetest.clear_craft({output = "stairs:stair_"..base_stone})
    minetest.clear_craft({output = "stairs:stair_inner_"..base_stone})
    minetest.clear_craft({output = "stairs:stair_outer_"..base_stone})

    quarry_link.register_block_craft_recipe(base_stone)
end
