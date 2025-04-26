eps = 0.001;

modelScale = 1.0;


addScrewHole = false;
rScrewHole = 3.0/2/2.5;


unit_size = 7.8*modelScale;
pitch = 8.0*modelScale;

smallSize = 7*pitch;


// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 1;
correction_ra1 = PRINTABLE ? 0.05 : 0.0;
correction_ra2 = PRINTABLE ? 0.0 : 0.0;
correction_offset_ra2 = PRINTABLE ? 0.10 : 0.0;


// axle hole
ra1 = (4.8/2 + correction_ra1)*modelScale;
ra2 = (1.0/2 + correction_ra2)*modelScale;
offset_ra2 = (1.4 + correction_offset_ra2)*modelScale;


axleLengthBase = 20.0*modelScale;

ro1 = 4.0*modelScale;
ro2 = 3.6*modelScale;
ro3 = 4.0*modelScale;
ho1 = 8.0*modelScale;
ho2 = 23.2*modelScale;

ri1 = 3.2*modelScale;
ri2 = 2.4*modelScale;
ri3 = 3.2*modelScale;
hi1 = 0.8*modelScale;
hi2 = 0.8*modelScale;


tHook = 1.6*modelScale;

wSlotHole = 1.6*modelScale;
lSlotHole = 11.2*modelScale;

distBearingHoles = 44.0*modelScale;


rSpringCoil = 0.4*modelScale;
rSpring = (ra1+ri3)/2;
lSpring = 17.6* modelScale;
nrOfCoils = 7;


module drawHookFlat()
{
    x1 = -0.4*modelScale;
    y1 = 0.0;
    x2 = x1;
    y2 = -4.8*modelScale;
    x3 = -1.2*modelScale;
    y3 = -8.0*modelScale;
    x4 = -1.6*modelScale;
    y4 = -8.0*modelScale;
    x5 = -3.6*modelScale;
    y5 = -6.0*modelScale;
    x6 = x5;
    y6 = y2;
    x7 = -2.276*modelScale;
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
        translate([0,0,-2*eps]) cylinder(prmLength+4*eps,ra2,ra2,$fn=200*modelScale);
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
			cylinder(prmLength,ra1,ra1,$fn=200*modelScale);
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
                translate([0,0,-2*eps]) cylinder(axlelLength+4*eps,rScrewHole,rScrewHole,$fn=50*modelScale);
            }
        }
    }
}



module drawBearingMask()
{
    cylinder(ho1+2*eps,ri2,ri2,$fn=100*modelScale,true);
    translate([0,0,ho1/2-hi1]) cylinder(hi1+eps,ri1,ri1,$fn=100*modelScale);
    mirror([0,0,1]) translate([0,0,ho1/2-hi1]) cylinder(hi1+eps,ri1,ri1,$fn=100*modelScale);
}    


module drawBearing()
{
    cylinder(ho1,ro1,ro1,$fn=100*modelScale,true);
}    


module drawShockAbsorberTop()
{
    difference()
	{
        union()
        {
            drawBearing();
            rotate([90,0,0]) cylinder(ro1,ro2,ro2,$fn=100*modelScale);
            translate([0,-ro1,0]) rotate([90,0,0]) drawAxle();
            translate([0,-ro1-axleLengthBase,0]) rotate([0,90,0]) drawHook();
            mirror([0,0,1]) translate([0,-ro1-axleLengthBase,0]) rotate([0,90,0]) drawHook();
        }
        union()
        {
            drawBearingMask();
        }
    }
}


module drawShockAbsorberBottom()
{
    difference()
	{
        union()
        {
            drawBearing();
            difference()
            {
                rotate([-90,0,0]) cylinder(ho2,ro3,ro3,$fn=100*modelScale);
                translate([-wSlotHole/2,ro1,-smallSize/2]) cube([wSlotHole,lSlotHole,smallSize]);
            }
        }
        union()
        {
            drawBearingMask();
            translate([0,ro1,0]) rotate([-90,0,0]) cylinder(smallSize,ri2,ri2,$fn=100*modelScale);
            translate([0,ho2-hi2,0]) rotate([-90,0,0]) cylinder(hi2+eps,ri3,ri3,$fn=100*modelScale);
        }
    }
}


module drawSpring()
{
    difference()
	{
        union()
        {
            linear_extrude(height=lSpring,center=false,convexity=10,twist=360*nrOfCoils,$fn=100) translate([rSpring,0,0]) circle(r=rSpringCoil,$fn=10);
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
            translate([0,-distBearingHoles,0]) drawShockAbsorberBottom();
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


// parts
drawSpring();
//drawShockAbsorberTop();
//drawShockAbsorberBottom();
//drawShockAbsorber();

