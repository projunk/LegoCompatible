eps = 0.001;

modelScale = 1.0;

isEasyPrintable = false;



// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 1;
correction_r1 = PRINTABLE ? 0.15 : 0.0;
correction_r2 = PRINTABLE ? 0.0 : 0.0;
correction_offset_r2 = PRINTABLE ? 0.15 : 0.0;



pitch = 8.0*modelScale;
unit_size = 7.8*modelScale;





ro1 = 12.8*modelScale;
ro2 = 12.0*modelScale;
ro3 = 13.6*modelScale;
ro4 = 15.2*modelScale;
ro5 = 4.0*modelScale;
ro6 = 3.2*modelScale;

ho1 = 0.8*modelScale;
ho2 = 4.0*modelScale;
ho3 = 1.6*modelScale;
ho4 = 6.4*modelScale;
hTotal = ho1+ho2+ho3+ho4;
echo("hTotal",hTotal);


ri1 = 12.0*modelScale;
ri3 = 2.4*modelScale;
ri4 = 13.6*modelScale;
ri5 = 11.2*modelScale;

hi1 = isEasyPrintable ? 0.0 : 0.4*modelScale;
hi2 = 3.2*modelScale;
hi3 = 7.2*modelScale;

nrOfHoles = 6;

hInnerWall = 3.2*modelScale;
tInnerWall = 0.8*modelScale;



module drawRim()
{
    difference()
	{
        union()
        {   
            translate([0,0,ho1+ho2+ho3-eps]) cylinder(ho4+eps,ro4,ro4,$fn=200*modelScale);
            translate([0,0,ho1+ho2]) cylinder(ho3,ro3,ro4,$fn=200*modelScale);
            translate([0,0,ho1-eps]) cylinder(ho2+2*eps,ro2,ro2,$fn=200*modelScale);
            translate([0,0,0]) cylinder(ho1,ro1,ro1,$fn=200*modelScale);            
        }
        union()
        {
            translate([0,0,-eps]) cylinder(hTotal+2*eps,ri3,ri3,$fn=100*modelScale);
            for (s=[1:1:nrOfHoles])
			{
				angle = (s-1)/nrOfHoles * 360;
                rotate([0,0,angle]) translate([pitch,0,-eps]) cylinder(hTotal+2*eps,ri3,ri3,$fn=100*modelScale);
            }  
  
            difference()
            {
                translate([0,0,hTotal-hi3]) cylinder(hi3+eps,ri4,ri4,$fn=100*modelScale);
                cylinder(ho4,ro5,ro5,$fn=100*modelScale);
            }
            
            difference()
            {   
                union()
                {
                    translate([0,0,hTotal-hi3-hi2]) cylinder(hi2+eps,ri5,ri5,$fn=100*modelScale);
                    translate([0,0,-eps]) cylinder(hi1+eps,ri1,ri1,$fn=100*modelScale);
                }
                union()
                {
                    translate([0,0,-eps]) cylinder(hTotal+2*eps,ro5,ro5,$fn=100*modelScale);
                    for (s=[1:1:nrOfHoles])
                    {
                        angle = (s-1)/nrOfHoles * 360;
                        rotate([0,0,angle]) translate([pitch,0,-eps]) cylinder(hTotal+2*eps,ro6+eps,ro6+eps,$fn=100*modelScale);
                    }                     
                }
            }
        }
    }
    
    // add inner walls
    for (s=[1:1:nrOfHoles])
    {
        angle = (s-1)/nrOfHoles * 360;
        xPos = (ri3+ro5)/2;
        lInnerWall = pitch-ri3-xPos-eps;
        rotate([0,0,angle]) translate([xPos,-tInnerWall/2,hTotal-hi3-hi2-eps]) cube([lInnerWall,tInnerWall,hInnerWall+eps]);
    }                         
}



// tests


// parts
drawRim();
