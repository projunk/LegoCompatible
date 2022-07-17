// Roller shape design according to
// http://www.chiefdelphi.com/media/papers/download/2749


eps = 0.1;
bigSize = 500.0;
smallSize = 15.0;


// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 1;
correction_ra1 = PRINTABLE ? 0.05 : 0.0;
correction_ra2 = PRINTABLE ? 0.0 : 0.0;
correction_offset_ra2 = PRINTABLE ? 0.10 : 0.0;
correction_pinhole_r2 = PRINTABLE ? 0.0 : 0.0;
correction_pinhole_r3 = PRINTABLE ? 0.5 : 0.0;
correction_radiusAxleCavity = PRINTABLE ? 0.0 : 0.1;
correction_rollerlength = -1.0;


// bearing
radiusBearingHole = 7.0;
thicknessBearing = 3.0;


// lego pin hole
h1 = 7.8;
h2 = 0.7;

r1 = 23.4/2;
r2 = 4.8/2 + correction_pinhole_r2;
r3 = 6.1/2 + correction_pinhole_r3;

pitch = 8.0;


// roller
heightRoller = 18.0;
radiusWheel = 56.0/2;
radiusRoller = 11.0/2;
nrOfSteps = 40;


// roller axle
rollerAxleRadius = 2.0/2;
rollerAxleLength = heightRoller + 2*thicknessBearing + 3;


// roller cavity
rollerRadiusMarge = 2.0;
rollerHeightMarge = 1.0;
heightRollerCavity = heightRoller + rollerHeightMarge;
radiusWheelCavity = radiusWheel + rollerRadiusMarge;
radiusRollerCavity = radiusRoller + rollerRadiusMarge;
radiusAxleCavity = rollerAxleRadius + correction_radiusAxleCavity;


// mecanumwheel properties
radiusRollerAxleLocation = radiusWheel - radiusRoller;
widthMecanumWheelBase = 3 * h1;
radiusMecanumWheelBase = radiusWheel - 1.5;
nrOfRollers = 7;


// fancy stuff
fancyAngleOffset = 2.5;
fancyTorusRadius = 1.7 * pitch;
fancyTorusCylinderRadius = 2.4;
fancyTorusOffsetZ = 1.5;
fancyVerticalHoleRadius = 1.5;
fancyNrOfVerticalHoles = 2*nrOfRollers;
fancySphereOffsetAngle = 23.0;
fancySphereRadius = 5;
fancySphereOffsetZ = 4.5;
fancySphereOffsetRadial = 1.0;


// axle hole
ra1 = (4.8/2 + correction_ra1);
ra2 = (1.0/2 + correction_ra2);
offset_ra2 = (1.4 + correction_offset_ra2);


Green = "lightgreen";
Grey = "#B6B6B6";
Black = "#333333";



function calcF(S,D) = sqrt(2*D*D+S*S);
	
function calcG(S,D) = sqrt(4*D*D+S*S);

function calcT(S,D,R) = sqrt(2)*R/calcF(S,D);

function calcH(S,D,R) = S/2*(calcT(S,D,R)+1);

function calcRr(S,D,R) = calcG(S,D)/2*(calcT(S,D,R)-1);


module drawHalfRollerFlat(prmRadiusWheel,prmRadiusRoller,prmHeightRoller)
{
	D = prmRadiusWheel - prmRadiusRoller;
	R = prmRadiusWheel;
	H = prmHeightRoller;
	for (i = [1:nrOfSteps-1]) 
    {
		S = (i/(nrOfSteps-1))*H/2;
        prevS = ((i-1)/(nrOfSteps-1))*H/2;
        x2 = calcH(S,D,R);
        y2 = calcRr(S,D,R);
        x1 = calcH(prevS,D,R);
        y1 = calcRr(prevS,D,R);
		polygon([[x1,0],[x2,0],[x2,y2],[x1,y1],[x1,0]]);
	}
}


module drawRollerFlatFixedLength(prmRadiusWheel,prmRadiusRoller,prmHeightRoller)
{
	rotate([0,0,-90]) difference() 
	{
		drawHalfRollerFlat(prmRadiusWheel,prmRadiusRoller,prmHeightRoller);
		translate([prmHeightRoller/2,-bigSize/2,0]) square([bigSize,bigSize]);
	}
}


module drawRollerFlat(prmRadiusWheel,prmRadiusRoller,prmHeightRoller)
{
	drawRollerFlatFixedLength(prmRadiusWheel,prmRadiusRoller,prmHeightRoller);
	mirror([0,1,0]) drawRollerFlatFixedLength(prmRadiusWheel,prmRadiusRoller,prmHeightRoller);
}


