eps = 0.001;


include <..\lib\rounds.scad>
include <..\lib\camphers.scad>
include <dimensions.scad>
include <utils.scad>



ro1 = pitch;
ro2 = 7.6;
ri = 6.5;
ho1 = 0.45;
ho2 = 0.45;

hSphere = 2.3;
tSphere = 1.5;
roSphere = (ro1*ro1+hSphere*hSphere)/(2*hSphere);
riSphere = roSphere-tSphere;

offsetPinRadial = ro1-roExternalPin;
offsetPinZ = 2.5;

nrOfPins = 4;



module drawDishEx()
{
    difference()
	{
        union()
        {
            drawHollowCutOffSphere(roSphere,riSphere,hSphere,250);
            translate([0,0,-ho1]) drawCampheredHollowCylinder(ho1+eps,ro1,ri,eps,250);
            translate([0,0,-ho1-ho2]) drawCampheredHollowCylinder(ho2+eps,ro2,ri,eps,250);  
            
            for (i = [0:nrOfPins-1]) 
            {
                angle = i/nrOfPins*360;
                rotate([0,0,angle]) translate([offsetPinRadial,0,-offsetPinZ]) drawCampheredHollowCylinder(hSphere+ho1+ho2,roExternalPin,riExternalPin,eps,100);
            }
        }
        union()
        {
            drawHollowCutOffSphere(roSphere+hSphere,roSphere,2*hSphere,250);
            
            for (i = [0:nrOfPins-1]) 
            {
                angle = i/nrOfPins*360+180/nrOfPins;
                rotate([0,0,angle]) translate([offsetPinRadial,0,-offsetPinZ-eps]) drawCampheredCylinder(offsetPinZ-ho2-ho1+eps,roExternalPin,eps,100);
            }            
        }
    }
}


module drawDish()
{
    translate([0,0,offsetPinZ]) drawDishEx();
}



// test
//drawHollowCutOffSphere(roSphere,riSphere,hSphere,250);
//drawDishEx();


// parts
drawDish();

