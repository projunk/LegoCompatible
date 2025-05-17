eps = 0.001;


include <../lib/springs.scad>

include <dimensions.scad>
include <utils.scad>


// exported parts
_ShockAbsorberTop = 0;
_ShockAbsorberTopHalf = 1;
_ShockAbsorberBottom = 2;
_ShockAbsorberBottomHalf = 3;
_ShockAbsorberSpring = 4;
selectedPart = _ShockAbsorberBottom;



addScrewHole = false;

rScrewHole = 3.0/2/2.5;

modelScaleSpring = 2.5;


// axle hole
ra1 = 4.6/2; //4.8/2;
ra2 = 1.0/2;
offset_ra2 = 1.4;


axleLengthBase = 20.0;

ro1 = unit_size/2;
ro2 = 3.6;
ro3 = unit_size/2;
ho1 = unit_size;
ho2 = 23.2;

ri1 = 3.2;
ri2 = 2.6; //2.4;
ri3 = 3.2;
hi1 = 0.8;
hi2 = 0.8;


wSlotHole = 1.8;
lSlotHole = 11.2;

tHook = 1.5;


rSpringCoil = 0.45/modelScaleSpring;
rSpring = (14.0/2)/modelScaleSpring-rSpringCoil;
lSpring = 17.6;
nrOfCoils = 7;


roCircle = 2.1;
riCircle = 0.5; //1.2;



module drawHollowCircleFlat()
{
    difference()
    {
        union()
        {
            circle(roCircle,$fn=250);
        }
        union()
        {
            circle(riCircle,$fn=250);
        }        
    }
}


module drawHollowQuarterCircleFlat()
{
    smallSize = 3*roCircle;
    difference()
    {
        union()
        {
            drawHollowCircleFlat();
        }
        union()
        {
            translate([0,-smallSize/2]) square([smallSize,smallSize]);
            translate([-smallSize/2,-smallSize]) square([smallSize,smallSize]);
        }        
    }
}


module drawHookFlat()
{
    x1 = -riCircle;
    y1 = 0.0;
    x2 = -1.2;
    y2 = -8.0;
    x3 = -1.6;
    y3 = -8.0;
    x4 = -ro2+0.2;
    y4 = -6.0;
    x5 = x4;
    y5 = -4.8;
    x6 = -roCircle;
    y6 = y5;
    x7 = x6;
    y7 = 0.0;
        
    polygon([[x1,y1],[x2,y2],[x3,y3],[x4,y4],[x5,y5],[x6,y6],[x7,y7],[x1,y1]]);
    smallSize = 3*roCircle;
    difference()
    {
        translate([0,-riCircle]) drawHollowQuarterCircleFlat();
        translate([-smallSize/2,0]) square([smallSize,smallSize]);
    }
}


module drawHook()
{
    linear_extrude(height=tHook,center=true) drawHookFlat();
}


module drawAxleCutOut(prmLength)
{
    smallSize = 6*ra2;   
    translate([-offset_ra2,offset_ra2,0]) hull()
    {
        translate([0,0,-2*eps]) cylinder(prmLength+4*eps,ra2,ra2,$fn=200);
        translate([-smallSize,-ra2,-2*eps]) cube([eps,2*ra2,prmLength+4*eps]);
        translate([-ra2,smallSize,-2*eps]) cube([2*ra2,eps,prmLength+4*eps]);
    }
}    


module drawAxleEx(prmLength)
{	
    echo("prmLength",prmLength);
	difference()
	{
		union()
		{
			cylinder(prmLength,ra1,ra1,$fn=200);
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


module drawAxle()
{
    axlelLength = axleLengthBase+2*eps;
    difference()
	{
        union()
        {
            drawAxleEx(axlelLength);
        }
        union()
        {
            if (addScrewHole)
            {
                translate([0,0,-2*eps]) cylinder(axlelLength+4*eps,rScrewHole,rScrewHole,$fn=50);
            }
        }
    }
}


module drawBearing()
{
    cylinder(ho1,ro1,ro1,$fn=250,true);
}    


module drawShockAbsorberTop()
{
    difference()
	{
        union()
        {
            drawBearing();
            rotate([90,0,0]) cylinder(ro1,ro2,ro2,$fn=250);
            translate([0,-ro1,0]) rotate([90,0,0]) drawAxle();
            translate([0,-ro1-axleLengthBase,0]) rotate([0,90,0]) drawHook();
            mirror([0,0,1]) translate([0,-ro1-axleLengthBase,0]) rotate([0,90,0]) drawHook();
        }
        union()
        {
            rotate([90,0,0]) drawPinHole(true);
        }
    }
}


module drawShockAbsorberTopHalf()
{
    smallSize = 11*pitch;
    difference()
	{
        union()
        {
            rotate([0,90,0]) drawShockAbsorberTop();
        }
        union()
        {
            translate([-smallSize/2,-smallSize/2,-smallSize]) cube([smallSize,smallSize,smallSize]);
        }
    }
}


module drawShockAbsorberBottom()
{
    smallSize = 7*pitch;
    difference()
	{
        union()
        {
            drawBearing();
            difference()
            {
                rotate([-90,0,0]) cylinder(ho2,ro3,ro3,$fn=250);
                translate([-wSlotHole/2,ro1,-smallSize/2]) cube([wSlotHole,lSlotHole,smallSize]);
            }
        }
        union()
        {
            rotate([90,0,0]) drawPinHole(true);
            translate([0,ro1,0]) rotate([-90,0,0]) cylinder(smallSize,ri2,ri2,$fn=250);
            translate([0,ho2-hi2,0]) rotate([-90,0,0]) cylinder(hi2+eps,ri3,ri3,$fn=250);
        }
    }
}


module drawShockAbsorberBottomHalf()
{
    smallSize = 7*pitch;
    difference()
	{
        union()
        {
            drawShockAbsorberBottom();
        }
        union()
        {
            translate([-smallSize/2,-smallSize/2,-smallSize]) cube([smallSize,smallSize,smallSize]);
        }
    }
}


module drawShockAbsorberSpring()
{
    difference()
	{
        union()
        {
            //linear_extrude(height=lSpring,center=false,convexity=10,twist=360*nrOfCoils,$fn=250) translate([rSpring,0,0]) circle(r=rSpringCoil,$fn=250);
            spring(r=rSpringCoil,R=rSpring,H=lSpring,windings=nrOfCoils,start=true,end=true,center=false,$fn=25);
        }
        union()
        {
        }
    }
}


module drawShockAbsorberAssembly()
{
    difference()
	{
        union()
        {
            color("grey") drawShockAbsorberTop();
            color("blue") translate([0,-shockAbsorberHoleDistance,0]) drawShockAbsorberBottom();
            color("orange") translate([0,-ro1,0]) rotate([90,0,0]) drawShockAbsorberSpring();
        }
        union()
        {
        }
    }
}



// tests
//drawHollowCircleFlat();
//drawHollowQuarterCircleFlat();
//drawHookFlat();
//drawHook();
//drawAxle();
//drawBearing();
//drawPinHole(true);
//drawShockAbsorberAssembly();


// parts
if (selectedPart==_ShockAbsorberTop) drawShockAbsorberTop();
if (selectedPart==_ShockAbsorberTopHalf) drawShockAbsorberTopHalf();
if (selectedPart==_ShockAbsorberBottom) drawShockAbsorberBottom();
if (selectedPart==_ShockAbsorberBottomHalf) drawShockAbsorberBottomHalf();
if (selectedPart==_ShockAbsorberSpring) drawShockAbsorberSpring();
