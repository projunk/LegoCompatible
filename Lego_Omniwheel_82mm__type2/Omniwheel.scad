// OpenSCAD 2019-5

eps = 0.1;
rotate_extrude_eps = 0.001;
bigSize = 200.0;
smallSize = 15.0;


// printability corrections; values should be zero for real object dimensions
// ninja 
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

axleLength = 31.4;


// roller
hRoller = 20.0;
rRoller1 = 82.0/2;
rRoller2 = 15.0/2;
rollerRadiusMarge = 1.5;
rollerHeightMarge = 2.0;
hRollerHole = hRoller + rollerHeightMarge;
rRollerHole1 = rRoller1 + rollerRadiusMarge;
rRollerHole2 = rRoller2 + rollerRadiusMarge;
rRollerHoleAxis = r2;
nrOfRollers = 6;


// circumference limits
distanceAtMid = 2.0;
distanceAtBearings = 1.5;


// position of rollers
flesh = 1.0;
rotaAxisRadius = rRoller1 - rRoller2;
rotaAxisOffset = rRoller2 + flesh;


// bearing
rBearing = r2 + 1.8;
tBearing = (2*PI *rotaAxisRadius - nrOfRollers * hRoller)/(2*nrOfRollers);


// sphere
rollerRadiusReduction = 0.1;
radiusSphere = rRoller1 - rollerRadiusReduction;
heightCutOffSphere = 38.5;
cutOffHeightSphere = (2*radiusSphere-heightCutOffSphere)/2;
offsetSphere = radiusSphere - cutOffHeightSphere;


// sphere for axis holes
radiusSphere2 = 7.0;
radiusOffsetSphere2 = 6.5;
cutOffSphere2 = 1.5;


// fancy stuff
fancyTorusRadius = 2.3*pitch;
fancyTorusCylinderRadius = 4.5;
fancyTorusOffsetZ = 1.5;
fancyVerticalHoleRadius = fancyTorusCylinderRadius - 1.0;
fancyNrOfVerticalHoles = 12;
fancyDimpelRadius = 5;
fancyDimpelOffsetX = -1.5;
fancyDimpelOffsetZ = 1.5;
fancyInnerRadius = fancyTorusRadius + fancyTorusCylinderRadius;


Orange = "orange";
Grey = "#B6B6B6";
Black = "#333333";



module circumferenceLimiter(prmDistanceLimit)
{
	difference()
	{
		translate([0,0,-eps-bigSize/2]) cylinder(bigSize+eps, bigSize, bigSize, $fn=500);
		translate([0,0,-2*eps-bigSize/2]) cylinder(bigSize+3*eps, rRoller1-prmDistanceLimit, rRoller1-prmDistanceLimit, $fn=500);
	}
}


module drawPinHole()
{
	translate([0,0,-eps]) cylinder(h2+eps, r3, r3,$fn=50);
	translate([0,0,h2-eps]) cylinder(h1-2*h2+2*eps, r2, r2,$fn=50);
	translate([0,0,h1-h2]) cylinder(h2+eps, r3, r3,$fn=50);
}


module drawDoublePinHole()
{
	drawPinHole();
	translate([0,0,h1]) drawPinHole();
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
    holeAxleLength = 2*(rotaAxisRadius*tan(180/nrOfRollers));
	rotate_extrude(convexity = 10, $fn = 100) translate([rotate_extrude_eps,0,0]) drawRollerFlat(rRollerHole1, rRollerHole2, hRollerHole);
    translate([0,0,-holeAxleLength/2]) cylinder(holeAxleLength, rRollerHoleAxis, rRollerHoleAxis,$fn=50);
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
			translate([0,0,-hRollerHole/2-tBearing]) cylinder(tBearing, rBearing, rBearing,$fn=50);
			translate([0,0,hRollerHole/2]) cylinder(tBearing, rBearing, rBearing,$fn=50);
		}
		union()
		{
			translate([0,0,-hRollerHole/2-bigSize]) cylinder(bigSize, rRollerHoleAxis, rRollerHoleAxis,$fn=50);
			translate([0,0,hRollerHole/2]) cylinder(bigSize, rRollerHoleAxis, rRollerHoleAxis,$fn=50);
		}
	}		
}


module drawBearings()
{
	difference()
	{
		union()
		{
            for (i = [0:nrOfRollers-1]) {
                angle=i*360/nrOfRollers;	
                rotate([0,0,angle]) translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) drawBearing();
            }            
		}
		union()
		{
            for (i = [0:nrOfRollers-1]) {            
                angle=i*360/nrOfRollers+180/nrOfRollers;
                rotate([0,0,angle]) drawSphereHole();
            }            
		}
	}
}


module drawSphereHole()
{
	translate([-rotaAxisRadius-radiusOffsetSphere2,0,0]) 
	{
		difference()
		{
			union()
			{
				sphere(r=radiusSphere2,$fn=100);
			}
			union()
			{
                angle = 180/nrOfRollers;
				rotate([0,0,90-angle]) translate([radiusSphere2-cutOffSphere2,-bigSize/2,-bigSize/2]) cube([bigSize,bigSize,bigSize]);
                rotate([0,0,-90+angle]) translate([radiusSphere2-cutOffSphere2,-bigSize/2,-bigSize/2]) cube([bigSize,bigSize,bigSize]);                
			}
		}
	}
}


