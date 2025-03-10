function quarry_link.override_resource_node(resource_node, cobble_name)
    minetest.override_item(resource_node, {
        after_dig_node = function(pos, oldnode, oldmetadata, digger)
            minetest.set_node(pos, {name=cobble_name})
            minetest.check_for_falling(pos)
        end
    })
end

function quarry_link.is_registered(node, in_mod)
    local is_registered = minetest.registered_nodes[in_mod..":"..node] and true or false
    -- minetest.log("action", "[Quarry Link] "..in_mod..":"..node.." is "..(is_registered and "" or "NOT ").."registered.")

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

function quarry_link.register_cobble(cobble_name)
    local base_cobble = quarry_link.snake_case(cobble_name)
    local is_marble = base_cobble == "marble"

    minetest.register_node( "quarry_link:"..base_cobble.."_cobble", {
    	description = cobble_name.." Cobble",
    	tiles = { "quarry_link_"..base_cobble.."_cobble.png" },
    	is_ground_content = false,
    	groups = is_marble and {cracky=3, marble=1} or {cracky=3},
    	sounds = default.node_sound_stone_defaults(),
    })
end

function quarry_link.register_cut_variant(base_stone, base_stone_name, in_mod)
    local block_suffix = quarry_link.read_block_suffix(base_stone)
    -- minetest.log("action", "[Quarry Link] "..base_stone.."'s block suffix: >"..block_suffix.."<")

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

function quarry_link.register_block_craft_recipe(block_name)
    block_name = "quarry_link:"..quarry_link.snake_case(block_name)
    local base_stone = string.gsub(block_name, "_block", "")
    -- minetest.log("action", "[Quarry Link] Using for block craft recipe registration: block_name "..block_name.." and base_stone "..base_stone)
    minetest.register_craft({
        output = block_name.." 9",
        recipe = {
                {base_stone, base_stone, base_stone},
                {base_stone, base_stone, base_stone},
                {base_stone, base_stone, base_stone}
        }
    })
end

function quarry_link.set_tools_for_stone(base_stone_name, in_mod, is_own_cobble, is_brick_plural)
    local base_stone = quarry_link.snake_case(base_stone_name)
    local cobble_mod = is_own_cobble and "quarry_link" or in_mod
    local cobble_name = quarry_link.determine_cobble_name(base_stone, cobble_mod)
    -- minetest.log("action", "[Quarry_Link] ".."Using name "..cobble_name.." to set cobble for stone "..in_mod..":"..base_stone_name..".")

    if (not cobble_name) then
        minetest.log("action", "[Quarry Link] Cannot register "..cobble_mod..":"..base_stone.." as cobble name could not be determined.")

        return false
    end

    -- minetest.log("action", "[Quarry_Link] ".."Using "..in_mod..":"..base_stone.." and "..cobble_mod..":"..cobble_name)
    local plural_s = is_brick_plural and "s" or ""
    quarry.override_hammer(in_mod..":"..base_stone, "quarry_link:cut_"..base_stone, cobble_mod..":"..cobble_name, {cracky = 3})
    quarry.override_mortar(cobble_mod..":"..cobble_name, in_mod..":"..base_stone.."_brick"..plural_s, {crumbly = 3, stone = 1, falling_node = 1}, {sticky = 3})
    quarry.override_pick(in_mod..":"..base_stone.."_brick"..plural_s, cobble_mod..":"..cobble_name, {cracky = 2})
end

function quarry_link.register_cut_stone_or_block_stair_and_slab(stone_name, in_mod)
    local base_stone = quarry_link.snake_case(stone_name)
    local block_suffix = quarry_link.read_block_suffix(base_stone)
    local crackiness = block_suffix == "" and 3 or 2

    stairs.register_stair_and_slab(
        "cut_"..base_stone,
        "quarry_link:cut_"..base_stone,
        {cracky = crackiness},
        {in_mod.."_"..base_stone..".png^quarry_cut_stone"..block_suffix..".png"},
        "Cut "..stone_name.." Stair",
        "Cut "..stone_name.." Slab",
        default.node_sound_stone_defaults(),
        true
    )

    -- minetest.log("action", "Registered ".."Cut "..stone_name.." Stair and Slab.")
