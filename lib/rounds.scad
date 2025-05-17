module drawRoundedPlate(prmLength,prmWidth,prmHeight,prmCornerRadius,prmFn=100)
{
    dx = prmLength-2*prmCornerRadius;
    dy = prmWidth-2*prmCornerRadius;
    hull()
    {
        translate([-dx/2,-dy/2,0]) cylinder(prmHeight,prmCornerRadius,prmCornerRadius,$fn=prmFn,true);
        translate([dx/2,-dy/2,0]) cylinder(prmHeight,prmCornerRadius,prmCornerRadius,$fn=prmFn,true);
        translate([-dx/2,dy/2,0]) cylinder(prmHeight,prmCornerRadius,prmCornerRadius,$fn=prmFn,true);
        translate([dx/2,dy/2,0]) cylinder(prmHeight,prmCornerRadius,prmCornerRadius,$fn=prmFn,true);
    }   
}


module drawRoundedHollowPlateEx(prmLength,prmWidth,prmHeight,prmCornerRadius,prmCornerInnerRadius,prmWallThickness,prmFn=100)
{
    li = prmLength-2*prmWallThickness;
    wi = prmWidth-2*prmWallThickness;
    difference()
    {
        union()
        {
            drawRoundedPlate(prmLength,prmWidth,prmHeight,prmCornerRadius,prmFn);
        }
        union()
        {
            drawRoundedPlate(li,wi,prmHeight+2*eps,prmCornerInnerRadius,prmFn);
        }        
    }
}


module drawRoundedHollowPlate(prmLength,prmWidth,prmHeight,prmCornerRadius,prmWallThickness,prmFn=100)
{
    ri = (prmCornerRadius>prmWallThickness) ? prmCornerRadius-prmWallThickness : 0.0;
    drawRoundedHollowPlateEx(prmLength,prmWidth,prmHeight,prmCornerRadius,ri,prmWallThickness,prmFn=100);
}


module drawRoundedBox(prmLength,prmWidth,prmHeight,prmCornerRadius,prmFn=100)
{
    dx = prmLength-2*prmCornerRadius;
    dy = prmWidth-2*prmCornerRadius;
    dz = prmHeight-2*prmCornerRadius;
    hull()
    {
        translate([-dx/2,-dy/2,-dz/2]) sphere(prmCornerRadius,$fn=prmFn);
        translate([dx/2,-dy/2,-dz/2]) sphere(prmCornerRadius,$fn=prmFn);
        translate([-dx/2,dy/2,-dz/2]) sphere(prmCornerRadius,$fn=prmFn);
        translate([dx/2,dy/2,-dz/2]) sphere(prmCornerRadius,$fn=prmFn);
        translate([-dx/2,-dy/2,dz/2]) sphere(prmCornerRadius,$fn=prmFn);
        translate([dx/2,-dy/2,dz/2]) sphere(prmCornerRadius,$fn=prmFn);
        translate([-dx/2,dy/2,dz/2]) sphere(prmCornerRadius,$fn=prmFn);
        translate([dx/2,dy/2,dz/2]) sphere(prmCornerRadius,$fn=prmFn);        
    }
}


module drawSymmetricalCutOffSphere(prmRO,prmHeight,prmFn=500)
{
    smallSize = 3*prmRO;
    difference()
    {
        union()
        {
            sphere(prmRO,$fn=prmFn);
        }
        union()
        {
            translate([-smallSize/2,-smallSize/2,prmHeight/2]) cube([smallSize,smallSize,smallSize]);
            mirror([0,0,1]) translate([-smallSize/2,-smallSize/2,prmHeight/2]) cube([smallSize,smallSize,smallSize]);
        }        
    }
}


module drawHollowSphere(prmRO,prmRI,prmFn=500)
{
    difference()
    {
        union()
        {
            sphere(prmRO,$fn=prmFn);
        }
        union()
        {
            sphere(prmRI,$fn=prmFn);
        }        
    }
}


module drawHollowCutOffSphere(prmRO,prmRI,prmCutOffHeight,prmFn=500)
{
    smallSize = 3*prmRO;
    difference()
    {
        union()
        {
            translate([0,0,-prmRO+prmCutOffHeight]) drawHollowSphere(prmRO,prmRI,prmFn);
        }
        union()
        {
            translate([-smallSize/2,-smallSize/2,-smallSize]) cube([smallSize,smallSize,smallSize]);
        }        
    }
}


module drawHollowSymmetricalCutOffSphere(prmRO,prmRI,prmHeight,prmFn=500)
{
    smallSize = 3*prmRO;
    difference()
    {
        union()
        {
            drawHollowSphere(prmRO,prmRI,prmFn);
        }
        union()
        {
            translate([-smallSize/2,-smallSize/2,prmHeight/2]) cube([smallSize,smallSize,smallSize]);
            mirror([0,0,1]) translate([-smallSize/2,-smallSize/2,prmHeight/2]) cube([smallSize,smallSize,smallSize]);
        }        
    }
}