module drawRollers(prmIsHole, prmAddAxle=false)
{
    for (i = [0:nrOfRollers-1]) {    
		angle=i*360/nrOfRollers;	
		rotate([0,0,angle]) translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) drawRollerEx(prmIsHole, prmAddAxle);
    }

	if (prmIsHole)
	{
        for (i = [0:nrOfRollers-1]) {        
            angle=i*360/nrOfRollers+180/nrOfRollers;
            rotate([0,0,angle]) drawSphereHole();
        }
	}
}


module drawFancyTorus() {
	rotate([0,0,180]) {
		rotate_extrude(convexity = 10, $fn = 100) {
					translate([fancyTorusRadius, 0, 0])
					circle(r = fancyTorusCylinderRadius,$fn=50);
		}
	}
}


module drawFancyVerticalHoles() {
	offsetAngle = 0.5*360/fancyNrOfVerticalHoles;
	for (i = [0:fancyNrOfVerticalHoles-1]) {
		angle=i*360/fancyNrOfVerticalHoles+offsetAngle;
		rotate([0,0,angle]) translate([-fancyTorusRadius,0,0]) translate([0,0,-bigSize/2]) cylinder(bigSize,fancyVerticalHoleRadius,fancyVerticalHoleRadius,$fn=50);
	}
}


module drawFancyDimpels(prmIsTop)
{
    offsetAngle = prmIsTop ? 180/nrOfRollers : 0;
    zPos = prmIsTop ? offsetSphere+fancyDimpelOffsetZ : -offsetSphere-fancyDimpelOffsetZ;
    R = (radiusSphere - distanceAtMid + fancyInnerRadius)/2;
    for (i = [0:nrOfRollers-1]) {
        angle=i*360/nrOfRollers+offsetAngle;
        rotate([0,0,angle]) translate([R+fancyDimpelOffsetX,0,zPos]) sphere(fancyDimpelRadius,$fn=100);        
    }    
}


module drawFancyStuff()
{       
    drawFancyDimpels(true);
    drawFancyDimpels(false); 
    translate([0,0,-offsetSphere+2*h1+fancyTorusOffsetZ]) drawFancyTorus();
    translate([0,0,-offsetSphere-fancyTorusOffsetZ]) drawFancyTorus();
    drawFancyVerticalHoles();
}


module drawPrintSupport()
{
    supportHeight = 1;
    supportWidth = 2;
    nrOfSupports = 4;
    
    R = fancyTorusRadius - fancyTorusCylinderRadius;
    for (i = [0:nrOfSupports-1]) {
        angle=i*360/nrOfSupports;
        rotate([0,0,angle]) translate([R,-supportWidth/2,-offsetSphere]) cube([2*fancyTorusCylinderRadius,supportWidth,supportHeight]);
    }
}


module drawBase() 
{
	difference()
	{
		union()
		{	
			sphere(r=radiusSphere, $fn=500);
		}
		union()
		{	
            translate([0,0,-offsetSphere+2*h1]) cylinder(bigSize,fancyInnerRadius,fancyInnerRadius, $fn=500);            
			translate([0,0,-bigSize/2]) drawAxleHole(bigSize);
            translate([0,0,-offsetSphere]) {
                rotate([0,0,0]) translate([0,pitch,0]) drawDoublePinHole();
                rotate([0,0,90]) translate([0,pitch,0]) drawDoublePinHole();
                rotate([0,0,180]) translate([0,pitch,0]) drawDoublePinHole();
                rotate([0,0,270]) translate([0,pitch,0]) drawDoublePinHole();
            }
            drawFancyStuff();
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
			translate([-bigSize/2,-bigSize/2,offsetSphere]) cube([bigSize,bigSize,bigSize]);
			translate([-bigSize/2,-bigSize/2,-bigSize-offsetSphere]) cube([bigSize,bigSize,bigSize]);
			translate([0,0,rotaAxisOffset]) drawRollers(true);
			rotate([0,0,180/nrOfRollers]) translate([0,0,-rotaAxisOffset]) drawRollers(true);			
		}
	}

	translate([0,0,rotaAxisOffset]) drawBearings();
	rotate([0,0,180/nrOfRollers]) translate([0,0,-rotaAxisOffset]) drawBearings();
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
//    drawPrintSupport();
}


module drawImportedOmniwheel()
{
    color(Orange) import("Omniwheel.stl");
}    


module drawImportedRoller()
{
    color(Black) import("Roller.stl");
}    


module drawImportedAxle4()
{
    color(Grey) import("technic_axle_4.stl");
}    


module drawImportedRollerAxle()
{
    drawImportedRoller();
    translate([0,0,-2*pitch]) drawImportedAxle4();
}    


module drawImportedRollers()
{
    for (i = [0:nrOfRollers-1]) {    
		angle=i*360/nrOfRollers;	
		rotate([0,0,angle]) translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) drawImportedRollerAxle();
    }    
}


module drawAssembly()
{
	drawImportedOmniwheel();
	translate([0,0,rotaAxisOffset]) drawImportedRollers();
	rotate([0,0,180/nrOfRollers]) translate([0,0,-rotaAxisOffset]) drawImportedRollers();
}



// tests
//drawRollerFlat(rRoller1, rRoller2, hRoller);
//drawRoller(true);
//drawRollers(true,true);
//drawRollers(true,false);
//drawBearings();
//drawFancyTorus();
//drawFancyStuff();
//drawSphereHole();
//translate([-rotaAxisRadius,0,0]) rotate([90,0,0]) 
//drawRollerHole();
//drawRollerEx(true, false);
//drawRollerEx(false, true);
//drawRollerEx(false, false);
//drawBase();
//drawBaseWithBearings();
//drawFullPinHole();
//drawPrintSupport();
drawAssembly();


// parts
//drawOmniwheel();
//drawRoller();
