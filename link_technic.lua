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
    quarry_link.register_cut_stone_or_block(stone_name, mod_name)
    -- quarry_link.register_cut_stone_or_block(stone_name.." Block", mod_name)
    quarry_link.set_tools_for_stone(stone_name, mod_name, true, true)
    -- quarry_link.set_tools_for_stair_and_slab(stone_name, mod_name, true)
    quarry_link.clear_crafts(stone_name, mod_name)
    -- quarry_link.register_block_craft_recipe(stone_name)
end
