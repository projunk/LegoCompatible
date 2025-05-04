module drawShockAbsorberTop(prmColor)
{    
    colorEx(prmColor) importEx("technic_shock_absorber_top.stl");
}    


module drawShockAbsorberBottom(prmColor)
{
    colorEx(prmColor) importEx("technic_shock_absorber_bottom.stl");
}    


module drawShockAbsorberSpring(prmColor)
{
    colorEx(prmColor) importEx("technic_shock_absorber_spring.stl");
}    


module drawShockAbsorber(prmColorTop,prmColorBottom,prmColorSpring)
{
    rotate([0,0,90]) rotate([90,0,0]) 
    {
        drawShockAbsorberTop(prmColorTop);
        translate([0,-44,0]) drawShockAbsorberBottom(prmColorBottom);
        translate([0,-4,0]) rotate([90,0,0]) drawShockAbsorberSpring(prmColorSpring);
    }
}


module drawMotorCyclePivot(prmColor)
{
    colorEx(prmColor) importEx("MotorCyclePivot.stl");
}    


module drawDish(prmColor)
{
    colorEx(prmColor) importEx("Dish.stl");
}    
