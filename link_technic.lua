if (not minetest.get_modpath('technic_worldgen')) then
    return
end

-- Make Technic resource nodes work the same way
-- as the default resource nodes.
local resource_nodes_technic = {
    'technic:mineral_chromium',
    'technic:mineral_lead',
    'technic:mineral_sulfur',
    'technic:mineral_uranium',
    'technic:mineral_zinc',
}

for _,resource_node_technic in pairs(resource_nodes_technic) do
    quarry.override_with(resource_node_technic)
end
