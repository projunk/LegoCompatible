eps = 0.001;

modelScale = 1.0;



nr_length_units = 2;
nr_width_units = 1;
nr_width_units2 = 3;
isSolidExternalPin = true;
isSolidExternalPin2 = true;
addInnerWalls = true;


// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 0;
correction_t1 = PRINTABLE ? 0.05 : 0.0;



unit_size = 7.8*modelScale;
pitch = 8.0*modelScale;

h1 = 9.6*modelScale; // height
h2 = h1-1.0*modelScale; // inner height
h3 = 1.6*modelScale;

hi1 = 1.6*modelScale;
hi2 = 8.0*modelScale;


// internal pin
r1 = 6.5/2*modelScale;
r2 = 4.8/2*modelScale;
r3 = 3.2/2*modelScale;


// external pin
h_pin = 1.7*modelScale;
r_pin1 = 4.8/2*modelScale;
r_pin2 = 3.2/2*modelScale;



t1 = (1.5-correction_t1)*modelScale; // wall thickness
t2 = 1.2*modelScale; // inner wall thickness


function getSize(prmNrOfUnits) = prmNrOfUnits*unit_size + (prmNrOfUnits - 1) * (pitch - unit_size);

length = getSize(nr_length_units);
width = getSize(nr_width_units);
width2 = getSize(nr_width_units2);
echo("length", length);
echo("width", width);
echo("width2", width2);



function getExternalPinPos(prmPinNr) = prmPinNr*pitch-pitch+unit_size/2;

function getInternalPinPos(prmPinNr) = prmPinNr*pitch-(pitch-unit_size)/2;


module drawExternalPinSolid(prmPinNrX,prmPinNrY)
{
	translate([0,0,h1-eps]) cylinder(h_pin+eps,r_pin1+eps,r_pin1+eps,$fn=100*modelScale);
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


module drawExternalPin(prmPinNrX,prmPinNrY)
{
	if (isSolidExternalPin)
    {
        translate([getExternalPinPos(prmPinNrX),getExternalPinPos(prmPinNrY),0]) drawExternalPinSolid();
    }
    else
    {
        translate([getExternalPinPos(prmPinNrX),getExternalPinPos(prmPinNrY),0]) drawExternalPinHollow();
    }
}


module drawExternalPinSolid2(prmPinNrX,prmPinNrY)
{
	translate([0,0,h1-hi2-eps]) cylinder(h_pin+hi2+eps,r_pin1+eps,r_pin1+eps,$fn=100*modelScale);
}


module drawExternalPinHollow2()
{
	translate([0,0,h1-hi2-eps]) 
    {
        difference()
        {
            cylinder(h_pin+hi2+eps,r_pin1+eps,r_pin1+eps,$fn=100*modelScale);
            cylinder(h_pin+hi2+2*eps,r_pin2,r_pin2,$fn=100*modelScale);
        }
    }
}


module drawExternalPin2(prmPinNrX,prmPinNrY)
{
	if (isSolidExternalPin2)
    {
        translate([getExternalPinPos(prmPinNrX),getExternalPinPos(prmPinNrY),0]) drawExternalPinSolid2();
    }
    else
    {
        translate([getExternalPinPos(prmPinNrX),getExternalPinPos(prmPinNrY),0]) drawExternalPinHollow2();
    }
}


module drawInternalPin1(prmPinNrX,prmPinNrY)
{
	difference()
	{
		translate([getInternalPinPos(prmPinNrX),getInternalPinPos(prmPinNrY),-eps]) cylinder(h2+eps,r1,r1,$fn=100*modelScale);
		translate([getInternalPinPos(prmPinNrX),getInternalPinPos(prmPinNrY),-2*eps]) cylinder(h2+eps,r2,r2,$fn=100*modelScale);
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
                        translate([getInternalPinPos(x)-t2/2,t1-eps,0]) cube([t2,width-2*t1+2*eps,h2+eps]);
                    }
                    union()
                    {
                        if (nr_width_units > 1)
                        {
                            for (y = [1:nr_width_units-1]) 
                            {
                                translate([getInternalPinPos(x),getInternalPinPos(y),-eps]) cylinder(h1+2*eps,r2,r2,$fn=100*modelScale);
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
                        translate([t1-eps,getInternalPinPos(y)-t2/2,0]) cube([length-2*t1+2*eps,t2,h2+eps]);
                    }
                    union()
                    {
                        if (nr_length_units > 1)
                        {
                            for (x = [1:nr_length_units-1]) 
                            {
                                translate([getInternalPinPos(x),getInternalPinPos(y),-eps]) cylinder(h1+2*eps,r2,r2,$fn=100*modelScale);
                            }
                        }
                    }
                }
            }
        }
    }
}


