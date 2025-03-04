local stairs = {
    "slab",
    "stair",
    "stair_inner",
    "stair_outer",
}

function quarry_link.link(mod_name, conversions_by_tool, irregularly_named_pairs)
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
                -- minetest.log("action", "[Quarry Link] target: "..target)
                if is_sandstone_or_quartz then
                    bad_result = "rubble"
                    -- minetest.log("action", "[Quarry Link] Attempting to register rubble variant for "..name..", with technical name: "..target.."_rubble")
                    quarry_link.register_rubble(name, mod_name)
                end

                local is_irregular = irregularly_named_pairs[target] ~= nil
                bad_result = is_irregular and irregularly_named_pairs[target] or target.."_"..bad_result
                bad_result = is_block and string.gsub(bad_result, "block_", "") or bad_result
                bad_result = quarry_link.is_registered(bad_result, mod_name) and bad_result or string.gsub(bad_result, "stone_", "")
                -- minetest.log("action", "[Quarry Link] Attempting to override hammer for "..mod_name..":"..target.." with quarry_link:cut_"..target.." and "..mod_name..":"..bad_result)
                quarry.override_hammer(mod_name..":"..target, "quarry_link:cut_"..target, mod_name..":"..bad_result, {cracky = 3})

                if (quarry_link.is_registered("stair_"..target, "stairs")) then
                    quarry_link.register_cut_stone_or_block_stair_and_slab(name, mod_name)
                end

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
                    if (quarry_link.is_registered(stair.."_cut_"..result, "stairs")) and (quarry_link.is_registered(stair.."_"..result, "stairs")) then
                        quarry.override_mortar(
                            "stairs:"..stair.."_cut_"..result,
                            "stairs:"..stair.."_"..result,
                            {stair = 1, falling_node = 1, dig_immediate = 2},
                            {sticky = 2}
                        )
                    elseif ((is_cobble or is_rubble) and (quarry_link.is_registered(stair.."_"..target, "stairs")) and (quarry_link.is_registered(stair.."_"..result, "stairs"))) then
                        quarry.override_mortar(
                            "stairs:"..stair.."_"..target,
                            "stairs:"..stair.."_"..result,
                            {stair = 1, falling_node = 1, dig_immediate = 2},
                            {sticky = 2}
                        )
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
end
