include <BOSL2/std.scad>
include <BOSL2/skin.scad>

build_tree = [
    ];

include <parameters.scad>
include <geometry.scad>
include <common.scad>

paths = tile_set(build_tree);
for (path = paths) {
    union() {
      difference() {
          path_sweep2d(base_profile(edge_ln), path, closed=true);
  
          for (i = [0 : len(path)-1]) {
            let (em = edge_mid(path, i))
              translate([em[0], em[1], 0])
                rotate(edge_angle(path, i))
                  clip_cutout(edge_ln, clearance);
          }
      }

      for (i = [0 : len(path)-1]) {
        let (em = edge_mid(path, i))
          translate([em[0], em[1], 0])
            rotate(edge_angle(path, i))
              clip(edge_ln, clearance);
      }
    }
}