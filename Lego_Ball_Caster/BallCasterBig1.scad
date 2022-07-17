eps = 0.001;


Radius1 = 4.8 / 2;
Radius2 = 6.1 / 2;
Height = 7.8;
Depth = 0.8;
Width = 11.0;

ri3 = 54.0 / 2;
t = 2.0; 
t2 = 2.5;
offset = 8.0;
extra = 0.01;


module drawConnector()
{
	difference() 
    {
		union() 
        {
			cylinder(r=Width/2, h=Height,$fn=100);
		}
		union() 
        {
			cylinder(r=Radius2,h=Depth,$fn=100);
			translate([0,0,-eps]) cylinder(r=Radius1,h=Height+2*eps,$fn=100);
			translate([0,0,Height-Depth]) cylinder(r=Radius2,h=Depth+eps,$fn=100);
		}
	}
}

module drawBallCaster() 
{
	difference() 
    {
		union() 
        {
			translate([0,0,ri3+offset]) drawConnector();
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






