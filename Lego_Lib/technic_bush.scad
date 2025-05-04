eps = 0.001;

modelScale = 1.0;



// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 0;
correction_r1 = PRINTABLE ? 0.05 : 0.0;
correction_r2 = PRINTABLE ? 0.0 : 0.0;
correction_offset_r2 = PRINTABLE ? 0.10 : 0.0;


// bush
rb1 = 7.4/2*modelScale;
rb2 = 5.7/2*modelScale;
h1 = 8.0*modelScale;
h2 = 1.5*modelScale;
wSlotHole = 0.5*modelScale;
rFancy = 4.0/2*modelScale;
offsetRFancy = 0.8*rFancy;


// axle hole
r1 = (4.8/2 + correction_r1)*modelScale;
r2 = (1.0/2 + correction_r2)*modelScale;
offset_r2 = (1.4 + correction_offset_r2)*modelScale;



module drawSlotHole()
{
    r = wSlotHole/2;
    hull()
    {
        translate([0,0,h2+r]) rotate([90,0,0]) cylinder(2*rb1+2*eps,r,r,$fn=100*modelScale,true);
        translate([0,0,h1-h2-r]) rotate([90,0,0]) cylinder(2*rb1+2*eps,r,r,$fn=100*modelScale,true);
    }
}    


module drawFancy()
{
    translate([rb1+offsetRFancy,0,h1-h2-eps]) cylinder(h2+2*eps,rFancy,rFancy,$fn=100*modelScale);
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
            translate([0,0,h1-h2]) cylinder(h2,rb1,rb1,$fn=200*modelScale);
            translate([0,0,h2-eps]) cylinder(h1-2*h2+2*eps,rb2,rb2,$fn=200*modelScale);
            translate([0,0,0]) cylinder(h2,rb1,rb1,$fn=200*modelScale);
        }
        union()
        {
            drawAxleHole(h1+2*eps);
            drawSlotHole();
            rotate([0,0,45]) drawFancy();
            rotate([0,0,135]) drawFancy();
            rotate([0,0,225]) drawFancy();
            rotate([0,0,315]) drawFancy();
        }
    }
}



// parts
drawBush();

