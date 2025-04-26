eps = 0.001;

modelScale = 1.0;




// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 1;
correction_ri1 = PRINTABLE ? 0.05 : 0.0;


ro1 = 4.0*modelScale;
ro2 = 3.2*modelScale;

ho1 = 2.0*modelScale; 
ho2 = 1.2*modelScale;

ri1 = (2.4+correction_ri1)*modelScale;
hi1 = 2.0*modelScale;

h_pin = 1.7*modelScale;
r_pin1 = 4.8/2*modelScale;





module drawExternalPinSolid()
{
	translate([0,0,ho1+ho2-eps]) cylinder(h_pin+eps,r_pin1,r_pin1,$fn=100*modelScale);
}


module drawPlate() 
{
	difference()
	{
		union()
		{	
            drawExternalPinSolid();
            translate([0,0,ho2]) cylinder(ho1,ro1,ro1,$fn=100*modelScale);
            cylinder(ho2+eps,ro2,ro2,$fn=100*modelScale);
		}
		union()
		{	
            translate([0,0,-eps]) cylinder(hi1+eps,ri1,ri1,$fn=100*modelScale);
		}
	}

}


drawPlate();


