
/* [General] */ 
shape = "rectangle"; // ["rectangle","circle","polygon"]
width = 80; // width | diameter
length = 120; 
height = 50;
sides = 6; // [3:36]
thickness= 2.4;
// Corner Radius
cornerRadius = 30;// [0:100]

/* [Holes] */ 
holes= 4; //[0:6]
holeSize = 10;

/* [Advanced] */ 
resolution = 250; //[200-500];
$fn=resolution;
cr = (width/2/101) * cornerRadius;


if(holes > 0){
    difference(){
        pot(); 
        renderHoles();
        }  
}
else {
    pot();
}

module pot(){
    union(){
        linear_extrude(thickness/2) 
        boxShape(width,length,cr);
        linear_extrude(height)
            translate([0,0,thickness/2]) difference(){
               boxShape(width,length,cr);
               offset(-thickness ) boxShape(width,length,cr);
            
        }
    }

}

module renderHoles(){
    l = width - holeSize * 2;
    union()
        translate([0,0,-thickness]) linear_extrude(2*thickness)
            if(holes <2 ) circle(d=holeSize);
            else    
                for(i = [0:holes]){
                    rotate([0,0, 360/holes * i]) translate([l/3 ,0,0])
                        circle(d=holeSize);
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
        if(shape == "circle") circle(d=l);
        else rotate([0,0, (sides%2 != 0 ? 270/sides : 0)]) roundedPolygon(l,cr);
}


