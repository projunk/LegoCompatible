eps = 0.001;

modelScale = 1.0;


nr_length_units = 2;
nr_width_units = 1;
isSolidPin2 = true;
addInnerWalls = true;


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


t1 = 1.5*modelScale; // wall thickness
t2 = 1.2*modelScale; // inner wall thickness

length = nr_length_units*unit_size + (nr_length_units - 1) * (pitch - unit_size);
width = nr_width_units*unit_size + (nr_width_units - 1) * (pitch - unit_size);


h_pin = 1.7*modelScale;
r_pin = 4.8/2*modelScale;


nrOfFingers = 5;
fingerClearance = 0.0;//0.1*modelScale;
wFinger = (width-(nrOfFingers-1)*fingerClearance)/nrOfFingers;
rBearingSphere = h1;
offsetBearingSphere = 0.9*rBearingSphere;



module drawExternalPin()
{
	translate([0,0,h1-eps]) cylinder(h_pin+eps,r_pin,r_pin,$fn=100*modelScale);
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
		for (y = [1:nr_width_units])
		{	
			translate([x*pitch-pitch+unit_size/2,y*pitch-pitch+unit_size/2,0]) drawExternalPin();
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
    }    
}


module drawHingeFinger()
{
    hull()
    {
        translate([pitch/2,0,0]) cube([eps,wFinger,h1]);
        translate([0,0,h1/2]) rotate([-90,0,0]) cylinder(wFinger,h1/2,h1/2,$fn=100*modelScale);
    }
}


module drawHinge2Finger()
{
    difference()
    {
        union()
        {
            drawHingeFinger();
        }
        union()
		{	
            translate([0,-offsetBearingSphere,h1/2]) sphere(rBearingSphere,$fn=250*modelScale);
            translate([0,wFinger+offsetBearingSphere,h1/2]) sphere(rBearingSphere,$fn=250*modelScale);   
		}
    }
}


module drawHinge3Finger(prmAddSphere1,prmAddSphere2)
{
    difference()
    {
        union()
        {
            drawHingeFinger();
            if (prmAddSphere1)
            {
                difference()
                {
                    translate([0,offsetBearingSphere,h1/2]) sphere(rBearingSphere,$fn=250*modelScale);
                    translate([-rBearingSphere,eps,-rBearingSphere+h1/2]) cube([2*rBearingSphere,2*rBearingSphere,2*rBearingSphere]);
                }
            }
            if (prmAddSphere2)
            {
                difference()
                {
                    translate([0,wFinger-offsetBearingSphere,h1/2]) sphere(rBearingSphere,$fn=250*modelScale);
                    translate([-rBearingSphere,wFinger-2*rBearingSphere-eps,-rBearingSphere+h1/2]) cube([2*rBearingSphere,2*rBearingSphere,2*rBearingSphere]);
                }
            }            
        }
        union()
		{	
		}
    }   
}


module drawHingePlate2Fingers() 
{
	difference()
	{
		union()
		{	
			translate([pitch/2,0,0]) drawPlate();
            translate([pitch/2,0,h1/2]) rotate([-90,0,0]) cylinder(width,h1/2,h1/2,$fn=250*modelScale);
            
            translate([0,wFinger+fingerClearance,0]) drawHinge2Finger();
            translate([0,3*wFinger+3*fingerClearance,0]) drawHinge2Finger();
		}
		union()
		{	
		}
	}
}


module drawHingePlate3Fingers() 
{
	difference()
	{
		union()
		{	
			translate([pitch/2,0,0]) drawPlate();
            translate([pitch/2,0,h1/2]) rotate([-90,0,0]) cylinder(width,h1/2,h1/2,$fn=100*modelScale);
            
            translate([0,0,0]) drawHinge3Finger(false,true);
            translate([0,width/2-wFinger/2,0]) drawHinge3Finger(true,true);
            translate([0,width-wFinger,0]) drawHinge3Finger(true,false);
		}
		union()
		{	
		}
	}
}


module drawAssembly()
{
    drawHingePlate2Fingers();
    mirror([1,0,0]) drawHingePlate3Fingers();
}


// tests
//drawPlate();
//drawHingeFinger();
//drawHinge2Finger();
//drawHinge3Finger(true,true);
//drawAssembly();


// parts
drawHingePlate2Fingers();
//drawHingePlate3Fingers();



