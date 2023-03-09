include <handyfunctions.scad>
include <primitives.scad>

module stealth_lock(slop=0) {
  union() {
    rx(90) cylinder(r=3.1+slop, h=23);
    dx(-1.6-slop) dy(-23) dz(-8.1-slop) cube([3.2+2*slop, 21.5, 8.1+slop]);
    dy(-1.5) ry(90) rx(90) rotate_extrude(angle=-55) {
      square([8.1+slop, 7+slop]);
    }
  }
}

module stealth_lock_insert(angle=0) {
  ry(90) cylinder(r=3.0, h=13.0);
  dz(-7) cuboid(13.0, 2.65, 7.0, false, true, false);
  dz(-6) dx(13) rx(90) linear_extrude(1.7, center=true) {
    polygon([[0,0], [2.5, 0], [1.45, 2.5], [0, 2.5]]);
  }
  rx(180+angle) {
    dx(19) ry(-90) cylinder(r=2.75, h=6.0);
    *dx(19) rz(180) cuboid(3,1.7,6.05, false, true, false);
    dx(19) rz(180) rx(90) linear_extrude(1.7, center=true) {
  polygon([[0,0],[0,6.05],[3,6.05],[5.54,0]]);
    }
  }
}