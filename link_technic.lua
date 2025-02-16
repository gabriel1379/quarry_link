local mod_name = "technic"
if (not minetest.get_modpath(mod_name.."_worldgen")) then
    return
end

-- Strengthen Quarry hammer, so granite can be quarried too.
minetest.override_item("quarry:stone_quarry_hammer", {
	tool_capabilities = {
        full_punch_interval = 1.3,
		max_drop_level=0,
		groupcaps = {
			cracky = {times={[1]=5.00, [2]=2.0, [3]=1.00}, uses=30, maxlevel=1}},
		damage_groups = {fleshy=3},
    },
})

-- Make Technic resource nodes work the same way
-- as the default resource nodes.
local resource_nodes_technic = {
    mod_name..':mineral_chromium',
    mod_name..':mineral_lead',
    mod_name..':mineral_sulfur',
    mod_name..':mineral_uranium',
    mod_name..':mineral_zinc',
}
for _,resource_node_technic in pairs(resource_nodes_technic) do
    quarry.override_with(resource_node_technic)
end

local stones_to_process = {
    "Granite",
    "Marble",
}
local missing_cobbles = stones_to_process

for _,missing_cobble in pairs(missing_cobbles) do
    quarry_link.register_cobble(missing_cobble)
end

for _,stone_name in pairs(stones_to_process) do
    quarry_link.register_cut_stone_or_block(stone_name, mod_name)
    -- quarry_link.register_cut_stone_or_block(stone_name.." Block", mod_name)
    quarry_link.set_tools_for_stone(stone_name, mod_name, true, true)
    -- quarry_link.set_tools_for_stair_and_slab(stone_name, mod_name, true)
    quarry_link.clear_crafts(stone_name, mod_name)
    -- quarry_link.register_block_craft_recipe(stone_name)
end
