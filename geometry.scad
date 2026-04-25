edge_ln = 3.5;

_base_profile = [
    [0, 0], [edge_ln, 0], [0, edge_ln]
];

_bottom_profile = [
    [0, 0], [edge_ln + 0.15, 0], [0, edge_ln + 0.15]
];

module rect_prism(size=[1,1,1], center=false) {
    if (center) {
        translate([0, 0, -size[2]/2])
            linear_extrude(height=size[2])
                square([size[0], size[1]], center=true);
    } else {
        linear_extrude(height=size[2])
            square([size[0], size[1]], center=false);
    }
}

clip_w = 3;
clip_depth = 2;
clip_gap = 2;
clip_h = 3;
clip_base = 2;
clearance = 0.25;

module clip() {
  union() {
    translate([0, - clip_depth / 2 - clip_gap/2, 0])
      rect_prism([clip_w, clip_depth, clip_h], true);
    translate([0, clip_depth / 2 + clip_gap / 2, 0])
      rect_prism([clip_w, clip_depth, clip_h], true);
    translate([0, 0 , -clip_base])
      rect_prism([clip_w, clip_depth * 2 + clip_gap, clip_base], true);
  }
}

module clip_cutout() {
    union() {
      translate([0, - clip_depth / 2 - clip_gap/2 + clearance / 2, 0])
        rect_prism([clip_w + clearance, clip_depth + clearance, clip_h], true);
      translate([0, clip_depth / 2 + clip_gap / 2 - clearance / 2, 0])
        rect_prism([clip_w + clearance, clip_depth + clearance, clip_h], true);
      translate([0, 0 , -clip_base])
        rect_prism([clip_w + clearance, clip_depth * 2 + clip_gap, clip_base], true);
  }
}