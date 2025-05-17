eps = 0.001;


include <..\lib\transformers.scad>
include <..\Lego_Lib\utils.scad>
include <..\Lego_Lib\dimensions.scad>
include <..\Lego_Lib\colors.scad>
include <..\Lego_Lib\imported_plates.scad>
include <..\Lego_Lib\imported_tiles.scad>
include <..\Lego_Lib\imported_hinges.scad>
include <..\Lego_Lib\imported_sloped_bricks.scad>
include <..\Lego_Lib\imported_technick_bricks.scad>
include <..\Lego_Lib\imported_technick_plates.scad>
include <..\Lego_Lib\imported_technick_axles_pins.scad>
include <..\Lego_Lib\imported_technick_connectors_bushes.scad>
include <..\Lego_Lib\imported_technick_rims_tires.scad>
include <..\Lego_Lib\imported_technick_specials.scad>


// choices
USE_MD_CUSTOMIZATION = true;


// angles
shockAbsorberAngle = 160.5;
shockAbsorberAngle2 = 33.0;
standAngle = -30.0;
offsetSteering = 1.5*hBrick;
angleSteeringHandle = 30.0;
angleSteerColumn = 15.5;
angleSteer = 30.0;


// colors
FrontLightColor = USE_MD_CUSTOMIZATION ? TrMatWhite : White;
FrameColor = USE_MD_CUSTOMIZATION ? Blue : White;
FrameColorSlopedBrick1 = USE_MD_CUSTOMIZATION ? Black : White;
FrameColorSlopedBrick2 = USE_MD_CUSTOMIZATION ? Blue : Black;
TankColor = USE_MD_CUSTOMIZATION ? Red : White;
SpringArmColor = USE_MD_CUSTOMIZATION ? Blue : Black;



module drawRearWheelAssembly()
{
    // 6
    translate([0,-1.5*pitch,shockAbsorberHoleDistance]) rotate([0,0,90]) drawShockAbsorber(Black,OldGray,OldGray);
    translate([0,1.5*pitch,shockAbsorberHoleDistance]) rotate([0,0,90]) drawShockAbsorber(Black,OldGray,OldGray);    
       
    // 7
    translate([0,0,shockAbsorberHoleDistance]) rotate([90,0,0]) translate([0,0,-0.5*getLengthAxle(6)]) drawAxle6(Black); 
    translate([0,-0.5*pitch,shockAbsorberHoleDistance]) rotate([90,0,0]) translate([0,0,-0.5*pitch]) drawBush(OldGray);   
    
    // 8
    translate([0,pitch,shockAbsorberHoleDistance]) rotate([90,0,0]) drawWheel_2695_2696(White,Black);
    
    // 9
    translate([0,-2*pitch,shockAbsorberHoleDistance]) rotate([0,shockAbsorberAngle2,0]) rotate([90,0,0]) translate([-pitch/2,-pitch/2,0]) drawTechnickPlateToothedEnd_1x6(SpringArmColor);
    mirror([0,1,0]) translate([0,-2*pitch,shockAbsorberHoleDistance]) rotate([0,shockAbsorberAngle2,0]) rotate([90,0,0]) translate([-pitch/2,-pitch/2,0]) drawTechnickPlateToothedEnd_1x6(SpringArmColor);
    
    // 10
    translate([0,-2.4*pitch,shockAbsorberHoleDistance]) rotate([90,0,0]) drawBushToothed(OldGray);
    mirror([0,1,0]) translate([0,-2.4*pitch,shockAbsorberHoleDistance]) rotate([90,0,0]) drawBushToothed(OldGray);    
}


module drawBikeStandAssembly()
{
    // 8
    translate([0,-2*pitch,0]) drawTechnickBrick_1x6(FrameColor);
    translate([0,pitch,0]) drawTechnickBrick_1x6(FrameColor);
    translate([pitch,0,axleOffset]) rotate([90,0,0]) translate([0,0,-0.5*getLengthAxle(6)]) drawAxle6(Black);
    
    // 9
    translate([2*pitch,-2*pitch,hBrick]) mirror([1,0,0]) drawHingeFingersConnected(Black,Black,standAngle);
    translate([2*pitch,pitch,hBrick]) mirror([1,0,0]) drawHingeFingersConnected(Black,Black,standAngle);
    
    // 10
    translate([pitch,-2.4*pitch,axleOffset]) rotate([90,0,0]) drawBushToothed(OldGray);
    mirror([0,1,0]) translate([pitch,-2.4*pitch,axleOffset]) rotate([90,0,0]) drawBushToothed(OldGray);
    translate([0,-2*pitch,hBrick]) rotateObject([0,0,-hPlate/2],[0,-standAngle,0]) translate([pitch-getSize(2),0,0]) rotate([0,0,90]) drawPlate_1x4(Black);
}


