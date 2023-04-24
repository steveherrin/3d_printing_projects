// Stereographic Projection Lamp (customizable)
// by SaberTail, 2022


// This file defines a 3D printable lamp. It prints in two halves, a
// base and a shade. The base can be supported by a separately printed
// stand or hung from a hanger. In addition to the parts in this file,
// the lamp requires a 20 mm "star emitter" LED, 3x M3x8 screws, 3x M3
// nuts, and wiring to connect the LED to a power supply.
//
// This file is customizable. A lamp can be made to project any pattern
// of simple polygons. Examples of hexagons and squares are included. If
// you have sets of 2D points defining the polygons you want to project,
// you can follow the examples here to cut them out of the shade.
//
// Compiling the shade can take a while (roughly an hour on my machine)


// pick a component from
//   * "all": a fully assembled lamp.
//   * "shade": the top portion of the lamp, with the pattern cut out.
//   * "base": the base of the lamp with LED holder. Supports the shade.
//   * "stand": a stand for holding the lamp, so that it projects upward.
//   * "hanger": a hanger for holding the lamp, so that it projects downward.
//   * "preview": a preview of the pattern that will be projected
component = "all";
// pick a pattern from
//   * "hex": a hexagonal pattern
//   * "square": a square pattern
pattern = "hex";


// Constants that define the overall dimensions.
// You can try adjusting these but not all combinations may produce a printable object.
diameter = 160;  // the diameter of the lamp
shade_thickness = 4;  // thickness of the shell of the shade
stand_thickness = 2;  // thickness of the base of the stand/hanger
base_fraction = .25;  // the fraction of the sphere that is support legs, and not pattern
base_leg_thickness = 8;  // thickness of the legs that support the shade
base_leg_width = 10;  // width of the legs that support the shade
led_holder_diameter = 32; // diameter of the cylinder that holds the LED

radius = diameter / 2;


// ********************
// * HELPER FUNCTIONS *
// ********************

// for a polygon, what (x, y) point is at angle theta relative to an offset
function n_gon_point(n_sides, theta, theta_offset) =
    let (r = cos(180 / n_sides) / cos (theta % (360/n_sides) - 180/n_sides))
    [r * cos(theta - theta_offset), r * sin(theta - theta_offset)];

// a bunch of points on the perimeter of a polygon        
function n_gon(n_sides, center=[0,0], r=1, theta_offset=0) =
    [for (theta = [0:6:359]) center + r * n_gon_point(n_sides, theta, theta_offset)];

// stereographically project an (x, y) point to a 3D point on the sphere
function stereographic_project(point) = 
    let (l = 1 + point.x^2 + point.y^2)
    [2 * point.x / l, 2 * point.y / l, (2 - l) / l];

// map a point to one just outside of the sphere
function outer_vertex(point) =
    let (sphere_pt = stereographic_project(point))
    radius * sphere_pt + 4 * shade_thickness * sphere_pt / norm(sphere_pt);

// map a point to one just inside the sphere   
function inner_vertex(point) =
    let (sphere_pt = stereographic_project(point))
    radius * sphere_pt - 4 * shade_thickness * sphere_pt / norm(sphere_pt);

// if a point is fractionally r out axially, what height is it
// r is in units of diameters
function fractional_r_to_z(r) =
    0.5 - 0.5*sqrt(1 - (2*r)^2);

// if a point is fractionally up z, what axial radius is it at
// z is in units of diameters
function fractional_z_to_r(z) =
    sqrt(z - z^2);

// *****************
// * SHADE MODULES *
// *****************

// Generate points for a bunch of hexagons
function hex_shapes() =
    let (spacing = 0.12,
         shape_size = 0.10,
         n_rows = 19,
         out_to_distance = 1.5,
         center = [(n_rows % 2)*spacing, (n_rows-1)*0.5*sqrt(3)*spacing]
    )
    [
        for (u = [0:(n_rows-1)], v = [0:(n_rows-1)])
            let (x = (u-v)*1.5*spacing - center.x, 
                 y = (u+v)*0.5*sqrt(3)*spacing - center.y
            )
            if (x^2 + y^2 < out_to_distance^2)
                n_gon(6, r=shape_size, center=[x, y])
    ];

