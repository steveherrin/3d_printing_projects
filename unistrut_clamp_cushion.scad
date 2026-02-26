width = 61; // 61 for 2 inch SS clamps
width_peg = 5;
width_slit = 4;
length = 58; // 58 for 2 inch SS clamps
length_peg = 8;
height = 38;
height_peg = 21;
dia_hole = 51;
dia_channel = 12;


module peg() {
  cube([width_peg, length_peg, height_peg], center=true);
};


module shell() {
  difference() {
    cylinder(h=height, d=width, center=true);
    translate([0,0.75*width,0]) cube([width, width, height], center=true);
  }
  translate([0,0.25*length,0]) cube([width, 0.5*length, height], center=true);
  
  x_peg = 0.5*(width - width_peg);
  y_peg = 0.5*(length + length_peg);
  translate([x_peg, y_peg, 0]) peg();
  translate([-x_peg, y_peg, 0]) peg();
};


module clamp() {
  difference() {
    shell();
    cylinder(h=1.1*height, d=dia_hole, center=true);
    translate([0, -0.5*length, 0]) cube([width_slit, 1.1*length, 1.1*height], center=true);
    x_chan = 0.5*(width - dia_channel) - width_peg;
    y_chan = 0.5*length;
    translate([x_chan, y_chan, 0]) cylinder(h=1.1*height, d=dia_channel, center=true);
    translate([-x_chan, y_chan, 0]) cylinder(h=1.1*height, d=dia_channel, center=true);
  };
};

clamp($fn=72);