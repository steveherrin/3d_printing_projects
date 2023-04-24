// the final width of the button
final_width_mm = 160;

// setting the black thickness lets you use layers of black filament
// to do the black coloring, while leaving the base and colored parts
// of the logo a different color

// the thickness of the rectangular base
base_thickness_mm = 8.0;
// how far the colored parts of the logo stick out beyond the base
logo_thickness_mm = 1.6;
// how far the black parts of the logo stick out beyond the base
black_thickness_mm = 2.0; 


// You shouldn't need to adjust anything below this line

scale_factor = final_width_mm / 53;


// I read all the coordinates off a bitmap, so the coordinate system
// is left handed. Everything needs to get flipped over.


// Defining these here because it's easier to do polygons with holes this way
logo_outline = [
    [7,8],[8,8],[8,9],[9,9],[9,8],[11,8],[11,7],[12,7],
    [12,6],[14,6],[14,5],[18,5],[18,6],[20,6],[20,7],[21,7],
    [21,10],[21,19],[20,19],[20,18],[18,18],[18,17],[14,17],[14,18],[12,18],
    [12,19],[7,19],[7,17],[8,17],[8,18],[9,18],[9,17],[11,17],
    [11,10],[7,10],[7,8]
];
logo_outline_path = [for (i = [0:len(logo_outline)]) i];
logo_hole_0 = [
    [13,8],[14,8],[14,7],[15,7],[15,10],[14,10],[14,11],[13,11],[13,8]
];
logo_hole_0_path = [for (i = [0:len(logo_hole_0)]) i + len(logo_outline_path) - 1];
logo_hole_1 = [
    [17,7],[18,7],[18,8],[19,8],[19,11],[18,11],[18,10],[17,10],[17,7]
];
logo_hole_1_path = [for (i = [0:len(logo_hole_1)]) i + len(logo_outline_path) + len(logo_hole_0) - 1];
logo_hole_2 = [
    [17,12],[18,12],[18,13],[19,13],[19,16],[18,16],[18,15],[17,15],[17,12]
];
logo_hole_2_path = [for (i = [0:len(logo_hole_2)]) i + len(logo_outline_path) + len(logo_hole_0) + len(logo_hole_1) - 1];
logo_hole_3 = [
    [13,13],[14,13],[14,12],[15,12],[15,15],[14,15],[14,16],[13,16],[13,13]
];
logo_hole_3_path = [for (i = [0:len(logo_hole_2)]) i + len(logo_outline_path) + len(logo_hole_0) + len(logo_hole_1) + len(logo_hole_2) - 1];
    
a_outline = [
    [37,10],[41,10],[41,11],[42,11],[42,16],[37,16],[37,15],[36,15],
    [36,13],[37,13],[37,12],[40,12],[40,11],[37,11],[37,10]
];
a_outline_path = [for (i = [0:len(a_outline)]) i];
a_hole = [
    [38,13],[40,13],[40,15],[38,15],[38,13]
];
a_hole_path = [for (i = [0:len(a_hole)]) i + len(a_outline_path) - 1];


// the portions of the logo that are black
color("#000000")
linear_extrude(black_thickness_mm)
scale([scale_factor, scale_factor, 1])
rotate([180,0,0])
union() {
    polygon([ // upper trail
        [5,7],[6,7],[6,9],[5,9]
    ]); 
    polygon([ // lower trail
        [5,16],[6,16],[6,18],[5,18]
    ]);
    polygon( // main windows logo
        concat(logo_outline, logo_hole_0, logo_hole_1, logo_hole_2, logo_hole_3),
        [logo_outline_path,
         logo_hole_0_path, logo_hole_1_path,
         logo_hole_2_path, logo_hole_3_path,
        ]
    );
    polygon([ // letter S
        [25,7],[29,7],[29,8],[30,8],[30,9],[28,9],[28,8],[26,8],
        [26,11],[29,11],[29,12],[30,12],[30,15],[29,15],[29,16],[25,16],
        [25,15],[24,15],[24,14],[26,14],[26,15],[28,15],[28,12],[25,12],
        [25,11],[24,11],[24,8],[25,8]
    ]);
    polygon([ // letter t
        [32,8],[34,8],[34,10],[35,10],[35,11],[34,11],[34,15],[35,15],
        [35,16],[33,16],[33,15],[32,15]
    ]);
    polygon( // letter a
        concat(a_outline, a_hole),
        [a_outline_path, a_hole_path]
    );
    polygon([ // letter r
        [43,10],[46,10],[46,11],[45,11],[45,16],[43,16]
    ]);
    polygon([ // letter t
        [47,8],[49,8],[49,10],[50,10],[50,11],[49,11],[49,15],[50,15],
        [50,16],[48,16],[48,15],[47,15]
    ]);
};

// the red part of the logo
color("#fc0d1b")
linear_extrude(logo_thickness_mm)
scale([scale_factor, scale_factor, 1])
rotate([180,0,0])
union() {
    polygon(logo_hole_0);
    polygon([ // middle upper trail
        [5,10],[6,10],[6,12],[5,12]
    ]);
    polygon([ // middle upper logo
        [7,11],[8,11],[8,12],[9,12],[9,11],[11,11],[11,13],[7,13]
    ]);
};
    
// the blue part of the logo
color("#0b24fb")
linear_extrude(logo_thickness_mm)
scale([scale_factor, scale_factor, 1])
rotate([180,0,0])
union() {
    polygon(logo_hole_3);
    polygon([ // middle lower trail
        [5,13],[6,13],[6,15],[5,15]
    ]);
    polygon([ // middle lower logo
        [7,14],[8,14],[8,15],[9,15],[9,14],[11,14],[11,16],[7,16]
    ]);
};

// the green part of the logo
color("#29fd2f")
linear_extrude(logo_thickness_mm)
scale([scale_factor, scale_factor, 1])
rotate([180,0,0])
polygon(logo_hole_1);

// the yellow part of the logo
color("#fffd38")
linear_extrude(logo_thickness_mm)
scale([scale_factor, scale_factor, 1])
rotate([180,0,0])
polygon(logo_hole_2);

// the base
unbeveled_thickness = base_thickness_mm/scale_factor - 1;
assert(unbeveled_thickness >= 0, "base isn't thick enough for bevel");
color("#c3c3c3")
translate([0,0,-scale_factor])
rotate([180,0,0])
union() {
    scale([scale_factor, scale_factor, scale_factor])
    polyhedron([
        [1,1,0],[54,1,0],[54,22,0],[1,22,0],
        [2,2,-1],[53,2,-1],[53,21,-1],[2,21,-1]
    ],[
        [0,1,2,3],[4,5,1,0],[7,6,5,4],
        [5,6,2,1],[6,7,3,2],[7,4,0,3]
    ]);
    scale([scale_factor, scale_factor, 1])
    linear_extrude(unbeveled_thickness)
    polygon([[1,1],[54,1],[54,22],[1,22]]);
}
