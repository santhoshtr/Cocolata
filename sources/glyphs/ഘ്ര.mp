input glyph;
beginglyph;
clearxy;
z0= (0, 0.45m);
z1= (x0+mw/4, y0+0.4m);
z2 = (x0+mw/2, y0);
z3 = (x1 + thick, y0);
z4 = ( x2 + 0.9mw , y3);
z5 = ( x4 - mw/4, m);
z6 = ( (x3+x4)/2, 0.5m);
z7 = (x4, undershoot);
z8 = (x7+mw/2, 0.9m);


paths[p]:=z0{dir 90}..z1..z2..{left}z3{right}..{dir -0}z4{dir 10}
..z5{left}..{dir 290}z6 ..z7 ..{dir 100}z8;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4, 5, 6, 7,8)
)(paths[p])(strokes[p]);


p:=p+1;
clearxy;
z0 = point 7.75 of paths[p-1];
z1 = (1/2(x0-x3), reph_sign_depth  );
z3 = (xpart(point 0 of paths[0]) - mw/6, m);
paths[p] =  z0{down}..z1..z3;
dt := directiontime dir 90 of subpath(2, 3) of paths[p];
paths[p] := insert_nodes(paths[p])(2+ dt);
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4)
)(paths[p])(strokes[p]);


anchor( "vc", point 0.5 of paths[p-1]);
anchor( "right", point 0.35 of paths[p]   );

endglyph;
