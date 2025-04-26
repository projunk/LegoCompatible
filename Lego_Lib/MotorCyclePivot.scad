eps = 0.001;


include <../lib/transformers.scad>
include <dimensions.scad>


modelScale = 1.0;



nr_length_units = 2;
nr_width_units = 2;
addScrewHoles = false;



// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 0;
correction_t1 = PRINTABLE ? 0.05 : 0.0;



h1 = 9.6*modelScale; // height
h2 = h1-1.0*modelScale; // inner height

// pin1
r1 = 6.5/2*modelScale;
r2 = 4.8/2*modelScale;

// pin2
r3 = 3.2/2*modelScale;

// pinhole
ph1 = unit_size*modelScale;
ph2 = 0.8*modelScale;
ph3 = 5.6*modelScale; // center hole offset
pr2 = 4.8/2*modelScale;
pr3 = 6.2/2*modelScale;
pr4 = 7.4/2*modelScale; // bearing


t1 = (1.5-correction_t1)*modelScale; // wall thickness
t2 = 1.2*modelScale; // inner wall thickness


length = getSize(nr_length_units);
width = getSize(nr_width_units);
width2 = getSize(1);
echo("length", length);
echo("width", width);


h_pin = 1.7*modelScale;
r_pin1 = 4.8/2*modelScale;
r_pin2 = 3.2/2*modelScale;


rScrewHole = 4.0/2/2.5;


distTillSlope = 17.715*modelScale;
hCutOut = 1.6*modelScale;
lCutOut = 4.8*modelScale;
offsetCutOut = 1.6*modelScale;
distBetweenCutOuts = 3.2*modelScale;
offsetPinHole = offsetCutOut+lCutOut+distBetweenCutOuts/2;

hPivotFiller = 2.9;
lPivotFiller = 8.4;
hPivotFiller2 = 4.025;
lPivotFiller2 = 1.015;

hPivot = 2*pitch*modelScale;
hPivot2 = 4.0*modelScale;
distPivotTop = 4.0*modelScale;
distPivotBottom = 8.143*modelScale;
offsetPivotCutOut = 4.4*modelScale;
hPivotCutOut = pitch*modelScale;
hPivotCutOut2 = 9.6*modelScale;

anglePivot = 15.5;


smallSize = 3*max(length,width);




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


module drawPinHoleBearing(prmWidth=width)
{
    translate([0,ph2,ph3]) rotate([-90,0,0])
    {
        ph = prmWidth - 2*ph2;
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


module drawPinHolePivot()
{
    translate([0,0,-eps]) cylinder(ph2+eps,pr3,pr3,$fn=100*modelScale);
    translate([0,0,ph2-eps]) cylinder(hPivot-2*ph2+2*eps,pr2,pr2,$fn=100*modelScale);
    translate([0,0,hPivot-ph2]) cylinder(ph2+eps,pr3,pr3,$fn=100*modelScale);

    hull()
    {
        translate([0,0,hPivot/2-hPivotCutOut2/2]) cylinder(hPivotCutOut2,pr3,pr3,$fn=100*modelScale);
        translate([-pr3,0,hPivot/2-hPivotCutOut2/2]) cube([2*pr3,smallSize,hPivotCutOut2]);
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


module drawPivot()
{
    difference()
    {
        union()
        {
            hull()
            {
                translate([distPivotBottom,width2/2,0]) cylinder(hPivot,width2/2,width2/2,$fn=250*modelScale);
                translate([distPivotBottom-distPivotTop,0,hPivot-eps]) cube([eps,width2,eps]);
                translate([0,0,hPivot2]) cube([eps,width2,eps]);
                cube([eps,width2,eps]);
            }
        }
        union()
        {
            translate([distPivotBottom,width2/2,0]) rotate([0,0,180]) drawPinHolePivot();
            translate([offsetPivotCutOut,-eps,(hPivot-hPivotCutOut)/2]) cube([distPivotBottom,width2+2*eps,hPivotCutOut]);
        }
    }
}


module drawPivotFiller()
{
    w = width2/5;
    difference()
    {
        union()
        {
            hull()
            {
                translate([0,0,-eps]) cube([2*eps,width2,h1+eps]);
                translate([lPivotFiller,0,-eps]) cube([2*eps,width2,hPivotFiller+h1+eps]);
            }
            translate([lPivotFiller,0,0]) hull()
            {
                translate([0,0,-eps]) cube([eps,width2,hPivotFiller+h1+eps]);
                translate([lPivotFiller2,0,-eps]) cube([eps,width2,hPivotFiller+hPivotFiller2+h1+eps]);
            }            
        }
        union()
        {
            translate([-smallSize/2,3*w,-smallSize/2]) cube([smallSize,w,smallSize]);
            translate([-smallSize/2,w,-smallSize/2]) cube([smallSize,w,smallSize]);
        }
    }
}


module drawPivotConnector()
{
    difference()
    {
        union()
        {
            translate([0,0,0]) cube([distTillSlope,width2,h1]);            
            translate([distTillSlope,0,0]) rotate([0,-anglePivot,0]) drawPivot();
            translate([offsetPinHole,0,0]) drawPivotFiller();
        }
        union()
        {
            translate([t1,t1,-eps]) cube([distTillSlope+eps,width2-2*t1,h2+eps]);
            translate([offsetCutOut,-eps,-eps]) cube([lCutOut,width2+2*eps,hCutOut+eps]);
            translate([offsetCutOut+lCutOut+distBetweenCutOuts,-eps,-eps]) cube([lCutOut,width2+2*eps,hCutOut+eps]);
            translate([offsetPinHole,0,0]) drawPinHole();
            rotateObject([-offsetPinHole,0,-ph3],[0,-anglePivot,0]) translate([offsetPinHole+pitch,0,0]) drawPinHole();
        }
    }
    translate([offsetPinHole,0,0]) drawPinHoleBearing(width2);       
    rotateObject([-offsetPinHole,0,-ph3],[0,-anglePivot,0]) translate([offsetPinHole+pitch,0,0]) drawPinHoleBearing(width2);
}


module drawMotorCyclePivot()
{
    difference()
    {
        union()
        {
            translate([0,-width/2,0]) drawHoledBrick();
            translate([length,-width2/2,0]) drawPivotConnector();
        }
        union()
        {
        }
    }    
}


// tests
//drawPinHole();
//drawDoublePinHole();
//drawFullPinHole();
//drawPinHoleBearing();
//drawHoledBrick();
//drawPinHolePivot();
//drawPivot();
//drawPivotFiller();
//drawPivotConnector();


// parts
drawMotorCyclePivot();

