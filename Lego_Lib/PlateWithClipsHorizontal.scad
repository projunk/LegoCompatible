eps = 0.001;

modelScale = 1.0;


nr_length_units = 1;
nr_width_units = 2;
isSolidExternalPin = true;
isSolidPin2 = true;
addInnerWalls = true;


// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 0;
correction_t1 = PRINTABLE ? 0.05 : 0.0;



unit_size = 7.8*modelScale;
pitch = 8.0*modelScale;

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


offsetClipX = 4.0*modelScale;
offsetClipZ = 2.4*modelScale;
tClip = 3.0*modelScale;
rClip1 = 3.2*modelScale;
rClip2 = 1.6*modelScale;
angleClip = 7.0;

xPosClip1 = 4.612*modelScale;
zPosClip1Bottom = 0.922*modelScale;
zPosClip1Top = 3.878*modelScale;

xPosClip2 = 5.6*modelScale;
zPosClip2Bottom = 0.8*modelScale;
zPosClip2Top = 4.0*modelScale;

rClipFilletBottom = 8.0*modelScale;


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


module drawFillet(prmZ,prmFillet)
{
    translate([0,width/2-tClip/2-eps,prmZ]) rotate([-90,0,0]) cylinder(tClip+2*eps,prmFillet,prmFillet,$fn=200*modelScale);
}


module drawClip()
{
    difference()
	{
		union()
		{	
            difference()
            {
                union()
                {
                    hull()
                    {
                        translate([0,width/2-tClip/2,0]) cube([eps,tClip,h1]);
                        translate([-offsetClipX,width/2-tClip/2,offsetClipZ]) rotate([-90,0,0]) cylinder(tClip,rClip1,rClip1,$fn=200*modelScale);
                    }
                }
                union()
                {
                    drawFillet(-rClipFilletBottom,rClipFilletBottom);
                }
            }
        }
		union()
		{	
            smallSize = 4*rClip1;
            translate([-xPosClip2-smallSize,width/2-tClip/2-eps,-smallSize/2]) cube([smallSize,tClip+2*eps,smallSize]);
            translate([-offsetClipX,width/2-tClip/2-eps,offsetClipZ]) rotate([-90,0,0]) cylinder(tClip+2*eps,rClip2,rClip2,$fn=200*modelScale);
            
            hull()
            {
                translate([-xPosClip2-eps,width/2-tClip/2-eps,zPosClip2Bottom]) cube([eps,tClip+2*eps,zPosClip2Top-zPosClip2Bottom]);
                translate([-xPosClip1,width/2-tClip/2-eps,zPosClip1Bottom]) cube([eps,tClip+2*eps,zPosClip1Top-zPosClip1Bottom]);
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
            cube([length,width,h1]);
            translate([0,-width/4,0]) drawClip();
            translate([0,width/4,0]) drawClip();
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



// tests
//drawClip();


// parts
drawPlate();
