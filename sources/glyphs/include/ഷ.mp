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

z3 = (x1 + thick, thick/4);
z4 = ( x2 + 2/3mw , y3);
z5 = ( x6 - mw/3 , 0.7m);
z6 = ( x4-mw/4  , 0.95m);
z7 =( x6 + mw/4  , 0.7m);
z8 = ( (x3 + x4)/2, y3);

paths[p]:=z3{right}..{right}z4{dir 120}..z5
    ..z6 ..z7..{dir -80}z8;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib )(1)
    nib(thicknib )(2)
    nib(thicknib )(3,4,5,6,7)
    nib(thicknib scaled 0.8)(8)
)(paths[p])(strokes[p]);
