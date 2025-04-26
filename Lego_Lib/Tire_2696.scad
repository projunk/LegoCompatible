eps = 0.001;


modelScale = 1.0;


ro1 = 21.6*modelScale;
ro2 = 19.2*modelScale;
ho1 = 12.8*modelScale;

ri1 = 15.2*modelScale;
ri2 = 13.6*modelScale;
ri3 = 12.0*modelScale;
ri4 = 12.8*modelScale;
ri5 = 15.2*modelScale;

hi1 = 6.4*modelScale;
hi2 = 1.6*modelScale;
hi3 = 4.0*modelScale;
hi4 = ho1-hi1-hi2-hi3;

n1 = 30;




module drawTireProfileMaskSingle()
{
    alfa = 360/n1;
    rotate_extrude(angle=alfa/2-2*eps,convexity=2,$fn=500*modelScale) translate([ro2,0,0]) square([ro1-ro2+eps,ho1/2+eps]);
}



module drawTireProfileMaskHalf()
{
    difference()
    {
        union()
        {
            for (s=[1:1:n1])
			{
				angle = (s-1)/n1 * 360;
                rotate([0,0,angle]) drawTireProfileMaskSingle();
            }
        }
        union()
        {
            cylinder(ho1+2*eps,ro2,ro2,$fn=500*modelScale,true);
        }
    }
}


module drawRimCutOuts()
{
    translate([0,0,hi1+hi2+hi3-eps]) cylinder(hi4+2*eps,ri4,ri5,$fn=500*modelScale);
    translate([0,0,hi1+hi2]) cylinder(hi3+eps,ri3,ri3,$fn=500*modelScale);
    translate([0,0,hi1]) cylinder(hi2+eps,ri1,ri2,$fn=500*modelScale);   
    translate([0,0,-eps]) cylinder(hi1+2*eps,ri1,ri1,$fn=500*modelScale);
}



module drawTire()
{
    difference()
    {
        union()
        {
            cylinder(ho1,ro1,ro1,$fn=500*modelScale,true);
        }
        union()
        {            
            drawTireProfileMaskHalf();
            rotate([0,0,360/(2*n1)]) mirror([0,0,1]) drawTireProfileMaskHalf();
            translate([0,0,-ho1/2]) drawRimCutOuts();
        }
    }
}


module drawTireHalf()
{
    difference()
    {   
        union()
        {    
            drawTire();
        }
        union()
        {
            smallSize = 5*ro1;
            translate([-smallSize/2,0,-smallSize/2]) cube([smallSize,smallSize,smallSize]);
        }
    }
}    


// tests
//drawTireProfileMaskSingle();
//drawTireProfileMaskHalf();
//drawRimCutOuts();
//drawTireHalf();


// parts
drawTire();

