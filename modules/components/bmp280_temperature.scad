$fa = 1;
$fs = 0.25;

bmp280_width = 16;
bmp280_length = 12;
bmp280_pcb_height = 1.6;
bmp280_headers_length = 2.5;
bmp280_headers_width = bmp280_width;
bmp280_holes_radius = 1.5;
bmp280_holes_offset_left = 1.2;
bmp280_holes_offset_top = bmp280_holes_offset_left;
bmp280_resistors_offset_left = 2.2;
bmp280_resistors_offset_bottom = 3;
bmp280_resistors_width = bmp280_width - bmp280_resistors_offset_left*2;
bmp280_resistors_length = 2.7;
bmp280_resistors_height = 1;
bmp280_sensor_offset_left = 5.4;
bmp280_sensor_offset_bottom = 6;
bmp280_sensor_height = 1.2;
bmp280_sensor_width = bmp280_width - bmp280_sensor_offset_left*2;
bmp280_sensor_length = 5; // includes also resistor on top


module bmp280_shadow(headers_height=1) {
    // pcb
    difference() {
        cube([bmp280_width, bmp280_length, bmp280_pcb_height]);
        // holes
        translate([bmp280_holes_offset_left + bmp280_holes_radius, bmp280_length - bmp280_holes_offset_top - bmp280_holes_radius, 0]) {
            cylinder(h = bmp280_pcb_height, r = bmp280_holes_radius);
        }
        translate([bmp280_width - bmp280_holes_offset_left - bmp280_holes_radius, bmp280_length - bmp280_holes_offset_top - bmp280_holes_radius, 0]) {
            cylinder(h = bmp280_pcb_height, r = bmp280_holes_radius);
        }
    }
    translate([0,0,bmp280_pcb_height]) { 
        // headers
        cube([bmp280_headers_width, bmp280_headers_length, headers_height]);
        // resistors
        translate([bmp280_resistors_offset_left, bmp280_resistors_offset_bottom, 0]) { 
            cube([bmp280_resistors_width, bmp280_resistors_length, bmp280_resistors_height]);
        }
        // sensor
        translate([bmp280_sensor_offset_left, bmp280_sensor_offset_bottom, 0]) { 
            cube([bmp280_sensor_width, bmp280_sensor_length, bmp280_sensor_height]);
        }
    }
}

module bmp280_box_back(wall_width = 1, wall_height = 1, headers_height = 1, with_holes_holder = false) {
    // back of the case, i.e. place the bmp280 on this case, with the sensor on top.
    // headers should be in the front (same side as the sensor)
    // headers_height is the height of the bottom part of the headers, i.e. the soldered part
    // wall_width is the same for the walls and the base
    // wall_height is above the line of the pcb, set to 0 to have it at the same level as the pcb
    difference() {
        cube([bmp280_width+2*wall_width, bmp280_length+2*wall_width, wall_width + bmp280_pcb_height + headers_height + wall_height]);
        translate([wall_width, wall_width, wall_width]) {
            // hole for headers
            cube([bmp280_headers_width, bmp280_headers_length, headers_height]);
            // hole for pcb
            translate([0,0,headers_height]) {
                cube([bmp280_width, bmp280_length, bmp280_pcb_height + wall_height]);
            }
        }
    }
    if (with_holes_holder) {
        translate([wall_width, wall_width, wall_width + headers_height]) {
            translate([bmp280_holes_offset_left + bmp280_holes_radius, bmp280_length - bmp280_holes_offset_top - bmp280_holes_radius, 0]) {
                cylinder(h = bmp280_pcb_height, r = bmp280_holes_radius);
            }
            translate([bmp280_width - bmp280_holes_offset_left - bmp280_holes_radius, bmp280_length - bmp280_holes_offset_top - bmp280_holes_radius, 0]) {
                cylinder(h = bmp280_pcb_height, r = bmp280_holes_radius);
            }
        }
    }
}
