thickness = 8;
slotted = false;

blind_spacer(h=thickness, slotted=slotted, $fn=18);


module blind_spacer(h, slotted=false) {
  size = [36, 32, h];
  hole_xy = [12, 10];
  hole_d = 4.8;
  
  if (slotted) {
    blind_spacer_slotted(size, hole_xy, hole_d);
  } else {
    blind_spacer_holes(size, hole_xy, hole_d);
  };
};


module rounded_cube(size, r, center=true) {
  minkowski() {
    cube(size - 2*r*[1, 1, 1], center=center);
    sphere(r=r);
  };
};


module blind_spacer_slotted(size, hole_xy, hole_d) {
  h = size.z;
  hole_x = hole_xy.x;
  hole_y = hole_xy.y;
  difference() {
    rounded_cube(size, r=1, center=true);
    hull() {
      translate([hole_x, -hole_y, 0]) cylinder(h=h+1, d=hole_d, center=true);
      translate([-hole_x, -hole_y, 0]) cylinder(h=h+1, d=hole_d, center=true);
    };
    hull() {
      translate([hole_x, hole_y, 0]) cylinder(h=h+1, d=hole_d, center=true);
      translate([-hole_x, hole_y, 0]) cylinder(h=h+1, d=hole_d, center=true);
    };
  };
};


module blind_spacer_holes(size, hole_xy, hole_d) {
  h = size.z;
  hole_x = hole_xy.x;
  hole_y = hole_xy.y;
  difference() {
    rounded_cube(size, r=1, center=true);
    translate([hole_x, -hole_y, 0]) cylinder(h=h+1, d=hole_d, center=true);
    translate([-hole_x, -hole_y, 0]) cylinder(h=h+1, d=hole_d, center=true);
    translate([hole_x, hole_y, 0]) cylinder(h=h+1, d=hole_d, center=true);
    translate([-hole_x, hole_y, 0]) cylinder(h=h+1, d=hole_d, center=true);
  };
};