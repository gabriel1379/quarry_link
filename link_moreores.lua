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
quarry_link.quarrify_resource_nodes(resource_nodes_moreores, mod_name)
