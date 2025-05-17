bb_eps = 0.001;

function bb_toMM(prmInch) = 25.4*prmInch;
function bb_toInch(prmMM) = prmMM/25.4;



// types
bbCU123  =  0;
bbCU124  =  1;
bbCU234  =  2;
bbCU247  =  3;
bbCU347  =  4;
bbCustom =  bbCU347+1;


bb_A = [3.625,4.375,4.688,7.390,7.390];
bb_B = [1.500,2.375,3.688,4.703,4.703];
bb_C = [1.218,1.218,2.218,2.218,3.218];
bb_D = [1.062,1.062,2.062,2.062,3.062];
bb_E = [3.250,4.000,4.312,7.000,7.000];
bb_F = [1.125,2.000,3.312,4.312,4.312];
bb_G = [0.000,0.000,0.000,3.500,3.500];
bb_H = [0.062,0.062,0.094,0.094,0.094];
bb_J = [0.062,0.078,0.078,0.078,0.078];

bb_r = [0.125,0.125,0.125,0.125,0.125];
bb_d = [0.094,0.094,0.094,0.094,0.094];


// clearance
bb_clearanceLid = 0.5;

// ridge
bb_wRidge = 4.0;


// flat lid
bb_rScrewHoleFlatLid = 3.2/2;


// rounded lid
bb_rScrewHoleRoundedLid1 = 3.569;
bb_rScrewHoleRoundedLid2 = 1.829;
bb_lScrewHoleRoundedLid = 2.057;
bb_tRoundedLid = 6.0;


// knurl nuts
rKnurlNutHole = 4.0/2;
lKnurlNutHole = 5.0;




function getBudBox_A(prmType) = bb_toMM(bb_A[prmType]);
function getBudBox_B(prmType) = bb_toMM(bb_B[prmType]);
function getBudBox_C(prmType) = bb_toMM(bb_C[prmType]);
function getBudBox_D(prmType) = bb_toMM(bb_D[prmType]);
function getBudBox_E(prmType) = bb_toMM(bb_E[prmType]);
function getBudBox_F(prmType) = bb_toMM(bb_F[prmType]);
function getBudBox_G(prmType) = bb_toMM(bb_G[prmType]);
function getBudBox_H(prmType) = bb_toMM(bb_H[prmType]);
function getBudBox_J(prmType) = bb_toMM(bb_J[prmType]);
function getBudBox_r(prmType) = bb_toMM(bb_r[prmType]);
function getBudBox_d(prmType) = bb_toMM(bb_d[prmType]);

function getBudBox_rScrewHole() = 2.8/2;
function getBudBox_lScrewHole(prmD) = 0.5*prmD;
function getBudBox_rScrewHolder(prmA,prmE,prmH) = (prmA-prmE)/2-prmH/2;
function getBudBox_lScrewHolder(prmD,prmJ,prmd) = prmD-prmd-prmJ;

function getBudBox_extraD_front(prmr,prmAngle) = prmr*(1-cos(prmAngle))/cos(prmAngle);
function getBudBox_extraD_back(prmF,prmr,prmAngle) = prmF*tan(prmAngle)+prmr*(1-cos(prmAngle))/cos(prmAngle);

function bb_calc_custom_E(prmType, prmA) = prmA - (getBudBox_A(prmType)-getBudBox_E(prmType));
function bb_calc_custom_F(prmType, prmB) = prmB - (getBudBox_B(prmType)-getBudBox_F(prmType));

function bb_getType(prmType) = (prmType == bbCustom) ? bbCU123 : prmType;




module drawBudBoxScrewHolder(prmOffsetX,prmOffsetY,prmA,prmD,prmE,prmH,prmJ,prmr,prmd,prmExtraD,prmAddKnurlHoles)
{
    rScrewHole = getBudBox_rScrewHole();
    lScrewHole = getBudBox_lScrewHole(prmD);
    rScrewHolder = getBudBox_rScrewHolder(prmA,prmE,prmH);
    lScrewHolder = getBudBox_lScrewHolder(prmD,prmJ,prmd);