// Generate points for a bunch of squares
function square_shapes() =
    let (spacing = 0.14,
         shape_size = 0.08,
         n_rows = 22,
         out_to_distance = 1.5,
         center = [0.5 * n_rows * spacing, 0.5 * n_rows * spacing]
    )
    [
        for (x_i = [0:(n_rows-1)], y_i = [0:(n_rows-1)])
            let (x = x_i*spacing - center.x, 
                 y = y_i*spacing - center.y
            )
            if (x^2 + y^2 < out_to_distance^2)
                n_gon(4, r=shape_size, center=[x, y], theta_offset=45)
    ];
            
function projection_shapes() =
    (pattern == "hex") ? hex_shapes() :
    (pattern == "square") ? square_shapes() :
    // You can add your own pattern here. Provide a list of shapes you want
    // to project. Each shape is a list of points on the perimeter.
    // For example [ [[0,0],[0,-1],[-1,0]], [[0,0],[1,0],[1,1],[0,1]] ]
    // Ideally add more points on the perimeter than just the vertices 
    // or you may get distortions.
    echo("Invalid pattern");

// map a set of points in a polygon to a polyhedron that, when
// subtracted from a spherical shell, will stereographically
// project that polygon
module points_to_punchout(points) {
    n = len(points);
    inner_vertices = [for (point = points) inner_vertex(point)];
    outer_vertices = [for (point = points) outer_vertex(point)]; 
    inner_face = [for (i = [0:1:(n-1)]) i];
    outer_face = [for (i = [0:1:(n-1)]) 2*n - i - 1];
    other_faces = concat(
        [for (i = [0:1:(n-2)]) [n + i, n + i + 1, i + 1, i]],
        [[2 * n - 1, n, 0, n - 1]]
    );
    vertices = concat(inner_vertices, outer_vertices);
    faces = concat([inner_face], other_faces, [outer_face]);
    polyhedron(vertices, faces);
}

// subtract this from the spherical shade
module punchouts() {
    shapes = projection_shapes();
    for (shape = shapes) {
        points_to_punchout(shape);
    }
}

// a preview of what will be projected
module preview() {
    shapes = projection_shapes();
    scale([100, 100, 0]) {
        for (shape = shapes) {
            polygon(shape);
        }
    }
}

// a peg that is part of the base and mates with a hole on the shade
module attachment_peg(center, scale_factor) {
    peg_height = 3;
    translate(center)
        scale([scale_factor, scale_factor, scale_factor])
            translate([0, 0, peg_height/2])
                cube([0.6*base_leg_width,2.5,peg_height], center=true);
}

// a piece on the shade that attaches to the base
module shade_attachment() {
    width = 5;
    height = 4;
    point = [
        0,
        diameter*fractional_z_to_r(base_fraction) - width/2,
        diameter*base_fraction + height/2,
    ];
    difference() {
        union() {
            translate(point) cube([base_leg_width, width, height], center=true);
            translate([point.x, point.y+width/2, point.z+height/4]) cube([base_leg_width, 2, height/2], center=true);
        }
        attachment_peg([point[0], point[1], point[2]-height/2], 1.15);
    }
}

module shade() {
    translate([0,0,radius])
    union() {
        rotate([0,0,30]) // adjust this if the attachment points aren't in good spots
        difference() {
            sphere(d=diameter + shade_thickness/2, $fn=180);
            sphere(d=diameter - shade_thickness/2, $fn=180);
            translate([0,0,(base_fraction-1.5)*diameter]) cube(2*diameter, center=true);
            punchouts();
        }
    }
    for (theta = [0:60:359]) {
        rotate([0,0,theta])
            shade_attachment();
    }
}

// ****************
// * BASE MODULES *
// ****************

// helps attach the base leg to the led holder
module leg_support() {
    translate([-base_leg_width/2,4,0])
    rotate([0,90,0])
    linear_extrude(base_leg_width) polygon([[4.8,-5], [-2,-5], [-3.2,3]]);
}

