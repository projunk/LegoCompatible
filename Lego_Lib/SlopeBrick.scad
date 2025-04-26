eps = 0.001;

modelScale = 1.0;


nr_length_units_bottom = 2;
nr_length_units_top = 1;
nr_width_units_bottom = 2;
nr_width_units_top = 1;
isSolidExternalPin = true;
addInnerWalls = true;


// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 0;
correction_t1 = PRINTABLE ? 0.05 : 0.0;



unit_size = 7.8*modelScale;
pitch = 8.0*modelScale;

ho1 = 1.6*modelScale;
ho2 = 8.0*modelScale;
hi1 = 1.6*modelScale;
hi2 = 6.4*modelScale;


t1 = (1.5-correction_t1)*modelScale; // wall thickness
t2 = 1.2*modelScale; // inner wall thickness


// internal pin
r1 = 6.5/2*modelScale;
r2 = 4.8/2*modelScale;


// external pin
h_pin = 1.6*modelScale;
r_pin1 = 4.8/2*modelScale;
r_pin2 = 3.2/2*modelScale;



function getSize(prmNrOfUnits) = prmNrOfUnits*unit_size + (prmNrOfUnits - 1) * (pitch - unit_size);

length_bottom = getSize(nr_length_units_bottom);
length_top = getSize(nr_length_units_top);
width_bottom = getSize(nr_width_units_bottom);
width_top = getSize(nr_width_units_top);
echo("length_bottom", length_bottom);
echo("length_top", length_top);
echo("width_bottom", width_bottom);
echo("width_top", width_top);


function getExternalPinPos(prmPinNr) = prmPinNr*pitch-pitch+unit_size/2;

function getInternalPinPos(prmPinNr) = prmPinNr*pitch-(pitch-unit_size)/2;



module drawExternalPinSolid(prmPinNrX,prmPinNrY)
{
	translate([0,0,ho1+ho2-eps]) cylinder(h_pin+eps,r_pin1,r_pin1,$fn=100*modelScale);
}


module drawExternalPinHollow()
{
	translate([0,0,ho1+ho2-eps]) 
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


module drawInternalPin(prmPinNrX,prmPinNrY)
{
	difference()
	{
		translate([getInternalPinPos(prmPinNrX),getInternalPinPos(prmPinNrY),0]) cylinder(hi1+hi2+eps,r1,r1,$fn=100*modelScale);
		translate([getInternalPinPos(prmPinNrX),getInternalPinPos(prmPinNrY),-eps]) cylinder(hi1+hi2+2*eps,r2,r2,$fn=100*modelScale);
	}
}


module drawInnerWallsX()
{
    if (nr_length_units_bottom > 1)
    {
        for (x = [1:nr_length_units_bottom-1])
        {
            if (nr_length_units_bottom > 1)
            {
                difference()
                {
                    union()
                    {
                        translate([getInternalPinPos(x)-t2/2,t1-eps,0]) cube([t2,width_bottom-2*t1+2*eps,hi1+hi2+eps]);
                    }
                    union()
                    {
                        if (nr_width_units_bottom > 1)
                        {
                            for (y = [1:nr_width_units_bottom-1]) 
                            {
                                translate([getInternalPinPos(x),getInternalPinPos(y),-eps]) cylinder(hi1+hi2+2*eps,r2,r2,$fn=100*modelScale);
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
    if (nr_width_units_bottom > 1)
    {
        for (y = [1:nr_width_units_bottom-1])
        {
            if (nr_width_units_bottom > 1)
            {
                difference()
                {
                    union()
                    {
                        translate([t1-eps,getInternalPinPos(y)-t2/2,0]) cube([length_bottom-2*t1+2*eps,t2,hi1+hi2+eps]);
                    }
                    union()
                    {
                        if (nr_length_units_bottom > 1)
                        {
                            for (x = [1:nr_length_units_bottom-1]) 
                            {
                                translate([getInternalPinPos(x),getInternalPinPos(y),-eps]) cylinder(hi1+hi2+2*eps,r2,r2,$fn=100*modelScale);
                            }
                        }
                    }
                }
            }
        }
    }
}


module drawOuterSlope()
{
    hull()
    {
        translate([0,0,ho1+ho2-eps]) cube([length_top,width_top,eps]);
        cube([length_bottom,width_bottom,ho1]);			
    }    
}


module drawOuterSlopeMask()
{
    difference()
    {
        translate([-eps,-eps,-eps]) cube([length_bottom+2*eps,width_bottom+2*eps,ho1+ho2+2*eps]);
        drawOuterSlope();
    }
}


module drawSlopeBrick() 
{
	difference()
	{
		union()
		{	
            drawOuterSlope();
		}
		union()
		{	
            hull()
            {
                translate([t1,t1,hi1+hi2-eps]) cube([length_top-2*t1,width_top-2*t1,eps]);
                translate([t1,t1,-eps]) cube([length_bottom-2*t1,width_bottom-2*t1,hi1+eps]);			
            }            
		}
	}

	for (x = [1:nr_length_units_top])
	{
		for (y = [1:nr_width_units_top])
		{	
            drawExternalPin(x,y);
		}
	}


    difference()
    {
        union()
        {
            if ((nr_length_units_bottom > 1) && (nr_width_units_bottom > 1)) 
            {
                for (x = [1:nr_length_units_bottom-1])
                {
                    for (y = [1:nr_width_units_bottom-1]) 
                    {	
                        drawInternalPin(x,y);
                    }
                }
            }
                
            if (addInnerWalls)
            {
                drawInnerWallsX();
                drawInnerWallsY();
            }
        }
        union()
        {
            drawOuterSlopeMask();
        }
    }
}



// tests
//drawOuterSlope();


// parts
drawSlopeBrick();


