include <handyfunctions.scad>

module stealth_lock(slop=0) {
  union() {
    rx(90) cylinder(r=3.1+slop, h=23);
    dx(-1.6-slop) dy(-23) dz(-8.1-slop) cube([3.2+2*slop, 21.5, 8.1+slop]);
    dy(-1.5) ry(90) rx(90) rotate_extrude(angle=-55) {
      square([8.1+slop, 7+slop]);
    }
  }
}