// Hooks for garage shelving
// by sabertail@physicsdog.org
//
// The failure mode I've observed is the "mushrooms" that lock into the
// shelving breaking off. They and the rest of the "mount" should be printed
// with 100% infill for maximum strength. The print should have the top of
// the "mushrooms" perpendicular to the layers, so they don't delaminate off.
// This means they will need supports.


width_back = 15;
thick_back = 4;
height_back = 64;


module mushroom() {
  h_total = 5;
  h_cap = 3.3;
  h_base = h_total - h_cap;
  
  d_cap = 11;
  d_base = 6.8;
  
  h_bevel = 1;
  r_bevel = 2;
  
  h_cap_unbeveled = h_cap - h_bevel;
  
  cylinder(d=d_base, h=h_base, center=false);
  translate([0,0,h_base])
    cylinder(d=d_cap, h=h_cap_unbeveled, center=false);
  translate([0,0,h_base + h_cap_unbeveled])
    cylinder(d1=d_cap, d2=d_cap - r_bevel, h=h_bevel, center=false);
};


module mount() {
  cube([thick_back, height_back, width_back]);

  n_mushroom = 2;
  mushroom_spacing = 37;
  extra_offset = 6;
  mushroom_offset = 0.5*(height_back - (n_mushroom-1)*mushroom_spacing) + extra_offset;
  for(i = [0:1:(n_mushroom-1)]) {
    translate([0, mushroom_offset + i*mushroom_spacing, 0.5*width_back]) rotate([0,-90,0]) mushroom();
  }
};


module hook() {
  points = [
    [ 0,  0],
    [25,  3],
    [32,  8],
    [37, 15],
    [40, 40],
    [40, 50],
    [28, 50],
    [27, 35],
    [23, 30],
    [15, 26],
    [ 0, 25],
    [ 0,  0],
  ];
  i_top_out = 5;
  i_top_in = 6;
  top_center = 0.5*(points[i_top_out] + points[i_top_in]);
  top_d = (points[i_top_out] - points[i_top_in])[0];
  linear_extrude(width_back) union() {
    polygon(points);
    translate(top_center) circle(d=top_d);
  }
};


mount();
translate([thick_back,0,0]) hook();