render = "A"; // [A,B]
diameter=70;
coreDiameter=30;
height=6.2;
thickness=1.2;
resolution = 150; //[100-500];
divisions=12; // [1:1:12];
light=0.1; // [0.1:0:1];
$fn=resolution;
tt=2*thickness;
centerHole = coreDiameter-tt;


if(render=="A") spool(coreDiameter);
if(render=="B") spool(centerHole-light);
//holes(diameter);


module spool(d){
union(){
    spoolWheel(d);
    core(d);
}    
}

module core(d){
 linear_extrude(height+thickness)
   difference(){
    circle(d=d);
    circle(d=d-tt);
     }
}

module spoolWheel(d){
difference(){

linear_extrude(thickness){
    difference(){
        circle(d=diameter);
        circle(d=d);
        }
}
holes(d);
}
}

module holes(d){
r = diameter/2 - d/2;
cd = r/3;
  color("red") 
    translate([d,0,-thickness]) 
        linear_extrude(thickness*3) 
            circle(d=cd);
}
