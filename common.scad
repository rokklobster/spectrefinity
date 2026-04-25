edge_len = 16;

_tile_path = [0, -2, 1, 3, 3, 5, 2, 4, 7, 9, 6, 8, 11, 9];

function edge_vec(k, s=1) = [s * cos(30 * k), s * sin(30 * k)];
    
tile_vecs = [
    for (t = _tile_path)
        edge_vec(t, edge_len)
    ];

function partial_sum(vs, i, acc=[0,0]) =
    i <= 0 
        ? acc
        : sum([for (j = [0:i-1]) vs[j]]);
            
tile_vertices = [
    for (i = [0 : len(tile_vecs) - 1])
        partial_sum(tile_vecs, i)
    ];
    
function vsub(a,b) = [a[0]-b[0], a[1]-b[1]];
function vadd(a,b) = [a[0]+b[0], a[1]+b[1]];
function rot(v, a) = [
    v[0]*cos(a) - v[1]*sin(a),
    v[0]*sin(a) + v[1]*cos(a)
];
    
function edge_start(pts, i) = pts[i];
function edge_end(pts, i) = pts[(i+1) % len(pts)];
function edge_from_pts(pts, i) = vsub(edge_end(pts,i), edge_start(pts,i));

function angle_of(v) = atan2(v[1], v[0]);
    
function connect(parent_pts, parent_edge_idx, child_edge_idx) =
    let(
        pv = edge_from_pts(parent_pts, parent_edge_idx),
        cv = edge_from_pts(tile_vertices, child_edge_idx),

        ang = angle_of(pv) - angle_of(cv) + 180,

        child_rot = [for (p = tile_vertices) rot(p, ang)],

        p0 = edge_start(parent_pts, parent_edge_idx),
        p1 = edge_end(parent_pts, parent_edge_idx),

        c0 = edge_start(child_rot, child_edge_idx),
        c1 = edge_end(child_rot, child_edge_idx),

        shift = vsub(p1, c0)
    )
    [for (p = child_rot) vadd(p, shift)];

function tail(ss) = len(ss) <= 1 ? [] : [for (i=[1 : len(ss) - 1]) ss[i]];

function tile_set(instructions, acc=[tile_vertices]) =
    len(instructions) < 1
        ? acc
        : let (
            head = instructions[0],
            parent = acc[head[0]],
            this_tile = connect(parent, head[1], head[2])
            ) tile_set(
                tail(instructions),
                concat(acc, [this_tile]));

/*
outline of a tile set - for a bucket
*/

function dist2(a, b) =
    (a[0]-b[0])*(a[0]-b[0]) + (a[1]-b[1])*(a[1]-b[1]);

function pt_eq(a, b, eps=1e-5) =
    dist2(a, b) < eps*eps;

function tile_edges(tile) =
    let(l = len(tile))
    [for (i = [0 : l-1])
        [tile[i], tile[(i+1) % l]]
    ];

function all_edges(tiles) =
    [for (t = tiles) each tile_edges(t)];

function edge_rev(e) = [e[1], e[0]];

function edge_eq(e1, e2, eps=1e-5) =
    pt_eq(e1[0], e2[0], eps) && pt_eq(e1[1], e2[1], eps);

function has_reverse(edges, i, eps=1e-5) =
    let(rev = edge_rev(edges[i]))
    len([
        for (j = [0 : len(edges)-1])
            if (j != i && edge_eq(edges[j], rev, eps))
                1
    ]) > 0;

function outer_edges(edges, eps=1e-5) =
    [
        for (i = [0 : len(edges)-1])
            if (!has_reverse(edges, i, eps))
                edges[i]
    ];

function contains_idx(arr, x) =
    len([for (v = arr) if (v == x) 1]) > 0;

function find_next_edge_any(edges, p, used, eps=1e-5) =
    let(candidates = [
        for (i = [0 : len(edges)-1])
            if (!contains_idx(used, i) &&
                (pt_eq(edges[i][0], p, eps) || pt_eq(edges[i][1], p, eps)))
                i
    ])
    len(candidates) == 0 ? -1 : candidates[0];

function orient_edge_from_point(e, p, eps=1e-5) =
    pt_eq(e[0], p, eps) ? e :
    pt_eq(e[1], p, eps) ? [e[1], e[0]] :
    undef;

function build_loop(edges, current_p, start_p, used=[], pts=[], eps=1e-5, guard=0) =
    guard > len(edges) + 5 ? pts :
    let(
        next_idx = find_next_edge_any(edges, current_p, used, eps)
    )
    next_idx == -1 ? pts :
    let(
        e = orient_edge_from_point(edges[next_idx], current_p, eps),
        next_p = e[1],
        used2 = concat(used, [next_idx]),
        pts2 = concat(pts, [current_p])
    )
    (len(pts2) > 1 && pt_eq(next_p, start_p, eps))
        ? pts2
        : build_loop(edges, next_p, start_p, used2, pts2, eps, guard + 1);
    
function outer_boundary(tiles, eps=1e-5) =
    let(
        edges = all_edges(tiles),
        out = outer_edges(edges, eps),
        start_p = out[0][0]
    )
    build_loop(out, start_p, start_p, [], [], eps);