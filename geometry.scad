function base_profile(p_edge_length) = [
    [0, 0], [p_edge_length, 0], [0, p_edge_length]
];

function bottom_profile(p_edge_length, p_clearance) = [
    [0, 0], [p_edge_length + p_clearance, 0], [0, p_edge_length + p_clearance]
];

function clip_profile(p_edge_length, p_clearance) =
    let(
        c1 = p_edge_length,
        c2 = p_edge_length * 0.2,
        r1 = p_edge_length - p_clearance / 2,
        r2 = p_edge_length / 6)
    [
        [-c1, r1], [c1, r1], [c1, r2], [c2, r2], [c2, -r2], [c1, -r2],
        [c1, -r1], [-c1, -r1], [-c1, -r2], [-c2, -r2], [-c2, r2], [-c1, r2]
    ];

module base_profile_cutout(p_edge_length, p_clearance, orient=0) {
    rotate([0, 90, 180 * orient])
      translate([-p_edge_length, -p_edge_length, 0])
        linear_extrude(height=p_edge_length * 2 + 1, center = true)
          polygon(bottom_profile(p_edge_length, p_clearance));
}

module clip(p_edge_length, p_clearance) {
  difference() {
    translate([0, 0, 0])
      linear_extrude(height=p_edge_length * 0.4)
        polygon(clip_profile(p_edge_length, p_clearance));
    base_profile_cutout(p_edge_length, p_clearance, 0);
    base_profile_cutout(p_edge_length, p_clearance, 1);
  }
}

module clip_cutout(p_edge_length, p_clearance) {
    union() {
        scale([1 + p_clearance / 2 / p_edge_length, 1, 1])
            clip(p_edge_length, p_clearance);
        base_profile_cutout(p_edge_length, p_clearance, 0);
        base_profile_cutout(p_edge_length, p_clearance, 1);
    }
}