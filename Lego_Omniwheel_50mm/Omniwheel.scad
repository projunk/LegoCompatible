// OpenSCAD 2019-5


eps = 0.1;
rotate_extrude_eps = 0.001;
bigSize = 200.0;


// printability corrections; values should be zero for real object dimensions
PRINTABLE = 1;
correction_ra1 = PRINTABLE ? 0.05 : 0.0;
correction_ra2 = PRINTABLE ? 0.0 : 0.0;
correction_offset_ra2 = PRINTABLE ? 0.10 : 0.0;
correction_pinhole_r2 = PRINTABLE ? 0.05 : 0.0;
correction_pinhole_r3 = PRINTABLE ? 0.5 : 0.0;
correction_rollerlength = PRINTABLE ? -0.3 : 0.0;


h1 = 7.8;
h2 = 0.7;

r1 = 23.4/2;
r2 = 4.8/2 + correction_pinhole_r2;
r3 = 6.1/2 + correction_pinhole_r3;

pitch = 8.0;


// axle hole
ra1 = (4.8/2 + correction_ra1);
ra2 = (1.0/2 + correction_ra2);
offset_ra2 = (1.4 + correction_offset_ra2);

axleLength = 23.3;


// bearing
rBearing = r2 + 1.8;
tBearing = 4.0;


// Roller
hRoller = 14.0;
rRoller1 = 50.0/2;
rRoller2 = 15.0/2;
RollerRadiusMarge = 1.5;
RollerHeightMarge = 2.0;
hRollerHole = hRoller + RollerHeightMarge;
rRollerHole1 = rRoller1 + RollerRadiusMarge;
rRollerHole2 = rRoller2 + RollerRadiusMarge;
rRollerHoleAxis = r2;


// circumference limits
distanceAtMid = 2.0;
distanceAtBearings = 1.5;


// position of Rollers
flesh = 1.0;
rotaAxisRadius = rRoller1 - rRoller2;
rotaAxisOffset = rRoller2 + flesh;


// sphere
RollerRadiusReduction = 0.1;
radiusSphere = rRoller1 - RollerRadiusReduction;
cutOffHeightSphere = 5.6;
offsetSphere = radiusSphere - cutOffHeightSphere;


// sphere for axis holes
radiusSphere2 = 7.0;
radiusOffsetSphere2 = 6.5;
cutOffSphere2 = 1.5;


fnSphere = $preview ? 50 : 250;


Orange = "orange";
Grey = "#B6B6B6";
Black = "#333333";



module circumferenceLimiter(prmDistanceLimit)
{
	difference()
	{
		translate([0,0,-eps-bigSize/2]) cylinder(bigSize+eps, bigSize, bigSize, $fn=250);
		translate([0,0,-2*eps-bigSize/2]) cylinder(bigSize+3*eps, rRoller1-prmDistanceLimit, rRoller1-prmDistanceLimit, $fn=250);
	}
}


module drawHole()
{
	translate([0,0,-eps]) cylinder(h2+eps, r3, r3, $fn=50);
	translate([0,0,h2-eps]) cylinder(h1-2*h2+2*eps, r2, r2, $fn=50);
	translate([0,0,h1-h2]) cylinder(h2+eps, r3, r3, $fn=50);
}


module drawAxleCutOut(prmLength)
{
    smallSize = 6*ra2;   
    translate([-offset_ra2,offset_ra2,0]) hull()
    {
        translate([0,0,-2*eps]) cylinder(prmLength+4*eps,ra2,ra2,$fn=50);
        translate([-smallSize,-ra2,-2*eps]) cube([eps,2*ra2,prmLength+4*eps]);
        translate([-ra2,smallSize,-2*eps]) cube([2*ra2,eps,prmLength+4*eps]);
    }
}    


module drawAxleHole(prmLength)
{	
    echo("prmLength",prmLength);
	difference()
	{
		union()
		{
			 translate([0,0,-eps]) cylinder(prmLength+2*eps,ra1,ra1,$fn=50);
		}
		union()
		{
            drawAxleCutOut(prmLength);
            rotate([0,0,90]) drawAxleCutOut(prmLength);
            rotate([0,0,180]) drawAxleCutOut(prmLength);
            rotate([0,0,270]) drawAxleCutOut(prmLength);
		}
	}
}


