eps = 0.001;

modelScale = 1.0;



nr_length_units = 2;
addInnerWalls = true;


// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 0;
correction_t1 = PRINTABLE ? 0.05 : 0.0;



unit_size = 7.8*modelScale;
pitch = 8.0*modelScale;

h1 = 3.2*modelScale; // height
h2 = h1-1.0*modelScale; // inner height
h3 = 2.8*modelScale; // height
h4 = 1.6*modelScale;

// internal pin
r1 = 3.2/2*modelScale;


t1 = (1.5-correction_t1)*modelScale; // wall thickness
t2 = 1.2*modelScale; // inner wall thickness
tRidge = 0.8*modelScale;

function getSize(prmNrOfUnits) = prmNrOfUnits*unit_size + (prmNrOfUnits - 1) * (pitch - unit_size);


length = getSize(nr_length_units);
width = unit_size;
echo("length", length);
echo("width", width);

lengthStep1 = getSize(1);
lengthStep2 = length-lengthStep1-tRidge;

h_pin = 1.7*modelScale;
r_pin1 = 4.8/2*modelScale;


offsetClipX = 8.8*modelScale;
hClip = 4.0*modelScale;
wClip = 3.0*modelScale;
lClip = length-offsetClipX-tRidge;
rClip1 = 0.8*modelScale;
rClip2 = 0.612*modelScale;
rClip3 = 1.6*modelScale;
offsetRClip3Z = 2.4*modelScale;
xPosClip1 = 1.525*modelScale;
zPosClip1 = hClip;
xPosClip2 = 1.665*modelScale;
zPosClip2 = 3.012*modelScale;



module drawExternalPinSolid()
{
	cylinder(h_pin+eps,r_pin1,r_pin1,$fn=100*modelScale);
}


module drawInternalPin()
{
	cylinder(h2+eps,r1,r1,$fn=100*modelScale);
}


module drawInnerWallsX()
{
    if (nr_length_units > 1)
    {        
        for (x = [1:nr_length_units-1])
        {            
            translate([x*pitch-(pitch-unit_size)/2-t2/2,t1-eps,0]) cube([t2,width-2*t1+2*eps,h2+eps]);
        }
    }
}


module drawInternalPins()
{
	for (x = [1:nr_length_units-1])
    {
        translate([x*pitch-(pitch-unit_size)/2,width/2,0]) drawInternalPin();
	}
}


module drawClip()
{
    difference()
	{
		union()
		{
            hull()
            {
                translate([rClip1,0,hClip-rClip1]) rotate([-90,0,0]) cylinder(wClip,rClip1,rClip1,$fn=100*modelScale);
                translate([lClip-rClip1,0,hClip-rClip1]) rotate([-90,0,0]) cylinder(wClip,rClip1,rClip1,$fn=100*modelScale);
                translate([0,0,-eps]) cube([lClip,wClip,eps]);
            }
        }   
		union()
		{
            translate([lClip/2,-eps,offsetRClip3Z]) rotate([-90,0,0]) cylinder(wClip+2*eps,rClip3,rClip3,$fn=200*modelScale);
            
            hull()
            {
                translate([lClip/2,-eps,hClip]) rotate([-90,0,0]) cylinder(wClip+2*eps,rClip2,rClip2,$fn=200*modelScale);
                translate([lClip/2,-eps,rClip2]) rotate([-90,0,0]) cylinder(wClip+2*eps,rClip2,rClip2,$fn=200*modelScale);
            } 
 
            hull()
            {
                translate([xPosClip1,-eps,zPosClip1]) cube([lClip-2*xPosClip1,wClip+2*eps,eps]);
                translate([xPosClip2,-eps,zPosClip2-eps]) cube([lClip-2*xPosClip2,wClip+2*eps,eps]);
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
			cube([lengthStep1,width,h1]);
            translate([offsetClipX,width/2-wClip/2,h1-eps]) drawClip();
            translate([lengthStep1-eps,width/2-wClip/2,h3-eps]) cube([lengthStep2+eps,wClip,h1-h3+eps]);
            translate([lengthStep1-eps,0,0]) cube([lengthStep2+eps,width,h3]);
            translate([lengthStep1+lengthStep2-eps,0,0]) cube([tRidge+eps,width,h4]);
		}
		union()
		{	
			translate([t1,t1,-eps]) cube([length-2*t1,width-2*t1,h2+eps]);
		}
	}

    if (addInnerWalls)
    {
        drawInnerWallsX();
    }
	drawInternalPins();
    translate([unit_size/2,width/2,h1-eps]) drawExternalPinSolid();
}



// tests
//drawInnerWallsX();
//drawClip();

// parts
drawPlate();

