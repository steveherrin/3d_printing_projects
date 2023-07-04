// TODO
// 1. Test the support for the PCB
// 2. Print with the "all" option and see what you like better
// 3. Look at what inductor is used, consider swapping to a
//    smaller size


solar_option = "all"; // [all, chest, butt, support_only]
peek_inside = false;


module inner_dog() {
  import("akita_centered_inner_2mm_noleg.stl", convexity=8);
};


module outer_dog() {
  import("akita_centered_outer.stl", convexity=8);
};


module dog() {
  difference() {
    outer_dog();
    inner_dog();
    // water drainage hole, lol
    translate([0,53.5,-64.8]) rotate([90,0,0]) cylinder(h=10, r=2, $fn=12);
  };
}


module solar_board_holder(h) {
  difference() {
    translate([-9.5, -7.5, 0])
    cube([19, 15, h]);
    for (x = [-6, 0, 6]) {
      translate([x, 0, 0]) union() {
        translate([-2.25,-10,-1]) cube([4.5, 20, h-7], center=false);
        translate([0,10,h-8.25]) rotate([90,0,0]) cylinder(h=20, d=4.5, center=false, $fn=18);
      };
    };
    translate([-8,-8.5,h-4]) union() {
      cube([16, 17, 3], center=false);
      translate([1,0,2]) cube([14, 17, 3], center=false);
    };
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
  union() {
    cube([15,30,12], center=true);
    cylinder(h=20, d=6);
  };
}


module solar_additive() {
  translate([0,0,26.6]) rotate([0,0,45])
  difference() {  // "shelf" for the panel to rest on
    cube([25,25,1.2], center=true);
    cube([20,20,1.5], center=true);
  };
}


module solar_subtractive(hole_size=20) {
   translate([0,0,31]) rotate([0,0,45]) cube([25,25,7], center=true);
   translate([0,0,25]) rotate([0,0,45]) cube([hole_size,hole_size,13], center=true);
}


module solar(location, rotation, hole_size=20) {
  // put a hole suitable for mounting a solar panel in the children
  union() {
    for ( i = [0:1:$children-1] ) {  // step needed in case $children < 2  
      difference() {
        children(i);
        translate(location) rotate(rotation) solar_subtractive(hole_size);
      };
    };
    //translate(location) rotate(rotation) solar_additive();
  };
}


//rotate([0,0,45])
difference() {
  union() {
    intersection() {
      if (solar_option == "all" || solar_option == "chest") {
        solar(location=[0, -20.5, 20], rotation=[-57.5, 0, 0], hole_size=17) {
          dog();
        };
      };
      if (solar_option == "all" || solar_option == "butt") {
        solar(location=[0, 23, -38], rotation=[-56, 0, 0], hole_size=20) {
          dog();
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
  if (peek_inside) {
    translate([10,-100,-80]) cube([40,200,200], center=false);  // see a cross-section
  };
};

if (solar_option == "support_only") {
  solar_board_holder(20);
  translate([0, 0, 1]) cube([19, 15, 2], center=true);
};
