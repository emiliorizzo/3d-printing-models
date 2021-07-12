
/* [General] */ 
shape = "rectangle"; // ["rectangle","circle","polygon"]
width = 80; // width | diameter
length = 120; 
height = 50;
sides = 6; // [3:36]
thickness= 3.2;
//0=auto
bottomThickness = 0;//[0.8:0.1:6.4] 
// Corner Radius
cornerRadius = 30;// [0:100]

bThick = bottomThickness >= 0.8 ? bottomThickness : thickness > 1.6 ? thickness/2: 0.8;
/* [Holes] */ 
holes= 4; //[0:6]
holeSize = 10;
onlyMarkHoles = false;

/* [Routing Template] */ 
rtOffset = 20;
rtHeight = 8;
rtBushSize = 1;
// 0 to use the same as pot
rtCornerRadius = 0; //[0:100]

/* [Render] */ 
renderPot = true;
renderRoutingTemplate = false;

/* [Advanced] */ 
resolution = 250; //[200-500];
$fn=resolution;
cr = (width/2/101) * cornerRadius;
rtCr = rtCornerRadius > 0 ?(width/2/101) * rtCornerRadius :cr;


if(renderPot) renderPot();
if (renderRoutingTemplate) renderRoutingTemplate();

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

module pot(){
    union(){
        linear_extrude(bThick) 
            boxShape(width,length,cr);
        linear_extrude(height)
            translate([0,0,thickness/2]) 
            difference(){
               boxShape(width,length,cr);
               boxShape(width-2*thickness,length-2*thickness,cr);
        }
    }

}

module renderHoles(){
    s = (shape=="rectangle") ? width < length ? width: length : width; 
    rot = (shape=="rectangle" && holes > 3) ? 45 :0;
    extrude = onlyMarkHoles ? 0.2 : 4 * bThick;
    l = s - holeSize * 2;
    union()
        translate([0,0,-extrude/2]) linear_extrude(extrude)
            if(holes < 2 ) circle(d=holeSize);
            else    
                for(i = [0:holes]){
                    rotate([0,0, 360/holes * i + rot]) translate([l/2.5 ,0,0])
                        if(onlyMarkHoles){
                            difference(){
                                circle(d=holeSize);
                                circle(d=holeSize/1.25);
                            }
                            circle(d=1);
                            
                        }
                        else{
                            circle(d=holeSize);
                        }
                    
                }
}


module routingTemplate(){
linear_extrude(rtHeight)
    difference(){
        boxShape(width + rtOffset *2,length + rtOffset * 2,rtCr);
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


