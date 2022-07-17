eps = 0.001;

modelScale = 1.0;


nrOfUnits = 4;
addScrewHole = false;
rScrewHole = 3.0/2/2.5;


// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 0;
correction_r1 = PRINTABLE ? 0.1 : 0.0;
correction_r2 = PRINTABLE ? 0.1 : 0.0;




// axle
r1 = (4.8/2 + correction_r1)*modelScale;
r2 = (1.0/2 + correction_r2)*modelScale;
offset_r2 = 1.4*modelScale;

axleBaseLength = -0.5*modelScale;
axleLengthUnit = 8.0*modelScale;


// camfer
camferAngle = 60;
camferWidth = 0.3;



module drawCamferSingle()
{
    smallSize = 4*r1;
    translate([0,r1-camferWidth,0]) rotate([camferAngle,0,0]) translate([-smallSize/2,-smallSize/2,-smallSize]) cube([smallSize,smallSize,smallSize]);
}


module drawCamfer()
{
    drawCamferSingle();
    rotate([0,0,90]) drawCamferSingle();
    rotate([0,0,180]) drawCamferSingle();
    rotate([0,0,270]) drawCamferSingle();
}


module drawAxleCutOut(prmLength)
{
    smallSize = 6*r2;   
    translate([-offset_r2,offset_r2,0]) hull()
    {
        translate([0,0,-eps]) cylinder(prmLength+2*eps,r2,r2,$fn=200*modelScale);
        translate([-smallSize,-r2,-eps]) cube([eps,2*r2,prmLength+2*eps]);
        translate([-r2,smallSize,-eps]) cube([2*r2,eps,prmLength+2*eps]);
    }
}    


module drawAxleEx(prmLength)
{	
    echo("prmLength",prmLength);
	difference()
	{
		union()
		{
			cylinder(prmLength,r1,r1,$fn=200*modelScale);
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
    length = axleBaseLength+nrOfUnits*axleLengthUnit;
    difference()
	{
        union()
        {
            drawAxleEx(length);
        }
        union()
        {
            if (addScrewHole)
            {
                translate([0,0,-2*eps]) cylinder(length+4*eps,rScrewHole,rScrewHole,$fn=50*modelScale);
            }
            drawCamfer();
            translate([0,0,length]) mirror([0,0,1]) drawCamfer();
        }
    }
}


// tests
//drawCamfer();
//drawAxleCutOut(2);


// parts
drawAxle();


