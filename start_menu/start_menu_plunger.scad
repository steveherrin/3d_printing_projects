inner_button_diameter_mm = 25;
inner_button_depth_mm = 5;
outer_button_diameter_mm = 31;
outer_button_depth_mm = 12.5;

base_height_mm = 2;
shell_width_mm = 2;

// the final width of the start button
final_width_mm = 160;

// You shouldn't need to adjust anything below this line

scale_factor = final_width_mm / 53;

$fn=72;

union() {
    difference() {
        cylinder(h=base_height_mm + outer_button_depth_mm, d=outer_button_diameter_mm + 2 * shell_width_mm);
        translate([0, 0, base_height_mm])
            cylinder(h=outer_button_depth_mm+1, d=outer_button_diameter_mm);
    }
    translate([0, 0, base_height_mm])
        cylinder(h=inner_button_depth_mm, d=inner_button_diameter_mm);
    cube([final_width_mm, 21*scale_factor, base_height_mm], center=true);
};