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
for (path = paths) {
    difference() {
        path_sweep2d(_base_profile, path, closed=true);

        for (i = [0 : len(path)-1]) {
            translate(edge_mid(path, i))
                rotate(edge_angle(path, i))
                    clip_cutout();
        }
    }
}