module drawRoller(prmRadiusWheel,prmRadiusRoller,prmHeightRoller)
{
	rotate_extrude(convexity = 10, $fn = 100) drawRollerFlat(prmRadiusWheel,prmRadiusRoller,prmHeightRoller);
}


module drawPinHole()
{
	translate([0,0,-eps]) cylinder(h2+eps, r3, r3, $fn=50);
	translate([0,0,h2-eps]) cylinder(h1-2*h2+2*eps, r2, r2, $fn=50);
	translate([0,0,h1-h2]) cylinder(h2+eps, r3, r3, $fn=50);
}


module drawTripplePinHole()
{
	drawPinHole();
	translate([0,0,h1]) drawPinHole();
	translate([0,0,2*h1]) drawPinHole();
}


module drawTripplePinHolePassThrough()
{
	drawTripplePinHole();
	translate([0,0,-bigSize]) cylinder(bigSize, r2, r2, $fn=50);
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


module drawRollerAxle(prmHeight)
{
	cylinder(prmHeight, rollerAxleRadius, rollerAxleRadius, $fn=50);
}


module drawRollerWithAxle()
{
	drawRoller(radiusWheel,radiusRoller,heightRoller);
	translate([0,0,-rollerAxleLength/2]) drawRollerAxle(rollerAxleLength);
}


module drawRollerWithAxleHole()
{
	difference()
	{
		drawRoller(radiusWheel,radiusRoller,heightRoller);
		translate([0,0,-heightRoller/2-eps]) drawRollerAxle(heightRoller+2*eps);
	}
}


module drawRollerWithAxleHoleShortened()
{
	difference() 
	{
		union()
		{
			drawRollerWithAxleHole();
		}
		union()
		{
			translate([-bigSize/2,-bigSize/2,-bigSize-heightRoller/2-correction_rollerlength/2]) cube([bigSize, bigSize, bigSize]);
			translate([-bigSize/2,-bigSize/2,heightRoller/2+correction_rollerlength/2]) cube([bigSize, bigSize, bigSize]);
		}
	}
}


module drawBearingHole()
{
	cylinder(bigSize, radiusBearingHole, radiusBearingHole, $fn=100);
}


module drawRollerCavity()
{
	drawRoller(radiusWheelCavity,radiusRollerCavity,heightRollerCavity);
	translate([0,0,-heightRollerCavity/2-bigSize-eps]) cylinder(bigSize+eps, radiusAxleCavity, radiusAxleCavity, $fn=50);
	translate([0,0,heightRollerCavity/2-eps]) cylinder(bigSize+eps, radiusAxleCavity, radiusAxleCavity, $fn=50);	
	translate([0,0,heightRollerCavity/2+thicknessBearing]) drawBearingHole();
	translate([0,0,-heightRollerCavity/2-thicknessBearing]) rotate([180,0,0]) drawBearingHole();
}


module drawRollerEx(prmIsHole)
{
	if (prmIsHole) drawRollerCavity(); else drawRollerWithAxle();
}


module drawRollers(prmIsHole,prmIsLeft)
{
	angleX = prmIsLeft ? 45 : -45;
	for (i = [0:nrOfRollers-1]) {
		angle=i*360/nrOfRollers;
		rotate([0,0,angle]) translate([-radiusRollerAxleLocation,0,0]) rotate([angleX,0,0]) rotate([90,0,0]) drawRollerEx(prmIsHole);
	}
}


module drawFancyAngleFlat()
{
	translate([radiusWheel-fancyAngleOffset,0,0]) polygon([[0,-eps],[smallSize+eps,-eps],[smallSize+eps,smallSize+eps],[0,-eps]]);
}


module drawFancyAngle()
{
	rotate_extrude(convexity = 10, $fn = 200) drawFancyAngleFlat();
}


module drawFancySphereHoles(prmIsLeft,prmIsTop)
{
	offsetZ = prmIsTop ? fancySphereOffsetZ : -fancySphereOffsetZ;
	offsetAngle = ((prmIsLeft && !prmIsTop) || (!prmIsLeft && prmIsTop)) ? -fancySphereOffsetAngle : fancySphereOffsetAngle;
	topFactor = prmIsTop ? 0.5 : 1;
	R = (radiusWheel+1.5*pitch-topFactor*fancyAngleOffset) / 2;
	for (i = [0:nrOfRollers-1]) {
		angle=i*360/nrOfRollers+offsetAngle;	
		rotate([0,0,angle]) translate([R+fancySphereOffsetRadial,0,offsetZ]) sphere(fancySphereRadius,$fn=100);
	}
}


module drawFancyVerticalHoles() {
	offsetAngle = 0.5*360/fancyNrOfVerticalHoles;
	for (i = [0:fancyNrOfVerticalHoles-1]) {
		angle=i*360/fancyNrOfVerticalHoles+offsetAngle;	
		rotate([0,0,angle]) translate([-fancyTorusRadius,0,0]) translate([0,0,-bigSize/2]) cylinder(bigSize,fancyVerticalHoleRadius,fancyVerticalHoleRadius,$fn=25);
	}
}


module drawFancyTorus() {
	rotate([0,0,180]) {
		rotate_extrude(convexity = 10, $fn = 100) {
					translate([fancyTorusRadius, 0, 0])
					circle(r = fancyTorusCylinderRadius, $fn = 50);
		}
	}
}


module drawBase(prmIsLeft) 
{
	difference()
	{
		union()
		{	
			translate([0,0,-widthMecanumWheelBase/2]) cylinder(widthMecanumWheelBase,radiusMecanumWheelBase,radiusMecanumWheelBase,$fn=200);
		}
		union()
		{	
			translate([0,0,-bigSize/2]) drawAxleHole(bigSize);
			drawFancyVerticalHoles();

			translate([0,0,-widthMecanumWheelBase/2])
			{
				rotate([0,0,0]) translate([0,pitch,0]) drawTripplePinHolePassThrough();
				rotate([0,0,90]) translate([0,pitch,0]) drawTripplePinHolePassThrough();
				rotate([0,0,180]) translate([0,pitch,0]) drawTripplePinHolePassThrough();
				rotate([0,0,270]) translate([0,pitch,0]) drawTripplePinHolePassThrough();				
			}

			// top
			translate([0,0,widthMecanumWheelBase/2]) rotate([180,0,0]) drawFancyAngle();
			translate([0,0,widthMecanumWheelBase/2+fancyTorusOffsetZ]) drawFancyTorus();
			translate([0,0,widthMecanumWheelBase/2]) drawFancySphereHoles(prmIsLeft,true);

			// bottom
			translate([0,0,-widthMecanumWheelBase/2]) drawFancyAngle();
			translate([0,0,-widthMecanumWheelBase/2-fancyTorusOffsetZ]) drawFancyTorus();
			translate([0,0,-widthMecanumWheelBase/2]) drawFancySphereHoles(prmIsLeft,false);
		}
	}
}


module drawMecanumWheel(prmIsLeft)
{
	difference()
	{
		union()
		{
			drawBase(prmIsLeft);
		}
		union()
		{
			drawRollers(true,prmIsLeft);
		}
	}
}


module drawImportedMecanumWheel(prmIsLeft)
{
    if (prmIsLeft)
    {
        color(Green) import("MecanumWheel_left.stl");
    }
    else
    {
        color(Green) import("MecanumWheel_right.stl");
    }
}    


module drawImportedRoller()
{
    color(Black) import("Roller.stl");
}    


module drawImportedRollerAxle()
{
    drawImportedRoller();
    color(Grey) translate([0,0,-rollerAxleLength/2]) drawRollerAxle(rollerAxleLength);
}    


module drawImportedRollers(prmIsLeft)
{
	angleX = prmIsLeft ? 45 : -45;
	for (i = [0:nrOfRollers-1]) {
		angle = i*360/nrOfRollers;	
		rotate([0,0,angle]) translate([-radiusRollerAxleLocation,0,0]) rotate([angleX,0,0]) rotate([90,0,0]) drawImportedRollerAxle();
	}
}


module drawAssembly(prmIsLeft)
{
	drawImportedMecanumWheel(prmIsLeft);
	drawImportedRollers(prmIsLeft);
}



// tests
//drawPinHole();
//drawRoller(radiusWheel, radiusRoller, heightRoller);
//drawRollerWithAxleHole();
//drawBearingHole();
//drawRollerCavity(45);
//drawRollerWithAxle();
//drawFancyAngleFlat();
//drawFancyAngle();
//drawFancyVerticalHoles();
//drawFancyTorus();
//drawBase(false);
//drawRollers(true, true);
//drawAssembly(false);
drawAssembly(true);


// parts
//drawRollerWithAxleHole();
//drawRollerWithAxleHoleShortened();
//drawMecanumWheel(false);
//drawMecanumWheel(true);

