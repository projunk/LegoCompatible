eps = 0.001;


include <dimensions.scad>
include <utils.scad>



addScrewHole = false;

rScrewHole = 3.0/2/2.5;



// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 1;
correction_ra1 = PRINTABLE ? 0.05 : 0.0;
correction_ra2 = PRINTABLE ? 0.0 : 0.0;
correction_offset_ra2 = PRINTABLE ? 0.10 : 0.0;


// axle hole
ra1 = (4.8/2 + correction_ra1);
ra2 = (1.0/2 + correction_ra2);
offset_ra2 = (1.4 + correction_offset_ra2);


axleLengthBase = 20.0;

ro1 = unit_size/2;
ro2 = 3.6;
ro3 = unit_size/2;
ho1 = unit_size;
ho2 = 23.2;

ri1 = 3.2;
ri2 = 2.4;
ri3 = 3.2;
hi1 = 0.8;
hi2 = 0.8;


tHook = 1.6;

wSlotHole = 1.6;
lSlotHole = 11.2;

rSpringCoil = 0.4;
rSpring = (ra1+ri3)/2;
lSpring = 17.6;
nrOfCoils = 7;


module drawHookFlat()
{
    x1 = -0.4;
    y1 = 0.0;
    x2 = x1;
    y2 = -4.8;
    x3 = -1.2;
    y3 = -8.0;
    x4 = -1.6;
    y4 = -8.0;
    x5 = -3.6;
    y5 = -6.0;
    x6 = x5;
    y6 = y2;
    x7 = -2.276;
    y7 = y2;
    x8 = x7;
    y8 = 0.0;
        
    polygon([[x1,y1],[x2,y2],[x3,y3],[x4,y4],[x5,y5],[x6,y6],[x7,y7],[x8,y8],[x1,y1]]);
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
    cylinder(ho1,ro1,ro1,$fn=100,true);
}    


module drawShockAbsorberTop()
{
    difference()
	{
        union()
        {
            drawBearing();
            rotate([90,0,0]) cylinder(ro1,ro2,ro2,$fn=100);
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
                rotate([-90,0,0]) cylinder(ho2,ro3,ro3,$fn=100);
                translate([-wSlotHole/2,ro1,-smallSize/2]) cube([wSlotHole,lSlotHole,smallSize]);
            }
        }
        union()
        {
            rotate([90,0,0]) drawPinHole(true);
            translate([0,ro1,0]) rotate([-90,0,0]) cylinder(smallSize,ri2,ri2,$fn=100);
            translate([0,ho2-hi2,0]) rotate([-90,0,0]) cylinder(hi2+eps,ri3,ri3,$fn=100);
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


module drawSpring()
{
    difference()
	{
        union()
        {
            linear_extrude(height=lSpring,center=false,convexity=10,twist=360*nrOfCoils,$fn=100) translate([rSpring,0,0]) circle(r=rSpringCoil,$fn=100);
        }
        union()
        {
        }
    }
}


module drawShockAbsorber()
{
    difference()
	{
        union()
        {
            drawShockAbsorberTop();
            translate([0,-shockAbsorberHoleDistance,0]) drawShockAbsorberBottom();
            translate([0,-ro1,0]) rotate([90,0,0]) drawSpring();
        }
        union()
        {
        }
    }
}



// tests
//drawHookFlat();
//drawHook();
//drawAxle();
//drawBearing();
//drawPinHole(true);
drawShockAbsorberTopHalf();
//drawShockAbsorberBottomHalf();



// parts
//drawSpring();
//drawShockAbsorberTop();
//drawShockAbsorberBottom();
//drawShockAbsorber();

