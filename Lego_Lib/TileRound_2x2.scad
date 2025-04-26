eps = 0.001;

modelScale = 1.0;


addInnerWalls = true;



pitch = 8.0*modelScale;


ho1 = 3.2*modelScale; // height
ho2 = 1.6*modelScale;
ro1 = 8.0*modelScale;
hi1 = 1.6*modelScale;
hi2 = 1.6*modelScale;
ri1 = 6.4*modelScale;
ri2 = 3.2*modelScale;
ri3 = 2.4*modelScale;



tInnerWall = 1.2*modelScale;
lInnerWall = 2*ri1;




module drawTile()
{
    difference()
	{
        union()
        {
            cylinder(ho1,ro1,ro1,$fn=250*modelScale);            
        }
        union()
        {
            translate([0,0,-eps]) cylinder(hi2+eps,ri3,ri3,$fn=100*modelScale);
            difference()
            {
                translate([0,0,-eps]) cylinder(hi1+eps,ri1,ri1,$fn=250*modelScale);
                translate([0,0,-2*eps]) cylinder(hi1+2*eps,ri2,ri2,$fn=100*modelScale);                
            }
            difference()
            {
                translate([-ri1,-ri1,-eps]) cube([2*ri1,2*ri1,ho2+eps]);
                translate([0,0,-2*eps]) cylinder(ho2+2*eps,ri2,ri2,$fn=100*modelScale);                
            }            
        }
    }
    
    if (addInnerWalls)
    {
        difference()
        {
            union()
            {        
                translate([-lInnerWall/2,-tInnerWall/2,0]) cube([lInnerWall,tInnerWall,hi1+eps]);
                translate([-tInnerWall/2,-lInnerWall/2,0]) cube([tInnerWall,lInnerWall,hi1+eps]);
            }
            union()
            {
                translate([0,0,-eps]) cylinder(hi1+3*eps,ri2,ri2,$fn=100*modelScale);
            }
        }
    }    
}



// test


// parts
drawTile();

