eps = 0.001;

modelScale = 1.0;


nr_length_units = 2;
nr_width_units = 2;
isSolidExternalPin = false;


// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 0;
correction_t1 = PRINTABLE ? 0.05 : 0.0;


unit_size = 7.8*modelScale;
pitch = 8.0*modelScale;

h1 = 3.2*modelScale; // height
h2 = h1-1.0*modelScale; // inner height

t1 = (1.5-correction_t1)*modelScale; // wall thickness
t2 = 1.2*modelScale; // inner wall thickness


length = nr_length_units*unit_size + (nr_length_units - 1) * (pitch - unit_size);
width = nr_width_units*unit_size + (nr_width_units - 1) * (pitch - unit_size);
echo("length", length);
echo("width", width);


// external pin
h_pin = 1.7*modelScale;
r_pin1 = 4.8/2*modelScale;
r_pin2 = 3.2/2*modelScale;


// bearing
ph1 = length;
ph2 = 0.7*modelScale;
ph3 = 1.6*modelScale;
pr1 = 4.8/2*modelScale;
pr2 = 5.6/2*modelScale;
rBearing = 8.0/2*modelScale;
offsetBearingZ = -0.8*modelScale;


smallSize = 3*max(length,width);



module drawBearingHole()
{
    translate([0,0,offsetBearingZ]) rotate([0,90,0]) 
    {
        translate([0,0,ph1/2-ph2]) cylinder(ph2+eps,pr2,pr2,$fn=100*modelScale);
        mirror([0,0,1]) translate([0,0,ph1/2-ph2]) cylinder(ph2+eps,pr2,pr2,$fn=100*modelScale);
        cylinder(ph1+2*eps,pr1,pr1,$fn=100*modelScale,true);
        cylinder(ph3,rBearing+eps,rBearing+eps,$fn=250*modelScale,true);
    }
}


module drawBearing() 
{
	difference()
	{
		union()
		{	
            hull()
            {
                translate([0,0,offsetBearingZ]) rotate([0,90,0]) cylinder(length,rBearing,rBearing,$fn=250*modelScale,true);
                translate([-length/2,-rBearing,rBearing]) cube([length,2*rBearing,eps]);
            }
		}
		union()
		{	
			translate([-smallSize/2,-smallSize/2,h1]) cube([smallSize,smallSize,smallSize]);
        }
	}
}


module drawExternalPinSolid()
{
	translate([0,0,h1-eps]) cylinder(h_pin+eps,r_pin1,r_pin1,$fn=100*modelScale);
}


module drawExternalPinHollow()
{
	translate([0,0,h1-eps]) 
    {
        difference()
        {
            cylinder(h_pin+eps,r_pin1,r_pin1,$fn=100*modelScale);
            cylinder(h_pin+2*eps,r_pin2,r_pin2,$fn=100*modelScale);
        }
    }
}


module drawPlate() 
{
	difference()
	{
		union()
		{	
			cube([length,width,h1]);
		}
		union()
		{	
			translate([t1,t1,-eps]) cube([length-2*t1,width-2*t1,h2+eps]);
        }
	}

	for (x = [1:nr_length_units])
	{
		for (y = [1:nr_width_units])
		{	
            difference()
            {
                union()
                {
                    if (isSolidExternalPin)
                    {
                        translate([x*pitch-pitch+unit_size/2,y*pitch-pitch+unit_size/2,0]) drawExternalPinSolid();
                    }
                    else
                    {
                        translate([x*pitch-pitch+unit_size/2,y*pitch-pitch+unit_size/2,0]) drawExternalPinHollow();
                    }                        
                }
                union()
                {
                }
            }
		}
	}
}


module drawPlateWithPinHoleOnBothSides() 
{
	difference()
	{
		union()
		{	
			translate([-length/2,-width/2,0]) drawPlate();
            drawBearing();
		}
		union()
		{	
			drawBearingHole();
        }
	}
}



// tests
//drawBearingHole();
//drawBearing();
//drawPlate();


// parts
drawPlateWithPinHoleOnBothSides();


