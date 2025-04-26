eps = 0.001;

modelScale = 1.0;


nr_length_units = 2;
nr_width_units = 2;
isSolidExternalPin = true;
isSolidPin2 = true;
addInnerWalls = true;


// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 0;
correction_t1 = PRINTABLE ? 0.05 : 0.0;



unit_size = 7.8*modelScale;
pitch = 8.0*modelScale;

gap = pitch-unit_size;


h1 = 3.2*modelScale; // height
h2 = h1-1.0*modelScale; // inner height

// pin1
r1 = 6.5/2*modelScale;
r2 = 4.8/2*modelScale;

// pin2
r3 = 3.2/2*modelScale;
r4 = 1.6/2*modelScale;


t1 = (1.5-correction_t1)*modelScale; // wall thickness
t2 = 1.2*modelScale; // inner wall thickness


length = nr_length_units*unit_size + (nr_length_units - 1) * (pitch - unit_size);
width = nr_width_units*unit_size + (nr_width_units - 1) * (pitch - unit_size);
echo("length", length);
echo("width", width);


h_pin = 1.7*modelScale;
r_pin1 = 4.8/2*modelScale;
r_pin2 = 3.2/2*modelScale;


offsetPinHole = 4.0*modelScale;
rPinHole1 = 3.2*modelScale;
rPinHole2 = 2.4*modelScale;



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


module drawInternalPin1()
{
	difference()
	{
		translate([0,0,-eps]) cylinder(h1+eps,r1,r1,$fn=100*modelScale);
		translate([0,0,-2*eps]) cylinder(h1+3*eps,r2,r2,$fn=100*modelScale);
	}
}


module drawInternalPin2Hollow()
{
	difference()
	{
		translate([0,0,-eps]) cylinder(h1+eps,r3,r3,$fn=100*modelScale);
		translate([0,0,-2*eps]) cylinder(h1+3*eps,r4,r4,$fn=100*modelScale);
	}
}


module drawInternalPin2Solid()
{
	translate([0,0,-eps]) cylinder(h1+eps,r3,r3,$fn=100*modelScale);
}


module drawInnerWallsX()
{
    if (nr_length_units > 1)
    {
        for (x = [1:nr_length_units-1])
        {
            if (nr_length_units > 1)
            {
                difference()
                {
                    union()
                    {
                        translate([x*pitch-(pitch-unit_size)/2-t2/2,t1-eps,0]) cube([t2,width-2*t1+2*eps,h2+eps]);
                    }
                    union()
                    {
                        if (nr_width_units > 1)
                        {
                            for (y = [1:nr_width_units-1]) 
                            {
                                translate([x*pitch-(pitch-unit_size)/2,y*pitch-(pitch-unit_size)/2,-eps]) cylinder(h1+2*eps,r2,r2,$fn=100*modelScale);
                            }
                        }
                    }
                }
            }
        }
    }
}


module drawInnerWallsY()
{
    if (nr_width_units > 1)
    {
        for (y = [1:nr_width_units-1])
        {
            if (nr_width_units > 1)
            {
                difference()
                {
                    union()
                    {
                        translate([t1-eps,y*pitch-(pitch-unit_size)/2-t2/2,0]) cube([length-2*t1+2*eps,t2,h2+eps]);
                    }
                    union()
                    {
                        if (nr_length_units > 1)
                        {
                            for (x = [1:nr_length_units-1]) 
                            {
                                translate([x*pitch-(pitch-unit_size)/2,y*pitch-(pitch-unit_size)/2,-eps]) cylinder(h1+2*eps,r2,r2,$fn=100*modelScale);
                            }
                        }
                    }
                }
            }
        }
    }
}


module drawPlate() 
{
	difference()
	{
		union()
		{	
            hull()
            {
                cube([length,width,h1]);
                translate([0,width/2,0]) cylinder(h1,width/2,width/2,$fn=200*modelScale);
            }
		}
		union()
		{	
			translate([t1,t1,-eps]) cube([length-2*t1,width-2*t1,h2+eps]);
            difference()
            {
                union()
                {
                    translate([0,width/2,-eps]) cylinder(h2+eps,width/2-t1,width/2-t1,$fn=200*modelScale);
                }
                union()
                {
                    translate([0,-eps,-eps]) cube([width/2+eps,width+2*eps,h1+2*eps]);
                }
            }
            translate([-offsetPinHole,width/2,-eps]) cylinder(h1+2*eps,rPinHole2,rPinHole2,$fn=200*modelScale);
		}
	}
    
    difference()
	{
		union()
		{   
            hull()
            {
                translate([-offsetPinHole,width/2,0]) cylinder(h2+eps,rPinHole1,rPinHole1,$fn=200*modelScale);
                translate([-offsetPinHole-rPinHole1,width/2-rPinHole1,0]) cube([eps,2*rPinHole1,h2]);
            }
        }
		union()
		{   
            translate([-offsetPinHole,width/2,-eps]) cylinder(h1+2*eps,rPinHole2,rPinHole2,$fn=200*modelScale);
        }        
    }
    

	for (x = [1:nr_length_units])
	{
		for (y = [1:nr_width_units])
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
	}

	if ((nr_length_units > 1) && (nr_width_units > 1)) 
	{
		for (x = [1:nr_length_units-1])
		{
			for (y = [1:nr_width_units-1]) 
			{	
				translate([x*pitch-(pitch-unit_size)/2,y*pitch-(pitch-unit_size)/2,0]) drawInternalPin1();
			}
		}
	}

	if ((nr_width_units == 1) && (nr_length_units > 1))
	{
		for (x = [1:nr_length_units-1])
		{
            if (isSolidPin2)
            {
                translate([x*pitch-(pitch-unit_size)/2,width/2,0]) drawInternalPin2Solid();
            }
            else
            {
                translate([x*pitch-(pitch-unit_size)/2,width/2,0]) drawInternalPin2Hollow();
            }
		}
	}

	if ((nr_length_units == 1) && (nr_width_units > 1))
	{
		for (y = [1:nr_width_units-1])
		{
            if (isSolidPin2)
            {
                translate([length/2,y*pitch-(pitch-unit_size)/2,0]) drawInternalPin2Solid();
            }
            else
            {      
                translate([length/2,y*pitch-(pitch-unit_size)/2,0]) drawInternalPin2Hollow();
            }
		}
	}
    
    if (addInnerWalls)
    {
        drawInnerWallsX();
        drawInnerWallsY();
    }
}


module drawDoublePlate()
{
    lx = gap+2*eps;
    translate([-length-gap/2,0,0]) drawPlate();
    mirror([1,0,0]) translate([-length-gap/2,0,0]) drawPlate();
    translate([-lx/2,0,0]) cube([lx,width,h1]);
}



// tests
//drawPlate();


// parts
drawDoublePlate();


