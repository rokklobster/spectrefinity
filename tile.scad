include <BOSL2/std.scad>
include <BOSL2/skin.scad>

build_tree = [
    // [0, 12, 11],
    // [1, 12, 11],
    // [2, 12, 11]
    ];
add_clips = true;
add_holes = true;

include <parameters.scad>
include <geometry.scad>
include <common.scad>

paths = tile_set(build_tree);
outline_pts = outer_boundary(paths);

difference() {
    union() {
        for (path = paths)
            path_sweep2d(base_profile(edge_ln), path, closed=true);
    }

    if (add_clips)
        for (i = [0 : len(outline_pts)-1]) {
            let (em = edge_mid(outline_pts, i))
                translate([em[0], em[1], 0])
                    rotate(edge_angle(outline_pts, i))
                        clip_cutout(edge_ln, clearance);
        }
}