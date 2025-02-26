local mod_name = "everness"
if (not minetest.get_modpath(mod_name)) then
    return
end

-- Resource nodes
local resource_nodes_everness = {
    {"stone_with_pyrite", "default:cobble"},
    {"quartz_ore", "default:cobble"},
    {"coral_desert_stone_with_coal", mod_name..":coral_desert_cobble"},
    {"crystal_stone_with_coal", mod_name..":crystal_cobble"},
    -- {"cursed_stone_carved_with_coal"}, has no cobble (yet)
    {"mineral_stone_with_coal", mod_name..":mineral_stone_cobble"},
}
for _,resource_node in ipairs(resource_nodes_everness) do
    quarry_link.override_resource_node(mod_name..":"..resource_node[1], resource_node[2])
end
-- Resource nodes END


local conversions_by_tool = {
    hammer = {
        "coral_bones_block",
        "coral_deep_ocean_sandstone_block",
        "coral_desert_stone",
        "coral_desert_stone_block",
        "coral_sandstone",
        "coral_sandstone_chiseled",
        "coral_sandstone_carved_1",
        "coral_white_sandstone",
        "coral_white_sandstone_pillar",
        "cursed_dream_stone",
        "cursed_lands_deep_ocean_sandstone_block",
        "cursed_sandstone_block",
        "cursed_stone",
        "cursed_stone_carved",
        "crystal_forest_deep_ocean_sandstone_block",
        "crystal_sandstone",
        "crystal_sandstone_chiseled",
        "crystal_stone",
        "forsaken_desert_stone",
        "forsaken_desert_chiseled_stone",
        "forsaken_desert_engraved_stone",
        "forsaken_tundra_stone",
        "mineral_sandstone",
        "mineral_stone",
        "quartz_block", -- MISSING
        "quartz_chiseled", -- MISSING
        "quartz_pillar", -- MISSING
        "soul_sandstone",
        "soul_sandstone_veined",
        "sulfur_stone",
    },
    mortar = {
        "coral_desert_cobble", -- MISSING
        "coral_desert_mossy_cobble", -- MISSING
        "coral_deep_ocean_sandstone_rubble",
        "coral_white_sandstone_rubble",
        "crystal_cobble",
        "crystal_mossy_cobble",
        "cursed_cobble", -- MISSING
        "cursed_cobble_with_growth", -- MISSING
        "cursed_sandstone_cobble", -- MISSING
        "cut_coral_bones_block",
        "cut_coral_deep_ocean_sandstone_block",
        "cut_coral_desert_stone",
        "cut_coral_desert_stone_block",
        "cut_coral_sandstone",
        "cut_coral_sandstone_carved_1",
        "cut_coral_sandstone_chiseled",
        "cut_coral_white_sandstone",
        "cut_coral_white_sandstone_pillar",
        "cut_cursed_dream_stone",
        "cut_cursed_lands_deep_ocean_sandstone_block",
        "cut_cursed_sandstone_block",
        "cut_cursed_stone",
        "cut_cursed_stone_carved",
        "cut_crystal_forest_deep_ocean_sandstone_block",
        "cut_crystal_sandstone",
        "cut_crystal_sandstone_chiseled",
        "cut_crystal_stone",
        "cut_forsaken_desert_stone",
        "cut_forsaken_desert_chiseled_stone",
        "cut_forsaken_desert_engraved_stone",
        "cut_forsaken_tundra_stone",
        "cut_mineral_cave_stone",
        "cut_mineral_lava_stone_dry",
        "cut_mineral_lava_stone",
        "cut_mineral_sandstone_block",
        "cut_mineral_sandstone",
        "cut_mineral_stone",
        "cut_quartz_block",
        "cut_quartz_chiseled",
        "cut_quartz_pillar",
        "cut_soul_sandstone",
        "cut_soul_sandstone_veined",
        "cut_sulfur_stone",
        "cut_volcanic_rock",
        "cut_volcanic_rock_with_magma",
        "forsaken_desert_cobble",
        "forsaken_desert_cobble_red",
        "forsaken_tundra_cobble",
        "magmacobble",
        "mineral_stone_cobble",
        "quartz_rubble", -- MISSING
    },
    pick = { -- BRICK ONLY!!!!
        "coral_bones_brick",
        "coral_sandstone_brick",
        "coral_white_sandstone_brick",
        "crystal_forest_deep_ocean_sandstone_brick",
        "crystal_mossy_brick",
        "crystal_stone_brick",
        "coral_deep_ocean_sandstone_brick", -- MISSING
        "coral_desert_stone_brick", -- MISSING
        "cursed_brick", -- MISSING
        "cursed_brick_with_growth", -- MISSING
        "cursed_lands_deep_ocean_sandstone_brick",
        "cursed_sandstone_brick", -- MISSING
        "forsaken_desert_brick",
        "forsaken_desert_brick_red",
        "forsaken_tundra_brick",
        "magmabrick",
        "mineral_cave_stone_brick", -- MISSING
    },
}

