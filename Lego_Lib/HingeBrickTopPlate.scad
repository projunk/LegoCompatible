eps = 0.001;

modelScale = 1.0;



unit_size = 7.8*modelScale;
pitch = 8.0*modelScale;

nr_length_units = 2;
nr_width_units = 1;

clearance = 0.2*modelScale;

h1 = 0.8*modelScale;
h2 = 2.4*modelScale;
r1 = 1.6*modelScale;
r2 = 2.4*modelScale;
w1 = 1.6*modelScale;
w2 = 12.8*modelScale;
w3 = 1.6*modelScale;
t1 = 0.8*modelScale;
t2 = 1.6*modelScale;

length = nr_length_units*unit_size + (nr_length_units - 1) * (pitch - unit_size);
width = nr_width_units*unit_size + (nr_width_units - 1) * (pitch - unit_size);
echo("length", length);
echo("width", width);


h_pin = 1.7*modelScale;
r_pin1 = 4.8/2*modelScale;
r_pin2 = 3.2/2*modelScale;



module drawExternalPin()
{
    difference()
    {
        cylinder(h_pin+eps,r_pin1,r_pin1,$fn=100*modelScale);
        cylinder(h_pin+2*eps,r_pin2,r_pin2,$fn=100*modelScale);
    }
}



module drawHingeBrickTopPlate() 
{
	difference()
	{
		union()
		{	
            translate([unit_size/2,width/2,h1-eps]) drawExternalPin();
            translate([pitch+unit_size/2,width/2,h1-eps]) drawExternalPin();
			cube([length,width,h1]);
            hull()
            {
                translate([length/2,width/2,-pitch/2]) rotate([0,90,0]) cylinder(w2-2*clearance,r2-clearance,r2-clearance,$fn=250*modelScale,true);
                translate([length/2-w2/2+clearance,width/2-r2+clearance,eps]) cube([w2-2*clearance,2*r2-2*clearance,eps]);
            }
            translate([length/2+w2/2-clearance-eps,width/2,-pitch/2]) rotate([0,90,0]) cylinder(w1+eps,r1,r1,$fn=250*modelScale);
            translate([length/2-w2/2+clearance+eps,width/2,-pitch/2]) rotate([0,-90,0]) cylinder(w1+eps,r1,r1,$fn=250*modelScale);
		}
		union()
		{	
			mirror([0,0,1]) translate([length/2-w2/2+t1+clearance,-eps,0]) cube([w2-2*t1-2*clearance,width/2-t2/2+eps,pitch/2+r2]);
            mirror([0,0,1]) translate([length/2-w2/2+t1+clearance,width/2+t2/2,0]) cube([w2-2*t1-2*clearance,width/2-t2/2+eps,pitch/2+r2]);
            mirror([0,0,1]) translate([length/2-w3/2-clearance,width/2-t2/2-eps,h2-clearance]) cube([w3+2*clearance,t2+2*eps,pitch]);
		}
	}
}


module drawHingeBrickTopPlateHalf() 
{
	rotate([-90,0,0]) difference()
	{
		union()
		{	
            drawHingeBrickTopPlate();
 		}
		union()
		{	
            smallSize = 8*unit_size;
			translate([-smallSize/2,width/2,-smallSize/2]) cube([smallSize,smallSize,smallSize]);
 		}
	}
}



// parts
drawHingeBrickTopPlate();
//drawHingeBrickTopPlateHalf();

