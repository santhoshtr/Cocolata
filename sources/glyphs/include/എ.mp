clearxy;
z0= (0, 0.1m);
z1= (x0+mw/4, 0.4m);
z2 = (x0+mw/2, (y1+ y3)/2);
z3 = (x1 + thick, thick/4);
paths[p]:=z0{dir 90}..z1..z2{dir -95}..{left}z3;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
)(paths[p])(strokes[p]);

p:=p+1;
z4 = ( x2 + 3/4mw , y3);
z5 = ( x4  , 0.8m);
paths[p]:=z3{right}..{right}z4{dir 100}..z5  ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0,1,2,3,4)
    nib(thicknib )(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0= point 1 of paths[p-1];
z1= (x0-mw/4, y0-0.4m);
z2 = (x1-mw/4, 0.4m);
z3 = (x0, 0.95m);
z4 = (x3+mw/3, 0.5m);
z5 = (x3+mw/4, 0);
paths[p]:=z0{down}..z1..z2..z3..z4...z5;
pen_stroke(
    nib(thicknib)(0,1,2,3,4)
    nib(thicknib rotated 30)(5)
)(paths[p])(strokes[p]);
