Quarry Link [quarry_link]
===========

By gabriel1379

This mod links the mod Quarry Mechanics [ContentDB](https://content.luanti.org/packages/kestral/quarry/) [Source](https://github.com/kestral246/quarry) with other mods, to make its mechanics usable with the stone-type and resource nodes of those too.

Currently supported mods:
-------------------------
- Everness [ContentDB](https://content.luanti.org/packages/SaKeL/everness/) [Source](https://bitbucket.org/minetest_gamers/everness/src/master/)
- More Ores [ContentDB](https://content.luanti.org/packages/Calinou/moreores/) [Source](https://github.com/minetest-mods/moreores)
- Technic [ContentDB](https://content.luanti.org/packages/RealBadAngel/technic/) [Source](https://github.com/minetest-mods/technic)

Currently supported features:
-----------------------------
- The resource nodes from the above mods will behave according to Quarry Mechanics (will turn to cobble and fall after being mined).
- **Everness**: Most stones, stairs, slabs and blocks can now be quarried/pickaxed/mortarred normally with **Quarry** tools, like their default variants. However, some lack the required variants (e.g. cobble, brick, or block), so some operations may not be possible with some nodes yet; dummy images may also appear.
- **Technic**:
1. Granite and Marble can now be quarried/pickaxed/mortarred normally with **Quarry** tools, like their default variants.
2. Replaced `default:stone` with `quarry:cut_stone` in machine crafting recipes that required the former (LV compressor, LV generator).
