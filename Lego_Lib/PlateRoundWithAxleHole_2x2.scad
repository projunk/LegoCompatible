eps = 0.001;

modelScale = 1.0;


addInnerWalls = true;


// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 1;
correction_ra1 = PRINTABLE ? 0.05 : 0.0;
correction_ra2 = PRINTABLE ? 0.0 : 0.0;
correction_offset_ra2 = PRINTABLE ? 0.10 : 0.0;
correction_hi1 = PRINTABLE ? 0.4 : 0.0;


pitch = 8.0*modelScale;


ho1 = 3.2*modelScale; // height
ro1 = 8.0*modelScale;
hi1 = (1.6+correction_hi1)*modelScale; // inner height
hi2 = 1.6*modelScale;
ri1 = 6.4*modelScale;
ri2 = 3.2*modelScale;
ri3 = 2.4*modelScale;


// axle hole
ra1 = (4.8/2 + correction_ra1)*modelScale;
ra2 = (1.0/2 + correction_ra2)*modelScale;
offset_ra2 = (1.4 + correction_offset_ra2)*modelScale;


h_pin = 1.7*modelScale;
r_pin1 = 4.8/2*modelScale;
nrOfPins = 4;


tInnerWall = 1.2*modelScale;
lInnerWall = 2*ri1;



module drawExternalPin()
{
	translate([0,0,ho1-eps]) cylinder(h_pin+eps,r_pin1,r_pin1,$fn=100*modelScale);
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


module drawAxleHole(prmLength)
{	
    echo("prmLength",prmLength);
	difference()
	{
		union()
		{
			 translate([0,0,-eps]) cylinder(prmLength+2*eps,ra1,ra1,$fn=200*modelScale);
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


module drawPlate()
{
    difference()
	{
        union()
        {
            cylinder(ho1,ro1,ro1,$fn=250*modelScale);
            for (s=[1:1:nrOfPins])
			{
				angle = (s-1)/nrOfPins * 360;
                rotate([0,0,angle+45]) translate([pitch*sqrt(2)/2,0,0]) drawExternalPin();
            }
            
        }
        union()
        {
            translate([0,0,-eps]) drawAxleHole(ho1+2*eps);
            translate([0,0,-eps]) cylinder(hi2+eps,ri3,ri3,$fn=100*modelScale);
            difference()
            {
                translate([0,0,-eps]) cylinder(hi1+eps,ri1,ri1,$fn=250*modelScale);
                translate([0,0,-2*eps]) cylinder(hi1+3*eps,ri2,ri2,$fn=100*modelScale);                
            }
            difference()
            {
                translate([-ri1,-ri1,-eps]) cube([2*ri1,2*ri1,hi1+eps]);
                translate([0,0,-2*eps]) cylinder(hi1+3*eps,ri2,ri2,$fn=100*modelScale);                
            }            
        }
    }
    
    if (addInnerWalls)
    {
        difference()
        {
            union()
            {        
                translate([-lInnerWall/2,-tInnerWall/2,0]) cube([lInnerWall,tInnerWall,hi1+eps]);
                translate([-tInnerWall/2,-lInnerWall/2,0]) cube([tInnerWall,lInnerWall,hi1+eps]);
            }
            union()
            {
                translate([0,0,-eps]) cylinder(hi1+3*eps,ri2,ri2,$fn=100*modelScale);
            }
        }
    }    
}



// test


// parts
drawPlate();

