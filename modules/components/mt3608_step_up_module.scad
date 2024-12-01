$fa = 1;
$fs = 0.25;

step_up_length = 32;
step_up_width = 18;
step_up_height = 9;
step_up_usb_width = 9;
step_up_usb_height = step_up_height;
step_up_usb_offset_width = (step_up_width-step_up_usb_width)/2;
step_up_usb_offset_height = 0;
step_up_regulator_radius = 1.5; // the thing that controls V_out
step_up_regulator_offset_length = 24; // wrt the center of the regulator, from the head (usb)
step_up_regulator_offset_height = 7; // wrt the center of the regulator
step_up_tail_width = 5; // the thinghy at the end, between the V+ and V- in out
step_up_tail_offset = (step_up_width-step_up_tail_width)/2;
step_up_head_hat_width = 5;

step_up_thickness_bars = 1;
step_up_thickness_base = 1;

module step_up_base(thickness = step_up_thickness_base, thickness_bars = step_up_thickness_bars) {
    cube([step_up_length+thickness_bars*2, step_up_width+thickness_bars*2, thickness]);
}

module step_up_bars(thickness = step_up_thickness_bars) {
    difference() {
        cube([thickness+step_up_length/3, thickness, step_up_height]);
        translate([step_up_length - step_up_regulator_offset_length, thickness, step_up_regulator_offset_height]) {
            rotate([90,0,0]) {
                cylinder(h = thickness, r = step_up_regulator_radius);
            } 
        } 
    }
    translate([step_up_length*2/3, 0, 0]) {
        cube([thickness+step_up_length/3, thickness, step_up_height]);
    }
    // top
    translate([0, step_up_width+thickness, 0]) {
        cube([thickness+step_up_length/3, thickness, step_up_height]);
    }
    translate([step_up_length*2/3, step_up_width+thickness, 0]) {
        cube([thickness+step_up_length/3, thickness, step_up_height]);
    }
}

module step_up_head(thickness = step_up_thickness_bars) {
    translate([step_up_length+thickness, 0, 0]) {
        difference() {
            cube([thickness, step_up_width+2*thickness, step_up_height]);
            translate([0, step_up_usb_offset_width+thickness, step_up_usb_offset_height]) { 
                cube([thickness, step_up_usb_width, step_up_usb_height]);
            }
        }
    }
}
module step_up_head_hat(thickness = step_up_thickness_bars) {
    translate([step_up_length+2*thickness-step_up_head_hat_width, 0, step_up_height]) {
        cube([step_up_head_hat_width, step_up_width+2*thickness, thickness]);
    }
}

module step_up_tail(thickness = step_up_thickness_bars) {
    translate([0, step_up_tail_offset+thickness, 0]) {
        cube([thickness, step_up_tail_width, step_up_height]);
    }
}

module step_up_aio(thickness_base = step_up_thickness_base, thickness_bars = step_up_thickness_bars) {
    step_up_base(thickness = thickness_base, thickness_bars = thickness_bars);
    translate([0, 0, thickness_base]) {
        step_up_bars(thickness = thickness_bars);
        step_up_head(thickness = thickness_bars);
        step_up_head_hat(thickness = thickness_bars);
        step_up_tail(thickness = thickness_bars);
    }
}