module drawInnerWallsX2()
{
    for (x = [1:nr_length_units])
    {
        difference()
        {
            union()
            {
                translate([getExternalPinPos(x)-t2/2,t1-eps,0]) cube([t2,width2-2*t1+2*eps,h1]);
            }
            union()
            {
                translate([t1,t1,-eps]) cube([length-2*t1,width-2*t1,h2+eps]);
                if (nr_width_units2 > 1)
                {
                    for (y = [nr_width_units:nr_width_units2]) 
                    {
                        translate([getExternalPinPos(x),getExternalPinPos(y),-eps]) cylinder(h1+2*eps,r2,r2,$fn=100*modelScale);
                    }
                }
            }
        }
    }
}


module drawInnerWallsY2()
{
    if (nr_width_units2 > 1)
    {
        for (y = [nr_width_units+1:nr_width_units2])
        {
            if (nr_width_units2 > 1)
            {
                difference()
                {
                    union()
                    {
                        translate([t1-eps,getExternalPinPos(y)-t2/2,0]) cube([length-2*t1+2*eps,t2,h1]);
                    }
                    union()
                    {
                        for (x = [1:nr_length_units]) 
                        {
                            translate([getExternalPinPos(x),getExternalPinPos(y),-eps]) cylinder(h1+2*eps,r2,r2,$fn=100*modelScale);
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
				drawInternalPin1(x,y);
			}
		}
	}

	if ((nr_width_units == 1) && (nr_length_units > 1))
	{
		for (x = [1:nr_length_units-1])
		{
			translate([getInternalPinPos(x),width/2,0]) drawInternalPin2();
		}
	}

	if ((nr_length_units == 1) && (nr_width_units > 1))
	{
		for (y = [1:nr_width_units-1])
		{
			translate([length/2,getInternalPinPos(y),0]) drawInternalPin2();
		}
	}
}


module drawExternalPins()
{
	for (x = [1:nr_length_units])
	{
		for (y = [1:nr_width_units])
		{	
			drawExternalPin(x,y);
		}
	}
}


module drawExternalPins2()
{
	for (x = [1:nr_length_units])
	{
		for (y = [nr_width_units+1:nr_width_units2])
		{	
			drawExternalPin2(x,y);
		}
	}
}


module drawSlopeBrickSolid()
{
    hull()
    {
        cube([length,width,h1]);
        translate([0,0,h1-h3]) cube([length,width2,h3]);
    }                
}


module drawSlopeBrickSolidMask()
{
    smallSize = 12*max(length,width);
    difference()
    {
        translate([-smallSize/2,-smallSize/2,-smallSize+h1]) cube([smallSize,smallSize,smallSize]);
        drawSlopeBrickSolid();
    }
}


module drawSlopeBrickInnerSolid()
{
    yPos = getExternalPinPos(nr_width_units+1)-width/2;
    hull()
    {
        translate([t1,yPos,h1-hi1]) cube([length-2*t1,width2-yPos-t1,hi1+eps]);
        translate([t1,yPos,h1-hi2]) cube([length-2*t1,eps,eps]);
    }                
}


module drawBrick() 
{
	difference()
	{
		union()
		{	
            drawSlopeBrickSolid();
		}
		union()
		{	
			translate([t1,t1,-eps]) cube([length-2*t1,width-2*t1,h2+eps]);
            drawSlopeBrickInnerSolid();
		}
	}
    
    if (addInnerWalls)
    {
        drawInnerWallsX();
        drawInnerWallsY();
    }
	drawInternalPins();
	drawExternalPins();
    
    difference()
	{   
        union()
		{ 
            drawExternalPins2();
            if (addInnerWalls)
            {
                drawInnerWallsX2();
                drawInnerWallsY2();
            }            
        }
        union()
		{        
            drawSlopeBrickSolidMask();
        }
    }
}



// tests
//drawSlopeBrickSolid();
//drawSlopeBrickSolidMask();
//drawSlopeBrickInnerSolid();


// parts
drawBrick();

