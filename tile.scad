include <BOSL2/std.scad>
include <BOSL2/skin.scad>
include <common.scad>
include <geometry.scad>

build_tree = [
    [0, 3, 8],
    [0, 4, 13],
    [2, 10, 11]
    ];
paths = tile_set(build_tree);
for (path = paths)
    path_sweep2d(base_profile, path, closed=true);