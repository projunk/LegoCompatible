eps = 0.001;


include <..\lib\rounds.scad>
include <..\lib\camphers.scad>
include <dimensions.scad>
include <utils.scad>



ro1 = 21.6;
ro2 = 19.2;
ho1 = 12.8;

ri1 = 15.2;
ri2 = 13.6;
ri3 = 12.0;
ri4 = 12.8;
ri5 = 15.2;

hi1 = 6.4;
hi2 = 1.6;
hi3 = 4.0;
hi4 = ho1-hi1-hi2-hi3;

n1 = 30;


hSphere = ho1;
roSphere = (ro2*ro2+hSphere*hSphere)/(2*hSphere);




module drawTireProfileMaskSingle()
{
    alfa = 360/n1;
    rotate_extrude(angle=alfa/2-2*eps,convexity=2,$fn=500) translate([ro2,0,0]) square([ro1-ro2+eps,ho1/2+eps]);
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
            cylinder(ho1+2*eps,ro2,ro2,$fn=500,true);
        }
    }
}


module drawRimCutOuts()
{
    translate([0,0,hi1+hi2+hi3-eps]) cylinder(hi4+2*eps,ri4,ri5,$fn=500);
    translate([0,0,hi1+hi2]) cylinder(hi3+eps,ri3,ri3,$fn=500);
    translate([0,0,hi1]) cylinder(hi2+eps,ri1,ri2,$fn=500);   
    translate([0,0,-eps]) cylinder(hi1+2*eps,ri1,ri1,$fn=500);
}



module drawTire()
{
    difference()
    {
        union()
        {
            drawSymmetricalCutOffSphere(roSphere,hSphere,250);
        }
        union()
        {            
            drawTireProfileMaskHalf();
            rotate([0,0,360/(2*n1)]) mirror([0,0,1]) drawTireProfileMaskHalf();
            translate([0,0,-ho1/2]) drawRimCutOuts();
        }
    }
}



// tests
//drawSymmetricalCutOffSphere(roSphere2,hSphere,250);
//drawTireProfileMaskSingle();
//drawTireProfileMaskHalf();
//drawRimCutOuts();


// parts
drawTire();

