module drawSlopeBrick_1x2(prmColor)
{
    colorEx(prmColor) importEx("SlopeBrick_1x2.stl");
}    


module drawSlopeBrick_2x2(prmColor)
{
    colorEx(prmColor) importEx("SlopeBrick_2x2.stl");
}    


module drawSlopeBrick_2x4(prmColor)
{
    colorEx(prmColor) importEx("SlopeBrick_2x4.stl");
}    


module drawSlopeBrick_3x2(prmColor)
{
    colorEx(prmColor) importEx("SlopeBrick_3x2.stl");
}    


module drawSlopeBrick_3x4(prmColor)
{
    colorEx(prmColor) importEx("SlopeBrick_3x4.stl");
}    


module drawSlopeBrickInverted_1x2(prmColor, prmIsStrong=false)
{
    colorEx(prmColor) 
    if (prmIsStrong) 
    {
        importEx("SlopeBrickInverted_1x2_strong.stl");
    }
    else 
    {
        importEx("SlopeBrickInverted_1x2.stl");
    }
}    


module drawSlopeBrickInverted_2x2(prmColor, prmIsStrong=false)
{
    colorEx(prmColor) 
    if (prmIsStrong) 
    {
        importEx("SlopeBrickInverted_2x2_strong.stl");
    }
    else 
    {
        importEx("SlopeBrickInverted_2x2.stl");
    }
}    


module drawSlopeBrickInverted_2x3(prmColor, prmIsStrong=false)
{
    colorEx(prmColor) 
    if (prmIsStrong) 
    {
        importEx("SlopeBrickInverted_2x3_strong.stl");
    }
    else 
    {
        importEx("SlopeBrickInverted_2x3.stl");
    }
}    
