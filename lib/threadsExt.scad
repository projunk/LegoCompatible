include <camphers.scad>


// round holes to standard metric drill sizes
function roundHoleDiameter(prmDiameter) = round(2*prmDiameter)/2;
function roundHoleRadius(prmRadius) = roundHoleDiameter(2*prmRadius)/2;
function getRadiusFromWidthSquareNut(prmWidth) = prmWidth/2*sqrt(2);
function getRadiusFromWidthHexNut(prmWidth) = prmWidth/2*(1/(2*sin(60))+1/tan(60));


// thread sizes
TS_M3 = 0;
TS_M4 = 1;
TS_M5 = 2;
TS_M6 = 3;
TS_M8 = 4;
TS_M10 = 5;
TS_M12 = 6;


// nut types
NT_SquareNut = 0;
NT_HexNut = 1;
NT_KnurlNut = 2;


// screw types
ST_HexSocketCap = 0;
ST_HexSocketLowCap = 1;
ST_HexHead = 2;
ST_ConeHead = 3;


// clearances
hClearanceNut = 0.5;
rClearanceNut = 0.1;
hClearanceWasher = 0.0;
rClearanceWasher = 0.0;
hClearanceScrewHead = 0.25;
rClearanceScrewHead = 0.20;
rClearanceScrewHole = 0.0;


// camphers
campherNut = 0.2;
campherWasher = 0.2;
campherScrewHead = 0.2;



// thread
pitchThread = [0.50,0.70,0.80,1.00,1.25,1.50,1.75];
diameterThread = [3.0,4.0,5.0,6.0,8.0,10.0,12.0];



// square nut
width_SquareNut = [6.6,7.4];
height_SquareNut = [1.7,1.7];

// hex nut
size_HexNut = [5.5,7.0,8.0,10.0,13.0,17.0,19.0];
height_HexNut = [2.4,3.1,3.9,5.1,6.3,7.8,9.8];

// knurl nut
diameter_KnurlNut = [3.9,4.4,5.8];
height_KnurlNut = [4.0,4.0,4.8];


// washer
diameterWasherInner = [3.2,4.3,5.3,6.4,8.4,10.5,13.0];
diameterWasherOuter = [7.0,9.0,10.0,12.0,16.0,20.0,24.0];
heightWasher = [0.5,0.8,1.0,1.6,1.6,2.0,2.5];


// hex socket cap screw
diameterScrewHead_HexSocketCap = [5.5,7.0,8.5,10.0,13.0,16.0,18.0];
heightScrewHead_HexSocketCap = [3.0,4.0,5.0,6.0,8.0,10.0,12.0];

// hex socket low cap screw
diameterScrewHead_HexSocketLowCap = [5.5,7.0,8.5,10.0,13.0,16.0];
heightScrewHead_HexSocketLowCap = [2.3,2.9,3.5,4.1,5.1,6.2];

// hex head screw
sizeScrewHead_HexHead = [5.5,7.0,8.0,10.0,13.0,17.0,19.0];
heightScrewHead_HexHead = [2.2,3.0,3.7,4.2,5.5,6.7,7.8];

// cone head screw
diameterScrewHead_ConeHead = [5.5,7.6,8.9,11.2,14.7,18.3];
heightScrewHead_ConeHead = [1.7,2.6,3.1,3.6,4.5,6.0];



module drawInnerThread(prmThreadSize,prmLengthThread)
{    
    if ($preview)
    {
        translate([0,0,-eps]) cylinder(prmLengthThread+2*eps,diameterThread[prmThreadSize]/2,diameterThread[prmThreadSize]/2,$fn=100);
    }
    else
    {
        translate([0,0,-eps]) metric_thread(diameter=diameterThread[prmThreadSize],pitch=pitchThread[prmThreadSize],length=prmLengthThread+2*eps,internal=true,leadin=3);        
    }
}


module drawOuterThread(prmThreadSize,prmLengthThread)
{    
    if ($preview)
    {
        translate([0,0,-eps]) cylinder(prmLengthThread+2*eps,diameterThread[prmThreadSize]/2,diameterThread[prmThreadSize]/2,$fn=100);
    }
    else
    {
        translate([0,0,-eps]) metric_thread(diameter=diameterThread[prmThreadSize],pitch=pitchThread[prmThreadSize],length=prmLengthThread+2*eps,internal=false,leadin=3);        
    }
}


function __getRoundNumber(prmRHole,prmRoundNumbers) = prmRoundNumbers ? roundHoleRadius(prmRHole) : prmRHole;

