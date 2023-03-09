////////////////////
// Jingle Bell Lock
// by Space Buck, November 2020
// Modified December 2022
// Released under BSD Revised License
////////////////////

// These custom libraries are necessary. They should be located in the same folder as jinglebell.scad, OR in the /libraries/ subfolder inside the main OpenSCAD Library folder.
include <handyfunctions.scad>
include <torus.scad>
include <stealth_lock.scad>

// Parameters you can change.
separated = T; // If true, lays out the component parts for FDM printing; if false, combines them.
bellRadius = 20;
wallThickness = 2;
gap = .5; // Amount of space to leave between hasp and bell
haspRadius = 8; // The radius of the large bend in the hasp
haspHeight = 24; // The straight portion of the hasp's length
haspThickness = 1.75; // The radius of the hasp
flatRadius = 12; // The radius of the flat portion at the top of the bell
thickLeaves = T; // Selectively thickens parts of the bell leaves so they are easier to print on an FDM machine.
squareHasp = T; // If true, gives the hasp a square cross-section that makes it more FDM-friendly.
$fn = 64; // Sets the resolution of the rendered part. Higher number means higher resolution.


// Some trig calculations used in computing the size of the flat portion at the top of the bell
theta = asin(flatRadius/bellRadius);
flatHeight = flatRadius/tan(theta);
interiorFlatRadius = sin(theta)*(bellRadius-wallThickness);



main();


module main() {
  if (separated) {
    dz(flatHeight) rx(180) bell();
    dz(haspThickness) dx(-2.4*bellRadius) rx(90) hasp();
  } else {
    union() {
      bell();
      dz(haspHeight/2 + haspRadius - 8.1-5) hasp();
    }
  }
}

module hasp() {
  if (squareHasp) {
    sy(.9) union() {
      dx(-haspRadius) cube([2*haspThickness, 2*haspThickness, haspHeight], center=true);
      dx(haspRadius) cube([2*haspThickness, 2*haspThickness, haspHeight], center=true);
      dz(haspHeight/2) rx(90) rotate_extrude(angle=180) {
        dx(haspRadius) square(2*haspThickness, center=true);
      }
      dz(-haspHeight/2) rx(90) rotate_extrude(angle=-110) {
        dx(haspRadius) square(2*haspThickness, center=true);
      }
      mx() dz(-haspHeight/2) rx(90) rotate_extrude(angle=-30) {
        dx(haspRadius) square(2*haspThickness, center=true);
      }
    }
  } else {
    union() {
      dz(-haspHeight/2) dx(-haspRadius) cylinder(r=haspThickness, h=haspHeight);
      dz(-haspHeight/2) dx(haspRadius) cylinder(r=haspThickness, h=haspHeight);
      dz(haspHeight/2) rx(90) torus(haspRadius, haspThickness, 180);
      dz(-haspHeight/2) rx(90) torus(haspRadius, haspThickness, -110, rounded=true);
      mx() dz(-haspHeight/2) rx(90) torus(haspRadius, haspThickness, -30, rounded=true);
    }
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
        union() {
        truncatedSphere(bellRadius, flatRadius);
          dz(10) cylinder(r1=20*cos(30), r2=13.8, h=6);
        }
    
        // Smaller truncated sphere to hollow out the main body
        truncatedSphere(bellRadius-wallThickness, interiorFlatRadius);
      }
      if (thickLeaves) {
        supports();
      }
      
    }
    
    // Bell holes
    rx(-90) cylinder(r=3.1, h=2*bellRadius);
    rx(90) cylinder(r=2.5, h=2*bellRadius);
    rz(90) rx(90) dz(-bellRadius) cylinder(r=2.5, h=2*bellRadius);
    
    // Bell slits
    rx(180) dy(-2*bellRadius) dx(-1.6) cube([3.2, 2*bellRadius, bellRadius]);
    rx(180) dx(-1.25) cube([2.5, 2*bellRadius, bellRadius]);
    rz(90) rx(180) dy(-bellRadius) dx(-1.25) cube([2.5, 2*bellRadius, bellRadius]);
    
    
    // A slot for the hasp to enter
    hull() {
      dx(-haspRadius-gap) cylinder(r=haspThickness+gap, h=bellRadius);
      dx(haspRadius+gap) cylinder(r=haspThickness+gap, h=2*bellRadius);
    }
    
//    dz(-bellRadius) cylinder(r=bellRadius, h=bellRadius);
  }
}

module supports() {
  intersection() {
    sphere(r=bellRadius);
    union() {
      dx(1.6) dy(1.6) dz(wallThickness) rz(45) dx(bellRadius) dy(-bellRadius*sqrt(2)/2) ry(135) cube(bellRadius*sqrt(2));
      rz(90) dx(1.6) dy(1.6) dz(wallThickness) rz(45) dx(bellRadius) dy(-bellRadius*sqrt(2)/2) ry(135) cube(bellRadius*sqrt(2));
      rz(180) dx(1.6) dy(1.6) dz(wallThickness) rz(45) dx(bellRadius) dy(-bellRadius*sqrt(2)/2) ry(135) cube(bellRadius*sqrt(2));
      rz(270) dx(1.6) dy(1.6) dz(wallThickness) rz(45) dx(bellRadius) dy(-bellRadius*sqrt(2)/2) ry(135) cube(bellRadius*sqrt(2));
    }
  }
}

module keyStuff() {
  difference() {
    union() {
      dy(2.25) rx(-90) cylinder(r=5, h=bellRadius);
      dy(2.25) dx(-5) cube([10, bellRadius, bellRadius]);
    }
    rx(-90) cylinder(r=3.1, h=bellRadius);
    dz(-bellRadius) dx(-1.6) cube([3.2, bellRadius, bellRadius]);
  }
  dy(-2.25) rx(90) {
    cylinder(r=5, h=4);
    dx(-5) cube([10, bellRadius, 4]);
    dx(-5) dy(5) cube([10, bellRadius, 17]);
  }
}