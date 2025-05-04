eps = 0.001;

modelScale = 1.0;



// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 0;
correction_r1 = PRINTABLE ? 0.15 : 0.0;
correction_r2 = PRINTABLE ? -0.05 : 0.0;
correction_offset_r2 = PRINTABLE ? 0.10 : 0.0;


widthSupport = 0.55;
clearanceSupport = 0.2;


// bush
rb1 = 7.4/2*modelScale;
rb2 = 5.7/2*modelScale;
h1 = 8.0*modelScale;
h2 = 1.5*modelScale;
wSlotHole = 0.5*modelScale;
rFancy = 4.0/2*modelScale;
offsetRFancy = 0.8*rFancy;


// axle hole
r1 = (4.8/2 + correction_r1)*modelScale;
r2 = (1.0/2 + correction_r2)*modelScale;
offset_r2 = (1.4 + correction_offset_r2)*modelScale;


unit_size = 7.8*modelScale;

h_pin = 1.7*modelScale;
r_pin = 4.8/2*modelScale;


// pinhole
ph1 = unit_size;
ph2 = 0.7*modelScale;
ph3 = unit_size/2+ph1; // center hole offset
ph4 = ph3-h1+h2+eps;
pr2 = 4.8/2*modelScale;
pr3 = 5.6/2*modelScale;
pr4 = 7.4/2*modelScale; // bearing



module drawAxle4L()
{
    color("grey") import("technic_axle_4.stl");
}


module drawExternalPinSolid()
{
	translate([0,0,unit_size/2-eps]) cylinder(h_pin+eps,r_pin,r_pin,$fn=100*modelScale);
}


module drawPinHole()
{
	translate([0,-ph1/2,ph3]) rotate([-90,0,0])
	{
		translate([0,0,-eps]) cylinder(ph2+eps,pr3,pr3,$fn=100*modelScale);
		translate([0,0,ph2-eps]) cylinder(ph1-2*ph2+2*eps,pr2,pr2,$fn=100*modelScale);
		translate([0,0,ph1-ph2]) cylinder(ph2+eps,pr3,pr3,$fn=100*modelScale);
	}
}


module drawSlotHole()
{
    r = wSlotHole/2;
    hull()
    {
        translate([0,0,h2+r]) rotate([90,0,0]) cylinder(2*rb1+2*eps,r,r,$fn=100*modelScale,true);
        translate([0,0,h1-h2-r]) rotate([90,0,0]) cylinder(2*rb1+2*eps,r,r,$fn=100*modelScale,true);
    }
}    


module drawFancy()
{
    translate([rb1+offsetRFancy,0,-eps]) cylinder(h2+2*eps,rFancy,rFancy,$fn=100*modelScale);
}    


module drawAxleCutOut(prmLength)
{
    smallSize = 6*r2;   
    translate([-offset_r2,offset_r2,0]) hull()
    {
        translate([0,0,-2*eps]) cylinder(prmLength+4*eps,r2,r2,$fn=200*modelScale);
        translate([-smallSize,-r2,-2*eps]) cube([eps,2*r2,prmLength+4*eps]);
        translate([-r2,smallSize,-2*eps]) cube([2*r2,eps,prmLength+4*eps]);
    }
}    


module drawAxleHole(prmLength)
{	
    echo("prmLength",prmLength);
	difference()
	{
		union()
		{
			 translate([0,0,-eps]) cylinder(prmLength+2*eps,r1,r1,$fn=200*modelScale);
		}
		union()
		{
            drawAxleCutOut(prmLength);
            rotate([0,0,90]) drawAxleCutOut(prmLength);
            rotate([0,0,180]) drawAxleCutOut(prmLength);
            rotate([0,0,270]) drawAxleCutOut(prmLength);
		}
	}
}


module drawConnector()
{
    difference()
	{
        union()
        {
            translate([0,0,ph3]) rotate([90,0,0]) cylinder(ph1,unit_size/2,unit_size/2,$fn=100*modelScale,true);
            translate([-unit_size/2,-ph1/2,ph3-r_pin]) cube([unit_size,ph1,2*r_pin]);
            translate([0,0,ph3]) rotate([0,90,0]) drawExternalPinSolid();
            translate([0,0,ph3]) rotate([0,-90,0]) drawExternalPinSolid();
            
            translate([0,0,h1-h2]) cylinder(ph4,unit_size/2,unit_size/2,$fn=200*modelScale);
            translate([0,0,h2-eps]) cylinder(h1-2*h2+2*eps,rb2,rb2,$fn=200*modelScale);
            translate([0,0,0]) cylinder(h2,rb1,rb1,$fn=200*modelScale);
        }
        union()
        {
            drawPinHole();
            
            drawAxleHole(h1+2*eps);
            drawSlotHole();
            rotate([0,0,45]) drawFancy();
            rotate([0,0,135]) drawFancy();
            rotate([0,0,225]) drawFancy();
            rotate([0,0,315]) drawFancy();
        }
    }
}


module drawSupportPillar1()
{
    translate([unit_size/2-widthSupport,unit_size/2-widthSupport,0]) cube([widthSupport,widthSupport,ph3-r_pin-clearanceSupport]);
}    

module drawSupportPillar2()
{
    translate([unit_size/2+clearanceSupport,-widthSupport/2,0]) cube([widthSupport,widthSupport,ph1]);
}    



module drawSupport()
{   
    difference()
	{
        union()
        {
            translate([unit_size/2+clearanceSupport,-widthSupport/2,0]) cube([h_pin,widthSupport,ph3-r_pin-clearanceSupport]);
            hull()
            {
                translate([unit_size/2+clearanceSupport,0,ph3]) rotate([0,90,0]) cylinder(h_pin,r_pin+widthSupport,r_pin+widthSupport,$fn=100*modelScale);
                translate([unit_size/2+clearanceSupport,-widthSupport/2,ph1]) cube([h_pin,widthSupport,eps]);
            }
            
        }
        union()
        {
            translate([unit_size/2+clearanceSupport-eps,0,ph3]) rotate([0,90,0]) cylinder(h_pin+2*eps,r_pin+clearanceSupport,r_pin+clearanceSupport,$fn=100*modelScale); 
            wy = 2*(r_pin+widthSupport+eps);
            translate([unit_size/2+clearanceSupport-eps,-wy/2,ph3-0.8*r_pin]) cube([h_pin+2*eps,wy,wy]);
        }
    }
    
    hull()
    {
        drawSupportPillar1();
        drawSupportPillar2();
    }
    
    mirror([0,1,0]) hull()
    {    
        drawSupportPillar1();
        drawSupportPillar2();
    }      
}


module drawConnectorWithSupport()
{
    drawConnector();
    drawSupport();
    mirror([1,0,0]) drawSupport();
}


module drawAssembly()
{
    translate([0,0,-2]) drawAxle4L();    
    drawConnector();
}    



// tests
//drawPinHole();
//drawAssembly();


// parts
drawConnector();
//drawConnectorWithSupport();

