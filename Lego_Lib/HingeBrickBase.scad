eps = 0.001;

modelScale = 1.0;



// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 1;
correction_hi1 = PRINTABLE ? 0.4 : 0.0;


unit_size = 7.8*modelScale;
pitch = 8.0*modelScale;

nr_length_units = 2;
nr_width_units = 1;
rHingeAxle = 3.2/2*modelScale;
offsetHingeAxle = pitch/2+rHingeAxle;
rFancy = 6.4/2*modelScale;

t1 = 1.6*modelScale;
t2 = 0.8*modelScale;
h1 = 1.6*modelScale; 
h2 = offsetHingeAxle+rFancy;
h3 = 2.4*modelScale;
hi1 = h1+correction_hi1; // inner height
clamping = 0.3*modelScale;

length = nr_length_units*unit_size + (nr_length_units - 1) * (pitch - unit_size);
width = nr_width_units*unit_size + (nr_width_units - 1) * (pitch - unit_size);
echo("length", length);
echo("width", width);



module drawHingeBrickBase() 
{
	difference()
	{
		union()
		{	
            hull()
            {
                translate([0,t2+rFancy,offsetHingeAxle]) rotate([0,90,0]) cylinder(length,rFancy,rFancy,$fn=100*modelScale);
                translate([0,t2,h1-eps]) cube([length,width-t2,eps]);
                translate([0,width-eps,h1-eps]) cube([length,eps,h2-h1+eps]);
            }
            
			cube([length,width,h1]);               
		}
		union()
		{	
            lx = (length-3*t1)/2;
			translate([t1,t1,-eps]) cube([lx,width-2*t1,hi1+eps]);
            translate([2*t1+lx,t1,-eps]) cube([lx,width-2*t1,hi1+eps]);
            translate([-eps,pitch/2,offsetHingeAxle]) rotate([0,90,0]) cylinder(length+2*eps,rHingeAxle,rHingeAxle,$fn=100*modelScale);        translate([-eps,pitch/2-rHingeAxle+clamping/2,offsetHingeAxle]) cube([length+2*eps,2*rHingeAxle-clamping,rFancy+eps]);    
            translate([t1,-eps,2*h1]) cube([length-2*t1,width-t1+eps,h2-2*h1+eps]);    
		}
	}
    
    hull()
    {
        translate([length/2-t1/2,width/2,2*h1+h3]) rotate([0,90,0]) cylinder(t1,t1/2,t1/2,$fn=100*modelScale);
        translate([length/2-t1/2,width/2-t1/2,2*h1-eps]) cube([t1,t1,eps]);
    }    
}


drawHingeBrickBase();
