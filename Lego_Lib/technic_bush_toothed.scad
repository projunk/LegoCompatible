eps = 0.001;

modelScale = 1.0;



// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 1;
correction_r1 = PRINTABLE ? 0.05 : 0.0;
correction_r2 = PRINTABLE ? 0.0 : 0.0;
correction_offset_r2 = PRINTABLE ? 0.10 : 0.0;


// bush
rb1 = 7.4/2*modelScale;
rb2 = 5.7/2*modelScale;
h1 = 4.0*modelScale;


// tooth
nrOfTeeth = 16;
hTooth = 0.8*modelScale;
clearanceAngle = 0.5;
alfa = 360/(2*nrOfTeeth)+clearanceAngle;


// axle hole
r1 = (4.8/2 + correction_r1)*modelScale;
r2 = (1.0/2 + correction_r2)*modelScale;
offset_r2 = (1.4 + correction_offset_r2)*modelScale;




module drawToothMaskSingle()
{
    rotate([0,0,-alfa/2]) rotate_extrude(angle=alfa,convexity=2,$fn=500*modelScale) square([rb1+eps,hTooth+eps]);
}


module drawToothMask()
{
    for (s=[1:1:nrOfTeeth])
    {
        angle = (s-1)/nrOfTeeth * 360;
        translate([0,0,h1-hTooth]) rotate([0,0,angle]) drawToothMaskSingle();
    }
}


module drawTorus() {
	rotate([0,0,180]) {
		rotate_extrude(convexity = 10, $fn=100*modelScale) {
					translate([rb1, 0, 0])
					circle(r=rb1-rb2,$fn=50*modelScale);
		}
	}
}


module drawAxleCutOut(prmLength)
{
    smallSize = 6*r2;   
    translate([-offset_r2,offset_r2,0]) hull()
    {
        translate([0,0,-2*eps]) cylinder(prmLength+4*eps,r2,r2,$fn=200*modelScale);
        translate([-smallSize,-r2,-2*eps]) cube([eps,2*r2,prmLength+4*eps]);
        translate([-r2,smallSize,-2*eps]) cube([2*r2,eps,prmLength+4*eps]);
    }
}    


module drawAxleHole(prmLength)
{	
    echo("prmLength",prmLength);
	difference()
	{
		union()
		{
			 translate([0,0,-eps]) cylinder(prmLength+2*eps,r1,r1,$fn=200*modelScale);
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


module drawBush()
{
    difference()
	{
        union()
        {
            cylinder(h1,rb1,rb1,$fn=200*modelScale);
        }
        union()
        {
            drawAxleHole(h1+2*eps);
            translate([0,0,h1/2]) drawTorus();
            drawToothMask();
            translate([0,0,h1-hTooth-2*eps]) cylinder(hTooth+4*eps,r1,r1,$fn=500*modelScale);
        }
    }
}



// tests
//drawToothMaskSingle();
//drawToothMask();


// parts
drawBush();

