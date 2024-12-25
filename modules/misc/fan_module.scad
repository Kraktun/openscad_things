$fa = 1;
$fs = 0.25;

// a grill to cover fans, with customizable measures.
// You can also print only the square around the fan with the holes if you just need something to attach a fan.

default_hole_radius = 2;

module fan_base_w_holes(width, height, thickness, hole_radius=default_hole_radius) {
    difference() {
        cube([thickness, width, height]);
        translation_axis = width/10/2; // height of the holes from the bottom, should be enough to make the fan touch the bottom
        translate([0,translation_axis,translation_axis]) {
            rotate([0,90,0]) {
                cylinder(h = thickness, r = hole_radius);
            }
        }
        translate([0,width-translation_axis,translation_axis]) {
            rotate([0,90,0]) {
                cylinder(h = thickness, r = hole_radius);
            }
        }
    }
}

module fan_base_w_holes_sx(width, height, thickness, hole_radius=default_hole_radius) {
    translate([0, height, 0]) {
        rotate([90,0,0]) {
            fan_base_w_holes(width = width, height = height, thickness = thickness, hole_radius = hole_radius);
        }
    }
}

module fan_base_w_holes_dx(width, height, thickness, hole_radius=default_hole_radius) {
    translate([0, width, 0]) {
        rotate([90,0,0]) {
            fan_base_w_holes(width = width, height = height, thickness = thickness, hole_radius = hole_radius);
        }
    }
}

module fan_base_w_holes_top(width, height, thickness, hole_radius=default_hole_radius) {
    translate([0, 0, width-height]) {
        fan_base_w_holes(width = width, height = height, thickness = thickness, hole_radius = hole_radius);
    }
}

module fan_square(width, height, thickness, hole_radius=default_hole_radius) {
    fan_base_w_holes(width = width, height = height, thickness = thickness, hole_radius = hole_radius);
    fan_base_w_holes_sx(width = width, height = height, thickness = thickness, hole_radius = hole_radius);
    fan_base_w_holes_dx(width = width, height = height, thickness = thickness, hole_radius = hole_radius);
    fan_base_w_holes_top(width = width, height = height, thickness = thickness, hole_radius = hole_radius);
}

module fan_bars_diagonals(width, height, thickness, height_diag_divider=3) {
    // height = height of the standard bars (the square around the grill), the diagonals will be height / height_diag_divider
    sq2 = sqrt(2);
    translate([0, height, height-(height/height_diag_divider/sq2)]) { 
        rotate([45,0,0]) {
            cube([thickness, width*sq2-(height*sq2*2)+(height/height_diag_divider), height/height_diag_divider]);
        }
    }
    translate([0, height-(height/height_diag_divider/sq2), width-height]) { 
        rotate([-45,0,0]) {
            cube([thickness, width*sq2-(height*sq2*2)+(height/height_diag_divider), height/height_diag_divider]);
        }
    }
}

module fan_grill(width, height, thickness, width_circles=3, width_void=7) {
    steps = width/2/(width_circles+width_void);
    for(i = [1 : steps]){
        width_radius_ext = i*(width_circles+width_void);
        translate([0, width/2,width/2]) {
            rotate([0,90,0]) {
                difference() {
                    cylinder(h = thickness, r = width_radius_ext);
                    cylinder(h = thickness, r = width_radius_ext-width_circles);
                }
            }
        }
        // center is always filled
        translate([0, width/2,width/2]) {
            rotate([0,90,0]) {
                difference() {
                    cylinder(h = thickness, r = width_circles);
                }
            }
        }
    }
}

module fan_grill_complete(fan_main_dimension, fan_height_base, grill_thickness, hole_radius=default_hole_radius) {
    // fan_main_dimension = size of the fan e.g. 80, 120, 140
    // fan_height_base = width of the bar with holes
    // grill_thickness = thickness of the grill
    // hole_radius = radius for the holes, the default is fine for fans 80,120,140
    fan_square(width = fan_main_dimension, height = fan_height_base, thickness = grill_thickness, hole_radius = hole_radius);
    fan_bars_diagonals(width = fan_main_dimension, height = fan_height_base, thickness = grill_thickness);
    fan_grill(width = fan_main_dimension, height = fan_height_base, thickness = grill_thickness);
}

module fan_grill_complete_aio(fan_main_dimension, hole_radius=default_hole_radius) {
    // fan_main_dimension = size of the fan e.g. 80, 120, 140
    // hole_radius = radius for the holes, the default is fine for fans 80,120,140
    fan_grill_complete(fan_main_dimension, fan_main_dimension/10, grill_thickness = 2, hole_radius = hole_radius);
}
