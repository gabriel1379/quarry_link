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

-- Cut Stone (m)
quarry_link.register_cut_stone_or_block("Coral Desert Stone", "everness")
quarry_link.register_cut_stone_or_block("Coral Desert Stone Block", "everness")
quarry_link.set_tools_for_stone("Coral Desert Stone", "everness")

-- These stone nodes can no longer be crafted directly.
for _,nodename in pairs({
    "everness:coral_desert_stone",
}) do
minetest.clear_craft({output = nodename})
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
