// TODO
// 1. Test the support for the PCB
// 2. Test the lower panel position
// 3. Either go with the lower panel position or fix the too-thin
//    support square for the upper position
// 4. If going with the upper position, modify the support to
//    build on top of the belly


module dog(scale_f=1) {
  difference() {
    scale(scale_f*[1,1,1]) import("akita_centered_outer.stl", convexity=8);
    scale(scale_f*[1,1,1]) import("akita_centered_inner_2mm_noleg.stl", convexity=8);
    // water drainage hole, lol
    translate(scale_f*[0,53.5,-64.8]) rotate([90,0,0]) cylinder(h=10, r=2*scale_f, $fn=12);
  };
}

module solar_additive() {
  translate([0,0,26.6]) rotate([0,0,45])
  difference() {  // "shelf" for the panel to rest on
    cube([25,25,1.2], center=true);
    cube([20,20,1.5], center=true);
  };
}

module solar_board_holder() {
  translate([0, 35, -58])
  difference() {
    cube([19, 15, 20], center=true);
    for (x = [-6, 0, 6]) {
      translate([x, 0, 0]) union() {
        translate([0,0,-3]) cube([4.5, 21, 13], center=true);
        translate([0,0,3.5]) rotate([90,0,0]) cylinder(h=25, d=4.5, center=true, $fn=18);
      };
    };
    translate([0,0,8]) union() {
      cube([16, 17, 2], center=true);
      translate([0,0,2]) cube([14, 17, 4], center=true);
    };
  };
}


module solar_board() {
  translate([0, 30, -45]) union() {
    cube([15,30,12], center=true);
    cylinder(h=20, d=6);
  };
}


module solar_subtractive() {
   translate([0,0,31]) rotate([0,0,45]) cube([25,25,7], center=true);
   translate([0,0,25]) rotate([0,0,45]) cube([20,20,13], center=true);
}


module solar(location, rotation) {
  // put a hole suitable for mounting a solar panel in the children
  union() {
    for ( i = [0:1:$children-1] ) {  // step needed in case $children < 2  
      difference() {
        children(i);
        translate(location) rotate(rotation) solar_subtractive();
      };
    };
    translate(location) rotate(rotation) solar_additive();
  };
}

//rotate([0,0,45]) 
difference() {
  //solar(location=[0, -22, 20], rotation=[-58, 0, 0]) {  // higher option but this isn't quite right and prints with a hole
  solar(location=[0, 23, -38], rotation=[-56, 0, 0]) {  // lower option
    dog();
    solar_board_holder();  // lower option only so far
    //%solar_board();
  };
  //translate([10,-100,-80]) cube([40,200,200], center=false);  // see a cross-section
};


//difference() {
//  solar_additive();
//  solar_subtractive();
//}


//solar_board_holder();
//translate([0, 35, -68.5]) cube([19, 15, 2], center=true);
