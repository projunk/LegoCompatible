
module drawCampheredCylinder(prmHeight,prmRadius,prmCampher,prmFn=500)
{
    hull()
    {
        translate([0,0,prmHeight-eps]) cylinder(eps,prmRadius-prmCampher,prmRadius-prmCampher,$fn=prmFn);
        translate([0,0,prmCampher]) cylinder(prmHeight-2*prmCampher,prmRadius,prmRadius,$fn=prmFn);
        translate([0,0,0]) cylinder(eps,prmRadius-prmCampher,prmRadius-prmCampher,$fn=prmFn);
    }
}


module drawCampheredCylinderHole(prmLHole,prmRHole,prmCampher,prmFn=500)
{    
    translate([0,0,-eps]) cylinder(prmCampher+eps,prmRHole+prmCampher,prmRHole,$fn=prmFn);
    translate([0,0,-eps]) cylinder(prmLHole+2*eps,prmRHole,prmRHole,$fn=prmFn);
    translate([0,0,prmLHole-prmCampher]) cylinder(prmCampher+eps,prmRHole,prmRHole+prmCampher,$fn=prmFn);
}


module drawCampheredCylinderBlindHole(prmLHole,prmRHole,prmCampher,prmFn=500)
{    
    hull()
    {
        cylinder(eps,prmRHole-prmCampher,prmRHole-prmCampher,$fn=prmFn);
        translate([0,0,prmCampher]) cylinder(prmLHole-prmCampher+eps,prmRHole,prmRHole,$fn=prmFn);
    }
    translate([0,0,prmLHole-prmCampher]) cylinder(prmCampher+eps,prmRHole,prmRHole+prmCampher,$fn=prmFn);
}


module drawCampheredHollowCylinder(prmHeight,prmROHole,prmRIHole,prmCampher,prmFn=500)
{    
    difference()
    {
        union()
        {
            drawCampheredCylinder(prmHeight,prmROHole,prmCampher,prmFn);
        }
        union()
        {
            drawCampheredCylinderHole(prmHeight,prmRIHole,prmCampher,prmFn);
        }        
    }
}


module drawCampheredHollowCylinderWithBottom(prmHeight,prmROHole,prmRIHole,prmCampher,prmTBottom=0,prmFn=500)
{    
    tBottom = (prmTBottom == 0) ? prmROHole-prmRIHole : prmTBottom;
    difference()
    {
        union()
        {
            drawCampheredCylinder(prmHeight,prmROHole,prmCampher,prmFn);
        }
        union()
        {
            translate([0,0,tBottom]) drawCampheredCylinderBlindHole(prmHeight-tBottom,prmRIHole,prmCampher,prmFn);
        }        
    }
}



module drawCampheredSlot(prmLHole,prmHeight,prmRadius,prmCampher,prmFn=500)
{
    dist = prmLHole-2*prmRadius;
    hull()
    {
        translate([dist/2,0,0]) drawCampheredCylinder(prmHeight,prmRadius,prmCampher,prmFn);
        translate([-dist/2,0,0]) drawCampheredCylinder(prmHeight,prmRadius,prmCampher,prmFn);
    }
}    


module drawCampheredSlotHole(prmLHole,prmHeight,prmRadius,prmCampher,prmFn=500)
{
    dist = prmLHole-2*prmRadius;
    hull()
    {
        translate([dist/2,0,prmHeight-prmCampher]) cylinder(prmCampher+eps,prmRadius,prmRadius+prmCampher,$fn=prmFn);    
        translate([-dist/2,0,prmHeight-prmCampher]) cylinder(prmCampher+eps,prmRadius,prmRadius+prmCampher,$fn=prmFn);    
    }
    hull()
    {
        translate([dist/2,0,prmCampher-eps]) cylinder(prmHeight-2*prmCampher+2*eps,prmRadius,prmRadius,$fn=prmFn);    
        translate([-dist/2,0,prmCampher-eps]) cylinder(prmHeight-2*prmCampher+2*eps,prmRadius,prmRadius,$fn=prmFn);    
    }
    
