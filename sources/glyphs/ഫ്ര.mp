input glyph;
beginglyph;
clearxy;
z0= (0, 0.1m);
z1= (x0+mw/4, 0.4m);
z2 = (x0+mw/2, (y1+ y3)/2);
z3 = (x1 + thick, thick/4);
paths[p]:=z0{dir 90}..z1..{left}z3;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
z0= (0, 0.1m);
z1= (x0+mw/4, 0.4m);
z2 = (x0+mw/2, y0);
z3 = (x1 + thick, thick/4);
z4 = ( x2 + 0.75mw , y3);
z5 = ( x4 - mw/4, 0.8m);
z6 = ( (x3+x4)/2, 0.2m);

paths[p]:=z3{dir -5}..{dir 5}z4{dir 10}..z5..{dir 290}z6  ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3,4,5,6)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
z0 = point 1.5 of paths[p-1] ;
z1 = (3/4(x0-x3), -0.6descent  );
z2 = (0.1(x0-x3), y1);
z3 = (xpart(point 1 of paths[0]) - mw/3, 0.9m);
paths[p] =  z0{dir -70}..z1 .. z2..{dir 60}z3;
dt := directiontime dir 90 of subpath(2, 3) of paths[p];
paths[p] := insert_nodes(paths[p])(2+ dt);
pen_stroke(
    nib(thicknib)(0, 1,2,3,4)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart(point 2 of paths[0]),0));
anchor( "right", point 1 of paths[p] );

endglyph;