module drawRollerFlat(prmRadiusRoller1, prmRadiusRoller2, prmHeightRoller)
{
	rotate([0,0,-90]) difference()
	{
		union()
		{
			translate([0,-prmRadiusRoller1+prmRadiusRoller2]) circle(r=prmRadiusRoller1,$fn = 250);
		}	
		union()
		{	
			translate([prmHeightRoller/2,-bigSize/2]) square([bigSize,bigSize]);
			translate([-bigSize-prmHeightRoller/2,-bigSize/2]) square([bigSize,bigSize]);
			translate([-bigSize/2,-bigSize]) square([bigSize,bigSize]);
		}
	}
}


module drawRoller(prmAddAxle=false)
{
    difference() 
	{
		union()
		{    
            difference()
            {
                rotate_extrude(convexity = 10, $fn = 100) translate([rotate_extrude_eps,0,0]) drawRollerFlat(rRoller1, rRoller2, hRoller);
                translate([0,0,-hRoller/2-eps]) drawAxleHole(hRoller+2*eps);
            }
        }
		union()
		{
			translate([-bigSize/2,-bigSize/2,-bigSize-hRoller/2-correction_rollerlength/2]) cube([bigSize, bigSize, bigSize]);
			translate([-bigSize/2,-bigSize/2,hRoller/2+correction_rollerlength/2]) cube([bigSize, bigSize, bigSize]);
		}        
    }
	if (prmAddAxle) translate([0,0,-axleLength/2]) drawAxleHole(axleLength);
}


module drawRollerHole()
{
	rotate_extrude(convexity = 10, $fn = 100) translate([rotate_extrude_eps,0,0]) drawRollerFlat(rRollerHole1, rRollerHole2, hRollerHole);
	translate([0,0,-hRollerHole/2-bigSize-eps]) cylinder(bigSize+eps, rRollerHoleAxis, rRollerHoleAxis, $fn=50);
	translate([0,0,hRollerHole/2-eps]) cylinder(bigSize+eps, rRollerHoleAxis, rRollerHoleAxis, $fn=50);	
}


module drawRollerEx(prmIsHole, prmAddAxle=false)
{
	if (prmIsHole) drawRollerHole(); else drawRoller(prmAddAxle);
}


module drawBearing()
{
	difference()
	{
		union()
		{
			translate([0,0,-hRollerHole/2-tBearing]) cylinder(tBearing, rBearing, rBearing, $fn=50);
			translate([0,0,hRollerHole/2]) cylinder(tBearing, rBearing, rBearing, $fn=50);
		}
		union()
		{
			translate([0,0,-hRollerHole/2-bigSize]) cylinder(bigSize, rRollerHoleAxis, rRollerHoleAxis, $fn=50);
			translate([0,0,hRollerHole/2]) cylinder(bigSize, rRollerHoleAxis, rRollerHoleAxis, $fn=50);
		}
	}		
}


module drawBearings()
{
	difference()
	{
		union()
		{
			translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) drawBearing();
			rotate([0,0,90]) translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) drawBearing();
			rotate([0,0,180]) translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) drawBearing();
			rotate([0,0,270]) translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) drawBearing();
		}
		union()
		{
			rotate([0,0,45]) drawSphereHole();
			rotate([0,0,135]) drawSphereHole();
			rotate([0,0,225]) drawSphereHole();
			rotate([0,0,315]) drawSphereHole();
		}
	}
}


module drawSphereHole()
{
	translate([-rotaAxisRadius-radiusOffsetSphere2,0,0]) rotate([0,0,-45]) 
	{
		difference()
		{
			union()
			{
				sphere(r=radiusSphere2,$fn=100);
			}
			union()
			{
				translate([radiusSphere2-cutOffSphere2,-bigSize/2,-bigSize/2]) cube([bigSize,bigSize,bigSize]);
				translate([-bigSize/2,radiusSphere2-cutOffSphere2,-bigSize/2]) cube([bigSize,bigSize,bigSize]);
			}
		}
	}
}


