function isTransparent(prmColor) = (prmColor[0]=="_" || prmColor[0]=="+") ? true : false;
function getTransparency(prmColor) = prmColor[0]=="_" ? 0.5 : prmColor[0]=="+" ? 0.75 : 1.0;
function removeTranparencyChar(prmColor) = isTransparent(prmColor) ? chr([for(i=[1:len(prmColor)-1]) ord(prmColor[i])]) : prmColor;


module colorEx(prmColor) 
{       
    color(removeTranparencyChar(prmColor),getTransparency(prmColor)) 
    { 
        children(); 
    }
}    


module importEx(prmFSpec)
{
    //echo(prmFSpec);
    echo(str("copy /y ..\\Lego_Lib\\", prmFSpec, " \"c:\\temp\\lego_export\""));
    import(prmFSpec);
}


module drawExternalPinSolid()
{
	translate([0,0,-eps]) cylinder(hExternalPin+eps,roExternalPin,roExternalPin,$fn=100);
}


module drawExternalPinHollow()
{
	translate([0,0,-eps]) 
    {
        difference()
        {
            cylinder(hExternalPin+eps,roExternalPin,roExternalPin,$fn=100);
            cylinder(hExternalPin+2*eps,riExternalPin,riExternalPin,$fn=100);
        }
    }
}


module drawExternalPin(prmIsHollow=false)
{
	if (prmIsHollow)
    {
        drawExternalPinHollow();        
    }
    else
    {
        drawExternalPinSolid();
    }
}


module drawInternalPin(prmInnerHeight)
{
	difference()
	{
		translate([0,0,0]) cylinder(prmInnerHeight+eps,roInternalPin,roInternalPin,$fn=100);
		translate([0,0,-eps]) cylinder(prmInnerHeight+2*eps,riInternalPin,riInternalPin,$fn=100);
	}
}


module drawInternalPinSmall(prmInnerHeight)
{
	cylinder(prmInnerHeight+eps,roInternalPinSmall,roInternalPinSmall,$fn=100);
}


module drawPinHoleEx()
{
	rotate([-90,0,0])
	{
		translate([0,0,-eps]) cylinder(h2PinHole+eps,r2PinHole,r2PinHole,$fn=100);
		translate([0,0,h2PinHole-eps]) cylinder(h1PinHole-2*h2PinHole+2*eps,r1PinHole,r1PinHole,$fn=100);
		translate([0,0,h1PinHole-h2PinHole]) cylinder(h2PinHole+eps,r2PinHole,r2PinHole,$fn=100);
	}
}


module drawPinHole(prmCenter=false)
{
	if (prmCenter)
    {
        translate([0,-h1PinHole/2,0]) drawPinHoleEx();
    }
    else
    {    
        drawPinHoleEx();
    }
}


module drawDoublePinHole()
{
    drawPinHole();
    translate([0,h1PinHole,0]) drawPinHole();
}


module drawFullPinHole(prmNrOfWidthUnits=1)
{
    width = getSize(prmNrOfWidthUnits);
    drawDoublePinHole();
    translate([0,width-2*h1PinHole,0]) drawDoublePinHole();
    translate([0,-eps,0]) rotate([-90,0,0]) cylinder(width+2*eps,r1PinHole,r1PinHole,$fn=100);
}


module drawPinHoleBearingEx(prmNrOfWidthUnits)
{
    width = getSize(prmNrOfWidthUnits);
    translate([0,h2PinHole,0]) rotate([-90,0,0])
    {
        ph = width - 2*h2PinHole;
        difference()
        {
            translate([0,0,-eps]) cylinder(ph+2*eps,r3PinHole,r3PinHole,$fn=100);
            translate([0,0,-2*eps]) cylinder(ph+4*eps,r1PinHole,r1PinHole,$fn=100);
        }
    }
}


module drawPinHoleBearing(prmCenter=false,prmNrOfWidthUnits=1)
{
	if (prmCenter)
    {
        translate([0,-h1PinHole/2,0]) drawPinHoleBearingEx(prmNrOfWidthUnits);
    }
    else
    {    
        drawPinHoleBearingEx(prmNrOfWidthUnits);
    }
}