    difference()
    {
        union()
        {
            hull()
            {
                translate([0,0,lScrewHolder-bb_eps]) cylinder(bb_eps,rScrewHolder,rScrewHolder,$fn=100);
                translate([prmOffsetX,prmOffsetY,-prmExtraD+prmr]) sphere(prmr,$fn=100);
            }
        }
        union()
        {
            translate([0,0,lScrewHolder-lScrewHole]) cylinder(lScrewHole+bb_eps,rScrewHole,rScrewHole,$fn=100);
            if (prmAddKnurlHoles)
            {
                translate([0,0,lScrewHolder-lKnurlNutHole]) cylinder(lKnurlNutHole+eps,rKnurlNutHole,rKnurlNutHole,$fn=100);
            }            
        }
    }
}


module drawCustomBudBoxInternal(prmType,prmAddKnurlHoles,prmAngle,prmA=0,prmB=0,prmC=0,prmD=0,prmE=0,prmF=0,prmG=0,prmH=0,prmJ=0)
{
    type = bb_getType(prmType);

    A = (prmType == bbCustom) ? prmA : getBudBox_A(prmType);
    B = (prmType == bbCustom) ? prmB : getBudBox_B(prmType);
    C = (prmType == bbCustom) ? prmC : getBudBox_C(prmType);
    D = (prmType == bbCustom) ? prmD : getBudBox_D(prmType);
    E = (prmType == bbCustom) ? (prmE == -1) ? bb_calc_custom_E(type, A) : prmE : getBudBox_E(prmType);
    F = (prmType == bbCustom) ? (prmF == -1) ? bb_calc_custom_F(type, B) : prmF : getBudBox_F(prmType);
    G = (prmType == bbCustom) ? (prmG == -1) ? 0 : (prmG == -2) ? bb_calc_custom_E(type, A)/2 : prmG : getBudBox_G(prmType);
    H = (prmType == bbCustom) ? (prmH == -1) ? getBudBox_H(type) : prmH : getBudBox_H(prmType);
    J = (prmType == bbCustom) ? (prmJ == -1) ? getBudBox_J(type) : prmJ : getBudBox_J(prmType);
        
    r = getBudBox_r(type);
    d = getBudBox_d(type);
    ri = r-J;

    extraD_front = getBudBox_extraD_front(r,prmAngle);
    extraD_back = getBudBox_extraD_back(F,r,prmAngle);

    dxo = (A-2*r)/2;
    dyo = (B-2*r)/2;

    difference()
    {
        union()
        {
            hull()
            {            
                hull()
                {
                    translate([-dxo,-dyo,r-extraD_front]) sphere(r,$fn=100);
                    translate([dxo,-dyo,r-extraD_front]) sphere(r,$fn=100);
                    translate([-dxo,dyo,r-extraD_back]) sphere(r,$fn=100);
                    translate([dxo,dyo,r-extraD_back]) sphere(r,$fn=100);
                }                  
                hull()
                {
                    translate([-dxo,-dyo,D-bb_eps]) cylinder(bb_eps,r,r,$fn=100);
                    translate([dxo,-dyo,D-bb_eps]) cylinder(bb_eps,r,r,$fn=100);
                    translate([-dxo,dyo,D-bb_eps]) cylinder(bb_eps,r,r,$fn=100);
                    translate([dxo,dyo,D-bb_eps]) cylinder(bb_eps,r,r,$fn=100);
                }                
            }                        
        }
        union()
        {
            hull()
            {
                hull()
                {
                    translate([-dxo,-dyo,r-extraD_front]) sphere(ri,$fn=100);
                    translate([dxo,-dyo,r-extraD_front]) sphere(ri,$fn=100);
                    translate([-dxo,dyo,r-extraD_back]) sphere(ri,$fn=100);
                    translate([dxo,dyo,r-extraD_back]) sphere(ri,$fn=100);
                }
                hull()
                {
                    translate([-dxo,-dyo,D]) cylinder(bb_eps,ri,ri,$fn=100);
                    translate([dxo,-dyo,D]) cylinder(bb_eps,ri,ri,$fn=100);
                    translate([-dxo,dyo,D]) cylinder(bb_eps,ri,ri,$fn=100);
                    translate([dxo,dyo,D]) cylinder(bb_eps,ri,ri,$fn=100);
                }
            }     
        }        
    }
    
