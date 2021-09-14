$fn=150;
nutDiameter=22;
coverHeight=15;
coverThickness= 1.2;



nutCover();

module nutCover(){
    externalDiameter=nutDiameter+2*coverThickness;

        difference(){

           nutSolid(externalDiameter,coverHeight,coverThickness*2);
           translate([0,0,coverThickness]) nutSolid(nutDiameter,coverHeight);
      }
       

    
}

module nutSolid(diameter,height,cr){
    linear_extrude(height)
        if(cr) roundedPolygon(diameter,cr);
        else circle($fn=6,d=diameter);
}


module roundedPolygon(l, cr){
    sides = 6;
    r = cr;
    offset(r) offset(-r){
        circle(d=l,$fn=sides);
        for (i = [0: sides]){
          rotate([0,0, 360/sides * i]) translate([l/2+cr/2 ,0,0])
            circle(d=r);
        }
    } 
}
