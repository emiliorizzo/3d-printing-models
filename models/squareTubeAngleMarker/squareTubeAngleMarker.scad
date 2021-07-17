$fn = 100;
width = 80;
height =40;
fit=0.75;
thick = 2.4;
holeDiameter = 6;


w = width + 2*thick + 2*fit;
h = height + 2*thick + 2*fit;
l = fit+thick;

// color("red") translate([0,w/4,w/2]) cube([w/2,w/3,w/2],center=true);
difference(){
    difference(){
    difference(){
//     union(){
//        translate([h-thick,0,0]) cube([thick,thick,w]);
        guide(w,h,h);
//     }    
     translate([l,l,l]) guide(width+fit,height+fit,h*2);
        
    }   
    color("red") translate([-thick/2,h-l,-w/4]) cube([thick*2,thick*2,w*1.5]);
    }
translate([-l,-h/2,w/2]) rotate([0,90,0]) cylinder(d=holeDiameter,h=100);
translate([h/2,-h/2,-l]) rotate([0,0,90]) cylinder(d=holeDiameter,h=100);
}



module guide(w,h,depth){
hull(){
linear_extrude(w) rightTriangle(h,h);
translate([0,-depth,0]) linear_extrude(w) square(h);    
    }   
}

module rightTriangle(w,h){
    polygon([[0,0],[0,w],[h,0]]);    
}
