// holds a lens, like from a pair of reading glasses,
// for use in projecting an image of the sun

lens_widest = 42;
lens_aperture = 33;
height = 50.8;
wall_thickness = 2.5;
base_thickness = 1.8;
shield_width = 60;


module tube() {
  $fn=72;
  difference() {
    union() {
      cylinder(h=height, d=lens_widest + wall_thickness);
      cylinder(h=base_thickness, d=(lens_widest + wall_thickness + shield_width));
    };
    translate([0, 0, base_thickness]) cylinder(h=height, d=lens_widest);
    translate([0, 0, -1]) cylinder(h=height + 2, d=lens_aperture);
  };
  
};

module plug() {
  $fn=72;
  difference() {
    cylinder(d=lens_widest - 0.1, h=base_thickness);
    translate([0, 0, -1]) cylinder(d=lens_aperture, h=base_thickness + 2);
  };
};


translate([2*lens_widest, 0, 0]) plug();
tube();