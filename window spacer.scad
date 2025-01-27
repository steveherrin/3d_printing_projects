width = 27;
corner_r = 2;

$fn=12;

scale([1, 1, width/2]) minkowski() {
    translate([corner_r, corner_r, 0]) difference() {
        cube([48-2*corner_r, 170-2*corner_r, 1], center=false);
        translate([10-corner_r, 161-corner_r, 0]) cube([38, 9, 1], center=false);
        cube([13, 16, 1]);
        translate([46-2*corner_r, 0, 0]) cube([2, 16, 1]);
    }

    translate([0, 0, 0.5]) cylinder(h=1, r=corner_r, center=true);
}

// this is the bounding box
//mirror([1, 0, 0]) rotate([180, -90, 180]) difference() {
//    cube([width, 170, 48], center=false);
//    translate([0, 161, 10]) cube([width, 9, 38], center=false);
//    cube([width, 16, 13]);
//    translate([0, 0, 46]) cube([width, 16, 2]);
//};
