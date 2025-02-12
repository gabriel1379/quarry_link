if (not minetest.get_modpath('everness')) then
    return
end

-- Make Everness resource nodes work the same way
-- as the default resource nodes.
local resource_nodes_everness = {
    'everness:stone_with_pyrite',
    'everness:quartz_ore',
}

for _,resource_node_everness in pairs(resource_nodes_everness) do
    quarry.override_with(resource_node_everness)
end

-- Cut Stone (m)
minetest.register_node("quarry_link:cut_coral_desert_stone", {
	description = "Cut Coral Desert Stone",
	tiles = {"everness_coral_desert_stone.png^quarry_cut_stone.png"},
	groups = {stone = 1, falling_node = 1, dig_immediate = 2},
	drop = "quarry_link:cut_coral_desert_stone",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
	on_dig = quarry.mortar_on_dig("everness:coral_desert_stone", {sticky = 2}),
})

quarry.override_hammer("everness:coral_desert_stone", "quarry_link:cut_coral_desert_stone", "everness:coral_desert_cobble", {cracky = 3})
quarry.override_mortar("everness:coral_desert_cobble", "everness:coral_desert_stone_brick", {crumbly = 3, stone = 1, falling_node = 1}, {sticky = 3})
quarry.override_pick("everness:coral_desert_stone_brick", "everness:coral_desert_cobble", {cracky = 2})

-- These stone nodes can no longer be crafted directly.
for _,nodename in pairs({
    "everness:coral_desert_stone",
}) do
minetest.clear_craft({output = nodename})
end

-- Cut Stone Block (m)
minetest.register_node("quarry_link:cut_coral_desert_stone_block", {
	description = "Cut Coral Desert Stone Block",
	tiles = {"everness_coral_desert_stone_block.png^quarry_cut_stone_block.png"},
	groups = {stone = 1, falling_node = 1, dig_immediate = 2},
	drop = "quarry_link:cut_coral_desert_stone_block",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
	on_dig = quarry.mortar_on_dig("everness:coral_desert_stone_block", {sticky = 2}),
})

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