function getRScrewHoleMask(prmThreadSize,prmRoundNumbers=true) = __getRoundNumber(diameterThread[prmThreadSize]/2+rClearanceScrewHole,prmRoundNumbers);

function getRNut(prmNutType,prmThreadSize) = (prmNutType == NT_SquareNut) ? getRadiusFromWidthSquareNut(width_SquareNut[prmThreadSize]) : (prmNutType == NT_HexNut) ? getRadiusFromWidthHexNut(size_HexNut[prmThreadSize]) : (prmNutType == NT_KnurlNut) ? diameter_KnurlNut[prmThreadSize]/2 : 0.0;
function getHNut(prmNutType,prmThreadSize) = (prmNutType == NT_SquareNut) ? height_SquareNut[prmThreadSize] : (prmNutType == NT_HexNut) ? height_HexNut[prmThreadSize] : (prmNutType == NT_KnurlNut) ? height_KnurlNut[prmThreadSize] : 0.0;

function getRNutMask(prmNutType,prmThreadSize) = getRNut(prmNutType,prmThreadSize)+rClearanceNut;
function getHNutMask(prmNutType,prmThreadSize) = getHNut(prmNutType,prmThreadSize)+hClearanceNut+eps;


module drawNutMask(prmNutType,prmThreadSize)
{
    r = getRNutMask(prmNutType,prmThreadSize);
    h = getHNutMask(prmNutType,prmThreadSize);
    
    if (prmNutType == NT_SquareNut)
    {
        translate([0,0,-eps]) rotate([0,0,45]) cylinder(h,r,r,$fn=4);
    }
    if (prmNutType == NT_HexNut)
    {
        translate([0,0,-eps]) cylinder(h,r,r,$fn=6);
    }
    if (prmNutType == NT_KnurlNut)
    {
        translate([0,0,h]) mirror([0,0,1]) drawCampheredCylinderBlindHole(h,r,campherNut);
    }    
}


module drawNut(prmNutType,prmThreadSize)
{
    r = getRNut(prmNutType,prmThreadSize);
    h = getHNut(prmNutType,prmThreadSize);
    
    difference()
    {
        union()
        {
            if (prmNutType == NT_SquareNut)
            {
                rotate([0,0,45]) drawCampheredCylinder(h,r,campherNut,4);
            }
            if (prmNutType == NT_HexNut)
            {
                drawCampheredCylinder(h,r,campherNut,6);
            }
            if (prmNutType == NT_KnurlNut)
            {
                drawCampheredCylinder(h,r,campherNut);
            }    
        }
        union()
        {
            drawInnerThread(prmThreadSize,h);
        }
    }
}


function getRWasherInner(prmThreadSize) = diameterWasherInner[prmThreadSize]/2;
function getRWasherOuter(prmThreadSize) = diameterWasherOuter[prmThreadSize]/2;
function getHWasher(prmThreadSize) = heightWasher[prmThreadSize];

function getRWasherInnerMask(prmThreadSize,prmRoundNumbers=true) = __getRoundNumber(getRWasherInner(prmThreadSize)+rClearanceWasher,prmRoundNumbers);
function getRWasherOuterMask(prmThreadSize,prmRoundNumbers=true) = __getRoundNumber(getRWasherOuter(prmThreadSize)+rClearanceWasher,prmRoundNumbers);
function getHWasherMask(prmThreadSize) = getHWasher(prmThreadSize)+hClearanceWasher;


module drawWasherMask(prmThreadSize,prmRoundNumbers=true)
{
    r = getRWasherOuterMask(prmThreadSize,prmRoundNumbers);
    h = getHWasherMask(prmThreadSize);
    echo("drawWasherMask:r",r);
    echo("drawWasherMask:h",h);
    translate([0,0,h]) mirror([0,0,1]) drawCampheredCylinderBlindHole(h,r,campherWasher);
}


module drawWasher(prmThreadSize)
{
    ri = getRWasherInner(prmThreadSize);
    ro = getRWasherOuter(prmThreadSize);
    h = getHWasher(prmThreadSize);
    drawCampheredHollowCylinder(h,ro,ri,campherWasher);
}


