module drawHingePlate2Fingers(prmColor)
{
    colorEx(prmColor) importEx("HingePlate2Fingers.stl");
}


module drawHingePlate3Fingers(prmColor)
{
    colorEx(prmColor) importEx("HingePlate3Fingers.stl");
}


module drawHingeFingersConnected(prmColor2Fingers,prmColor3Fingers,prmAngle)
{
    translate([getSize(2)+0.5*pitch,0,0])
    {
        rotateObject([0,0,-hPlate/2],[0,prmAngle,0]) drawHingePlate2Fingers(prmColor2Fingers);
        mirror([1,0,0]) drawHingePlate3Fingers(prmColor3Fingers);
    }
}


module drawHingeBrickBase(prmColor)
{
    colorEx(prmColor) importEx("HingeBrickBase.stl");
}    


module drawHingeBrickTopPlate(prmColor)
{
    colorEx(prmColor) importEx("HingeBrickTopPlate.stl");
}    


module drawHingeBrickConnected(prmColorBase,prmColorTopPlate,prmAngle)
{
    drawHingeBrickBase(prmColorBase);
    w = getSize(1);
    translate([0,0,offsetHingeBrickAxle+0.5*pitch]) rotateObject([0,-w/2,0.5*pitch],[prmAngle,0,0]) drawHingeBrickTopPlate(prmColorTopPlate);
}


module drawPlateWithClipOnTop(prmColor)
{
    colorEx(prmColor) importEx("PlateWithClipOnTop.stl");
}    


module drawPlateWithHole(prmColor)
{
    colorEx(prmColor) importEx("PlateWithHole.stl");
}


module drawPlateWithHole2(prmColor)
{
    colorEx(prmColor) importEx("PlateWithHole2.stl");
}


module drawPlateWithClipHorizontalOnEnd(prmColor)
{
    colorEx(prmColor) importEx("PlateWithClipHorizontalOnEnd.stl");
}


module drawPlateWithHandleOnSide(prmColor)
{
    colorEx(prmColor) importEx("PlateWithHandleOnSide.stl");
}


module drawPlateWithHandleOnEnd(prmColor)
{
    colorEx(prmColor) importEx("PlateWithHandleOnEnd.stl");
}


module drawPlateWithHandleType2()
{
    colorEx(prmColor) importEx("PlateWithHandleType2.stl");
}


module drawPlateWithClipsHorizontal(prmColor)
{
    colorEx(prmColor) importEx("PlateWithClipsHorizontal.stl");
}
