-- Make Everness resource nodes work the same way
-- as the default resource nodes.
if (minetest.get_modpath('everness')) then
    local resource_nodes_everness = {
        'everness:stone_with_pyrite',
        'everness:quartz_ore',
    }

    for _,resource_node_everness in pairs(resource_nodes_everness) do
        quarry.override_with(resource_node_everness)
    end
end
