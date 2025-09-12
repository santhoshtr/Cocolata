input glyph;
beginglyph;
z0 = (x1 + mw/4, -0.2*descent);
z1 = (0, y2 + m/3);
z2 = ((x1 + x3)/2, -descent*1.1);
z3 = (x2 + mw/3.5, y2 + m/3);
z4 = (x2, 0.4m);
z5 = (x2, m);

paths[p] = z0{down} .. z1{dir 235}..z2 ..z3{up} ..z4..z5;
paths[p] := paths[p] shifted(-x4+mw*0.15,0);
pen_stroke(
     nib(thicknib)(0,1,2,4,5 )
     nib(thicknib )(3)
)(paths[p])(strokes[p]);

rbearing:=rbearing/2;
absolute_position := 1;

anchor( "right", point 2.5 of paths[p]);
endglyph;
