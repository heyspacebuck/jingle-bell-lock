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
separated = false; // If true, lays out the component parts for FDM printing; if false, combines them.
bellRadius = 18;
wallThickness = 2;
gap = .75; // Amount of space to leave between hasp and bell
haspRadius = 8; // The radius of the large bend in the hasp
haspHeight = 20; // The straight portion of the hasp's length
haspThickness = 1.8; // The radius of the hasp
flatRadius = 9; // The radius of the flat portion at the top of the bell
thickLeaves = false; // Selectively thickens parts of the bell leaves so they are easier to print on an FDM machine.
$fn = 64; // Sets the resolution of the rendered part. Higher number means higher resolution.


// Some trig calculations used in computing the size of the flat portion at the top of the bell
theta = asin(flatRadius/bellRadius);
flatHeight = flatRadius/tan(theta);
interiorFlatRadius = sin(theta)*(bellRadius-wallThickness);

module main() {
  if (separated) {
    dz(flatHeight) rx(180) bell();
    dz(haspThickness) dx(-2.4*bellRadius) rx(90) hasp();
  } else {
    union() {
      bell();
      dz(haspHeight/2 + haspRadius - 8.1) hasp();
    }
  }
}

module hasp() {
  union() {
    dz(-haspHeight/2) dx(-haspRadius) cylinder(r=haspThickness, h=haspHeight);
    dz(-haspHeight/2) dx(haspRadius) cylinder(r=haspThickness, h=haspHeight);
    dz(haspHeight/2) rx(90) torus(haspRadius, haspThickness, 180);
//    dz(haspHeight/2) dx(-haspRadius) sy(0.5) cylinder(r=2*haspThickness, h=wallThickness);
//    dz(haspHeight/2) dx(haspRadius) sy(0.5) cylinder(r=2*haspThickness, h=wallThickness);
    dz(-haspHeight/2) rx(90) torus(haspRadius, haspThickness, -110, rounded=true);
    mx() dz(-haspHeight/2) rx(90) torus(haspRadius, haspThickness, -30, rounded=true);
  }
}

module truncatedSphere(R, r) {
  difference() {
    sphere(r=R);
    dz(r/tan(asin(r/R))) cylinder(r=r, h=R);
  }
}

module bell() {
  
  intersection() {
    keyStuff();
    truncatedSphere(bellRadius, flatRadius);
  }
  
  difference() {
    union() {
      difference() {
        // Main body: a truncated sphere
        truncatedSphere(bellRadius, flatRadius);
    
        // Smaller truncated sphere to hollow out the main body
        truncatedSphere(bellRadius-wallThickness, interiorFlatRadius);
      }
      if (thickLeaves) {
        supports();
      }
    }
    
    // Bell holes
    rx(90) dz(-bellRadius) cylinder(r=3.1, h=2*bellRadius);
    rz(90) rx(90) dz(-bellRadius) cylinder(r=3.1, h=2*bellRadius);
    
    // Bell slits
    rx(180) dy(-bellRadius) dx(-1.55) cube([3.1, 2*bellRadius, bellRadius]);
    rz(90) rx(180) dy(-bellRadius) dx(-1.55) cube([3.1, 2*bellRadius, bellRadius]);
    
    
    // A slot for the hasp to enter
    hull() {
      dx(-haspRadius) cylinder(r=haspThickness+gap, h=bellRadius);
      dx(haspRadius) cylinder(r=haspThickness+gap, h=2*bellRadius);
    }
    
//    dz(-bellRadius) cylinder(r=bellRadius, h=bellRadius);
  }
}

module supports() {
  intersection() {
    sphere(r=bellRadius);
    union() {
      dx(1.55) dy(1.55) dz(wallThickness) rz(45) dx(bellRadius) dy(-bellRadius*sqrt(2)/2) ry(135) cube(bellRadius*sqrt(2));
      rz(90) dx(1.55) dy(1.55) dz(wallThickness) rz(45) dx(bellRadius) dy(-bellRadius*sqrt(2)/2) ry(135) cube(bellRadius*sqrt(2));
      rz(180) dx(1.55) dy(1.55) dz(wallThickness) rz(45) dx(bellRadius) dy(-bellRadius*sqrt(2)/2) ry(135) cube(bellRadius*sqrt(2));
      rz(270) dx(1.55) dy(1.55) dz(wallThickness) rz(45) dx(bellRadius) dy(-bellRadius*sqrt(2)/2) ry(135) cube(bellRadius*sqrt(2));
    }
  }
}

module keyStuff() {
  rz(180) difference() {
    union() {
      dy(bellRadius-21.5) rx(90) {
        cylinder(r=5, h=bellRadius);
        dx(-5) cube([10, bellRadius, bellRadius]);
      }
    }
    dy(bellRadius-13) stealth_lock();
  }
  dy(-5) rx(90) {
    cylinder(r=5, h=7);
    dx(-5) cube([10, bellRadius, 7]);
  }
}

main();