thickness_flat = 5;
thickness_wedge_tip = 3;
thickness_wedge_base = 8;

gap_bridge = 14.5;
depth = 28;
height_top = 8;

width_prong = 10;
gap_prongs = 10;


module wedge() {
  wedge_x_lo = thickness_flat + gap_bridge;
  wedge_x_hi_z_lo = wedge_x_lo + thickness_wedge_tip;
  wedge_x_hi_z_hi = wedge_x_lo + thickness_wedge_base;


  union() {
    cube([thickness_flat, width_prong, depth + height_top]);
    translate([thickness_flat, 0, depth]) cube([gap_bridge, width_prong, height_top]);
    polyhedron(
      [
        [wedge_x_lo, 0, 0],
        [wedge_x_hi_z_lo, 0, 0],
        [wedge_x_hi_z_lo, width_prong, 0],
        [wedge_x_lo, width_prong, 0],
        [wedge_x_lo, 0, depth],
        [wedge_x_hi_z_hi, 0, depth],
        [wedge_x_hi_z_hi, width_prong, depth],
        [wedge_x_lo, width_prong, depth],
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
    translate([wedge_x_lo, 0, depth]) cube([thickness_wedge_base, width_prong, thickness_wedge_base]);
  };
};


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

//single();
double();
