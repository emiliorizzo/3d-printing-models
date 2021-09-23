$fn=400;
nutDiameter = 9.1;
nutHeight = 4.2;
nutSides = 6;
nutHole = 5;
insertSides = 1;
insertDiameter = 8.5;
insertHeight=3;
light = 0.1;
nut = false;

drawInsert();

module drawInsert(){
    sides = insertSides > 2 ? insertSides: 360;

difference(){
        difference(){
            translate([0,0,+light]) 
                linear_extrude(insertHeight+light)
                    circle(d=insertDiameter,$fn=sides);
            
           if(nut){
            linear_extrude(nutHeight)
                circle(d=nutDiameter+2*light,$fn=nutSides);
           }    
        }
        translate([0,0,-2*light]) linear_extrude(insertHeight*2) circle(d=nutHole);
}
}

