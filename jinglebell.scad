////////////////////
// Jingle Bell Lock
// by Space Buck, November 2020
// Released under BSD Revised License
////////////////////

// These custom libraries are necessary. They should be located in the /libraries/ subfolder inside the main OpenSCAD Library folder.
include <handyfunctions.scad>
include <torus.scad>
include <stealth_lock.scad>

// Parameters you can change.
separated = true; // If true, lays out the component parts for FDM printing; if false, combines them.
bellRadius = 18;
topShellHeight= 5;
wallThickness = 1;
gap = .75;
haspRadius = 10;
haspHeight = 5;
haspThickness = 1.8;
$fn = 64; // Sets the resolution of the rendered part. Higher number means higher resolution.

module main() {
  if (separated) {
    dz(topShellHeight) rx(180) topShell();
    dz(haspThickness) dx(-40) rx(90) hasp();
    dx(40) rx(180) bottomShell();
  } else {
    union() {
      topShell();
      bottomShell();
      dz(haspHeight/2+gap) hasp();
    }
  }
}

module hasp() {
  union() {
    dz(-haspHeight/2) dx(-haspRadius) cylinder(r=haspThickness, h=haspHeight);
    dz(-haspHeight/2) dx(haspRadius) cylinder(r=haspThickness, h=haspHeight);
    dz(haspHeight/2) rx(90) torus(haspRadius, haspThickness, 180);
    dz(haspHeight/2) dx(-haspRadius) sy(0.5) cylinder(r=2*haspThickness, h=wallThickness);
    dz(haspHeight/2) dx(haspRadius) sy(0.5) cylinder(r=2*haspThickness, h=wallThickness);
    dz(-haspHeight/2) rx(90) torus(haspRadius, haspThickness, -110, rounded=true);
    mx() dz(-haspHeight/2) rx(90) torus(haspRadius, haspThickness, -30, rounded=true);
  }
}

module topShell() {
  intersection() {
    union() {
      keyStuff();
      difference() {
        hull() torus(bellRadius-topShellHeight, topShellHeight);
        hull() torus(bellRadius-topShellHeight, topShellHeight-wallThickness);
        mz() cylinder(r=30, h=30);
        hull() {
          dx(-haspRadius) cylinder(r=haspThickness+gap, h=100);
          dx(haspRadius) cylinder(r=haspThickness+gap, h=100);
        }
        rx(90) dz(-30) cylinder(r=3.1, h=60);
        rz(90) rx(90) dz(-30) cylinder(r=3.1, h=60);      
      }
    }
    hull() torus(bellRadius-topShellHeight, topShellHeight);
  }
}

module bottomShell() {
  difference() {
    sphere(r=bellRadius);
    sphere(r=bellRadius-wallThickness);
    cylinder(r=40, h=40);
    dz(-100) cylinder(r=3, h=100);
    cube(center=true, [200, 3.2, 100]);
    cube(center=true, [3.2, 200, 100]);
    rx(90) dz(-30) cylinder(r=3.1, h=60);
    rz(90) rx(90) dz(-30) cylinder(r=3.1, h=60);
  }
}

module keyStuff() {
  rz(180) dy(5) difference() {
    dy(-8.5) rx(90) cylinder(r=5, h=11);
    stealth_lock();
  }
  dy(-5) rx(90) cylinder(r=5, h=6);
}

main();