module drawRollers(prmIsHole, prmAddAxle=false)
{
	translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) drawRollerEx(prmIsHole, prmAddAxle);
	rotate([0,0,90]) translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) drawRollerEx(prmIsHole, prmAddAxle);
	rotate([0,0,180]) translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) drawRollerEx(prmIsHole, prmAddAxle);
	rotate([0,0,270]) translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) drawRollerEx(prmIsHole, prmAddAxle);

	if (prmIsHole)
	{
		rotate([0,0,45]) drawSphereHole();
		rotate([0,0,135]) drawSphereHole();
		rotate([0,0,225]) drawSphereHole();
		rotate([0,0,315]) drawSphereHole();
	}
}


module drawBase() 
{
	difference()
	{
		union()
		{	
			sphere(r=radiusSphere, $fn=fnSphere);
		}
		union()
		{	
			translate([-bigSize/2,-bigSize/2,offsetSphere]) cube([bigSize,bigSize,bigSize]);
			translate([-bigSize/2,-bigSize/2,-bigSize-offsetSphere]) cube([bigSize,bigSize,bigSize]);
                       
			translate([0,0,-bigSize/2]) drawAxleHole(bigSize);
            
			// top
			rotate([0,0,45]) translate([0,0,offsetSphere-h1])
			{
				rotate([0,0,0]) translate([0,pitch,0]) drawHole();
				rotate([0,0,90]) translate([0,pitch,0]) drawHole();
				rotate([0,0,180]) translate([0,pitch,0]) drawHole();
				rotate([0,0,270]) translate([0,pitch,0]) drawHole();
			}
			//bottom
			translate([0,0,-offsetSphere])
			{
				rotate([0,0,0]) translate([0,pitch,0]) drawHole();
				rotate([0,0,90]) translate([0,pitch,0]) drawHole();
				rotate([0,0,180]) translate([0,pitch,0]) drawHole();
				rotate([0,0,270]) translate([0,pitch,0]) drawHole();
			}            
		}            
	}
}


module drawBaseWithBearings()
{
	difference()
	{
		union()
		{
			drawBase();
		}
		union()
		{
            circumferenceLimiter(distanceAtMid);
			translate([0,0,rotaAxisOffset]) drawRollers(true);
			rotate([0,0,45]) translate([0,0,-rotaAxisOffset]) drawRollers(true);			
		}
	}

	translate([0,0,rotaAxisOffset]) drawBearings();
	rotate([0,0,45]) translate([0,0,-rotaAxisOffset]) drawBearings();
}


module drawOmniwheel()
{
	difference()
	{
		union()
		{
			drawBaseWithBearings();
		}
		union()
		{
			circumferenceLimiter(distanceAtBearings);
		}
	}
}


module drawImportedOmniWheel()
{
    color(Orange) import("Omniwheel.stl");
}    


module drawImportedRoller()
{
    color(Black) import("Roller.stl");
}    


module drawImportedAxle3()
{
    color(Grey) import("technic_axle_3.stl");
}    


module drawImportedRollerAxle()
{
    drawImportedRoller();
    translate([0,0,-1.5*pitch]) drawImportedAxle3();
}    


module drawImportedRollers()
{
	translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) drawImportedRollerAxle();
	rotate([0,0,90]) translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) drawImportedRollerAxle();
	rotate([0,0,180]) translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) drawImportedRollerAxle();
	rotate([0,0,270]) translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) drawImportedRollerAxle();
}


module drawAssembly()
{
	drawImportedOmniWheel();
	translate([0,0,rotaAxisOffset]) drawImportedRollers();
	rotate([0,0,45]) translate([0,0,-rotaAxisOffset]) drawImportedRollers();
}


// tests
//drawRollerFlat(rRoller1, rRoller2, hRoller);
//drawRollers(true);
//translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) 
//drawRollerHole();
//drawRollerEx(true, false);
//drawBase();
//drawBaseWithBearings();
drawAssembly();



// parts
//drawOmniwheel();
//drawRoller();

