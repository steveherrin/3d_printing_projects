// This is a replacement weight holder for a sonic shaking ghost toy.
//
// There were several different designs over generations of the toy,
// and this copies one of them, but should work for ones with a
// T-shaped weight that goes completely through a hole.
//
// You will probably need to drill out the holes for a good fit.
// I found a 5/16 inch drill bit was about right.
//
// You will need to glue the weight in.

base_h = 2.1;
base_l = 33 - 0.5*(6.2+13);
big_d = 16;
small_d = 12.7;

disc_d = 22.7;

support_h = 5.1;
support_d = 6.2;

hole_d = 1.8;
weight_d = 14;

$fn = $preview ? 24 : 72;


difference() {
  union() {
    hull() {
      translate([4,0,0]) cylinder(h=base_h, d=big_d);
      translate([base_l,0,0]) cylinder(h=base_h, d=small_d);
    }
    cylinder(h=base_h, d=disc_d);
    translate([base_l,0,0]) cylinder(h=support_h, d=support_d);
  }
  cylinder(h=base_h, d=weight_d);
  translate([base_l,0,0]) cylinder(h=support_h, d=hole_d);
}
