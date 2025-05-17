eps = 0.001;

modelScale = 1.0;


addScrewHole = false;
addRib = true;

rScrewHole = 3.0/2/2.5;
rScrewHead = 5.6/2/2.5;
rNut = 6.0/2/2.5;


// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 1;
correction_rPin1 = PRINTABLE ? -0.1 : 0.0;
correction_hPinInternal = PRINTABLE ? -0.1 : 0.0;


// mid
rMid = 5.9/2*modelScale;
hMid = 1.6*modelScale;
tScrewFlesh = 4.0*modelScale;


// pin
rPin1 = (4.8/2 + correction_rPin1)*modelScale;
rPin2 = 5.2/2*modelScale;
rPin3 = 3.2/2*modelScale;
hPin1 = 6.4*modelScale;
hPin2 = 0.8*modelScale;


// slot hole
wSlotHole = 0.8*modelScale;
offsetSlotHole = 3.0*modelScale;


// rib
rRib1 = 1.7/2*modelScale;
rRib2 = 2.4/2*modelScale;
distRibsY = 2.5;
lRib = hPin1+0.84;




module drawCone()
{
    hull()
    {
        translate([0,0,lRib-rRib1]) sphere(rRib1,$fn=100*modelScale);
        translate([0,0,-eps]) cylinder(eps,rRib2,rRib2,$fn=100*modelScale);
    }    
}    


module drawRib()
{
    hull()
    {
        translate([0,-distRibsY/2,0]) drawCone();
        translate([0,distRibsY/2,0]) drawCone();
    }
}    


module drawCamfer()
{
    drawCamferSingle();
    rotate([0,0,90]) drawCamferSingle();
    rotate([0,0,180]) drawCamferSingle();
    rotate([0,0,270]) drawCamferSingle();
}


module drawSlotHole()
{
    r = wSlotHole/2;
    h = hPin1+hPin2;
    hull()
    {
        translate([0,0,h-offsetSlotHole]) rotate([90,0,0]) cylinder(2*rPin2+2*eps,r,r,$fn=100*modelScale,true);
        translate([-r,-rPin2-eps,h]) cube([2*r,2*rPin2+2*eps,eps]);
    }
}    


module drawHollowCylinder(prmH,prmRi)
{
    smallSize = 3*prmH;
    difference()
    {
        union()
        {
            cylinder(smallSize,smallSize,smallSize,$fn=200*modelScale,true);                    
        }
        union()
        {        
            cylinder(smallSize+2*eps,rPin1,rPin1,$fn=200*modelScale,true);
        }
    }
}


module drawPinHalf(prmIsTop)
{
    smallSize = 3*rMid;
    difference()
	{
        union()
        {
            translate([0,0,hPin1-correction_hPinInternal/2]) cylinder(hPin2+correction_hPinInternal/2,rPin2,rPin2,$fn=200*modelScale);
            translate([0,0,-eps+correction_hPinInternal/2]) cylinder(hPin1-correction_hPinInternal+2*eps,rPin1,rPin1,$fn=200*modelScale);
        }
        union()
        {
            translate([0,0,-2*eps+correction_hPinInternal/2]) cylinder(hPin1+hPin2-correction_hPinInternal/2+4*eps,rPin3,rPin3,$fn=200*modelScale);
            drawSlotHole();
        }
    }
    
    if (addRib)
    {
        difference()
        {
            union()
            {
               translate([rPin3,0,correction_hPinInternal/2-eps]) drawRib();
               translate([-rPin3,0,correction_hPinInternal/2-eps]) drawRib();
            }
            union()
            {
                drawHollowCylinder(hPin1,rPin1);
                if (addScrewHole)
                {
                    fn = prmIsTop ? 6 : 100*modelScale;
                    r = prmIsTop ? rNut : rScrewHead;
                    translate([0,0,-3*eps+correction_hPinInternal/2]) cylinder(hPin1+hPin2-correction_hPinInternal/2+6*eps,r,r,$fn=fn);
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
            translate([0,0,hMid/2]) drawPinHalf(true);
            cylinder(hMid+correction_hPinInternal,rMid,rMid,$fn=200*modelScale,true);
            mirror([0,0,1]) translate([0,0,hMid/2]) drawPinHalf(false);
            if (addScrewHole)
            {
                cylinder(tScrewFlesh,rPin3+eps,rPin3+eps,$fn=100*modelScale,true);
            }
        }
        union()
        {
            if (addScrewHole)
            {
                cylinder(tScrewFlesh+2*eps,rScrewHole,rScrewHole,$fn=50*modelScale,true);
            }            
        }
    }    
}



// tests
//drawRib();
//drawSlotHole();
//drawHollowCylinder(hPin1,rPin1);
//drawPinHalf();


// parts
drawPin();


