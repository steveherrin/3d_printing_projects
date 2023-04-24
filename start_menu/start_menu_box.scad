
enclosure_inner_length = 64;
enclosure_inner_width = 63;
enclosure_inner_depth = 46;

support_length = 36;
support_width = 31;

enclosure_thickness = 2;

cover_thickness = 3;

part = "enclosure"; // [enclosure:Enclosure, cover:Cover, both:Enclosure and Cover]

print_part();

module print_part() {
	if (part == "enclosure") {
		box2(enclosure_inner_length,enclosure_inner_width,enclosure_inner_depth,enclosure_thickness,enclosure_thickness/2-0.10,cover_thickness);
        supports(support_length, support_width);
	} else if (part == "cover") {
		lid2(enclosure_inner_length,enclosure_inner_width,enclosure_inner_depth,enclosure_thickness,enclosure_thickness/2+0.10,cover_thickness);
	} else {
		both();
	}
}

module both() {

	box2(enclosure_inner_length,enclosure_inner_width,enclosure_inner_depth,enclosure_thickness,enclosure_thickness/2-0.10,cover_thickness);
    supports(support_length, support_width);
	lid2(enclosure_inner_length,enclosure_inner_width,enclosure_inner_depth,enclosure_thickness,enclosure_thickness/2+0.10,cover_thickness);

}

module screws(in_x, in_y, in_z, shell) {

	sx = in_x/2 - 4;
	sy = in_y/2 - 4;
	sh = shell + in_z - 12;
	nh = shell + in_z - 4;

	translate([0,0,0]) {
		translate([sx , sy, sh]) cylinder(r=1.6, h = 15, $fn=32);
		translate([sx , -sy, sh ]) cylinder(r=1.6, h = 15, $fn=32);
		translate([-sx , sy, sh ]) cylinder(r=1.6, h = 15, $fn=32);
		translate([-sx , -sy, sh ]) cylinder(r=1.6, h = 15, $fn=32);
	
	
		translate([-sx , -sy, nh ]) rotate([0,0,-45]) 
			translate([-5.75/2, -5.6/2, -0.7]) cube ([6, 10, 3]);
		translate([sx , -sy, nh ]) rotate([0,0,45]) 
			translate([-5.75/2, -5.6/2, -0.7]) cube ([6, 10, 3]);
		translate([sx , sy, nh ]) rotate([0,0,90+45]) 
			translate([-5.75/2, -5.6/2, -0.7]) cube ([6, 10, 3]);
		translate([-sx , sy, nh ]) rotate([0,0,-90-45]) 
			translate([-5.75/2, -5.6/2, -0.7]) cube ([6, 10, 3]);
	}
}

module bottom(in_x, in_y, in_z, shell) {

	hull() {
   	 	translate([-in_x/2+shell, -in_y/2+shell, 0]) cylinder(r=shell*2,h=shell, $fn=32);
		translate([+in_x/2-shell, -in_y/2+shell, 0]) cylinder(r=shell*2,h=shell, $fn=32);
		translate([+in_x/2-shell, in_y/2-shell, 0]) cylinder(r=shell*2,h=shell, $fn=32);
		translate([-in_x/2+shell, in_y/2-shell, 0]) cylinder(r=shell*2,h=shell, $fn=32);
	}
}

module sides(in_x, in_y, in_z, shell) {
	translate([0,0,shell])
	difference() {
		hull() {
	   	 	translate([-in_x/2+shell, -in_y/2+shell, 0]) cylinder(r=shell*2,h=in_z, $fn=32);
			translate([+in_x/2-shell, -in_y/2+shell, 0]) cylinder(r=shell*2,h=in_z, $fn=32);
			translate([+in_x/2-shell, in_y/2-shell, 0]) cylinder(r=shell*2,h=in_z, $fn=32);
			translate([-in_x/2+shell, in_y/2-shell, 0]) cylinder(r=shell*2,h=in_z, $fn=32);
		}
	
		hull() {
	   	 	translate([-in_x/2+shell, -in_y/2+shell, 0]) cylinder(r=shell,h=in_z+1, $fn=32);
			translate([+in_x/2-shell, -in_y/2+shell, 0]) cylinder(r=shell,h=in_z+1, $fn=32);
			translate([+in_x/2-shell, in_y/2-shell, 0]) cylinder(r=shell,h=in_z+1, $fn=32);
			translate([-in_x/2+shell, in_y/2-shell, 0]) cylinder(r=shell,h=in_z+1, $fn=32);
		}
	}
	
