eps = 0.001;

modelScale = 1.0;


addRib = true;


// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 1;
correction_roPinBottom1 = PRINTABLE ? -0.1 : 0.0;
correction_hPinInternal = PRINTABLE ? -0.1 : 0.0;



// pin
riPin = 1.6*modelScale;
hPinTop = 1.6*modelScale;
roPinTop = 2.4*modelScale;
roPinMid = 5.9/2*modelScale;
hPinMid = 0.8*modelScale;
roPinBottom1 = (2.4 + correction_roPinBottom1)*modelScale;
roPinBottom2 = 2.6*modelScale;
hPinBottom1 = 6.4*modelScale;
hPinBottom2 = 0.8*modelScale;


// slot hole
wSlotHole = 0.8*modelScale;
offsetSlotHole = 3.0*modelScale;


// rib
rRib1 = 1.2/2*modelScale;
rRib2 = 2.4/2*modelScale;
lRib = hPinBottom1;




module drawRib()
{
    hull()
    {        
        translate([0,0,hPinBottom2+lRib-eps]) cylinder(eps,rRib2,rRib2,$fn=50*modelScale);
        translate([0,0,hPinBottom2+rRib1]) sphere(rRib1,$fn=50*modelScale);
    }    
}    


module drawSlotHole()
{
    r = wSlotHole/2;
    h = hPinBottom1+hPinBottom2;
    hull()
    {
        translate([0,0,offsetSlotHole]) rotate([90,0,0]) cylinder(2*roPinBottom2+2*eps,r,r,$fn=100*modelScale,true);
        translate([-r,-roPinBottom2-eps,-eps]) cube([2*r,2*roPinBottom2+2*eps,eps]);
    }
}    


module drawPinBottom()
{
    difference()
	{
        union()
        {
            translate([0,0,hPinBottom2-eps+correction_hPinInternal/2]) cylinder(hPinBottom1-correction_hPinInternal+2*eps,roPinBottom1,roPinBottom1,$fn=200*modelScale);            
            cylinder(hPinBottom2+correction_hPinInternal/2,roPinBottom2,roPinBottom2,$fn=200*modelScale);
        }
        union()
        {
            drawSlotHole();
            translate([0,0,-eps]) cylinder(hPinBottom1+hPinBottom2-correction_hPinInternal/2+3*eps,riPin,riPin,$fn=200*modelScale);            
        }
    }
    
    if (addRib)
    {
        difference()
        {
            union()
            {
               translate([riPin,0,correction_hPinInternal/2-eps]) drawRib();
               translate([-riPin,0,correction_hPinInternal/2-eps]) drawRib();
            }
            union()
            {               
                difference()
                {
                    translate([0,0,hPinBottom2+correction_hPinInternal/2-3*eps]) cylinder(hPinBottom1-correction_hPinInternal+6*eps,roPinMid+eps,roPinMid+eps,$fn=200*modelScale);                    
                    translate([0,0,hPinBottom2+correction_hPinInternal/2-4*eps]) cylinder(hPinBottom1-correction_hPinInternal+8*eps,roPinBottom1,roPinBottom1,$fn=200*modelScale);
                }                
            }
        }
    }   
}


module drawPin()
{
    difference()
	{
        union()
        {
            translate([0,0,hPinBottom1+hPinBottom2+hPinMid-eps]) cylinder(hPinTop+eps,roPinTop,roPinTop,$fn=200*modelScale);
            translate([0,0,hPinBottom1+hPinBottom2-correction_hPinInternal/2]) cylinder(hPinMid+correction_hPinInternal/2,roPinMid,roPinMid,$fn=200*modelScale);            
        }
        union()
        {
            translate([0,0,hPinBottom1+hPinBottom2-eps]) cylinder(hPinMid+hPinTop+2*eps,riPin,riPin,$fn=200*modelScale);
        }
    }    
    drawPinBottom();
}



// tests
//drawSlotHole();
//drawPinBottom();


// parts
drawPin();