local irregularly_named_pairs = {
    coral_desert_cobble = "coral_desert_stone_brick",
    coral_desert_stone_brick = "coral_desert_cobble",
    crystal_cobble = "crystal_stone_brick",
    crystal_stone = "crystal_cobble",
    crystal_stone_brick = "crystal_cobble",
}

-- cursed_stone_carved
-- quartz_block

local stairs = {
    "slab",
    "stair",
    "stair_inner",
    "stair_outer",
}

for tool, conversions in pairs(conversions_by_tool) do
    if tool == "hammer" then
        for _, target in ipairs(conversions) do
            local is_ok = true
            
            local name = quarry_link.capitalize_firsts(target)
            local block_suffix = quarry_link.read_block_suffix(target)
            local is_block = block_suffix ~= ""
            -- minetest.log("action", "[Quarry Link] Attempting to register cut variant for "..name..", with technical name: "..target)
            minetest.register_node("quarry_link:cut_"..target, {
                description = "Cut "..name,
                tiles = {mod_name.."_"..target..".png^quarry_cut_stone"..block_suffix..".png"},
                groups = {stone = 1, falling_node = 1, dig_immediate = 2},
                drop = "quarry_link:cut_"..target,
                legacy_mineral = true,
                sounds = default.node_sound_stone_defaults(),
                on_dig = quarry.mortar_on_dig(mod_name..":"..target, {sticky = 2}),
            })

            local bad_result = "cobble"
            local is_sandstone_or_quartz = not (string.find(target, "sandstone") == nil) or not (string.find(target, "quartz") == nil)
            minetest.log("action", "[Quarry Link] target: "..target)
            if is_sandstone_or_quartz then
                bad_result = "rubble"
                minetest.log("action", "[Quarry Link] Attempting to register rubble variant for "..name..", with technical name: "..target.."_rubble")
                quarry_link.register_rubble(name, "quarry_link")
            end

            local is_irregular = irregularly_named_pairs[target] ~= nil
            bad_result = is_irregular and irregularly_named_pairs[target] or target.."_"..bad_result
            bad_result = is_block and string.gsub(bad_result, "block_", "") or bad_result
            bad_result = quarry_link.is_registered(bad_result, mod_name) and bad_result or string.gsub(bad_result, "stone_", "")
            -- minetest.log("action", "[Quarry Link] Attempting to override hammer for "..mod_name..":"..target.." with quarry_link:cut_"..target.." and "..mod_name..":"..bad_result)
            quarry.override_hammer(mod_name..":"..target, "quarry_link:cut_"..target, mod_name..":"..bad_result, {cracky = 3})

            -- minetest.log("action", "[Quarry Link] Attempting to register stairs and slab for "..mod_name..":"..target)
            quarry_link.register_cut_stone_or_block_stair_and_slab(name, "quarry_link")

            for _, stair in ipairs(stairs) do
                if (quarry_link.is_registered(stair.."_"..target, "stairs")) and (quarry_link.is_registered(stair.."_cut_"..target, "stairs")) then
                    quarry.override_hammer(
                        "stairs:"..stair.."_"..target,
                        "stairs:"..stair.."_cut_"..target,
                        "stairs:"..stair.."_"..bad_result,
                        {cracky = 3}
                    )
                end
            end

            quarry_link.clear_crafts(target, mod_name)

            -- minetest.log("action", "[Quarry Link] Attempting to register block craft recipe for cut_"..target)
            quarry_link.register_block_craft_recipe("cut_"..target)
        end
    end
    if tool == "mortar" then
        for _, target in ipairs(conversions) do
            local is_cut = string.sub(target, 1, 4) == "cut_"
            local is_cobble = not (string.find(target, "cobble") == nil)
            local is_rubble = not (string.find(target, "rubble") == nil)
            local is_irregular = irregularly_named_pairs[target] ~= nil
            local result = is_cut and string.gsub(target, "cut_", "", 1) or ""
            result = is_cobble and string.gsub(target, "cobble", "brick", 1) or result
            result = is_rubble and string.gsub(target, "rubble", "brick", 1) or result
            result = is_irregular and irregularly_named_pairs[target] or result

            if (not quarry_link.is_registered(target, mod_name)) then
                -- minetest.log("action", "[Quarry Link] Node "..mod_name..":"..target.." (target) is not registered, unable to override mortar).")
            elseif (not quarry_link.is_registered(result, mod_name)) then
                -- minetest.log("action", "[Quarry Link] Node "..mod_name..":"..result.." (result) is not registered, unable to override mortar).")
            else
                -- minetest.log("action", "[Quarry Link] Attempting to override mortar for "..mod_name..":"..target.." with "..mod_name..":"..result)
                quarry.override_mortar(mod_name..":"..target, mod_name..":"..result, {crumbly = 3, stone = 1, falling_node = 1}, {sticky = 3})
            end

            for _, stair in ipairs(stairs) do
                if (quarry_link.is_registered(stair.."_cut_"..target, "stairs")) and (quarry_link.is_registered(stair.."_"..target, "stairs")) then
                    quarry.override_mortar(
                        "stairs:"..stair.."_cut_"..target,
                        "stairs:"..stair.."_"..target,
                        {stair = 1, falling_node = 1, dig_immediate = 2},
                        {sticky = 2}
                    )
                else
                    -- minetest.log("action", "[Quarry Link] Node stairs:"..stair.."_cut_"..target.." is not registered, unable to override mortar).")
                end
            end
        end
    end
    if tool == "pick" then
        for _, target in ipairs(conversions) do
            local is_ok = true
            if not quarry_link.is_registered(target, mod_name) then
                is_ok = false
                minetest.log("error", "[Quarry Link] Node "..mod_name..":"..target.." (target) is not registered, unable to override pick).")
            end

            local is_sandstone_or_quartz = not (string.find(target, "sandstone") == nil) or not (string.find(target, "quartz") == nil)
            local result = is_sandstone_or_quartz and "rubble" or "cobble"
            local result_in_mod = result == "rubble" and "quarry_link" or mod_name
            local is_irregular = irregularly_named_pairs[target] ~= nil
            result = is_irregular and irregularly_named_pairs[target] or string.gsub(target, "brick", result)

            -- minetest.log("action", "[Quarry Link] "..target.." - "..result.." (for pick)")
            if not quarry_link.is_registered(result, result_in_mod) then
                is_ok = false
                minetest.log("error", "[Quarry Link] Node "..result_in_mod..":"..result.." (result) is not registered, unable to override pick).")
            end

            if is_ok then
                -- minetest.log("action", "[Quarry Link] Attempting to override pick for "..mod_name..":"..target.." with "..result_in_mod..":"..result)
                quarry.override_pick(mod_name..":"..target, result_in_mod..":"..result, {cracky = 2})

                for _, stair in ipairs(stairs) do
                    quarry.override_pick(
                        "stairs:"..stair.."_"..target,
                        "stairs:"..stair.."_"..result,
                        {cracky = 2}
                    )
                end
            end
        end
    end
end

--[[ local stones_with_block_variant_everness = {
    "Coral Desert Stone",
    "Mineral Stone",
}

for _,stone_name in ipairs(stones_with_block_variant_everness) do
    quarry_link.register_cut_stone_or_block(stone_name, mod_name)
    quarry_link.register_cut_stone_or_block(stone_name.." Block", mod_name)
    quarry_link.set_tools_for_stone(stone_name, mod_name, false, false)
    quarry_link.set_tools_for_stair_and_slab(stone_name, mod_name, false, conversions_by_tool)
    quarry_link.clear_crafts(stone_name, mod_name)
    quarry_link.register_block_craft_recipe(stone_name)
end ]]