	intersection() {
		translate([-in_x/2, -in_y/2, shell]) cube([in_x, in_y, in_z+2]);
		union() {
			translate([-in_x/2 , -in_y/2,shell + in_z -6]) cylinder(r=10, h = 6, $fn=64);
			translate([-in_x/2 , -in_y/2,shell + in_z -10]) cylinder(r1=3, r2=10, h = 4, $fn=64);
		
			translate([in_x/2 , -in_y/2, shell + in_z -6]) cylinder(r=10, h = 6, $fn=64);
			translate([in_x/2 , -in_y/2, shell + in_z -10]) cylinder(r1=3, r2=10, h = 4, $fn=64);
		
			translate([in_x/2 , in_y/2,  shell + in_z -6]) cylinder(r=10, h = 6, $fn=64);
			translate([in_x/2 , in_y/2,  shell + in_z -10]) cylinder(r1=3, r2=10, h = 4, $fn=64);
		
			translate([-in_x/2 , in_y/2, shell + in_z -6]) cylinder(r=10, h = 6, $fn=64);
			translate([-in_x/2 , in_y/2, shell + in_z -10]) cylinder(r1=3, r2=10, h = 4, $fn=64);
		}
	}
}

module supports(in_x, in_y) {
    union() {
        translate([-in_x/2, -in_y/2+10, 0]) rotate([0,0,-135]) support();
        translate([in_x/2, -in_y/2+10, 0]) rotate([0,0,-45]) support();
        translate([-in_x/2, in_y/2+10, 0]) rotate([0,0,135]) support();
        translate([in_x/2, in_y/2+10, 0]) rotate([0,0,45]) support();
    }
}

module support() {
    difference() {
        cylinder(r=5.5, h=6, $fn=64);
        cylinder(r=1.6, h=8, $fn=64);
        translate([-6, -3.5, 2]) cube([9, 7, 3]);
    }
}
        

module lid_top_lip2(in_x, in_y, in_z, shell, top_lip, top_thickness) {

	cxm = -in_x/2 - (shell-top_lip);
	cxp = in_x/2 + (shell-top_lip);
	cym = -in_y/2 - (shell-top_lip);
	cyp = in_y/2 + (shell-top_lip);

	translate([0,0,shell+in_z])

	difference() {
	
		hull() {
	   	 	translate([-in_x/2+shell, -in_y/2+shell, 0]) cylinder(r=shell*2,h=top_thickness, $fn=32);
			translate([+in_x/2-shell, -in_y/2+shell, 0]) cylinder(r=shell*2,h=top_thickness, $fn=32);
			translate([+in_x/2-shell, in_y/2-shell, 0]) cylinder(r=shell*2,h=top_thickness, $fn=32);
			translate([-in_x/2+shell, in_y/2-shell, 0]) cylinder(r=shell*2,h=top_thickness, $fn=32);
		}
	
		
		translate([0, 0, -1]) linear_extrude(height = top_thickness + 2) polygon(points = [
			[cxm+5, cym],
			[cxm, cym+5],
			[cxm, cyp-5],
			[cxm+5, cyp],
			[cxp-5, cyp],
			[cxp, cyp-5],
			[cxp, cym+5],
			[cxp-5, cym]]);
	}
}

module lid2(in_x, in_y, in_z, shell, top_lip, top_thickness) {

	cxm = -in_x/2 - (shell-top_lip);
	cxp = in_x/2 + (shell-top_lip);
	cym = -in_y/2 - (shell-top_lip);
	cyp = in_y/2 + (shell-top_lip);	

	difference() {
		translate([0, 0, in_z+shell]) linear_extrude(height = top_thickness ) polygon(points = [
			[cxm+5, cym],
			[cxm, cym+5],
			[cxm, cyp-5],
			[cxm+5, cyp],
			[cxp-5, cyp],
			[cxp, cyp-5],
			[cxp, cym+5],
			[cxp-5, cym]]);
	
			screws(in_x, in_y, in_z, shell);
            speaker_grill(0, 0, in_z, 1, 19, 4, 1);

	}
    for (phi=[30:60:390]) {
        translate([0,0,in_z+shell])
        rotate([180,0,0])
            speaker_tab([21.5*cos(phi),21.5*sin(phi),0]);
    }
}

