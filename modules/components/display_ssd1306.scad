$fa = 1;
$fs = 0.25;

ssd1306_width = 24.7;
ssd1306_length = 26.8;
ssd1306_screen_width = ssd1306_width;
ssd1306_screen_length = 14.0;
ssd1306_screen_offset_top = 5;
ssd1306_screen_offset_leveled_bottom = 3;
ssd1306_screen_offset_bottom = 4.5;
ssd1306_ribbon_offset_left = 7.1;
ssd1306_ribbon_width = 8.8;
ssd1306_ribbon_offset_right = ssd1306_width - ssd1306_ribbon_offset_left - ssd1306_ribbon_width;
ssd1306_hole_offset = 1;
ssd1306_hole_radius = 1.5;
ssd1306_headers_width = 10;
ssd1306_headers_length = 3;
ssd1306_headers_offset_left = (ssd1306_width - ssd1306_headers_width)/2;
ssd1306_back_height = 1;
ssd1306_pcb_height = 1;
ssd1306_screen_height = 2;

ssd1306_full_height = ssd1306_back_height + ssd1306_pcb_height + ssd1306_screen_height;

module ssd1306_shadow(shadow_screen_extender=0, shadow_headers_extender=0, with_holes=false) {
    // a shadow of the display ssd1306 (128x64) with optional extenders to cut through a case for the screen and headers

    // set shadow_screen_extender if you need to use this in a diff to cut a base that would envelop the screen
    // same for shadow_headers_extender for the pin headers

    
    translate([0,0,ssd1306_back_height]) {
        ssd1306_shadow_front(shadow_screen_extender=shadow_screen_extender, with_holes=with_holes);
    }
    // back
    translate([0,ssd1306_screen_offset_bottom+ssd1306_screen_offset_leveled_bottom, 0]) { 
        cube([ssd1306_screen_width, ssd1306_screen_length, ssd1306_back_height]);
    }
    translate([ssd1306_headers_offset_left,ssd1306_screen_offset_bottom+ssd1306_screen_offset_leveled_bottom+ssd1306_screen_length, 0]) { 
        cube([ssd1306_headers_width, ssd1306_screen_offset_top, ssd1306_back_height]);
    }
    // headers continuation back
    translate([ssd1306_headers_offset_left,ssd1306_length - ssd1306_headers_length, -shadow_headers_extender]) { 
        cube([ssd1306_headers_width, ssd1306_headers_length, ssd1306_back_height+shadow_headers_extender]);
    }
}

module ssd1306_holes(hole_extender=0) {
    holes_offset = ssd1306_hole_offset + ssd1306_hole_radius;
    holes_height = ssd1306_screen_height + ssd1306_pcb_height + hole_extender;
    // bottom left
    translate([holes_offset, holes_offset, 0]) { 
        cylinder(h = holes_height, r = ssd1306_hole_radius);
    }
    // bottom right
    translate([ssd1306_width - holes_offset, holes_offset, 0]) { 
        cylinder(h = holes_height, r = ssd1306_hole_radius);
    }
    // top left
    translate([holes_offset, ssd1306_length - holes_offset, 0]) { 
        cylinder(h = holes_height, r = ssd1306_hole_radius);
    }
    // top right
    translate([ssd1306_width - holes_offset, ssd1306_length - holes_offset, 0]) { 
        cylinder(h = holes_height, r = ssd1306_hole_radius);
    }
}

module ssd1306_shadow_front(shadow_screen_extender=0, with_holes=false) {
    // same as the shadow above, but only for the front

    // pcb
    difference() {
        cube([ssd1306_width, ssd1306_length, ssd1306_pcb_height]);
        if (with_holes) {
            // holes
            ssd1306_holes(hole_extender=shadow_screen_extender);
        }
    }
    translate([0,0,ssd1306_pcb_height]) {
        // headers
        translate([ssd1306_headers_offset_left, ssd1306_length - ssd1306_headers_length, 0]) {
            cube([ssd1306_headers_width, ssd1306_headers_length, ssd1306_screen_height]);
        }
        // screen
        translate([0, ssd1306_screen_offset_bottom+ssd1306_screen_offset_leveled_bottom, 0]) {
            cube([ssd1306_screen_width, ssd1306_screen_length, ssd1306_screen_height+shadow_screen_extender]);
        }
        // screen continuation (controls etc.)
        translate([0, ssd1306_screen_offset_bottom, 0]) {
            cube([ssd1306_screen_width, ssd1306_screen_offset_leveled_bottom, ssd1306_screen_height]);
        }
        // ribbon
        translate([ssd1306_ribbon_offset_left, 0, 0]) {
            cube([ssd1306_ribbon_width, ssd1306_screen_offset_bottom, ssd1306_screen_height]);
        }
    }
}

module ssd1306_box_front(walls_width=1, cover_thickness=0, with_holes=false, with_hole_holders=false) {
    // cover_thickness = 0 means at the level of the screen
    // with_holes = true means that there will be holes in the cover
    // with_hole_holders = true means that there will be cylinders that will enter the holes of the screen to hold it
    // box
    case_height = ssd1306_pcb_height + ssd1306_screen_height + cover_thickness;
    difference() {
        cube([ssd1306_width+walls_width*2, ssd1306_length+walls_width*2, case_height]);
        translate([walls_width, walls_width, 0]) {
            ssd1306_shadow_front(shadow_screen_extender=cover_thickness, with_holes=with_hole_holders);
            if (with_holes) {
                ssd1306_holes(hole_extender=cover_thickness);
            }
        } 
    }
}
