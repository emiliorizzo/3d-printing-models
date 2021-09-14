use <./fonts/happy_lucky/HappyLuckyFree.ttf>
use <./fonts/bakso_sapi/BaksoSapi.otf>
use <./fonts/sweet_chili/SweetChiliDemo.ttf>
use <./fonts/wash_your_hand/Wash Your Hand.ttf>


/* [General] */ 
shape = "rectangle"; // ["rectangle","circle","polygon"]
// width or polygon diameter
width = 50; // [5:3000]
// only for rectangles
length = 70; // [5:3000]
height = 20; // [10:3000]
// Polygon sides
sides = 3; // [3:36]

// Wall thickness
thick = 3.2;// [0.4:0.1:8] 

// Corner Radius
cornerRadius = 30;// [0:100]


/* [Top] */
// Top Height
topHeight = 10; // [3:300]
topThick = thick / 2;
// topChamfer = 0; //[0:10] 

// Label type
label = "separate"; // ["none","inset","relief","separate","dual-extrusion"]
text = "MyBox";
font = "Sweet Chili"; // ["Arial","sans-serif","Happy Lucky","Bakso Sapi","Wash Your Hand","Sweet Chili"]
fontSize = 10; //[4:100]
labelHeight = 0.4; // [0.2:0.1:3.2]
rotateLabel = 0;// [-180:180]

/*[Render]*/

// Render box
rBox = true;
// Render Top
rTop = true;
// Render Label
rLabel = true;

/*[Advanced]*/
// Top fit, it depends of the printer and layer height.  For 0.2mm layer height I've been using 0.1 for small boxes and 0.2 for big boxes.
fit = 0.2;
layerHeight = 0.2; // 

// Render resolution
resolution = 250;// [50:500]
$fn=resolution;

minSide = width < length ? width: length;
sideLength = width * sin(180/sides);
cMax = (shape == "rectangle") ? minSide : sideLength;
cr = (cMax/2/101) * cornerRadius;
minTHeight = 3 * thick;
tHeight = topHeight > minTHeight ? topHeight: minTHeight;
labelDepth = thick/2;
// tChamfer = thick / 10 * topChamfer;

light = (fit <= thick/2) ? fit : thick/2;


// box
if(rBox) color("#fcfcfc") box();

// top
if(rTop) translate([0, space(1) ,tHeight])  top();

// 3d label
if(rLabel)
    if(label == "separate" || label == "dual-extrusion") translate([0, space(2) ,0]) label();

// Render Error
if((label == "none" || !rLabel) && !rTop && !rBox) color("red") text("Nothing selected for render");


function space(x) = x * (width + thick*3);

function getCr(l,r) = cr > l/2  ? l/2  : cr; 

module top(){
    if(label == "none")
        baseTop();
    else if(label == "relief")
        union(){
            baseTop();
            label3d(labelHeight); 
            }
    else
        difference(){
            baseTop();
            translate([0,0,-labelDepth]) linear_extrude(thick)
            if(label=="separate")
                offset(light * 2) label2D();
            else    
                label2D();                     
          }
}

module label(){
    label3d(labelDepth - light);
}

module label3d(height){
    linear_extrude(height)
        label2D();
}

module baseTop(){
  color("#2b2b2f")
    mirror([0,0,180])
        baseBox(tHeight,topThick,thick);
}

module label2D(){
l = shape== "rectangle" ? length : width;
translate([l/2,width/2,0])
     rotate([0,0,rotateLabel])
        text(text, size = fontSize, font = font, halign = "center", valign = "center", $fn = 32);  
 }

module box(){
   echo("Box:",topThick); 
    union(){
        baseBox(height,thick,thick);
        translate([0,0,height])
            linear_extrude(tHeight-2*thick)
                difference(){
                    offset(-topThick-light)
                        boxShape(length,width,cr); 
                    offset(-thick)
                        boxShape(length,width,cr);   
                }
    }
}

module baseBox(height,thick,topTick){
    union(){
        linear_extrude(topTick)
            boxShape(length,width,cr);

        translate([0,0,thick]){
            linear_extrude(height-thick){ 
                difference(){
                boxShape(length,width,cr);
                    offset(-thick)
                        boxShape(length,width,cr);
                    }   
            }
        }
    }
}

module roundedRectangle(w,l,cr){
    r = cr;
        offset(r) offset(-r){
            union(){
            square([w,l]);   
            circle(r);
            translate([0,l]){circle(r);}
            translate([w,l]){circle(r);}
            translate([w,0]){circle(r);}
        }
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
    if(shape =="rectangle")
        if(!cr) square([w,l]);
        else roundedRectangle(w,l,cr);
    else
     translate([l/2,l/2,0])
        if(shape == "circle") circle(d=l);
        else rotate([0,0, (sides%2 != 0 ? 270/sides : 0)]) roundedPolygon(l,cr);
}


