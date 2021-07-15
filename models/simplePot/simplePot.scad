// $fa = 36;
/* [General] */ 
shape = "rectangle"; // ["rectangle","circle","polygon"]
width = 70; // width | diameter
length = 120; 
height = 50;
sides = 6; // [3:36]
thickness= 4.8;
//0=auto
bottomThickness = 0;//[0.8:0.1:6.4] 
// Corner Radius
cornerRadius = 15;// [0:100]
// Use it with care, the end model could be malformed. Use: advanced-> slices, to smooth
twist = 0; //[0:360]


bThick = bottomThickness >= 1.2 ? bottomThickness : thickness >= 2.4 ? thickness/2: 1.2;
/* [Holes] */ 
holes= 4; //[0:8]
holeSize = 10;
onlyMarkHoles = false;
centerHole = false;
//if it's 0 uses holeSize
centerHoleSize = 0;

/* [Routing Template] */ 
rtOffset = 20;
rtHeight = 8;
rtBushSize = 1;
// 0 to use the same as pot
rtCornerRadius = 0; //[0:100]
rtShape = "sameAsPot"; // ["sameAsPot","rectangle","circle"]

/* [Leg] */ 
legHoleSize = 10;
legInsertion = 5;
legDiameter = 15;
legHeight = 6;


/* [Render] */ 
renderPot = true;
renderRoutingTemplate = false;
renderLeg = false;

/* [Advanced] */ 
resolution = 100; //[100-500];
slices = 100; //[0:500]
convexity = 10;
$fn=resolution;
cr = (width/2/101) * cornerRadius;
rtCr = rtCornerRadius > 0 ?(width/2/101) * rtCornerRadius :cr;


if(renderPot) renderPot();
if (renderRoutingTemplate) renderRoutingTemplate();
if(renderLeg) renderLeg();

module renderPot(){
if(holes > 0){
    difference(){
        pot(); 
        renderHoles();
        }  
}
else {
    pot();
}
}


module renderRoutingTemplate(){
    color("green") translate([width+rtOffset*3,0,0]) routingTemplate();
}


module renderLeg(){
translate([width/1.5,0,0]) leg();
}

module pot(){

difference(){
        linear_extrude(height+bThick, twist=twist, slices=slices, convexity = convexity)
            boxShape(width,length,cr);
        translate([0,0,bThick])    
            linear_extrude(height+bThick, twist=twist,slices=slices, convexity = convexity )
                boxShape(width - 2*thickness,length-2*thickness,cr);
        }
}

module renderHoles(){
    s = (shape=="rectangle") ? width < length ? width: length : width; 
    rot = (shape=="rectangle" && holes > 3) ? 45 :0;
    extrude = onlyMarkHoles ? 0.2 : 4 * bThick;
    l = s - holeSize * 2;
    union()
        translate([0,0,-extrude/2]) linear_extrude(extrude)
            union(){
            if(holes < 2 || centerHole){
               hs = (centerHoleSize) ? centerHoleSize : holeSize;
               if(onlyMarkHoles) holeMark(hs);
               else circle(d=hs);
                }
             if(holes>1){
                  for(i = [0:holes]){
                    rotate([0,0, 360/holes * i + rot]) translate([l/2.5 ,0,0])
                        if(onlyMarkHoles){
                            holeMark(holeSize);
                        }
                        else{
                            circle(d=holeSize);
                        } 
                }

                }  
            }
       
}


module holeMark(holeSize){
difference(){
    circle(d=holeSize);
    circle(d=holeSize/1.25);
}
circle(d=1);    
}

module routingTemplate(){
 w = width + rtOffset *2;
 l = length + rtOffset * 2;
linear_extrude(rtHeight)
    difference(){
        if(rtShape =="rectangle") translate([-w/2,-l/2,0])  roundedRectangle(w,l,rtCr);
        else if (rtShape=="circle") circle(d= w > l ? w:l);
        else boxShape(w,l,rtCr);
        offset(rtBushSize) boxShape(width,length,cr);
    }
}

module roundedRectangle(w,l,cr){
    r = cr;
    offset(r) offset(-r){
        square([w,l]);   
        circle(r);
        translate([0,l]){circle(r);}
        translate([w,l]){circle(r);}
        translate([w,0]){circle(r);}
    }
}

module roundedPolygon(l, cr){
    r = cr;
    offset(r) offset(-r){
        circle(d=l,$fn=sides);
        for (i = [0: sides]){
          rotate([0,0, 360/sides * i]) translate([l/2+cr/2 ,0,0])
            circle(d=r);
        }
    } 
}

module boxShape(w,l,cr){
    if(shape =="rectangle") translate([-w/2,-l/2,0])
        if(!cr)  square([w,l]);
        else roundedRectangle(w,l,cr);
    else
        if(shape == "circle") circle(d=w);
        else rotate([0,0, (sides%2 != 0 ? 270/sides : 0)]) roundedPolygon(w,cr);
}

module leg(){
   cylinder(h=legHeight, d=legDiameter);
   translate([0,0,legHeight]) cylinder(h=legInsertion, d=legHoleSize);
}


