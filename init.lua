-- Quarry Mechanics Link [quarry_link]
-- by Gabriel [gabriel1379@gmail.com]
-- 2025-02-09

-- This mod enables seamless integration between Quarry Mechanics and other mods' resource and stone-like nodes.

-- Definitions made by this mod that other mods can use too
quarry_link = {}

local path_own = minetest.get_modpath("quarry_link")

local function_files = {
    "functions_util.lua",
    "functions.lua",
    "functions_linker.lua",
}

for _,function_file in ipairs(function_files) do
    dofile(path_own.."/"..function_file)
end

local mods_linked = {
    "everness",
    "technic",
}

for _,mod_linked in ipairs(mods_linked) do
    dofile(path_own.."/link_"..mod_linked..".lua")
end