    offset = (B-F)/2-r;
    
    translate([-E/2,-F/2,J-bb_eps]) drawBudBoxScrewHolder(-offset,-offset,A,D,E,H,J,r,d,extraD_front,prmAddKnurlHoles);
    translate([E/2,-F/2,J-bb_eps]) drawBudBoxScrewHolder(offset,-offset,A,D,E,H,J,r,d,extraD_front,prmAddKnurlHoles);
    translate([-E/2,F/2,J-bb_eps]) drawBudBoxScrewHolder(-offset,offset,A,D,E,H,J,r,d,extraD_back,prmAddKnurlHoles);
    translate([E/2,F/2,J-bb_eps]) drawBudBoxScrewHolder(offset,offset,A,D,E,H,J,r,d,extraD_back,prmAddKnurlHoles);
    
    if (G > 0)
    {
        translate([-E/2+G,-F/2,J-bb_eps]) drawBudBoxScrewHolder(0,-offset,A,D,E,H,J,r,d,extraD_front,prmAddKnurlHoles);
        translate([-E/2+G,F/2,J-bb_eps]) drawBudBoxScrewHolder(0,offset,A,D,E,H,J,r,d,extraD_back,prmAddKnurlHoles);    
    }    
}


module drawCustomBudBox(prmAddKnurlHoles,prmA,prmB,prmC,prmD,prmE,prmF,prmG,prmH,prmJ,prmAngle=0.0)
{
    drawCustomBudBoxInternal(bbCustom,prmAddKnurlHoles,prmAngle,prmA,prmB,prmC,prmD,prmE,prmF,prmG,prmH,prmJ);
}


module drawBudBox(prmType,prmAddKnurlHoles,prmAngle=0.0)
{
    drawCustomBudBoxInternal(prmType,prmAddKnurlHoles,prmAngle);
}


module bb_drawBox(width,height,thickness,radiusCorner)
{
	translate([radiusCorner,radiusCorner,0]) minkowski()
	{
		cube([width-2*radiusCorner,height-2*radiusCorner,thickness/2]);
		cylinder(thickness/2,radiusCorner,radiusCorner, $fn=100);
	}
}


module drawBudBoxRidgeInternal(prmType,prmA=0,prmB=0,prmE=0,prmF=0,prmG=0,prmH=0,prmJ=0)
{
    type = bb_getType(prmType);

    A = (prmType == bbCustom) ? prmA : getBudBox_A(prmType);
    B = (prmType == bbCustom) ? prmB : getBudBox_B(prmType);
    E = (prmType == bbCustom) ? (prmE == -1) ? bb_calc_custom_E(type, A) : prmE : getBudBox_E(prmType);
    F = (prmType == bbCustom) ? (prmF == -1) ? bb_calc_custom_F(type, B) : prmF : getBudBox_F(prmType);
    G = (prmType == bbCustom) ? (prmG == -1) ? 0 : (prmG == -2) ? bb_calc_custom_E(type, A)/2 : prmG : getBudBox_G(prmType);
    H = (prmType == bbCustom) ? (prmH == -1) ? getBudBox_H(type) : prmH : getBudBox_H(prmType);
    J = (prmType == bbCustom) ? (prmJ == -1) ? getBudBox_J(type) : prmJ : getBudBox_J(prmType);
        
    r = getBudBox_r(type);
    d = getBudBox_d(type);