module drawFrontArmAssembly()
{
   // 11.7
   translate([0,0,1.5*unit_size]) mirror([0,0,1]) drawConnector(OldGray);
   translate([0,0,0.5*unit_size]) drawAxle8(Black);
   translate([0,0,1.5*unit_size+offsetSteering]) drawBush(OldGray);
   translate([0,0,1.5*unit_size+offsetSteering+pitch+2*hPlate+hBrick]) drawBush(OldGray);

   // 12
   translate([0,0,1.5*unit_size+offsetSteering+pitch+2*hPlate+hBrick+1.5*pitch]) drawSteerHandleAssembly();
}


module drawSteerHandleAssembly()
{
   // 11.7
   rotate([0,0,angleSteeringHandle]) 
   {
        rotate([90,0,0]) translate([0,0,offsetTechnicConnectorToggleJointToothedAxle]) drawConnectorToggleJointToothed(OldGray);
        translate([0,-0.5*pitch,0]) rotate([90,0,0]) drawAxle2(Black);
        translate([0,0,0.5*pitch]) mirror([0,0,1]) drawBushToothed(OldGray);        
   }
}


module drawFrontLight()
{
    if (USE_MD_CUSTOMIZATION)
    {
        translate([0,0,hPlate]) drawDish(FrontLightColor);
        drawPlateRoundWithAxleHole_2x2(Black);
    }    
    else
    {
        drawTileRound_2x2(FrontLightColor);
    }
}


module drawFrontSteeringAssembly()
{
    // 11.1
    translate([2*pitch,pitch,0]) rotate([0,0,180]) drawPlateWithHole(FrameColor);
    
    // 11.2
    translate([pitch,-pitch,hPlate]) rotate([0,0,90]) drawPlate_1x2(FrameColor);
    translate([2*pitch,-2*pitch,hPlate]) rotate([0,0,90]) drawTechnickPlateToothedEnd_1x4(Black);
    
    // 11.3
    translate([pitch,-pitch,2*hPlate]) rotate([0,0,90]) drawTechnickBrick_1x2(FrameColor);
    translate([2*pitch,-pitch,2*hPlate]) rotate([0,0,90]) drawTechnickBrick_1x2(Black);
    
    // 11.4
    translate([-hPlate2,2*pitch,2*hPlate+offsetPlate2]) rotate([0,0,-90]) drawPlateBracket_1x2_1x4(Black);
    translate([-hPlate2,-1.5*pitch,2*hPlate+offsetPlate2+0.5*pitch]) rotate([0,-90,0]) drawPlateRound(TrYellow);
    translate([-hPlate2,1.5*pitch,2*hPlate+offsetPlate2+0.5*pitch]) rotate([0,-90,0]) drawPlateRound(TrYellow);
    translate([-hPlate2,0,2*hPlate+offsetPlate2]) rotate([0,-90,0]) drawFrontLight();
    
    // 11.5
    translate([2*pitch,-2*pitch,2*hPlate+hBrick]) rotate([0,0,90]) drawTechnickPlateToothedEnd_1x4(Black);
    translate([2*pitch,pitch,3*hPlate+hBrick]) rotate([0,0,180]) drawPlateWithHole(FrameColor);
    
    // 11.6
    translate([2*pitch,pitch,4*hPlate+hBrick]) rotate([0,0,180]) drawSlopeBrick_2x2(FrameColor);
    
    // 11.7
    offsetZ = -1.5*unit_size-offsetSteering-pitch+hPlate;
    translate([1.5*pitch,0,offsetZ])
    {
        translate([0,-1.5*pitch,0]) drawFrontArmAssembly();
        mirror([0,1,0]) translate([0,-1.5*pitch,0]) drawFrontArmAssembly();
        translate([0,0,0]) rotate([90,0,0]) translate([0,0,-0.5*getLengthAxle(4)]) drawAxle4(Black); 
        translate([0,-0.5*pitch,0]) rotate([90,0,0]) translate([0,0,-0.5*pitch]) drawBush(OldGray);   
        translate([0,pitch,0]) rotate([90,0,0]) drawWheel_2695_2696(White,Black);        
    }
    translate([2.5*pitch,0,-0.5*pitch]) 
    {
        drawAxle4(Black);
        translate([0,0,3.3*pitch]) drawBushToothed(OldGray);
        translate([0,0,0.5*pitch])mirror([0,0,1]) drawBushToothed(OldGray);
    }
}


