// TODO
// 1. decide if there's more I want to do about the lip for the board holder
// 2. think about water ingress. coat the board? where will drips go?
// 3. full print


solar_option = "butt"; // [all, chest, butt, support_only]
peek_inside = false;


module inner_dog() {
  import("akita_centered_inner_2mm_noleg.stl", convexity=8);
}


module outer_dog() {
  import("akita_centered_outer.stl", convexity=8);
}


module water_drainage_hole() {
  translate([0,53.5,-64.8]) rotate([90,0,0]) cylinder(h=10, r=2, $fn=12);
}


module solar_board_holder(height) {
  difference() {
    translate([-9.5, -7.5, 0])
    cube([19, 15, height-4]);
    for (x = [-6, 0, 6]) {
      translate([x, 0, 0]) union() {
        translate([-2.25,-10,-1]) cube([4.5, 20, height-7], center=false);
        translate([0,10,height-8.25]) rotate([90,0,0]) cylinder(h=20, d=4.5, center=false, $fn=18);
      };
    };
    translate([0, 4, height-7]) cylinder(d=1.8, h=4, $fn=18);
  };
}

module solar_board_holder_lip(height) {
  difference() {
    translate([-9.5, -7.5, 0])
    cube([19, 15, height]);
    for (x = [-6, 0, 6]) {
      translate([x, 0, 0]) union() {
        translate([-2.25,-10,-1]) cube([4.5, 20, height-7], center=false);
        translate([0,10,height-8.25]) rotate([90,0,0]) cylinder(h=20, d=4.5, center=false, $fn=18);
      };
    };
    translate([-8,-8.5,height-4]) union() {
      cube([16, 17, 3], center=false);
      translate([1,0,2]) cube([14, 17, 3], center=false);
    };
    translate([0, 4, height-7]) cylinder(d=1.8, h=4, $fn=18);
  };
}


module butt_solar_board_holder() {
  intersection() {
    outer_dog();
    translate([0, 35, -68]) solar_board_holder(20);
  };
  //%translate([0, 30, -45]) solar_board();
}


module chest_solar_board_holder() {
  intersection() {
    outer_dog();
    translate([0,-25,-30]) solar_board_holder(30);
  };
  //%translate([0, -20, 2]) solar_board();
}


module solar_board() {
  // to check clearances; not used in print
  union() {
    cube([15,30,12], center=true);
    cylinder(h=20, d=6);
  };
}


module solar_additive(hole_size=20) {
  // extra support "shelf" so the panel has something to rest on
  shelf_i = hole_size - 6;
  shelf_o = shelf_i + 2*1.732;
  translate([0,0,26.5]) rotate([0,0,45])
  polyhedron(
    [
      [-shelf_i,-shelf_i,-1], [shelf_i,-shelf_i,-1], [shelf_i,shelf_i,-1], [-shelf_i,shelf_i,-1],
      [-shelf_o,-shelf_o,2], [shelf_o,-shelf_o,2], [shelf_o,shelf_o,2], [-shelf_o,shelf_o,2],
    ], [
      [0,1,2,3], [4,5,1,0], [7,6,5,4],
      [5,6,2,1], [6,7,3,2], [7,4,0,3],
    ]
  );
}


module solar_subtractive(hole_size=20) {
   translate([0,0,31]) rotate([0,0,45]) cube([25,25,7], center=true);
   translate([0,0,25]) rotate([0,0,45]) cube([hole_size,hole_size,13], center=true);
}


module solar(location, rotation, hole_size=20) {
  // put a hole suitable for mounting a solar panel in the children
  // first child is the outer model, second is the inside
  difference() {
    children(0);
    difference() {
      children(1);
      // by subtracting the extra material from the model we're using
      // to hollow it out, we add it to the model, but cleanly so
      // it doesn't overhang the outer model
      translate(location) rotate(rotation) solar_additive(hole_size);
    };
    translate(location) rotate(rotation) solar_subtractive(hole_size);
  };
}

module for_test_print() {
  // so I can just print the part where the solar panel goes to test fit
  difference() {
    intersection() {
      children(0);
      translate([0, 32, -39]) cube([70,64,68], center=true);
    };
    translate([0,64,-15]) sphere(r=15);
  };
}


//rotate([0,0,45])
//for_test_print() {
difference() {
  union() {
    intersection() {
      if (solar_option == "all" || solar_option == "chest") {
        solar(location=[0, -21.5, 19], rotation=[-57.5, 0, 0], hole_size=17) {
          outer_dog();
          inner_dog();
        };
      };
      if (solar_option == "all" || solar_option == "butt") {
        solar(location=[0, 22, -39], rotation=[-56, 0, 0], hole_size=20) {
          outer_dog();
          inner_dog();
        };
      };
    };
    if (solar_option == "all" || solar_option == "chest") {
      chest_solar_board_holder();
    };
    if (solar_option == "all" || solar_option == "butt") {
      butt_solar_board_holder();
    };
  };
  water_drainage_hole();
  if (peek_inside) {
    translate([10,-100,-80]) cube([40,200,200], center=false);  // see a cross-section
  };
};
//};

if (solar_option == "support_only") {
  solar_board_holder(15);
  translate([0, 0, 1]) cube([19, 15, 2], center=true);
};