    wxo = A-2*H-2*bb_clearanceLid;
    wyo = B-2*H-2*bb_clearanceLid;
    wxi = wxo-2*bb_wRidge;
    wyi = wyo-2*bb_wRidge;
    r2 = r - bb_clearanceLid;
        
        
    difference()
    {
        union()
        {   
            translate([-wxo/2,-wyo/2,0]) bb_drawBox(wxo,wyo,d+bb_eps,r2);
        }
        union()
        {   
            difference()
            {
                union()
                {
                    translate([-wxi/2,-wyi/2,-bb_eps]) bb_drawBox(wxi,wyi,d+3*bb_eps,r);     
                }
                union()
                {
                    translate([-E/2,-F/2,-2*bb_eps]) cylinder(d+5*bb_eps,r,r,$fn=100);
                    translate([E/2,-F/2,-2*bb_eps]) cylinder(d+5*bb_eps,r,r,$fn=100);
                    translate([-E/2,F/2,-2*bb_eps]) cylinder(d+5*bb_eps,r,r,$fn=100);
                    translate([E/2,F/2,-2*bb_eps]) cylinder(d+5*bb_eps,r,r,$fn=100);
                    
                    if (G > 0)
                    {
                        translate([-E/2+G,-F/2,-2*bb_eps]) cylinder(d+5*bb_eps,r,r,$fn=100);
                        translate([-E/2+G,F/2,-2*bb_eps]) cylinder(d+5*bb_eps,r,r,$fn=100);                    
                    }
                }
            }
            translate([-E/2,-F/2,0]) drawBudBoxScrewHoleRoundedLid();
            translate([E/2,-F/2,0]) drawBudBoxScrewHoleRoundedLid();
            translate([-E/2,F/2,0]) drawBudBoxScrewHoleRoundedLid();
            translate([E/2,F/2,0]) drawBudBoxScrewHoleRoundedLid();   

            if (G > 0)
            {
                translate([-E/2+G,-F/2,0]) drawBudBoxScrewHoleRoundedLid();
                translate([-E/2+G,F/2,0]) drawBudBoxScrewHoleRoundedLid();
            }                                        
        }
    }
}


module drawCustomBudBoxRidge(prmA,prmB,prmE,prmF,prmG,prmH,prmJ)
{
    drawBudBoxRidgeInternal(bbCustom,prmA,prmB,prmE,prmF,prmG,prmH,prmJ);
}


module drawBudBoxRidge(prmType)
{
    drawBudBoxRidgeInternal(prmType);
}


module drawBudBoxHoleFlatLid(prmd)
{
    translate([0,0,-eps]) cylinder(prmd+2*bb_eps,bb_rScrewHoleFlatLid,bb_rScrewHoleFlatLid,$fn=100);
}    


module drawBudBoxFlatLidInternal(prmType,prmA=0,prmB=0,prmE=0,prmF=0,prmG=0,prmH=0,prmJ=0)
{
    type = bb_getType(prmType);

    A = (prmType == bbCustom) ? prmA : getBudBox_A(prmType);
    B = (prmType == bbCustom) ? prmB : getBudBox_B(prmType);
    E = (prmType == bbCustom) ? (prmE == -1) ? bb_calc_custom_E(type, A) : prmE : getBudBox_E(prmType);
    F = (prmType == bbCustom) ? (prmF == -1) ? bb_calc_custom_F(type, B) : prmF : getBudBox_F(prmType);
    G = (prmType == bbCustom) ? (prmG == -1) ? 0 : (prmG == -2) ? bb_calc_custom_E(type, A)/2 : prmG : getBudBox_G(prmType);
    H = (prmType == bbCustom) ? (prmH == -1) ? getBudBox_H(type) : prmH : getBudBox_H(prmType);
    J = (prmType == bbCustom) ? (prmJ == -1) ? getBudBox_J(type) : prmJ : getBudBox_J(prmType);
        
    r = getBudBox_r(type);
    d = getBudBox_d(type);

