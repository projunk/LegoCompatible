eps = 0.001;

modelScale = 1.0;



nr_length_units_side = 4;
nr_length_units_top = 2;
addInnerWalls = true;


// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 0;
correction_t1 = PRINTABLE ? 0.05 : 0.0;



unit_size = 7.8*modelScale;
pitch = 8.0*modelScale;

h1 = 8.0*modelScale; // height

offsetSideHoleZ = 4.0*modelScale;

rCorner = 0.8*modelScale;


// internal pin
r1 = 3.2/2*modelScale;


t1 = (1.5-correction_t1)*modelScale; // wall thickness
t2 = 1.2*modelScale; // inner wall thickness
t3 = 1.6*modelScale; // side wall thickness
t4 = 3.2*modelScale; // top thickness
t5 = 1.0*modelScale; // top wall thickness


lengthSide = nr_length_units_side*unit_size + (nr_length_units_side - 1) * (pitch - unit_size);
lengthTop = nr_length_units_top*unit_size + (nr_length_units_top - 1) * (pitch - unit_size);
widthTop = unit_size;
offsetTopY = (pitch-unit_size)/2;
echo("lengthSide", lengthSide);
echo("lengthTop", lengthTop);
echo("widthTop", widthTop);


h_pin = 1.7*modelScale;
r_pin1 = 4.8/2*modelScale;
r_pin2 = 3.2/2*modelScale;



module drawExternalPinSolid()
{
	cylinder(h_pin+eps,r_pin1,r_pin1,$fn=100*modelScale);
}


module drawExternalPinHollow()
{
    difference()
    {
        cylinder(h_pin+eps,r_pin1,r_pin1,$fn=100*modelScale);
        cylinder(h_pin+2*eps,r_pin2,r_pin2,$fn=100*modelScale);
    }
}


module drawInternalPin()
{
	cylinder(t4-t5+eps,r1,r1,$fn=100*modelScale);
}


module drawInnerWallsX()
{
    if (nr_length_units_top > 1)
    {        
        for (x = [1:nr_length_units_top-1])
        {            
            translate([lengthSide/2-lengthTop/2+x*pitch-(pitch-unit_size)/2-t2/2,offsetTopY+t3+t1-eps,h1-t4]) cube([t2,widthTop-2*t1+2*eps,t4-t5+eps]);
        }
    }
}


module drawInternalPins()
{
	for (x = [1:nr_length_units_top-1])
    {
        translate([lengthSide/2-lengthTop/2+x*pitch-(pitch-unit_size)/2,offsetTopY+t3+widthTop/2,h1-t4]) drawInternalPin();
	}
}


module drawExternalTopPins()
{
	for (x = [1:nr_length_units_top])
	{
		translate([lengthSide/2-lengthTop/2+x*pitch-pitch+unit_size/2,offsetTopY+t3+widthTop/2,h1-eps]) drawExternalPinSolid();
	}
}


module drawExternalSidePins()
{
	for (x = [1:nr_length_units_side])
	{
		translate([x*pitch-pitch+unit_size/2,0,offsetSideHoleZ]) rotate([90,0,0]) drawExternalPinHollow();
	}
}


module drawBrick() 
{
	difference()
	{
		union()
		{	
            hull()
            {
                translate([0,0,h1-eps]) cube([lengthSide,t3,eps]);
                translate([rCorner,0,rCorner]) rotate([-90,0,0]) cylinder(t3,rCorner,rCorner,$fn=50*modelScale);
                translate([lengthSide-rCorner,0,rCorner]) rotate([-90,0,0]) cylinder(t3,rCorner,rCorner,$fn=50*modelScale);
            }
           
			translate([lengthSide/2-lengthTop/2,t3-eps,h1-t4]) cube([lengthTop,offsetTopY+widthTop+eps,t4]);
		}
		union()
		{	
			translate([lengthSide/2-lengthTop/2+t1,offsetTopY+t3+t1,h1-t4-eps]) cube([lengthTop-2*t1,widthTop-2*t1,t4-t5+eps]);
		}
	}

    if (addInnerWalls)
    {
        drawInnerWallsX();
    }
	drawInternalPins();
	drawExternalTopPins();
    drawExternalSidePins();
}



// tests
//drawInnerWallsX();
//drawExternalSidePins();


// parts
drawBrick();

