local mod_name = "moreores"
if (not minetest.get_modpath(mod_name)) then
    return
end

-- Make More Ores resource nodes work the same way
-- as the default resource nodes.
local resource_nodes_moreores = {
    "mineral_silver",
    "mineral_mithril",
}
for _,resource_node_moreores in ipairs(resource_nodes_moreores) do
    quarry.override_with(mod_name..":"..resource_node_moreores)
end
