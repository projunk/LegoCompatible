eps = 0.001;


include <dimensions.scad>
include <utils.scad>


// exported parts
_HingePlate2Fingers = 0;
_HingePlate3Fingers = 1;
selectedPart = _HingePlate2Fingers;



nr_length_units = 2;
nr_width_units = 1;
echo("nr_length_units", nr_length_units);
echo("nr_width_units", nr_width_units);
isHollowExternalPin = false;
addInnerWalls = true;


length = getSize(nr_length_units);
width = getSize(nr_width_units);


nrOfFingers = 5;
fingerClearance = 0.0;//0.1;
wFinger = (width-(nrOfFingers-1)*fingerClearance)/nrOfFingers;
rBearingSphere = hPlate;
offsetBearingSphere = 0.9*rBearingSphere;
rBearingSphereCup = 0.95*rBearingSphere;
offsetBearingSphereCup = 0.9*rBearingSphereCup;



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
                        translate([x*pitch-(pitch-unit_size)/2-tInnerWall/2,tWall-eps,0]) cube([tInnerWall,width-2*tWall+2*eps,hInnerPlate+eps]);
                    }
                    union()
                    {
                        if (nr_width_units > 1)
                        {
                            for (y = [1:nr_width_units-1]) 
                            {
                                translate([x*pitch-(pitch-unit_size)/2,y*pitch-(pitch-unit_size)/2,-eps]) cylinder(hPlate+2*eps,riInternalPin,riInternalPin,$fn=100);
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
				translate([x*pitch-(pitch-unit_size)/2,y*pitch-(pitch-unit_size)/2,0]) drawInternalPin(hInnerPlate);
			}
		}
	}

	if ((nr_width_units == 1) && (nr_length_units > 1))
	{
		for (x = [1:nr_length_units-1])
		{
			translate([x*pitch-(pitch-unit_size)/2,width/2,0]) drawInternalPinSmall(hInnerPlate);
		}
	}

	if ((nr_length_units == 1) && (nr_width_units > 1))
	{
		for (y = [1:nr_width_units-1])
		{
			translate([length/2,y*pitch-(pitch-unit_size)/2,0]) drawInternalSmall(hInnerPlate);
		}
	}
}


module drawExternalPins()
{
	for (x = [1:nr_length_units])
	{
		for (y = [1:nr_width_units])
		{	
            difference()
            {
                union()
                {
                    translate([x*pitch-pitch+unit_size/2,y*pitch-pitch+unit_size/2,hPlate]) drawExternalPin(isHollowExternalPin);
                }
                union()
                {
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
			cube([length,width,hPlate]);
		}
		union()
		{	
			translate([tWall,tWall,-eps]) cube([length-2*tWall,width-2*tWall,hInnerPlate+eps]);
		}
	}
    
    if (addInnerWalls)
    {
        drawInnerWallsX();
    }
	drawInternalPins();
	drawExternalPins();    
}


module drawHingeFinger()
{
    hull()
    {
        translate([pitch/2,0,0]) cube([eps,wFinger,hPlate]);
        translate([0,0,hPlate/2]) rotate([-90,0,0]) cylinder(wFinger,hPlate/2,hPlate/2,$fn=100);
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
            translate([0,-offsetBearingSphereCup,hPlate/2]) sphere(rBearingSphereCup,$fn=250);
            translate([0,wFinger+offsetBearingSphereCup,hPlate/2]) sphere(rBearingSphereCup,$fn=250);   
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
                    translate([0,offsetBearingSphere,hPlate/2]) sphere(rBearingSphere,$fn=250);
                    translate([-rBearingSphere,eps,-rBearingSphere+hPlate/2]) cube([2*rBearingSphere,2*rBearingSphere,2*rBearingSphere]);
                }
            }
            if (prmAddSphere2)
            {
                difference()
                {
                    translate([0,wFinger-offsetBearingSphere,hPlate/2]) sphere(rBearingSphere,$fn=250);
                    translate([-rBearingSphere,wFinger-2*rBearingSphere-eps,-rBearingSphere+hPlate/2]) cube([2*rBearingSphere,2*rBearingSphere,2*rBearingSphere]);
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
            translate([pitch/2,0,hPlate/2]) rotate([-90,0,0]) cylinder(width,hPlate/2,hPlate/2,$fn=250);
            
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
            translate([pitch/2,0,hPlate/2]) rotate([-90,0,0]) cylinder(width,hPlate/2,hPlate/2,$fn=100);
            
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
if (selectedPart==_HingePlate2Fingers) drawHingePlate2Fingers();
if (selectedPart==_HingePlate3Fingers) drawHingePlate3Fingers();

