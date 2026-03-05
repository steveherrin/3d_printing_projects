gap_bridge = 14.5;
depth = 28;
height_top = 8;

thickness_flat = 5;
thickness_wedge_tip = 2;
thickness_wedge_base = 10;
wedge_n_steps = 14; // should divide depth into a multiple of your step height, or use 0 for smooth ramp

width_prong = 10;
gap_prongs = 10;


module wedge() {
  wedge_x_lo = thickness_flat + gap_bridge;
  wedge_x_hi_z_lo = wedge_x_lo + thickness_wedge_tip;
  wedge_x_hi_z_hi = wedge_x_lo + thickness_wedge_base;


  union() {
    cube([thickness_flat, width_prong, depth + height_top]);
    translate([thickness_flat, 0, depth]) cube([gap_bridge, width_prong, height_top]);
    ramp(wedge_n_steps, wedge_x_lo, wedge_x_hi_z_lo, wedge_x_hi_z_hi);
    translate([wedge_x_lo, 0, depth]) cube([thickness_wedge_base, width_prong, height_top]);
  };
};

module ramp(n_steps, x_lo, x_hi_z_lo, x_hi_z_hi) {
  if(n_steps < 1) {
    polyhedron(
      [
        [x_lo, 0, 0],
        [x_hi_z_lo, 0, 0],
        [x_hi_z_lo, width_prong, 0],
        [x_lo, width_prong, 0],
        [x_lo, 0, depth],
        [x_hi_z_hi, 0, depth],
        [x_hi_z_hi, width_prong, depth],
        [x_lo, width_prong, depth],
      ],
      [
        [0,1,2,3],
        [4,5,1,0],
        [7,6,5,4],
        [5,6,2,1],
        [6,7,3,2],
        [7,4,0,3],
      ]
    );
  } else {
    z_step = depth / n_steps;
    x_min = x_hi_z_lo - x_lo;
    x_step = (x_hi_z_hi - x_hi_z_lo) / (wedge_n_steps-1);
    translate([x_hi_z_lo-x_min,0,0]) for (i = [0:1:(n_steps-1)]) {
      translate([0,0,i*z_step]) cube([i*x_step+x_min, width_prong, z_step], center=false);
    };
  }
}



module double() {  
  translate([0,0,depth+height_top]) rotate([0, 180, 270]) union() {
    wedge();
    translate([0, (gap_prongs+width_prong), 0]) wedge();
    translate([0, width_prong, depth]) cube([gap_bridge + thickness_flat, gap_prongs, height_top]);
    translate([0, width_prong, 0]) cube([thickness_flat, gap_prongs, depth]);
  };
};
  
module single() {
  rotate([90, 0,0]) wedge();
}

echo(str("the step height is ", depth / wedge_n_steps, " which should be a multiple of your layer height"));
//single();
double();