// a pair of legs that hold the shade up
module base_leg_pair() {
    offset = base_leg_thickness-shade_thickness/2;
    union() {
        difference() {
            intersection() {
                translate([0,0,radius]) difference() {
                    sphere(d=diameter + shade_thickness/2, $fn=180);
                    sphere(d=diameter - offset, $fn=180);
                }
                scale([1,1,base_fraction]) translate([0, 0, radius]) cube([base_leg_width, 1.1*diameter, diameter], center=true);
            }
            cylinder(h=10, d=led_holder_diameter, center=true);
        }
        translate([0,led_holder_diameter/2,0]) leg_support();
        translate([0,-led_holder_diameter/2,0]) rotate([0,0,180]) leg_support();
        base_attachment();
        rotate([0,0,180]) base_attachment();
    }
}

// attaches the base to the shade
module base_attachment() {
    width = 5;
    corner = [fractional_z_to_r(base_fraction) - width/diameter, base_fraction];
    points = diameter * [
        corner,
        [corner[0], fractional_r_to_z(corner[0])],
        [fractional_z_to_r(base_fraction), corner[1]]
    ];
    union() {
        translate([-base_leg_width/2, 0, 0]) rotate([90,0,90]) linear_extrude(base_leg_width) polygon(points);
        attachment_peg([0, diameter*fractional_z_to_r(base_fraction) - width/3, base_fraction*diameter], 1);
    }
}

// holes for the screws to go through the LED holder
module screw_holes() {
    for (theta = [-120, 0, 120]) {
        rotate([0,0,theta]) translate([0,9.5,0]) cylinder(h=8, d=3.2, $fn=36);
    }
}

// little pegs to help hold the LED in place
module led_pegs() {
    for (theta = [-60, 60, 180]) {
        rotate([0,0,theta]) translate([0,9.5,1]) cylinder(h=1, d=3.0, $fn=36);
    }
}

// a cup to hold the LED in place and partially shade it around the edges
module led_holder() {
    shield_height = 14.2;
    translate([0,0,-1.6])
        difference() {
            union() {
                difference() {
                    cylinder(h=shield_height, d=led_holder_diameter, $fn=36);
                    translate([0, 0, 1]) cylinder(h=shield_height+1, d=25.6, $fn=36);
                    cylinder(h=1, d=15, $fn=36);
                    rotate([0,0,-30]) screw_holes();
                }
                rotate([0,0,-30]) led_pegs();
        }
        translate([led_holder_diameter/2-5, 0, 6]) rotate([0,90,0]) cylinder(h=8,d=5,$fn=36);
    }
}

// the bottom half of the lamp; should be interchangeable between patterns
module base() {
    base_leg_pair();
    rotate([0,0,120]) base_leg_pair();
    rotate([0,0,-120]) base_leg_pair();
    translate([0,0,-3.3]) led_holder();
}

// **********************
// * ATTACHMENT MODULES *
// **********************

// a plate that can connect to the base of the lamp for supporting it
module stand_plate() {
    difference() {
        cylinder(h=stand_thickness, d=led_holder_diameter, $fn=36);
        cylinder(h=stand_thickness, d=15, $fn=36);
        screw_holes();
    }
}

// a 3-legged stand designed to hold the lamp pointing upward
module stand() {
    stand_leg_width = 15;
    stand_leg_height = 20;
    stand_leg_thick = 4;
    translate([0,0,-9 + stand_thickness]) 
    union() {
        stand_plate();
        for (theta = [30, 150, 270]) {
            rotate([0,0,theta])
            translate([8, stand_leg_width/2, 0])
            rotate([0,90,-90])
            linear_extrude(stand_leg_width)
            polygon([
                [0,0],
                [0,stand_leg_thick],
                [stand_leg_height, stand_leg_height+stand_leg_thick],
                [stand_leg_height, stand_leg_height]
            ]);
        }
    }
}

// a circular hanger designed to hold the lamp pointing downward
module hanger() {    
    stand_plate();
    // this should not interfere too much with the screw holes
    rotate([0,0,30]) intersection() {
        translate([0,0,led_holder_diameter/2]) cube(led_holder_diameter, center = true);
        translate([0,0,0.25*led_holder_diameter]) rotate([90,0,30]) rotate_extrude() translate([led_holder_diameter/2 - 2, 0, 0]) square(stand_thickness*[1.5, 4], center=true);
    };
}


if (component == "all") {
    shade();
    base();
    stand();
} else if (component == "shade") {
    shade();
} else if (component == "base") {
    base();
} else if (component == "stand") {
    stand();
} else if (component == "hanger") {
    hanger();
} else if (component == "preview") {
    preview();
}