// Cover for the display panel on a Schwinn IC4 / Bowflex C6 stationary bike

lip_height = 5;  // how tall to make the lip that hangs down
thickness = 1;  // how thick to make the walls
rpm_slot = true;
time_slot = false;
calorie_slot = false;
speed_slot = true;
distance_slot = false;
level_slot = true;
pulse_slot = true;

module half_display_polygon() {
    polygon([
        [  0,  0],
        [  1, 22],
        [ 10, 39],
        [ 20, 42],
        [ 30, 43],
        [ 40, 44],
        [ 70, 45],
        [ 80, 45],
        [110, 44],
        [120, 43],
        [130, 42],
        [140, 39],
        [149, 22],
        [150,  0],
    ]);
};

module rounded_wedge(pt1, pt2, r) {
    // Find the circle with the specified radius between the two points
    // and save only the wedge of it between the two points
    // (if it points the wrong way, simply swap the two points)
    pta = 0.5 * (pt2 - pt1);
    a = norm(pta);
    b = sqrt(r^2 - a^2);
    median = 0.5 * (pt1 + pt2);
    center = [
        median.x + b * pta.y / a,
        median.y - b * pta.x / a,
    ];
    intersection() {
        translate(center) circle(r);
        polygon([
            center,
            2 * pt1 - center,
            2 * pt2 - center,
        ]);
    }
};

module half_display_rounded() {
    r = 23;
    union() {
        half_display_polygon();
        rounded_wedge([1, 22], [10, 39], r);
        rounded_wedge([140, 39], [149, 22], r);
    };
}
        

module display() {
    union() {
        half_display_rounded();
        mirror([0, 1, 0]) half_display_rounded();
    }
};

module display_cover() {
    difference() {
        translate([-thickness/2, 0, 0]) linear_extrude(lip_height + thickness) scale([(150 + thickness)/150, (90 + thickness)/90, 1]) display();
        linear_extrude(lip_height) display();
    };
};

module display_slots() {
    offset = 20;
    w = 50;
    translate([offset, 0, lip_height]) union() {
        if (rpm_slot) {
            translate([5.075, 0, 0]) cube([10.15, w, 2*thickness], center=true);
        };
        if (time_slot) {
            translate([16.0, 0, 0]) cube([11.7, w, 2*thickness], center=true);
        };
        if (calorie_slot) {
            translate([27.7, 0, 0]) cube([11.7, w, 2*thickness], center=true);
        };
        if (speed_slot) {
            translate([39.4, 0, 0]) cube([11.7, w, 2*thickness], center=true);
        };
        if (distance_slot) {
            translate([51.1, 0, 0]) cube([11.7, w, 2*thickness], center=true);
        };
        if (level_slot) {
            translate([62.8, 0, 0]) cube([11.7, w, 2*thickness], center=true);
        };
        if (pulse_slot) {
            translate([74.5, 0, 0]) cube([11.7, w, 2*thickness], center=true);
        };
    };
}


rotate([180, 0, 0]) difference() {
    display_cover();
    display_slots();
}