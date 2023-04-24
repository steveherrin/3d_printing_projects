length = 56;
difference() {
    cylinder(length, 9, 9);
    translate([0, 0, -1])
        cylinder(length+2, 3, 3);
    translate([8, 0, length/2])
        cube([12, 4, length+2], center=true);
}