render = "A"; // [A,B]
diameter=60;
coreDiameter=20;
height=6.2;
thickness=1.2;
resolution = 100; //[100-500];
divisions=12; // [1:1:12];
light=0.2; // [0.1:0:1];
$fn=resolution;
tt=2*thickness;
centerHole = coreDiameter-tt;


if(render=="A") spool(coreDiameter);
if(render=="B") spool(centerHole-2*light);



module spool(d){
union(){
    spoolWheel(d);
    translate([0,0,thickness]) core(d);
}    
}

module core(d){
 linear_extrude(height)
   difference(){
    circle(d=d);
    circle(d=d-tt);
     }
}

module spoolWheel(d){
linear_extrude(thickness+light)
    difference(){
        circle(d=diameter);
        circle(d=d);
        }
}
