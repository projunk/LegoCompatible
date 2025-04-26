pitch = 8.0;
unit_size = 7.8;
axleOffset = 5.6;
tPlate = 3.2;
tPlate2 = 1.6;
offsetPlate2 = 4.8;
tHingePlate = 0.8;
tBrick = 9.6;
rAxleHole = 4.8/2;
rHingeBrickAxle = 3.2/2;
offsetHingeBrickAxle = pitch/2+rHingeBrickAxle;
offsetTechnicConnectorToggleJointToothedAxle = 3.6;

tTire_2696 = 12.8;

shockAbsorberHoleDistance = 44.0;




function getLengthAxle(prmNrOfUnits) = prmNrOfUnits*pitch-0.5;
function getSize(prmNrOfUnits) = prmNrOfUnits*unit_size + (prmNrOfUnits - 1) * (pitch - unit_size);

