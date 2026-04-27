include <BOSL2/std.scad>
include <BOSL2/skin.scad>

build_tree = [
    [0, 4, 13],
    [1, 10, 11]
    ];

height = 35;
bottom = 5;
wall = 1.5;
rim_height = 2;
rim_gap = 0.5;
preview = true;

include <parameters.scad>
include <common.scad>
include <geometry.scad>

paths = tile_set(build_tree);
outline_pts = outer_boundary(paths);

if (preview){
    for (p = paths)
        path_sweep2d(base_profile(edge_ln), p, closed=true);
}
else {
    difference() {
      translate([0, 0, 0.1])
        linear_extrude(height = height - 0.1)
            offset(delta = -0.1)
                polygon(points = outline_pts);

        translate([0, 0, bottom])
            linear_extrude(height = height - bottom - rim_height + 0.01)
                offset(delta = -wall)
                    polygon(points = outline_pts);

        translate([0, 0, height - rim_height])
            linear_extrude(height = rim_height + 0.01)
                offset(delta = -(wall + rim_gap))
                    polygon(points = outline_pts);
        
        for (p = paths)
            path_sweep2d(base_profile(edge_ln), p, closed=true);
    }
}