end

function quarry_link.set_tools_for_stair_and_slab(material_name, in_mod, is_ql_cobble, conversions_by_tool)
    local material = quarry_link.snake_case(material_name)
    local cobble_mod = is_ql_cobble and "quarry_link" or in_mod
    local cobble_name = quarry_link.determine_cobble_name(material, cobble_mod)
    -- minetest.log("action", "[Quarry_Link] base stone: "..material)
    -- minetest.log("action", "[Quarry_Link] cobble name: "..cobble_name)

    quarry_link.register_cut_stone_or_block_stair_and_slab(material_name, in_mod)
    quarry_link.register_cut_stone_or_block_stair_and_slab(material_name.." Block", in_mod)

    local stairs = {
        "slab",
        "stair",
        "stair_inner",
        "stair_outer",
    }

    for _,stair in ipairs(stairs) do
        -- minetest.log("action", "[Quarry Link]Overriding for stairs, using 'stairs:"..stair.."_"..material.."', 'stairs:"..stair.."_cut_"..base_stone.."' and 'stairs:"..stair.."_"..cobble_name.."'")
        quarry.override_hammer(
            "stairs:"..stair.."_"..material,
            "stairs:"..stair.."_cut_"..material,
            "stairs:"..stair.."_"..cobble_name,
            {cracky = 3}
        )
        quarry.override_mortar(
            "stairs:"..stair.."_cut_"..material,
            "stairs:"..stair.."_"..material,
            {stair = 1, falling_node = 1, dig_immediate = 2},
            {sticky = 2}
        )
        quarry.override_pick(
            "stairs:"..stair..material,
            "stairs:"..stair..cobble_name,
            {cracky = 2}
        )
    end
end

function quarry_link.clear_crafts(stone_name, in_mod)
    local base_stone = quarry_link.snake_case(stone_name)
    local crafts_to_clear = {
        {base_stone, in_mod},
        {base_stone.."_block", in_mod},
        {base_stone.."_brick", in_mod},
        {base_stone.."_bricks", in_mod},
        {base_stone.."brick", in_mod},
        {base_stone.."bricks", in_mod},
        {"slab_"..base_stone, "stairs"},
        {"stair_"..base_stone, "stairs"},
        {"stair_inner_"..base_stone, "stairs"},
        {"stair_outer_"..base_stone, "stairs"},
    }

    for _, craft_to_clear in ipairs(crafts_to_clear) do
        if quarry_link.is_registered(craft_to_clear[1], craft_to_clear[2]) then
            minetest.clear_craft({output = craft_to_clear[2]..":"..craft_to_clear[1]})
        end
    end
end

function quarry_link.register_rubble(stone_name, in_mod)
    local base_stone = quarry_link.snake_case(stone_name)
    minetest.register_node("quarry_link:"..base_stone.."_rubble", {
        description = stone_name.." Rubble",
        tiles = {in_mod.."_"..base_stone..".png^quarry_rubble_overlay.png"},
        is_ground_content = false,
        groups = {crumbly = 3, stone = 2, falling_node = 1},
        sounds = default.node_sound_stone_defaults(),
        on_dig = quarry.mortar_on_dig(in_mod..":"..base_stone.."_brick", {sticky = 3}),
    })
end

function quarry_link.quarrify_resource_nodes(resource_nodes, in_mod)
    for _,resource_node in ipairs(resource_nodes) do
        if type(resource_node) == "table" then
            quarry_link.override_resource_node(in_mod..":"..resource_node[1], resource_node[2])
        else
            quarry.override_with(in_mod..":"..resource_node)
        end
    end
end

function quarry_link.replace_craft(output, in_mod, recipe, replacements)
    output = in_mod..":"..output
    minetest.clear_craft({output = output})

    if replacements ~= nil then
        minetest.register_craft({
            output = output,
            recipe = recipe,
            replacements = replacements,
        })
    else
        minetest.register_craft({
            output = output,
            recipe = recipe,
        })
    end
end
