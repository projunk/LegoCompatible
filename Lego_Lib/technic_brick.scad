eps = 0.001;


include <dimensions.scad>
include <utils.scad>


nr_length_units = 8;
nr_width_units = 1;
echo("nr_length_units", nr_length_units);
echo("nr_width_units", nr_width_units);

addScrewHoles = false;


length = getSize(nr_length_units);
width = getSize(nr_width_units);


rScrewHole = 4.0/2/2.5;



module drawScrewHole()
{
    translate([0,0,-eps]) cylinder(hBrick+hExternalPin+2*eps,rScrewHole,rScrewHole,$fn=100);
}


module drawPinHoles()
{
    if (nr_length_units > 1)
    {
        for (x = [1:nr_length_units-1])
        {
            translate([x*pitch,0,axleOffset]) drawFullPinHole();
        }
    }
}


module drawPinHoleBearings()
{
    if (nr_length_units > 1)
    {
        for (x = [1:nr_length_units-1])
        {
            translate([x*pitch,0,axleOffset]) drawPinHoleBearing();
        }
    }
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
                        translate([x*pitch-(pitch-unit_size)/2-tInnerWall/2,tWall-eps,0]) cube([tInnerWall,width-2*tWall+2*eps,hInnerBrick+eps]);
                    }
                    union()
                    {
                        if (nr_width_units > 1)
                        {
                            for (y = [1:nr_width_units-1]) 
                            {
                                translate([x*pitch-(pitch-unit_size)/2,y*pitch-(pitch-unit_size)/2,-eps]) cylinder(h1+2*eps,riInternalPin,riInternalPin,$fn=100);
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
                        translate([tWall-eps,y*pitch-(pitch-unit_size)/2-tInnerWall/2,0]) cube([length-2*tWall+2*eps,tInnerWall,hInnerBrick+eps]);
                    }
                    union()
                    {
                        if (nr_length_units > 1)
                        {
                            for (x = [1:nr_length_units-1]) 
                            {
                                translate([x*pitch-(pitch-unit_size)/2,y*pitch-(pitch-unit_size)/2,-eps]) cylinder(h1+2*eps,riInternalPin,riInternalPin,$fn=100);
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
				translate([x*pitch-(pitch-unit_size)/2,y*pitch-(pitch-unit_size)/2,0]) drawInternalPin(hInnerBrick);
			}
		}
	}

	if ((nr_width_units == 1) && (nr_length_units > 1))
	{
		for (x = [1:nr_length_units-1])
		{
			translate([x*pitch-(pitch-unit_size)/2,width/2,0]) drawInternalPinSmall(hInnerBrick);
		}
	}

	if ((nr_length_units == 1) && (nr_width_units > 1))
	{
		for (y = [1:nr_width_units-1])
		{
			translate([length/2,y*pitch-(pitch-unit_size)/2,0]) drawInternalPinSmall(hInnerBrick);
		}
	}
}


module drawExternalPins()
{
	for (x = [1:nr_length_units])
	{
		for (y = [1:nr_width_units])
		{	
			translate([x*pitch-pitch+unit_size/2,y*pitch-pitch+unit_size/2,hBrick]) drawExternalPin(true);
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
			cube([length,width,hBrick]);
		}
		union()
		{	
			translate([tWall,tWall,-eps]) cube([length-2*tWall,width-2*tWall,hInnerBrick+eps]);
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

