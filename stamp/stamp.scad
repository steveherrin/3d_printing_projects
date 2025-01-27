d_outer = 40;    // outer diameter of the final stamp
t_wall = 1.67;   // wall thickness for the vertical part of the stamp
h_holder = 25;   // the height of the stamp holder
h_retainer = 3;  // the height of the thinner area that the stamp goes over
r_retainer = 1;  // the radius of the retaining notch
t_stamp = 1;     // the thickness of the stamp's pad
t_art = 1;       // the thickness of the stamp's art

$fn = $preview ? 18 : 72;

module retainer(d) {
  translate([0,0,-r_retainer]) rotate_extrude(angle=360) {
    translate([0.5*(d+1), 0, 0]) circle(r=r_retainer);
  }
};

module stamp_holder(d) {
  difference() {
    // the main portion that the user holds on to
    union() {
      cylinder(h=h_holder, d=d);
      translate([0,0,-h_retainer]) cylinder(h=h_holder,d=d-2*t_wall);
    };
    // groove to make it easier to hold
    translate([0,0,20]) rotate_extrude(angle=360) {
      translate([0.5*d+0.5, 0, 0]) circle(d=2);
    }
    // retaining notch for the stamp
    retainer(d-2*t_wall);
  }
}

module stamp_base(d) {
  // the bead that goes into the retaining notch
  intersection() {
    retainer(d_outer-2*t_wall);
    translate([0,0,-h_retainer]) cylinder(d=d, h=h_retainer);
  }
  // the rest of the stamp that slips over the holder
  translate([0,0,-h_retainer]) difference() {
    cylinder(d=d, h=h_retainer);
    cylinder(d=d-t_wall, h=h_retainer);
  };
  // the flat part of the stamp on which the art will go
  translate([0,0,-h_retainer-t_stamp]) cylinder(h=t_stamp, d=d);
}

module stamp_art_flat(d) {
  difference() {
    square(d-2, center=true);
    square(d-8, center=true);
  };
  difference() {
    square(d-9, center=true);
    square(d-13, center=true);
  };
  difference() {
    square(d-15, center=true);
    square(d-17, center=true);
  };
  difference() {
    square(d-20, center=true);
    square(d-21, center=true);
  };
  rotate([0,0,45]) union() {
    difference() {
      square(d-22, center=true);
      square(d-23, center=true);
    }
    square(d-24, center=true);
  }
}

module stamp_art_test(d) {
  linear_extrude(10) stamp_art_flat(d);
}


module stamp_art(d) {
  translate([0,2,0]) scale([10,10,20]) import("pawprint.stl");
}
  

module stamp(d) {
  stamp_base(d);
  translate([0,0,-(h_retainer+t_stamp+t_art)]) intersection() {
    cylinder(h=t_art, d=d);
    stamp_art(d);
  };
}


//stamp_holder(d_outer);
stamp(d_outer);