    hull()
    {
        translate([dist/2,0,-eps]) cylinder(prmCampher+eps,prmRadius+prmCampher,prmRadius,$fn=prmFn);
        translate([-dist/2,0,-eps]) cylinder(prmCampher+eps,prmRadius+prmCampher,prmRadius,$fn=prmFn);
    }
}


module drawCampheredBoxEx(prmLengthBottom,prmWidth,prmHeight,prmCampher,prmOffsetTopLeft=0,prmOffsetTopRight=0)
{
    hull()
    {
        // top
        translate([-prmLengthBottom/2+prmCampher+prmOffsetTopLeft,-prmWidth/2+prmCampher,prmHeight/2-eps]) cube([prmLengthBottom-2*prmCampher-prmOffsetTopLeft-prmOffsetTopRight,prmWidth-2*prmCampher,eps]);
                
        // bottom
        translate([-prmLengthBottom/2+prmCampher,-prmWidth/2+prmCampher,-prmHeight/2]) cube([prmLengthBottom-2*prmCampher,prmWidth-2*prmCampher,eps]);
                
        // front
        translate([-prmLengthBottom/2+prmCampher+prmOffsetTopLeft,-prmWidth/2,prmHeight/2-prmCampher-eps]) cube([prmLengthBottom-2*prmCampher-prmOffsetTopLeft-prmOffsetTopRight,eps,eps]);
        translate([-prmLengthBottom/2+prmCampher,-prmWidth/2,-prmHeight/2+prmCampher]) cube([prmLengthBottom-2*prmCampher,eps,eps]);

        // back
        translate([-prmLengthBottom/2+prmCampher+prmOffsetTopLeft,prmWidth/2-eps,prmHeight/2-prmCampher-eps]) cube([prmLengthBottom-2*prmCampher-prmOffsetTopLeft-prmOffsetTopRight,eps,eps]);
        translate([-prmLengthBottom/2+prmCampher,prmWidth/2-eps,-prmHeight/2+prmCampher]) cube([prmLengthBottom-2*prmCampher,eps,eps]);

        // left
        translate([-prmLengthBottom/2+prmOffsetTopLeft,-prmWidth/2+prmCampher,prmHeight/2-prmCampher-eps]) cube([eps,prmWidth-2*prmCampher,eps]);
        translate([-prmLengthBottom/2,-prmWidth/2+prmCampher,-prmHeight/2+prmCampher]) cube([eps,prmWidth-2*prmCampher,eps]);

        // right
        translate([prmLengthBottom/2-prmOffsetTopRight-eps,-prmWidth/2+prmCampher,prmHeight/2-prmCampher-eps]) cube([eps,prmWidth-2*prmCampher,eps]);
        translate([prmLengthBottom/2-eps,-prmWidth/2+prmCampher,-prmHeight/2+prmCampher]) cube([eps,prmWidth-2*prmCampher,eps]);
    }
}


module drawCampheredBox(prmLength,prmWidth,prmHeight,prmCampher)
{
    drawCampheredBoxEx(prmLength,prmWidth,prmHeight,prmCampher);
}


module drawCampheredBoxHole(prmLength,prmWidth,prmHeight,prmCampher)
{
    // top
    hull()
    {
        translate([-prmLength/2-prmCampher,-prmWidth/2-prmCampher,prmHeight/2]) cube([prmLength+2*prmCampher,prmWidth+2*prmCampher,eps]);
        translate([-prmLength/2,-prmWidth/2,prmHeight/2-prmCampher]) cube([prmLength,prmWidth,eps]);
    }
                
    // mid
    translate([-prmLength/2,-prmWidth/2,-prmHeight/2+prmCampher-eps]) cube([prmLength,prmWidth,prmHeight-2*prmCampher+2*eps]);
                
    // bottom
    hull()
    {
        translate([-prmLength/2,-prmWidth/2,-prmHeight/2+prmCampher]) cube([prmLength,prmWidth,eps]);
        translate([-prmLength/2-prmCampher,-prmWidth/2-prmCampher,-prmHeight/2-eps]) cube([prmLength+2*prmCampher,prmWidth+2*prmCampher,eps]);
    }
}


