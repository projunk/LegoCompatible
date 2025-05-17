module rotateObject(prmOrigin=[0,0,0],prmAngle=[0,0,0])
{
    translate(-prmOrigin) rotate([prmAngle[0],0,0]) rotate([0,prmAngle[1],0]) rotate([0,0,prmAngle[2]]) translate(prmOrigin) 
    {
        children();
    }
}
