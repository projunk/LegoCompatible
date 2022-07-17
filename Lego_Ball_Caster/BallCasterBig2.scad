eps = 0.001;

NrOfHoles = 5;

Pitch = 8;
Radius1 = 4.8 / 2;
Radius2 = 6.1 / 2;
Height = 7.8;
Depth = 0.8;
Width = 7.5;
MidThickness = Height;

ri3 = 54.0 / 2;
t = 2.0; 
t2 = 2.5;
offset = 8.0;
extra = 0.01;


module drawConnector()
{
	Length = (NrOfHoles - 1) * Pitch;
	Thickness = (Width - 2 * Radius2) / 2;

	difference()
	{
		union()
		{		
			// support
			translate([-Width/2,-(ri3+offset+t),0]) cube([Length+Width,ri3+offset+t+Width/2,Height]);
			// beam
			cube([Length, Thickness, Height]);
			translate([0, Width-Thickness,0]) cube([Length, Thickness, Height]);
			translate([0, 0, Height/2-MidThickness/2]) cube([Length, Width, MidThickness]);
			for (i = [1:NrOfHoles])
			{
				if (i!=(NrOfHoles+1)/2)
				{
					translate([(i-1)*Pitch, Width/2,0]) 
					{
						cylinder(r=Width/2, h=Height,$fn=100);
					}
				}
			}
		}

		union()
		{
			for (i = [1:NrOfHoles])
			{
				if (i!=(NrOfHoles+1)/2)
				{
					translate([(i-1)*Pitch, Width/2,0]) 
					{
						translate([0,0,-eps]) cylinder(r=Radius2,h=Depth+eps,$fn=100);
						translate([0,0,-eps]) cylinder(r=Radius1,h=Height+2*eps,$fn=100);
						translate([0,0,Height-Depth]) cylinder(r=Radius2,h=Depth+eps,$fn=100);
					}
				}
			}

			translate([Length/2,Width,Height/2]) rotate([90,0,0])
            {
				translate([0,0,-extra]) cylinder(r=Radius2,h=Depth+extra,$fn=100);
				translate([0,0,-extra]) cylinder(r=Radius1,h=Width+2*extra,$fn=100);
				translate([0,0,Width-Depth]) cylinder(r=Radius2,h=Depth+extra,$fn=100);
			}
		}
	}
}

module drawBallCaster() 
{
	difference() 
    {
		union() 
        {
			translate([-(NrOfHoles - 1)*Pitch/2,Height/2,ri3+offset+t]) rotate([90,0,0]) drawConnector();
			translate([0,0,offset]) sphere(ri3+t,$fn=250);
		}
		union() 
        {
			translate([0,0,offset]) sphere(ri3,$fn=250);
			translate([0,0,-2*ri3]) cylinder(2*ri3, ri3+t+extra, ri3+t+extra,$fn=100);

			cylinder(r=Radius1,h=ri3+offset+t,$fn=100);

			rotate([0,0,45]) translate([-(ri3+t), -t2/2, -eps]) cube([2*(ri3+t),t2,offset+eps]);
			rotate([0,0,135]) translate([-(ri3+t), -t2/2, -eps]) cube([2*(ri3+t),t2,offset+eps]);
		}
	}
}



drawBallCaster();



