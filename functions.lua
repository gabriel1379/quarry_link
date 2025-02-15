function quarry_link.override_resource_nodes(resource_nodes)
    for _,resource_node in pairs(resource_nodes) do
        quarry.override_with(resource_node)
    end
end

function quarry_link.snake_case(this_string)
    this_string = string.lower(this_string)
    this_string = string.gsub(this_string, ' ', '_')

    return this_string
end

function quarry_link.is_registered(node, in_mod)
    local is_registered = minetest.registered_nodes[in_mod..":"..node] and true or false
    -- minetest.log("action", "[Quarry_Link] "..in_mod..":"..node.." "..(is_registered and "is registered." or "is not registered."))

    return is_registered
end

function quarry_link.determine_cobble_name(base_stone, in_mod)
    base_stone = string.gsub(base_stone, '_stone', '')
    local cobble_name_no_stone = base_stone.."_cobble"
    local cobble_name_stone = base_stone.."_stone_cobble"
    local cobble_name = nil
    if quarry_link.is_registered(cobble_name_no_stone, in_mod) then
        cobble_name = cobble_name_no_stone
    elseif quarry_link.is_registered(cobble_name_stone, in_mod) then
        cobble_name = cobble_name_stone
    end
    -- minetest.log("action", "[Quarry_Link] ".."Using name "..cobble_name..".")

    return cobble_name
end

function quarry_link.read_block_suffix(base_stone)
    local is_block = string.find(base_stone, "block") or false
    local block_suffix = is_block and "_block" or ""

    return block_suffix
end

function quarry_link.register_cut_stone_or_block(base_stone_name, in_mod)
    local base_stone = quarry_link.snake_case(base_stone_name)
    local block_suffix = quarry_link.read_block_suffix(base_stone)

    minetest.register_node("quarry_link:cut_"..base_stone, {
        description = "Cut "..base_stone_name,
        tiles = {in_mod.."_"..base_stone..".png^quarry_cut_stone"..block_suffix..".png"},
        groups = {stone = 1, falling_node = 1, dig_immediate = 2},
        drop = "quarry_link:cut_"..base_stone,
        legacy_mineral = true,
        sounds = default.node_sound_stone_defaults(),
        on_dig = quarry.mortar_on_dig(in_mod..":"..base_stone, {sticky = 2}),
    })
end

function quarry_link.register_block_craft_recipe(base_stone)
    base_stone = quarry_link.snake_case(base_stone)
    minetest.register_craft({
        output = base_stone.."_block 9",
        recipe = {
                {base_stone, base_stone, base_stone},
                {base_stone, base_stone, base_stone},
                {base_stone, base_stone, base_stone}
        }
    })
end

function quarry_link.set_tools_for_stone(base_stone_name, in_mod)
    local base_stone = quarry_link.snake_case(base_stone_name)
    local cobble_name = quarry_link.determine_cobble_name(base_stone, in_mod)
    -- minetest.log("action", "[Quarry_Link] ".."Using name "..cobble_name.." to set cobble for stone "..in_mod..":"..base_stone_name..".")

    if (not cobble_name) then
        return false
    end

    quarry.override_hammer(in_mod..":"..base_stone, "quarry_link:cut_"..base_stone, in_mod..":"..cobble_name, {cracky = 3})
    quarry.override_mortar(in_mod..":"..cobble_name, in_mod..":"..base_stone.."_brick", {crumbly = 3, stone = 1, falling_node = 1}, {sticky = 3})
    quarry.override_pick(in_mod..":"..base_stone.."_brick", in_mod..":"..cobble_name, {cracky = 2})
end

function quarry_link.set_tools_for_stair_and_slab(stone_name, in_mod)
    local base_stone = quarry_link.snake_case(stone_name)
    local cobble_name = quarry_link.determine_cobble_name(base_stone, in_mod)
    -- minetest.log("action", "[Quarry_Link] base stone: "..base_stone)
    -- minetest.log("action", "[Quarry_Link] cobble name: "..cobble_name)

    stairs.register_stair_and_slab("cut_"..base_stone,"quarry_link:cut_"..base_stone,{cracky = 3},{in_mod.."_"..base_stone..".png^quarry_cut_stone.png"},"Cut "..stone_name.." Stair","Cut "..stone_name.." Slab",default.node_sound_stone_defaults(),true)
    stairs.register_stair_and_slab("cut_"..base_stone.."_block","quarry_link:cut_"..base_stone.."_block",{cracky = 2},{in_mod.."_"..base_stone.."_block.png^quarry_cut_stone_block.png"},"Cut "..base_stone.." Block Stair","Cut "..base_stone.." Block Slab",default.node_sound_stone_defaults(),true)

    quarry.override_hammer("stairs:slab_"..base_stone, "stairs:slab_cut_"..base_stone, "stairs:slab_"..cobble_name, {cracky = 3})
    quarry.override_hammer("stairs:stair_"..base_stone, "stairs:stair_cut_"..base_stone, "stairs:stair_"..cobble_name, {cracky = 3})
    quarry.override_hammer("stairs:stair_inner_"..base_stone, "stairs:stair_inner_cut_"..base_stone, "stairs:stair_inner_"..cobble_name, {cracky = 3})
    quarry.override_hammer("stairs:stair_outer_"..base_stone, "stairs:stair_outer_cut_"..base_stone, "stairs:stair_outer_"..cobble_name, {cracky = 3})

    quarry.override_mortar("stairs:slab_cut_"..base_stone, "stairs:slab_"..base_stone, {slab = 1, falling_node = 1, dig_immediate = 2}, {sticky = 2})
    quarry.override_mortar("stairs:stair_cut_"..base_stone, "stairs:stair_"..base_stone, {stair = 1, falling_node = 1, dig_immediate = 2}, {sticky = 2})
    quarry.override_mortar("stairs:stair_inner_cut_"..base_stone, "stairs:stair_inner_"..base_stone, {stair = 1, falling_node = 1, dig_immediate = 2}, {sticky = 2})
    quarry.override_mortar("stairs:stair_outer_cut_"..base_stone, "stairs:stair_outer_"..base_stone, {stair = 1, falling_node = 1, dig_immediate = 2}, {sticky = 2})
end