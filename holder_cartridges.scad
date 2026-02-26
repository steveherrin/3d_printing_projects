eps_hole = 2;

module holes(total_width, total_length, height, rows_of_hole_diameters) {
  n_rows = len(rows_of_hole_diameters);
  space_between_rows = n_rows > 1 ? total_length / (n_rows - 1) : 0;

  for (i = [0:(n_rows-1)]) {
    row = rows_of_hole_diameters[i];
    n_cols = len(row);
    
    space_between_cols = n_cols > 1 ? total_width / (n_cols - 1) : 0;
    
    for (j = [0:(n_cols-1)]) {
      offset_x = n_cols > 1 ? -0.5*total_width + j*space_between_cols : 0;
      //offset_y = n_rows > 1 ? -0.5*total_length + (i > 0 ? i-0.2 : 0)*space_between_rows : 0;
      offset_y = n_rows > 1 ? -0.5*total_length + i*space_between_rows : 0;

      if (row[j] > 0) {
        translate([offset_x, offset_y, 0]) cylinder(h=height, d=row[j]+eps_hole);
      }
    }
  }

}

module hole_bridge(total_width, total_length, height, rows_of_hole_diameters, row_idx, hole_l_idx) {
  n_rows = len(rows_of_hole_diameters);
  space_between_rows = total_length / (n_rows - 1);
  
  row = rows_of_hole_diameters[row_idx];
  n_cols = len(row);
    
  space_between_cols = total_width / (n_cols - 1);
  
  bridge_depth = max(row[hole_l_idx], row[hole_l_idx+1]) + eps_hole;

  hole_r_idx = hole_l_idx + 1;
  offset_x = -0.5*total_width + (hole_l_idx+0.5)*space_between_cols;
  offset_y = -0.5*total_length + row_idx*space_between_rows;
  
  translate([offset_x, offset_y, 0.5*height]) cube([space_between_cols, bridge_depth, height], center=true);
}

border = 28;
width = 48;
length = 24;
hole_diameters = [
  [18, 18, 18],
  [18, 18, 18],
];

// I think the 25 needs to be smaller
// I think the shelf thickness needs to be more

thick_shelf_l = 28;
thick_shelf_h = 28;
f_shelf_l = 1.0;
f_shelf_w = 0.675;
thick_floor = 4;
// length/2+25-.45*length, 20]) cube([.675*width, 0.9*length, 40], center=true)

difference() {
  translate([0, 0, -thick_floor]) union() {
    translate([0, 0, 0.5*(thick_shelf_l+thick_floor)]) cube([width + border, length + border, thick_shelf_l+thick_floor], center=true);
    translate([0, 0.5*(1-f_shelf_l)*length+0.5*border, 0.5*(thick_shelf_h+thick_floor)]) cube([f_shelf_w*width, f_shelf_l*length, thick_shelf_h+thick_floor], center=true);
  };
  holes(width, length, 60, hole_diameters);
  //hole_bridge(100, length, 60, hole_diameters, 2, 1);
};
