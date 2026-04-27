include <BOSL2/std.scad>
include <BOSL2/skin.scad>

build_tree = [
    ];
add_clips = true;
add_holes = true;

include <parameters.scad>
include <geometry.scad>
include <common.scad>

paths = tile_set(build_tree);
for (path = paths) {
    difference() {
        path_sweep2d(base_profile(edge_ln), path, closed=true);

        if (add_clips)
            for (i = [0 : len(path)-1]) {
              let (em = edge_mid(path, i))
                translate([em[0], em[1], 0])
                    rotate(edge_angle(path, i))
                        clip_cutout(edge_ln, clearance);
        }
    }
}