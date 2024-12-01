
module honeycomb(width, depth, height, r, wall) {
    // width, depth, height = 3d size of the mesh
    // r = radius of the hexagon, i.e. distance from center to vertex
    // wall = thickness of the hexagon, actual thickness of the mesh will be twice this measure
    module hexagon() {
        difference() {
            cylinder(r=r+wall, h=height, $fn=6);
            cylinder(r=r, h=height, $fn=6);
        }
    }
    module bounding_box() {
        difference() {
            translate([-2*r, -2*r, 0]) {
                cube([width+8*(r+wall), depth+8*(r+wall), height]);
            }
            cube([width, depth, height]);
        }
    }

    difference() {
        for (
            y_off = [0 : 2*(r+wall)*sin(60) : depth+r],
            x_off = [-r-wall+(r+wall)*cos(60) : 2*(r+wall)+(r+wall)*cos(60)*2 : width+r]
        ) {
            translate([x_off, y_off, 0]) { 
                hexagon();
            }
            translate([(r+wall)*cos(60)+r+wall+x_off, (r+wall)*sin(60)+y_off, 0]) { 
                hexagon();
            }
        }
        bounding_box();
    }
}
