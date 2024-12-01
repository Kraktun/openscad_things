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
esp32c3_supermini_width = 18;
esp32c3_supermini_pcb_width = esp32c3_supermini_width;
esp32c3_supermini_usbc_width = 9;
esp32c3_supermini_lat_width = (esp32c3_supermini_width - esp32c3_supermini_usbc_width)/2;
esp32c3_supermini_usbc_length = 7.5; // includes esp32c3_supermini_usbc_length_out
esp32c3_supermini_usbc_length_out = 1.5;
esp32c3_supermini_pcb_length = 22.5;
esp32c3_supermini_length = esp32c3_supermini_usbc_length_out + esp32c3_supermini_pcb_length;
esp32c3_supermini_pcb_height = 1;
esp32c3_supermini_usbc_height = 3.1;
esp32c3_supermini_height = esp32c3_supermini_pcb_height + esp32c3_supermini_usbc_height;
// buttons and components on the pcb
esp32c3_supermini_internal_comp_height = esp32c3_supermini_pcb_height + 2;
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
