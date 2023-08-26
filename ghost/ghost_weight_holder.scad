// This is a replacement weight holder for a sonic shaking ghost toy.
//
// There were several different designs over generations of the toy,
// and this copies one of them, but should work for any.
//
// You will probably need to drill out the holes for a good fit.
// I found a 5/16 inch drill bit was about right.
//
// You'll need to glue an approximately 9 gram weight into the cup.

base_h = 2.6; // thickness of the main part
base_l = 34.2; // how long the part is in its longest dimension
big_d = 18.5; // diameter of the big circle at one end
small_d = 4; // diameter of the small circle at the other end

cup_od = 17.7; // outer diameter of the cup that holds the weight
cup_h = 5.6; // total height (including base plate) of the cup
cup_id = cup_od - 2; // inner diameter of the recess where weight sits

support_h = 4; // total height (including base) of the extra support ridge
support_d = 4; // width of the extra support ridge

hole1_x = base_l - 0.5*(big_d + small_d); // location of the first hole
hole2_offset = 7.2; // distance between the two holes
hole2_x = hole1_x - hole2_offset;

hole_d = 1.8; // diameter of the holes

$fn=72;
difference() {
  union() {
    hull() {
      cylinder(h=base_h, d=18.5);
      translate([hole1_x,0,0]) cylinder(h=base_h, d=4);
    }
    difference() {
      cylinder(h=cup_h, d=cup_od);
      translate([0,0,base_h]) cylinder(h=cup_h, d=cup_id);
    }
    hull() {
      translate([hole1_x,0,0]) cylinder(h=support_h, d=support_d);
      translate([hole2_x,0,0]) cylinder(h=support_h, d=support_d);
    }
  };
  translate([hole1_x,0,0]) cylinder(h=support_h, d=hole_d);
  translate([hole2_x,0,0]) cylinder(h=support_h, d=hole_d);
}
