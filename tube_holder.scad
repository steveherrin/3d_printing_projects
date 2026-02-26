base_thickness = 6;
base_diameter = 100;
base_width = 20;

cup_od = 17;
cup_id = 13.7;  // was 12.2 which is a loose fit but makes it hard to tilt out


tube_height = 75+20;

leg_width = 16;
leg_thick = 3;
leg_inset = 1;
leg_length = tube_height + 2*1;
leg_peg = 3;
leg_tol = .3; // .4 was snug once, loose once???

module shelf_base(diameter, width, height, degrees) {
  translate([0, 0, 0.5*height]) rotate([0, 0, -0.5*degrees])
    rotate_extrude(angle=degrees)
      translate([0.5*diameter, 0, ])
        square([width, height], center=true);
}




module cup(d_out, d_in, h_out, h_in) {
  translate([0, 0, 0.5*h_out])
    difference() {
      translate([0,0,0]) cylinder(d=d_out, h=h_out, center=true);
      translate([0, 0, h_in]) cylinder(d=d_in, h=h_out-h_in, center=true);
    }
}

module bottom_cups(diameter, n, degrees) {
  d_degrees = degrees/(n - 1);
  r = 0.5*diameter;
  for (angle = [-0.5*degrees:d_degrees:0.5*degrees]) {
    translate([r*cos(angle), r*sin(angle), base_thickness]) rotate([0,0,angle]) cup(cup_od, cup_id, 12, 4);
  }
};

module top_cups(diameter, n, degrees) {
  d_degrees = degrees/(n - 1);
  r = 0.5*diameter;
  for (angle = [-0.5*degrees:d_degrees:0.5*degrees]) {
    translate([r*cos(angle), r*sin(angle), base_thickness]) rotate([0,0,angle]) cup(cup_od, cup_id, 26, 0);
  }
};


module leg_holes(diameter, n, degrees) {
  d_degrees = degrees/(n - 1);
  r = 0.5*diameter;
  w = leg_width + 2*leg_tol;
  w_peg = w - 2*leg_inset;
  t = leg_thick + 2 * leg_tol;
  for (angle = [-0.5*degrees:d_degrees:0.5*degrees]) {
    translate([r*cos(angle), r*sin(angle), 0]) rotate([0,0,angle]) leg_hole(w, t, 1, leg_inset, leg_peg);
  }
}

module leg_hole(length, width, depth, inset, inset_depth) {
  translate([0,0,0]) union() {
    translate([0,0,-0.5*depth]) cube([length, width, depth], center=true);
    translate([0.5*(length - width),0,-(depth+inset_depth)]) #cylinder(d=width-inset, h=inset_depth);
    translate([0.5*(-length + width),0,-(depth+inset_depth)]) #cylinder(d=width-inset, h=inset_depth);
  }
}


module leg(length, width, depth, inset, inset_depth) {
echo(length, width, depth);
  translate([0,0,-0.5*depth]) cube([length, width, depth], center=true);
  translate([0.5*(length - width),0,0]) cylinder(d=width-inset, h=inset_depth);
  translate([0.5*(-length + width),0,0]) cylinder(d=width-inset, h=inset_depth);
  translate([0.5*(length - width),0,-(depth+inset_depth)]) cylinder(d=width-inset, h=inset_depth);
  translate([0.5*(-length + width),0,-(depth+inset_depth)]) cylinder(d=width-inset, h=inset_depth);

}

module legs() {
leg(leg_width, leg_thick, leg_length, leg_inset, leg_peg);
}


module bottom() {
  difference() {
    shelf_base(base_diameter, base_width, base_thickness, 160);
    translate([0,0, base_thickness]) leg_holes(base_diameter, 6, 150);
    //shelf_base(base_diameter, base_width, base_thickness, 40);
    //translate([0,0, base_thickness]) leg_holes(base_diameter, 2, 30);
  }

  rotate([0,0,0]) bottom_cups(base_diameter, 5, 150*5/6);
  //rotate([0,0,15]) bottom_cups(base_diameter, 1, 30);

}

module top() {
  difference() {
    shelf_base(base_diameter, base_width, base_thickness, 160);
    translate([0,0, base_thickness]) leg_holes(base_diameter, 6, 150);
    //shelf_base(base_diameter, base_width, base_thickness, 40);
    //translate([0,0, base_thickness]) leg_holes(base_diameter, 2, 30);
  }

  top_cups(base_diameter, 5, 150*5/6);
  //rotate([0,0,15])top_cups(base_diameter, 1, 30);

}

$fn = 72;
bottom();
translate([60,0,0*(base_thickness+tube_height)]) rotate([180-180,0,0]) top();
translate([-20,-leg_length/2,leg_thick/2]) rotate([90,0,0]) legs();