module speaker_grill(center_x, center_y, center_z, hole_size, width, spacing, x_offset) {
    for (x=[center_x-width+x_offset:spacing:center_x+width-x_offset]) {
        y = sqrt(width*width - x*x);
        hull() {
            translate([x, y, center_z]) cylinder(h=2*cover_thickness, r=hole_size, center=false, $fn=18);
            translate([x, -y, center_z]) cylinder(h=2*cover_thickness, r=hole_size, center=false, $fn=18);
        };
    };
}
            

module box2(in_x, in_y, in_z, shell, top_lip, top_thickness) {
	bottom(in_x, in_y, in_z, shell);
	difference() {
		sides(in_x, in_y, in_z, shell);
		screws(in_x, in_y, in_z, shell);
		half_hole(9, [0, 15], 6);
	}
    half_nipple(9, 2, [0, 15], 6);
	lid_top_lip2(in_x, in_y, in_z, shell, top_lip, top_thickness);
}

module punch_hole(cylinder, rotate, translate_coords) {
	translate(translate_coords) rotate (rotate) cylinder (h = cylinder[1], r=cylinder[0], center = false, $fn=32);
}

module half_hole(radius, offset, overhang) {
    rotate = [90,0,90];
    length = enclosure_inner_length/2;
    translate([length, offset[0], offset[1]])
        rotate(rotate)
            difference() {
                cylinder(h=enclosure_thickness+overhang,r=radius,center=false, $fn=32);
                translate([-radius, -radius, -1])
                    cube([2*radius, radius, length+2], center=false);
            }
}

module half_nipple(radius, thickness, offset, overhang) {
    ramp_x = enclosure_inner_length/2 + enclosure_thickness;
    union() {
        translate([0,0,-thickness])
        difference() {
            half_hole(radius+thickness, offset, overhang);
            translate([enclosure_inner_length/2, offset[0], offset[1]])
                rotate([90,0,90])
                difference() {
                    cylinder(h=enclosure_thickness+overhang+1,r=radius,center=false, $fn=32);
                    translate([-radius, -radius, thickness])
                    cube([2*radius, radius+thickness, overhang+2], center=false);
                }
        }
        intersection()
        {
            translate([ramp_x, offset[0]+radius+thickness, offset[1]-thickness])
                rotate([90,90,0])
                linear_extrude(2*(radius+thickness))
                    polygon([[0,0],[0,overhang],[overhang,0]]);
            translate([enclosure_inner_length/2, offset[0], offset[1]])
            rotate([90,0,90])
            cylinder(h=enclosure_thickness+overhang, r=radius+thickness, center=false, $fn=32);
        }
    }
}

module speaker_tab(center) {
    translate(center)
    union() {
        cylinder(h=2, r=1.5, center=false, $fn=32);
        translate([0,0,2]) cylinder(2, r1=1.5, r2=2, center=false, $fn=32);
    }
}

module hole(side, radius, offset) {
	// side is "[length/width]_[1/2]"
	// radius is hole radius
	// offset is [horizontal, height] from the [center, bottom] of the side, or from the [center, center] of the lid.

	if (side == "length_1") {
		rotate = [90,0,90];
		translate_coords = [enclosure_thickness+1, offset[0], offset[1]];
		length = enclosure_inner_length/2;
		punch_hole([radius, length], rotate, translate_coords);
	}
	if (side == "length_2") {
		rotate = [90,0,270]; 
		translate_coords = [-(enclosure_thickness+1), offset[0], offset[1]];
		length = enclosure_inner_length/2;
		punch_hole([radius, length], rotate, translate_coords);
	}
	if (side == "width_1") {
		rotate = [90,0,0];
		translate_coords = [offset[0], -(enclosure_thickness+1), offset[1]];
        length = enclosure_inner_width/2;
		punch_hole([radius, length], rotate, translate_coords);
	}
	if (side == "width_2") {
		rotate = [90,0,180];
		translate_coords = [offset[0], enclosure_thickness+1, offset[1]];
		length = enclosure_inner_width/2;
		punch_hole([radius, length], rotate, translate_coords);
	}
	if (side == "lid") {
		rotate = [0,0,0];
		translate_coords = [offset[0], offset[1], enclosure_inner_depth-cover_thickness];
		length = enclosure_inner_depth/2;
		punch_hole([radius, length], rotate, translate_coords);
	}
}

