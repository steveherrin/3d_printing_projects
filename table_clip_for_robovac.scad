width = 20;
thickness = 2;
shelf_height = 18;
ridge_height = 0.4;
clip_height = shelf_height + ridge_height;
clip_depth = 25;
ridge_depth = 1.2;
hangdown = 60;
skip_ridges = 4;


union() {
  difference() {
    cube([width, clip_depth + thickness, clip_height + 2*thickness]);
    translate([0,thickness,thickness]) cube([width, clip_depth, clip_height]);
  }
  translate([0,0,-hangdown]) cube([width, thickness, hangdown]);

  for(y = [thickness+ridge_depth + 2*skip_ridges*ridge_depth: 2*ridge_depth : clip_depth ]) {
    translate([0,y,thickness]) cube([width, ridge_depth, ridge_height]);
  }
  for(y = [thickness+ridge_depth + 2*skip_ridges*ridge_depth: 2*ridge_depth : clip_depth ]) {
    translate([0,y,clip_height + thickness - ridge_height]) cube([width, ridge_depth, ridge_height]);
  }
}