module drawBackAssembly()
{
    // 1
    translate([0,0,0]) drawPlate_2x3(OldGray);
    translate([2*pitch,0,hPlate]) rotate([0,0,90]) drawPlate_1x2(Black);
    translate([2*pitch,2*pitch,hPlate]) rotate([0,0,-90]) drawSlopeBrickInverted_2x3(FrameColorSlopedBrick1);
    
    // 2
    translate([2*pitch,0,2*hPlate]) rotate([0,0,90]) drawSlopeBrickInverted_2x3(FrameColorSlopedBrick2);
    translate([2*pitch,0,hPlate+hBrick]) drawPlate_2x6(Black);
    
    // 3
    translate([3*pitch,pitch,2*hPlate+hBrick]) mirror([1,0,0]) drawMotorCyclePivot(FrameColor);
    
    // 4
    translate([8*pitch,0,2*hPlate+hBrick]) rotate([0,0,90]) drawTechnickBrick_1x2(FrameColor);
    translate([3*pitch,0,2*hPlate+hBrick]) drawTechnickBrick_1x4(FrameColor);
    translate([3*pitch,pitch,2*hPlate+hBrick]) drawTechnickBrick_1x4(FrameColor);
    translate([2*pitch,0,2*hPlate+hBrick+axleOffset]) rotate([90,0,0]) drawPinWithoutFriction(OldGray);
    translate([5*pitch,0,2*hPlate+hBrick+axleOffset]) rotate([90,0,0]) drawPinWithoutFriction(OldGray);
    translate([2*pitch,2*pitch,2*hPlate+hBrick+axleOffset]) rotate([90,0,0]) drawPinWithoutFriction(OldGray);
    translate([5*pitch,2*pitch,2*hPlate+hBrick+axleOffset]) rotate([90,0,0]) drawPinWithoutFriction(OldGray); 
 
    // 5
    translate([0,0,2*hPlate+2*hBrick]) drawPlate_2x8(FrameColor);
    
    // 6
    translate([pitch,0,-hPlate]) drawPlate_2x2(Black);
    translate([5*pitch,pitch,2*hPlate+hBrick+axleOffset]) rotate([0,shockAbsorberAngle,0]) drawRearWheelAssembly();
    
    // 7
    translate([0,0,-2*hPlate]) drawPlate_2x3(OldGray);
    translate([2*pitch,pitch,-3*hPlate]) rotate([0,0,90]) drawPlateWithPinHoleBothSides_2x2(Black);
    
    // 8
    translate([2*pitch,0,2*hPlate+hBrick+axleOffset]) rotate([0,-90,0]) translate([-5*pitch,pitch,-axleOffset]) drawBikeStandAssembly();
        
    // 12
    translate([-pitch,0,3*hPlate+2*hBrick]) drawSlopeBrick_3x2(TankColor);
    translate([5*pitch,0,3*hPlate+2*hBrick]) drawPlate_2x2(Black);
    translate([8*pitch+hPlate2,-pitch,3*hPlate+hBrick+offsetPlate2]) rotate([0,0,90]) drawPlateBracket_1x2_1x4(Black);
    
    // 13
    translate([8*pitch+hPlate2,0,3*hPlate+hBrick+offsetPlate2+0.5*pitch]) 
    {
        translate([0,-0.5*pitch,0]) rotate([0,90,0]) drawPlateRound(TrYellow);
        translate([0,0,0.5*pitch]) rotate([0,90,0]) drawPlate_1x1(TrRed);
        translate([0,pitch,0.5*pitch]) rotate([0,90,0]) drawPlate_1x1(TrRed);
        translate([0,2.5*pitch,0]) rotate([0,90,0]) drawPlateRound(TrYellow);
    }
    translate([6*pitch,0,4*hPlate+2*hBrick]) drawPlate_2x2(Black);    
}


module drawAssembly()
{
    translate([0,-pitch,0]) drawBackAssembly();
    
    // 11
    translate([-1.9*pitch,0,3.2*pitch]) rotate([0,angleSteerColumn,0]) rotate([0,0,angleSteer]) translate([-2.5*pitch,0,-(2*hPlate+offsetPlate2)]) drawFrontSteeringAssembly();    
}


// tests
//drawHingeFingersConnected(Red,Black,00);
//drawHingeBrickConnected(Red,Black,30);
//drawRearWheelAssembly();
//drawBikeStandAssembly();
//drawBackAssembly();
//drawFrontArmAssembly();
drawFrontLight();
//drawSteerHandleAssembly();
//drawFrontSteeringAssembly();


// parts
//drawAssembly();
