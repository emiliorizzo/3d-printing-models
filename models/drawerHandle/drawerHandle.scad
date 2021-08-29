// include <../../libraries/BOSL/masks.scad>

$fn=150;
handSpace=120;
handleSeparation=15;
handleHeight=12;
handleThickness=5;
baseWidth=25;
holeDiameter=6;
handleBevel=2;
handleRadius=3;
handleWidth=handSpace+2*baseWidth;
renderHandle=true;
renderHolesTemplate=false;


if(renderHandle) handle();
if(renderHolesTemplate) color("orange") translate([0,0,handleSeparation*2]) holesTemplate();


module holesTemplate(){
 difference(){
   translate([0,0,4]) linear_extrude(1.2) handleShape(); 
    difference(){
     translate([0,0,2]) linear_extrude(10) offset(-2) handleShape();
     handle();
   }
}
}


module handle(){
    union(){
        baseHandle();
        translate([handleWidth-baseWidth,0,0]) baseHandle();
        handleBar();
    }
}


module handleBar(){
     translate([0,0,handleSeparation]) 
        translate([0,0,-handleThickness/2]) 
            linear_extrude(handleThickness){
               handleShape();
     
 }
}

module baseHandle(){
        linear_extrude(handleSeparation)
            difference(){
                roundedRectangle(baseWidth,handleHeight,handleRadius);
                translate([baseWidth/2,handleHeight/2,0]) circle(d=holeDiameter);
            }
}

module handleShape(){
roundedRectangle(handleWidth,handleHeight,handleRadius);

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