function getRScrewHead(prmScrewType,prmThreadSize) = (prmScrewType == ST_HexSocketCap) ? diameterScrewHead_HexSocketCap[prmThreadSize]/2 : (prmScrewType == ST_HexSocketLowCap) ? diameterScrewHead_HexSocketLowCap[prmThreadSize]/2 : (prmScrewType == ST_HexHead) ? getRadiusFromWidthHexNut(sizeScrewHead_HexHead[prmThreadSize]) : (prmScrewType == ST_ConeHead) ? diameterScrewHead_ConeHead[prmThreadSize]/2 : 0.0;
function getHScrewHead(prmScrewType,prmThreadSize) = (prmScrewType == ST_HexSocketCap) ? heightScrewHead_HexSocketCap[prmThreadSize] : (prmScrewType == ST_HexSocketLowCap) ? heightScrewHead_HexSocketLowCap[prmThreadSize] : (prmScrewType == ST_HexHead) ? heightScrewHead_HexHead[prmThreadSize] : (prmScrewType == ST_ConeHead) ? heightScrewHead_ConeHead[prmThreadSize] : 0.0;

function getRScrewHeadMask(prmScrewType,prmThreadSize,prmRoundNumbers=true) = __getRoundNumber(getRScrewHead(prmScrewType,prmThreadSize)+rClearanceScrewHead,prmRoundNumbers);
function getHScrewHeadMask(prmScrewType,prmThreadSize) = getHScrewHead(prmScrewType,prmThreadSize)+hClearanceScrewHead+eps;


module drawScrewHeadMask(prmScrewType,prmThreadSize,prmAddWasher=false,prmRoundNumbers=true)
{
    rScrewHead = getRScrewHeadMask(prmScrewType,prmThreadSize,prmRoundNumbers);
    rWasher = prmAddWasher ? getRWasherOuterMask(prmThreadSize,prmRoundNumbers) : 0.0;
    rScrewHole = getRScrewHoleMask(prmThreadSize,prmRoundNumbers);
    r = max(rScrewHead,rWasher);
    h = getHScrewHeadMask(prmScrewType,prmThreadSize);
    echo("drawScrewHeadMask:r",r);
    echo("drawScrewHeadMask:h",h);
    if (prmScrewType == ST_ConeHead)
    {
        translate([0,0,-eps]) cylinder(h+eps,rScrewHead,rScrewHole,$fn=250);
    }
    else
    {
        translate([0,0,h]) mirror([0,0,1]) drawCampheredCylinderBlindHole(h,r,campherScrewHead);
    }
}


module drawScrewMask(prmScrewType,prmThreadSize,prmLength,prmRoundNumbers=true)
{
    drawScrewHeadMask(prmScrewType,prmThreadSize,false,prmRoundNumbers);
    r = getRScrewHoleMask(prmThreadSize,prmRoundNumbers);
    translate([0,0,-eps]) cylinder(prmLength+2*eps,r,r,$fn=100);
}


module drawScrewNutAssemblyMask(prmScrewType,prmNutType,prmThreadSize,prmLength,prmAddWasher=false,prmRoundNumbers=true)
{
    drawScrewHeadMask(prmScrewType,prmThreadSize,prmAddWasher,prmRoundNumbers);
    r = getRScrewHoleMask(prmThreadSize,prmRoundNumbers);
    echo("drawScrewNutAssemblyMask:r",r);
    translate([0,0,-eps]) cylinder(prmLength+2*eps,r,r,$fn=100);
    translate([0,0,prmLength]) mirror([0,0,1]) drawNutMask(prmNutType,prmThreadSize);
}


module drawScrew(prmScrewType,prmThreadSize,prmLength)
{
    rScrewHead = getRScrewHead(prmScrewType,prmThreadSize);
    hScrewHead = getHScrewHead(prmScrewType,prmThreadSize);
    r = diameterThread[prmThreadSize]/2;
    if ((prmScrewType == ST_HexSocketCap) || (prmScrewType == ST_HexSocketLowCap))
    {
        drawCampheredCylinder(hScrewHead,rScrewHead,campherScrewHead);
    }
    if (prmScrewType == ST_HexHead)
    {
        drawCampheredCylinder(hScrewHead,rScrewHead,campherScrewHead,6);
    }
    if (prmScrewType == ST_ConeHead)
    {
        cylinder(hScrewHead,rScrewHead,r,$fn=250);
    }    
    translate([0,0,hScrewHead-eps]) drawOuterThread(prmThreadSize,prmLength);
}


module drawScrewHeadMaskHexHead(prmThreadSize,prmAddClearance=true)
{
    r = prmAddClearance ? getRScrewHeadMask(ST_HexHead,prmThreadSize,false) : getRScrewHead(ST_HexHead,prmThreadSize);
    h = prmAddClearance ? getHScrewHeadMask(ST_HexHead,prmThreadSize) : getHScrewHead(ST_HexHead,prmThreadSize);     
    translate([0,0,-eps]) cylinder(h+eps,r,r,$fn=6);
}


