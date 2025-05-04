eps = 0.001;


include <dimensions.scad>
include <utils.scad>



nr_length_units = 10;
nr_width_units = 3;
echo("nr_length_units", nr_length_units);
echo("nr_width_units", nr_width_units);
isHollowExternalPin = false;
addInnerWalls = true;


length = getSize(nr_length_units);
width = getSize(nr_width_units);



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
                                translate([x*pitch-(pitch-unit_size)/2,y*pitch-(pitch-unit_size)/2,-eps]) cylinder(hBrick+2*eps,riInternalPin,riInternalPin,$fn=100);
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
                                translate([x*pitch-(pitch-unit_size)/2,y*pitch-(pitch-unit_size)/2,-eps]) cylinder(hBrick+2*eps,riInternalPin,riInternalPin,$fn=100);
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
			translate([length/2,y*pitch-(pitch-unit_size)/2,0]) drawInternalSmall(hInnerBrick);
		}
	}
}


module drawExternalPins()
{
	for (x = [1:nr_length_units])
	{
		for (y = [1:nr_width_units])
		{	
			translate([x*pitch-pitch+unit_size/2,y*pitch-pitch+unit_size/2,hBrick]) drawExternalPin(isHollowExternalPin);
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

    if (addInnerWalls)
    {
        drawInnerWallsX();
        drawInnerWallsY();
    }
	drawInternalPins();
	drawExternalPins();
}



// tests


// parts
drawBrick();

