// 3D print overrides; e.g. if not corrected for ABS shrinkage, the radii of external(internal) pins will be too small and hence the fit will be too loose
// values are calibrated by printing these materials using shrinkageFactor_NONE. The external pin (of Brick) is measured after a scaled print by factor 2.5.
// the value should be 12mm.
// factor = 12/<actual measured value>
//
shrinkageFactor_NONE = 1.00; // no shrinkage
shrinkageFactor_PLA = 1.03;
shrinkageFactor_PETG = 1.03;
shrinkageFactor_ABS = 1.05;
shrinkageFactor = shrinkageFactor_NONE;



// generic
pitch = 8.0;
unit_size = 7.8;


// external pin
hExternalPin = 1.6;
roExternalPin = shrinkageFactor*4.8/2;
riExternalPin = 3.2/2;


// internal pins
roInternalPin = shrinkageFactor*6.4/2;
riInternalPin = 4.8/2;
roInternalPinSmall = shrinkageFactor*3.2/2;


// brick
hBrick = 9.6;
hInnerBrick = hBrick-1.0;


// plate
hPlate = 3.2;
hInnerPlate = hPlate-1.0;
hPlate2 = 1.6;
offsetPlate2 = 4.8;
hHingePlate = 0.8;


// wall thickness (bricks/plates/...)
tWall = 1.5;
tInnerWall = 1.6;


// axle
axleOffset = 5.6;
rAxleHole = 4.8/2;
rHingeBrickAxle = 3.2/2;
offsetHingeBrickAxle = pitch/2+rHingeBrickAxle;
offsetTechnicConnectorToggleJointToothedAxle = 3.6;


// pinhole
h1PinHole = unit_size;
h2PinHole = 0.8;
r1PinHole = 4.8/2;
r2PinHole = 6.2/2;
r3PinHole = 7.4/2; // bearing


// tire
tTire_2696 = 12.8;


// shock
shockAbsorberHoleDistance = 44.0;




function getLengthAxle(prmNrOfUnits) = prmNrOfUnits*pitch-0.5;
function getSize(prmNrOfUnits) = prmNrOfUnits*unit_size + (prmNrOfUnits - 1) * (pitch - unit_size);

