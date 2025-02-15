function quarry_link.override_resource_nodes(resource_nodes)
    for _,resource_node in pairs(resource_nodes) do
        quarry.override_with(resource_node)
    end
end

function quarry_link.get_base_stone_type(base_stone_name)
    local base_stone_type = string.lower(base_stone_name)
    base_stone_type = string.gsub(base_stone_type, ' ', '_')

    return base_stone_type
end

function quarry_link.is_registered(node, in_mod)
    local is_registered = minetest.registered_nodes[in_mod..":"..node] and true or false
    -- minetest.log("action", "[Quarry_Link] "..in_mod..":"..node.." "..(is_registered and "is registered." or "is not registered."))

    return is_registered
end

function quarry_link.determine_cobble_name(base_stone_type, in_mod)
    local cobble_name_without_stone = base_stone_type.."_cobble"
    local cobble_name_with_stone = base_stone_type.."_stone_cobble"
    local cobble_name = nil
    if quarry_link.is_registered(cobble_name_without_stone, in_mod) then
        cobble_name = cobble_name_without_stone
    elseif quarry_link.is_registered(cobble_name_with_stone, in_mod) then
        cobble_name = cobble_name_with_stone
    end
    minetest.log("action", "[Quarry_Link] ".."Using name "..cobble_name..".")

    return cobble_name
end

function quarry_link.register_cut_stone_or_block(base_stone_name, in_mod)
    local base_stone_type = quarry_link.get_base_stone_type(base_stone_name)

    local is_block = string.find(base_stone_type, "block") or false
    local block_suffix = is_block and "_block" or ""

    minetest.register_node("quarry_link:cut_"..base_stone_type, {
        description = "Cut "..base_stone_name,
        tiles = {in_mod.."_"..base_stone_type..".png^quarry_cut_stone"..block_suffix..".png"},
        groups = {stone = 1, falling_node = 1, dig_immediate = 2},
        drop = "quarry_link:cut_"..base_stone_type,
        legacy_mineral = true,
        sounds = default.node_sound_stone_defaults(),
        on_dig = quarry.mortar_on_dig(in_mod..":"..base_stone_type, {sticky = 2}),
    })
end

function quarry_link.set_tools_for_stone(base_stone_name, in_mod)
    local base_stone_type = quarry_link.get_base_stone_type(base_stone_name)
    base_stone_type = string.gsub(base_stone_type, '_stone', '')
    local cobble_name = quarry_link.determine_cobble_name(base_stone_type, in_mod)
    minetest.log("action", "[Quarry_Link] ".."Using name "..cobble_name.." to set cobble for stone "..in_mod..":"..base_stone_name..".")

    if (not cobble_name) then
        return false
    end

    quarry.override_hammer(in_mod..":"..base_stone_type.."_stone", "quarry_link:cut_"..base_stone_type.."_stone", in_mod..":"..cobble_name, {cracky = 3})
    quarry.override_mortar(in_mod..":"..cobble_name, in_mod..":"..base_stone_type.."_stone_brick", {crumbly = 3, stone = 1, falling_node = 1}, {sticky = 3})
    quarry.override_pick(in_mod..":"..base_stone_type.."_stone_brick", in_mod..":"..cobble_name, {cracky = 2})
end