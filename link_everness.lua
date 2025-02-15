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

    minetest.clear_craft({output = "everness:"..quarry_link.get_base_stone_type(stone_name)})
    minetest.clear_craft({output = "everness:"..quarry_link.get_base_stone_type(stone_name).."_block"})
end

-- New craft recipes.
-- For cut_stone_block nodes.
for _,nodename in pairs({"quarry_link:cut_coral_desert_stone"}) do
minetest.register_craft({
    output = nodename.."_block 9",
    recipe = {
            {nodename, nodename, nodename},
            {nodename, nodename, nodename},
            {nodename, nodename, nodename}
    }
})
end
