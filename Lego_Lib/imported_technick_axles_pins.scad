module drawAxle2(prmColor, prmAddHole=false)
{
    colorEx(prmColor)
    if (prmAddHole) 
    {
        importEx("technic_axle_2_holed.stl");
    }
    else 
    {
        importEx("technic_axle_2.stl");
    }    
}


module drawAxle4(prmColor, prmAddHole=false)
{
    colorEx(prmColor)
    if (prmAddHole) 
    {
        importEx("technic_axle_4_holed.stl");
    }
    else 
    {
        importEx("technic_axle_4.stl");
    }    
}


module drawAxle6(prmColor, prmAddHole=false)
{
    colorEx(prmColor)
    if (prmAddHole) 
    {
        importEx("technic_axle_6_holed.stl");
    }
    else 
    {
        importEx("technic_axle_6.stl");
    }    
}


module drawAxle8(prmColor, prmAddHole=false)
{
    colorEx(prmColor)
    if (prmAddHole) 
    {
        importEx("technic_axle_8_holed.stl");
    }
    else 
    {
        importEx("technic_axle_8.stl");
    }    
}


module drawAxle10(prmColor, prmAddHole=false)
{
    colorEx(prmColor)
    if (prmAddHole) 
    {
        importEx("technic_axle_10_holed.stl");
    }
    else 
    {
        importEx("technic_axle_10.stl");
    }    
}


module drawAxle12(prmColor, prmAddHole=false)
{
    colorEx(prmColor)
    if (prmAddHole) 
    {
        importEx("technic_axle_12_holed.stl");
    }
    else 
    {
        importEx("technic_axle_12.stl");
    }    
    colorEx(prmColor) importEx("technic_axle_12.stl");
}


module drawPinHalfLength(prmColor)
{
    colorEx(prmColor) importEx("technic_pin_half_length.stl");
}    


module drawPinWithoutFriction(prmColor)
{
    colorEx(prmColor) importEx("technic_pin_without_friction.stl");
}    


module drawPinWithFriction(prmColor)
{
    colorEx(prmColor) importEx("technic_pin_with_friction.stl");
}    