    dxi = (A-2*r)/2-H;
    dyi = (B-2*r)/2-H;
    r2 = r-bb_clearanceLid;
    
    difference()
    {
        union()
        {
            hull()
            {
                translate([-dxi,-dyi,0]) cylinder(d,r2,r2,$fn=100);
                translate([dxi,-dyi,0]) cylinder(d,r2,r2,$fn=100);
                translate([-dxi,dyi,0]) cylinder(d,r2,r2,$fn=100);
                translate([dxi,dyi,0]) cylinder(d,r2,r2,$fn=100);
            }
        }
        union()
        {
            translate([-E/2,-F/2,0]) drawBudBoxHoleFlatLid(d);
            translate([E/2,-F/2,0]) drawBudBoxHoleFlatLid(d);
            translate([-E/2,F/2,0]) drawBudBoxHoleFlatLid(d);
            translate([E/2,F/2,0]) drawBudBoxHoleFlatLid(d);
            
            if (G > 0)
            {
                translate([-E/2+G,-F/2,0]) drawHoleFlatLid(d);
                translate([-E/2+G,F/2,0]) drawHoleFlatLid(d);
            }                
        }
    }    
}


module drawCustomBudBoxFlatLid(prmA,prmB,prmE,prmF,prmG,prmH,prmJ)
{
    drawBudBoxFlatLidInternal(bbCustom,prmA,prmB,prmE,prmF,prmG,prmH,prmJ);
}


module drawBudBoxFlatLid(prmType)
{
    drawBudBoxFlatLidInternal(prmType);
}


module drawBudBoxScrewHoleRoundedLid()
{
    translate([0,0,bb_tRoundedLid-eps]) cylinder(2*bb_eps,bb_rScrewHoleRoundedLid1,bb_rScrewHoleRoundedLid1,$fn=100);
    translate([0,0,bb_tRoundedLid-bb_lScrewHoleRoundedLid]) cylinder(bb_lScrewHoleRoundedLid,bb_rScrewHoleRoundedLid2,bb_rScrewHoleRoundedLid1,$fn=100);
    translate([0,0,-bb_eps]) cylinder(bb_tRoundedLid+bb_eps,bb_rScrewHoleRoundedLid2,bb_rScrewHoleRoundedLid2,$fn=100,false);
}    


module drawBudBoxRoundedLidInternal(prmType,prmA=0,prmB=0,prmE=0,prmF=0,prmG=0,prmH=0,prmJ=0)
{
    type = bb_getType(prmType);

    A = (prmType == bbCustom) ? prmA : getBudBox_A(prmType);
    B = (prmType == bbCustom) ? prmB : getBudBox_B(prmType);
    E = (prmType == bbCustom) ? (prmE == -1) ? bb_calc_custom_E(type, A) : prmE : getBudBox_E(prmType);
    F = (prmType == bbCustom) ? (prmF == -1) ? bb_calc_custom_F(type, B) : prmF : getBudBox_F(prmType);
    G = (prmType == bbCustom) ? (prmG == -1) ? 0 : (prmG == -2) ? bb_calc_custom_E(type, A)/2 : prmG : getBudBox_G(prmType);
    H = (prmType == bbCustom) ? (prmH == -1) ? getBudBox_H(type) : prmH : getBudBox_H(prmType);
    J = (prmType == bbCustom) ? (prmJ == -1) ? getBudBox_J(type) : prmJ : getBudBox_J(prmType);
        
    r = getBudBox_r(type);
    d = getBudBox_d(type);

    smallSize = A+2*eps;
    dxo = (A-2*r)/2;
    dyo = (B-2*r)/2;    
    r2 = (A-E)/2;
    
