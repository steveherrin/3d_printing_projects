desired_od = 80; // [suggested: 80]the diameter of the new dew shield (bigger means more insulation)
existing_od = 60; // [suggested: 60] the outer diameter of the existing dew shield
existing_id = 56; // [suggested: 56] the inner diameter of the existing dew shield

overlap_h = 60; // [suggested: 60] the length of the existing dew shield
extension_h = 60; // [suggested: 60] how further to extend the new dew shield
cap_h = 10; // [suggested: 10] how deep a hole to leave for the lens cap

include_heater = true;
resistor_r = 2.5; // [suggested: 2.5] should be larger than the resistor DIAMETER
resistor_h = 30; // [suggested: 30] distance from the built-in dew shield to the lens
wire_hole_d = 3.5; // [suggested: 3.5] how big of a hole to leave for heater power wires

total_h = overlap_h + extension_h;


module resistor_trough() {
    rotate_extrude(angle=360, $fn=72)
        translate([0.5*existing_od, 0, 0]) circle(r=resistor_r);
}


module lens_cap() {
    //translate([0,0,cap_h]) cylinder(h=2, d=existing_od+4, $fn=72);
    difference() {
        cylinder(h=cap_h, d=existing_od+4, $fn=72);
        cylinder(h=cap_h, d=existing_od-0.75, $fn=72);
    };
    translate([0,0.5*desired_od,1.5*cap_h]) rotate([90,0,0]) cylinder(h=desired_od-existing_od, d=2*cap_h, center=true, $fn=72); // groove so cap can be removed easily
    translate([0,-0.5*desired_od,1.5*cap_h]) rotate([90,0,0]) cylinder(h=desired_od-existing_od, d=2*cap_h, center=true, $fn=72); // groove so cap can be removed easily
}


translate([0,0,total_h]) rotate([180,0,0]) difference() {
    cylinder(h=total_h, d=desired_od, $fn=72);
    cylinder(h=overlap_h, d=existing_od+0.75, $fn=72); // fits over existing dew shield
    cylinder(h=total_h, d=existing_id, $fn=72);
    translate([0, 0, total_h-cap_h]) lens_cap();
    if (include_heater) {
        translate([0,0,overlap_h-resistor_h]) resistor_trough();
        translate([0,0,overlap_h-resistor_h]) rotate([0,90,0]) cylinder(h=0.5*desired_od, d=wire_hole_d, $fn=72);
    };
}