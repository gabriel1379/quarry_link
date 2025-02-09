-- Quarry Mechanics Link [quarry_link]
-- by Gabriel [gabriel1379@gmail.com]
-- 2025-02-09

-- This mod enables seamless integration between Quarry Mechanics and other mods' resource and stone-like nodes.

local path_own = minetest.get_modpath('quarry_link')
local mods_linked = {
    'everness',
    'technic',
}

for _,mod_linked in pairs(mods_linked) do
    dofile(path_own..'/link_'..mod_linked..'.lua')
end