eps = 0.001;

modelScale = 1.0;


nr_length_units = 4;
isSolidPin2 = true;
addInnerWalls = true;
noTeeth = true;
addScrewHoles = false;


// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 0;
correction_t1 = PRINTABLE ? 0.05 : 0.0;
correction_axleHoleRadius = PRINTABLE ? 0.15 : 0.0;
correction_axleHoleWidth = PRINTABLE ? 0.3 : 0.0;
correction_axleInnerRadius = PRINTABLE ? 0.3 : 0.0;



// tooth
nrOfTeeth = 16;
hTooth = 0.8*modelScale;
clearanceAngle = 0.5;
alfa = 360/(2*nrOfTeeth)+clearanceAngle;


// pinhole
pr2 = 4.8/2*modelScale;


unit_size = 7.8*modelScale;
pitch = 8.0*modelScale;

h1 = 3.2*modelScale; // height
h2 = h1-1.0*modelScale; // inner height


// pin2
r3 = 3.2/2*modelScale;
r4 = 1.6/2*modelScale;


t1 = (1.5-correction_t1)*modelScale; // wall thickness
t2 = 1.2*modelScale; // inner wall thickness


length = nr_length_units*unit_size + (nr_length_units - 1) * (pitch - unit_size);
width = unit_size;
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


module drawTooth()
{
    rotate([0,0,-alfa/2]) rotate_extrude(angle=alfa,convexity=2,$fn=500*modelScale) square([width/2,hTooth+eps]);
}


module drawTeeth()
{
    for (s=[1:1:nrOfTeeth])
    {
        angle = (s-1)/nrOfTeeth * 360;
        rotate([0,0,angle]) drawTooth();
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
                translate([x*pitch-(pitch-unit_size)/2-t2/2,t1-eps,0]) cube([t2,width-2*t1+2*eps,h2+eps]);
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
		}
		union()
		{	
			translate([t1,t1,-eps]) cube([length-2*t1,width-2*t1,h2+eps]);
		}
	}

	for (x = [1:nr_length_units])
	{
		translate([x*pitch-pitch+unit_size/2,pitch-pitch+unit_size/2,0]) drawExternalPin();
	}

	if (nr_length_units > 1)
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
    
    if (addInnerWalls)
    {
        drawInnerWallsX();
    }
}


module drawToothedEnd() 
{
	difference()
	{
		union()
		{	
            hull()
            {
                translate([width/2,width/2,hTooth]) cylinder(h1-hTooth,width/2,width/2,$fn=100*modelScale);
                translate([pitch+eps,0,hTooth]) cube([eps,width,h1-hTooth]);
            }
            if (noTeeth) 
            {
                translate([width/2,width/2,0]) cylinder(hTooth+eps,width/2,width/2,$fn=100*modelScale);
            }
            else
            {
                translate([width/2,width/2,0]) drawTeeth();
            }
		}
		union()
		{	
            translate([width/2,width/2,-eps]) cylinder(h1+2*eps,pr2,pr2,$fn=100*modelScale);
		}
	}    
}


module drawPlateToothedEnd() 
{
	difference()
	{
		union()
		{	
            drawToothedEnd();
            translate([pitch,0,0]) drawPlate();
            translate([2*pitch+length,0,0]) mirror([1,0,0]) drawToothedEnd();
		}
		union()
		{	
            if (addScrewHoles)
            {
                for (x = [1:nr_length_units])
                {
                    translate([(x+1)*pitch-pitch+unit_size/2,width/2,0]) drawScrewHole();
                }
            }            
		}
	}
}


// tests
//drawTooth();
//drawTeeth();
//drawToothedEnd();


// parts
drawPlateToothedEnd();


