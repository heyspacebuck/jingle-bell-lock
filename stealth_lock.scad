include <handyfunctions.scad>

module stealth_lock() {
  union() {
    rx(90) cylinder(r=3.1, h=23);
    dx(-1.6) dy(-23) dz(-8.1) cube([3.2, 21.5, 8.1]);
    dy(-1.5) ry(90) rx(90) rotate_extrude(angle=-55) {
      square([8.1, 7]);
    }
  }
}