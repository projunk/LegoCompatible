eps = 0.001;

modelScale = 1.0;

easyPrintable = true;



// printability corrections; values should be zero for real object dimensions 
PRINTABLE = 0;
correction_r1 = PRINTABLE ? 0.05 : 0.0;
correction_r2 = PRINTABLE ? 0.0 : 0.0;
correction_offset_r2 = PRINTABLE ? 0.10 : 0.0;


// bush
rb1 = 3.6*modelScale;
rb2 = 2.8*modelScale;
hb1 = 1.2*modelScale;
hb2 = 0.4*modelScale;
hb3 = 4.8*modelScale;
hb4 = 0.4*modelScale;
hb5 = 0.4*modelScale;
ri1 = 2.4*modelScale;
hi1 = 0.8*modelScale;


// horizontal bush
hb_rb1 = 3.6*modelScale;
hb_hb1 = 3.6*modelScale;
hb_ri1 = 3.2*modelScale;
hb_ri2 = 2.4*modelScale;
hb_hi1 = 0.8*modelScale;
hb_offset = 0.4*modelScale;


// tooth
nrOfTeeth = 16;
hTooth = 0.8*modelScale;
clearanceAngle = 0.5;
alfa = 360/(2*nrOfTeeth)+clearanceAngle;


hTotal = hb1+hb2+hb3+hb4+hb5+hTooth;
echo("hTotal",hTotal);


// axle hole
r1 = (4.8/2 + correction_r1)*modelScale;
r2 = (1.0/2 + correction_r2)*modelScale;
offset_r2 = (1.4 + correction_offset_r2)*modelScale;


// slot hole
wSlotHole = 0.8*modelScale;
lSlotHole = 4.0*modelScale;


// fancy
rFancy = 4.0/2*modelScale;
offsetRFancy = 0.8*rFancy;



module drawSlotHole()
{
    r = wSlotHole/2;
    d = lSlotHole-2*r;
    hull()
    {
        translate([0,0,hTotal/2+d/2]) rotate([90,0,0]) cylinder(2*rb1+2*eps,r,r,$fn=100*modelScale,true);
        translate([0,0,hTotal/2-d/2]) rotate([90,0,0]) cylinder(2*rb1+2*eps,r,r,$fn=100*modelScale,true);
    }
}    


module drawFancy()
{
    translate([rb1+offsetRFancy,0,h1-h2-eps]) cylinder(h2+2*eps,rFancy,rFancy,$fn=100*modelScale);
}    


module drawToothMaskSingle()
{
    rotate([0,0,-alfa/2]) rotate_extrude(angle=alfa,convexity=2,$fn=500*modelScale) square([rb1+eps,hTooth+eps]);
}


module drawToothMask()
{
    for (s=[1:1:nrOfTeeth])
    {
        angle = (s-1)/nrOfTeeth * 360;
        translate([0,0,hTotal-hTooth]) rotate([0,0,angle]) drawToothMaskSingle();
    }
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


module drawBush()
{
    difference()
	{
        union()
        {
            translate([0,0,hTotal-hTooth-eps]) cylinder(hTooth+eps,rb1,rb1,$fn=200*modelScale);
            translate([0,0,hb1+hb2+hb3+hb4-eps]) cylinder(hb5+eps,rb1,rb1,$fn=200*modelScale);
            translate([0,0,hb1+hb2+hb3]) cylinder(hb4,rb2,rb1,$fn=200*modelScale);
            translate([0,0,hb1+hb2-eps]) cylinder(hb3+2*eps,rb2,rb2,$fn=200*modelScale);
            translate([0,0,hb1]) cylinder(hb2,rb1,rb2,$fn=200*modelScale);
            cylinder(hb1+eps,rb1,rb1,$fn=200*modelScale);
        }
        union()
        {
            translate([0,0,hTotal-hi1]) cylinder(hi1+eps,ri1,ri1,$fn=200*modelScale);
            drawAxleHole(hTotal+2*eps);
            drawSlotHole();
            drawToothMask();
        }
    }
}


module drawHorizontalBush()
{
    angle = 0.5/nrOfTeeth * 360;
    difference()
	{
        union()
        {
            cylinder(hTooth+hb_hb1,hb_rb1,hb_rb1,$fn=200*modelScale);
        }
        union()
        {
            translate([0,0,hTotal]) mirror([0,0,1]) rotate([0,0,angle]) drawToothMask();
            translate([0,0,-eps]) cylinder(hTooth+hb_hb1+2*eps,hb_ri2,hb_ri2,$fn=200*modelScale);
            if (!easyPrintable)
            {            
                translate([0,0,hTooth+hb_hb1-hb_hi1]) cylinder(hb_hi1+eps,hb_ri1,hb_ri1,$fn=200*modelScale);
            }
        }
    }    
}    


module drawConnector()
{
    drawBush();
    translate([0,hb_offset,-hb_rb1]) rotate([90,0,0]) drawHorizontalBush();
    
    smallSize = 5*rb1;
   
    difference()
    {
        union()
        {
            translate([0,0,-hb_rb1]) cylinder(hb_rb1+eps,rb1,rb1,$fn=200*modelScale);
        }
        union()
        {
            translate([-smallSize/2,0,-smallSize/2]) cube([smallSize,smallSize,smallSize]);
            
            translate([0,hb_offset-hTooth,-hb_rb1]) rotate([-90,0,0]) cylinder(smallSize,hb_rb1,hb_rb1,$fn=200*modelScale);
           
            translate([0,0,-hb_rb1]) rotate([90,0,0]) cylinder(smallSize,hb_ri2,hb_ri2,$fn=200*modelScale,true);
            if (!easyPrintable)
            {
                translate([0,-hb_ri1,-hb_rb1]) rotate([90,0,0]) cylinder(smallSize,hb_ri1,hb_ri1,$fn=200*modelScale);
            }
            
        }
    }    
}


module drawConnectorTop()
{
    smallSize = 5*rb1;
    difference()
    {
        union()
        {
            drawConnector();
        }
        union()
        {
            translate([-smallSize/2,-smallSize/2,-smallSize]) cube([smallSize,smallSize,smallSize]);
            drawAxleHole(hTotal+2*eps);
        }
    }
}


module drawConnectorBottom()
{
    smallSize = 5*rb1;
    difference()
    {
        union()
        {
            drawConnector();
        }
        union()
        {
            translate([-smallSize/2,-smallSize/2,-eps]) cube([smallSize,smallSize,smallSize]);
        }         
    }
}


// tests
//drawToothMaskSingle();
//drawToothMask();
//drawBush();
//drawHorizontalBush();



// parts
drawConnector();

//drawConnectorTop();
//rotate([90,0,0]) drawConnectorBottom();



