use <../../fonts/happy_lucky/HappyLuckyFree.ttf>
use <../../fonts/bakso_sapi/BaksoSapi.otf>
use <../../fonts/sweet_chili/SweetChiliDemo.ttf>
use <../../fonts/wash_your_hand/Wash Your Hand.ttf>
use <../../fonts/Montserrat/Montserrat-Bold.ttf>


// Select part to render
render = "both"; // ["base","text","both"]
width = 5; // [5:3000]
length = 20; // [5:3000]
height = 1; // [1:3000]
text =  "DADO";
font = "Sweet Chili"; // ["Arial","sans-serif","Happy Lucky","Bakso Sapi","Wash Your Hand","Sweet Chili","Montserrat,Bold"]
textHeight = 0.6; // [0.2:0.1:3.2]
textOverhang = 0.2; // [0:0.1:10]



if(render=="base")base();
else if(render=="text")color("red") label();
else{
    base();
    color("red") label();
  }

module base(){
difference(){
    linear_extrude(height)
        translate([-length/2,-width/2,0]) square([length,width]);
    label();
    }    
}

    
module label(){
translate([0,0,height-textHeight])
 linear_extrude(textHeight + textOverhang)
    resize([length/1.2, 0], auto = true) text(text,size=width, font = font, halign = "center", valign = "center", $fn = 32);  
   }
   
   
