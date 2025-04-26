module drawRim_2695(prmColor)
{
    colorEx(prmColor) importEx("Rim_2695.stl");
}    


module drawTire_2696(prmColor)
{
    colorEx(prmColor) importEx("Tire_2696.stl");
}    


module drawWheel_2695_2696(prmColorRim,prmColorTire)
{
    drawRim_2695(prmColorRim);
    translate([0,0,tTire_2696/2]) drawTire_2696(prmColorTire);
}
