$fn=50;
height=40; //[5:100]
bottomSize=22;// [10:50]
topSize = 35;
holeSize=8;// [1:10]
capThick= 3;
capHeight= 10;
fit = 0.2;
boltHeadDiameter = 15;
boltHeadHeight = 5.6;
cornerRadius=1;
baseHeight = 1.2;
baseDiameter = 35;
renderHanger=true;
renderBase = false;



if(renderHanger) color("#ff6e3d") hanger();
if(renderBase) color("#ededed") translate([0,topSize/2,2*height-2*cornerRadius-fit]) hangerBase();

module hanger(){
    difference(){
        minkowski() {
           translate([0,topSize/2,height-cornerRadius] ){
               sphere(r=cornerRadius); 
               }
           cylinder(h=height-cornerRadius,d2=bottomSize-cornerRadius,d1=topSize,$fn=360);
           }
       translate([0,topSize/2,height]) cylinder(h=height*1.5,d=holeSize+fit,$fn=360);
       translate([0,topSize/2,height-2*cornerRadius-fit]) linear_extrude(boltHeadHeight+fit) circle(d=boltHeadDiameter+fit,$fn=6);
        }
    }
    
module hangerBase(){
difference(){
   cylinder(d=baseDiameter-fit,h=baseHeight,$fn=360);
   color("red") translate([0,0,-baseHeight/4]) cylinder(d=bottomSize+2*fit+2*cornerRadius,h=baseHeight*1.5,$fn=360);       
    }

}

