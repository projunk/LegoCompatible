eps = 0.001;

modelScale = 1.0;



nr_length_units = 8;
nr_width_units = 1;
addScrewHoles = false;



// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 0;
correction_t1 = PRINTABLE ? 0.05 : 0.0;



unit_size = 7.8*modelScale;
pitch = 8.0*modelScale;

h1 = 9.6*modelScale; // height
h2 = h1-1.0*modelScale; // inner height

// pin1
r1 = 6.5/2*modelScale;
r2 = 4.8/2*modelScale;

// pin2
r3 = 3.2/2*modelScale;

// pinhole
ph1 = unit_size;
ph2 = 0.8*modelScale;
ph3 = 5.6*modelScale; // center hole offset
pr2 = 4.8/2*modelScale;
pr3 = 6.2/2*modelScale;
pr4 = 7.4/2*modelScale; // bearing


t1 = (1.5-correction_t1)*modelScale; // wall thickness
t2 = 1.2*modelScale; // inner wall thickness


length = nr_length_units*unit_size + (nr_length_units - 1) * (pitch - unit_size);
width = nr_width_units*unit_size + (nr_width_units - 1) * (pitch - unit_size);
echo("length", length);
echo("width", width);


h_pin = 1.7*modelScale;
r_pin1 = 4.8/2*modelScale;
r_pin2 = 3.2/2*modelScale;


rScrewHole = 4.0/2/2.5;



module drawScrewHole()
{
    translate([0,0,-eps]) cylinder(h1+h_pin+2*eps,rScrewHole,rScrewHole,$fn=100*modelScale);
}


module drawPinHole()
{
	translate([0,0,ph3]) rotate([-90,0,0])
	{
		translate([0,0,-eps]) cylinder(ph2+eps,pr3,pr3,$fn=100*modelScale);
		translate([0,0,ph2-eps]) cylinder(ph1-2*ph2+2*eps,pr2,pr2,$fn=100*modelScale);
		translate([0,0,ph1-ph2]) cylinder(ph2+eps,pr3,pr3,$fn=100*modelScale);
	}
}


module drawDoublePinHole()
{
    drawPinHole();
    translate([0,ph1,0]) drawPinHole();
}


module drawFullPinHole()
{
    drawDoublePinHole();
    translate([0,width-2*ph1,0]) drawDoublePinHole();
    translate([0,-eps,ph3]) rotate([-90,0,0]) cylinder(width+2*eps,pr2,pr2,$fn=100*modelScale);
}


module drawPinHoles()
{
    if (nr_length_units > 1)
    {
        for (x = [1:nr_length_units-1])
        {
            translate([x*pitch,0,0]) drawFullPinHole();
        }
    }
}


module drawPinHoleBearing()
{
    translate([0,ph2,ph3]) rotate([-90,0,0])
    {
        ph = width - 2*ph2;
        difference()
        {
            translate([0,0,-eps]) cylinder(ph+2*eps,pr4,pr4,$fn=100*modelScale);
            translate([0,0,-2*eps]) cylinder(ph+4*eps,pr2,pr2,$fn=100*modelScale);
        }
    }
}


module drawPinHoleBearings()
{
    if (nr_length_units > 1)
    {
        for (x = [1:nr_length_units-1])
        {
            translate([x*pitch,0,0]) drawPinHoleBearing();
        }
    }
}


module drawExternalPin()
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
		translate([0,0,0]) cylinder(h2+eps,r1,r1,$fn=100*modelScale);
		translate([0,0,-eps]) cylinder(h2+2*eps,r2,r2,$fn=100*modelScale);
	}
}


module drawInternalPin2()
{
	cylinder(h2+eps,r3,r3,$fn=100*modelScale);
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


module drawInternalPins()
{
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
			translate([x*pitch-(pitch-unit_size)/2,width/2,0]) drawInternalPin2();
		}
	}

	if ((nr_length_units == 1) && (nr_width_units > 1))
	{
		for (y = [1:nr_width_units-1])
		{
			translate([length/2,y*pitch-(pitch-unit_size)/2,0]) drawInternalPin2();
		}
	}
}


module drawExternalPins()
{
	for (x = [1:nr_length_units])
	{
		for (y = [1:nr_width_units])
		{	
			translate([x*pitch-pitch+unit_size/2,y*pitch-pitch+unit_size/2,0]) drawExternalPin();
		}
	}
}


module drawScrewHoles()
{
	for (x = [1:nr_length_units])
	{
		for (y = [1:nr_width_units])
		{	
			translate([x*pitch-pitch+unit_size/2,y*pitch-pitch+unit_size/2,0]) drawScrewHole();
		}
	}
}


module drawBrick() 
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

    drawInnerWallsX();
    drawInnerWallsY();
	drawInternalPins();
	drawExternalPins();
}


module drawHoledBrick()
{
    difference()
    {
        union()
        {
            drawBrick();
            drawPinHoleBearings();
        }
        union()
        {
            drawPinHoles();
            if (addScrewHoles)
            {
                drawScrewHoles();
            }
        }
    }    
}


// tests
//drawPinHole();
//drawDoublePinHole();
//drawFullPinHole();
//drawPinHoleBearing();


// parts
drawHoledBrick();