    difference()
    {
        union()
        {
            hull()
            {
                hull()
                {
                    translate([-dxo,-dyo,bb_tRoundedLid-r]) sphere(r,$fn=100);
                    translate([dxo,-dyo,bb_tRoundedLid-r]) sphere(r,$fn=100);
                    translate([-dxo,dyo,bb_tRoundedLid-r]) sphere(r,$fn=100);
                    translate([dxo,dyo,bb_tRoundedLid-r]) sphere(r,$fn=100);
                }
                hull()
                {
                    translate([-dxo,-dyo,0]) cylinder(bb_eps,r,r,$fn=100);
                    translate([dxo,-dyo,0]) cylinder(bb_eps,r,r,$fn=100);
                    translate([-dxo,dyo,0]) cylinder(bb_eps,r,r,$fn=100);
                    translate([dxo,dyo,0]) cylinder(bb_eps,r,r,$fn=100);
                }
            }            
            
            hull() 
            {
                translate([-dxo,-dyo,bb_tRoundedLid-r]) sphere(r,$fn=100);
                translate([-E/2,-F/2,0]) cylinder(bb_tRoundedLid,r2,r2,$fn=100);
            }
            hull() 
            {   
                translate([dxo,-dyo,bb_tRoundedLid-r]) sphere(r,$fn=100);         
                translate([E/2,-F/2,0]) cylinder(bb_tRoundedLid,r2,r2,$fn=100);
            }
            hull() 
            {   
                translate([-dxo,dyo,bb_tRoundedLid-r]) sphere(r,$fn=100);
                translate([-E/2,F/2,0]) cylinder(bb_tRoundedLid,r2,r2,$fn=100);
            }
            hull() 
            {
                translate([dxo,dyo,bb_tRoundedLid-r]) sphere(r,$fn=100);                
                translate([E/2,F/2,0]) cylinder(bb_tRoundedLid,r2,r2,$fn=100);
            }   

            if (G > 0)
            {
                hull() 
                {   
                    translate([0,-dyo,bb_tRoundedLid-r]) sphere(r,$fn=100);
                    translate([-E/2+G,-F/2,0]) cylinder(bb_tRoundedLid,r2,r2,$fn=100);
                }
                hull() 
                {   
                    translate([0,dyo,bb_tRoundedLid-r]) sphere(r,$fn=100);
                    translate([-E/2+G,F/2,0]) cylinder(bb_tRoundedLid,r2,r2,$fn=100);
                }                
            }
        }
        union()
        {
            translate([-smallSize/2,-smallSize/2,-smallSize+d]) cube([smallSize,smallSize,smallSize]);
            
            translate([-E/2,-F/2,0]) drawBudBoxScrewHoleRoundedLid();
            translate([E/2,-F/2,0]) drawBudBoxScrewHoleRoundedLid();
            translate([-E/2,F/2,0]) drawBudBoxScrewHoleRoundedLid();
            translate([E/2,F/2,0]) drawBudBoxScrewHoleRoundedLid();
            
            if (G > 0)
            {
                translate([-E/2+G,-F/2,0]) drawBudBoxScrewHoleRoundedLid();
                translate([-E/2+G,F/2,0]) drawBudBoxScrewHoleRoundedLid();
            }                            
        }
    }    
}


module drawCustomBudBoxRoundedLid(prmA,prmB,prmE,prmF,prmG,prmH,prmJ,prmAddRidge=false)
{
    type = bb_getType(bbCustom);
    offsetZ = prmAddRidge ? 0 : -getBudBox_d(type);
    
    translate([0,0,offsetZ]) drawBudBoxRoundedLidInternal(bbCustom,prmA,prmB,prmE,prmF,prmG,prmH,prmJ);
    if (prmAddRidge) drawBudBoxRidgeInternal(bbCustom,prmA,prmB,prmE,prmF,prmG,prmH,prmJ);
}


module drawBudBoxRoundedLid(prmType,prmAddRidge=false)
{
    type = bb_getType(prmType);
    offsetZ = prmAddRidge ? 0 : -getBudBox_d(type);

    translate([0,0,offsetZ]) drawBudBoxRoundedLidInternal(prmType);
    if (prmAddRidge) drawBudBoxRidgeInternal(prmType);
}

