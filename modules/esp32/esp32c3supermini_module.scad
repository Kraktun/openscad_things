/*

ESP32-C3 supermini
measures are in mm
(in my case some modules have the usb-c not soldered perfectly straight, 
which is why the measures allow for some room around it)

\-\ = 4.5
   \--\ = 9
       \-\ = 4.5
\--------\ = 18    
    __  
 __|  |__  
|        | 
|        |
|        |
|        |
|________|


\-\ = 1.5
\---\ = 7.5
  \----------\ = 22.5
   __________
 _|_         |
|_ _|        |
  |__________|

\-\ = 1
  \-\ = 3.1 
\----\ = 4.1  
(with buttons etc. consider an internal height of around 3, pcb included)
   _
 _| |
|  _|
| |
| |
|_|

*/

// set esp32c3_supermini_overrider if your printer requires a manual resize to print the correct sizes 
// and instead you want to manually increase the main sizes by a given amount
// e.g. esp32c3_supermini_overrider = 1
// means that the base will be 1mm wider
// note that esp32c3_supermini_overrider must be set before your <include> statement
esp32c3_supermini_overrider_in = is_undef(esp32c3_supermini_overrider) ? 0 : esp32c3_supermini_overrider;

if (esp32c3_supermini_overrider_in != 0) {
  echo(str("Setting a manual override for esp32c3_supermini of ", esp32c3_supermini_overrider_in));
}

esp32c3_supermini_width = 18 + esp32c3_supermini_overrider_in;
esp32c3_supermini_pcb_width = esp32c3_supermini_width;
esp32c3_supermini_usbc_width = 9 + esp32c3_supermini_overrider_in;
esp32c3_supermini_lat_width = (esp32c3_supermini_width - esp32c3_supermini_usbc_width)/2;
esp32c3_supermini_usbc_length = 7.5 + esp32c3_supermini_overrider_in; // includes esp32c3_supermini_usbc_length_out
esp32c3_supermini_usbc_length_out = 1.5 + esp32c3_supermini_overrider_in/2;
esp32c3_supermini_pcb_length = 23 + esp32c3_supermini_overrider_in;
esp32c3_supermini_length = esp32c3_supermini_usbc_length_out + esp32c3_supermini_pcb_length;
esp32c3_supermini_pcb_height = 1 + esp32c3_supermini_overrider_in/2;
esp32c3_supermini_usbc_height = 3.1 + esp32c3_supermini_overrider_in/2;
esp32c3_supermini_height = esp32c3_supermini_pcb_height + esp32c3_supermini_usbc_height;
// buttons and components on the pcb
esp32c3_supermini_internal_comp_height = esp32c3_supermini_pcb_height + 2 + esp32c3_supermini_overrider_in/2;
esp32c3_supermini_internal_comp_width = esp32c3_supermini_width - 4;
esp32c3_supermini_internal_comp_length = esp32c3_supermini_length - esp32c3_supermini_usbc_length;

module esp32c3_supermini_shadow() {
    // this is a very basic copy of the esp32c3 supermini module that you can use to check if it fits in 
    // whatever you are designing, or to use it in a `difference()`

    // pcb
    cube([esp32c3_supermini_pcb_width, esp32c3_supermini_pcb_length, esp32c3_supermini_pcb_height]);
    // internal components
    translate([(esp32c3_supermini_pcb_width-esp32c3_supermini_internal_comp_width)/2,0,0]) { 
        cube([esp32c3_supermini_internal_comp_width, esp32c3_supermini_internal_comp_length, esp32c3_supermini_internal_comp_height]);
    }
    // usbc
    translate([esp32c3_supermini_lat_width,esp32c3_supermini_length-esp32c3_supermini_usbc_length,esp32c3_supermini_pcb_height]) { 
        cube([esp32c3_supermini_usbc_width, esp32c3_supermini_usbc_length, esp32c3_supermini_usbc_height]);
    }
}

module esp32c3_supermini_box(box_height) {
    // a "cube" with the 2d size of the esp32 + a smaller appendix for the usb c
    // the height must be supplied as a parameter

    cube([esp32c3_supermini_pcb_width, esp32c3_supermini_pcb_length, box_height]);
    translate([esp32c3_supermini_lat_width,esp32c3_supermini_length-esp32c3_supermini_usbc_length,0]) { 
        cube([esp32c3_supermini_usbc_width, esp32c3_supermini_usbc_length, box_height]);
    }
}

module esp32c3_supermini_surrounding_wall(wall_width, wall_height, base_height=0) {
    // a wall that goes around the esp32 with a hole for the usbc
    // the height must be supplied as a parameter
    // if base_height is > 0, a base is added (the height of the wall starts from the top of the base)

    difference() {
      cube([esp32c3_supermini_pcb_width+2*wall_width, esp32c3_supermini_pcb_length+2*wall_width, wall_height+base_height]);
      translate([wall_width, wall_width, base_height]) { 
        esp32c3_supermini_box(wall_height);
        // elongate usb c
        translate([esp32c3_supermini_lat_width,esp32c3_supermini_length-esp32c3_supermini_usbc_length,0]) { 
          cube([esp32c3_supermini_usbc_width, esp32c3_supermini_usbc_length+wall_width, wall_height]);
        }
      }
    }
}