clearxy;
z0= (0, 0.1m);
z1= (x0+mw/4, 0.4m);
z2 = (x0+mw/2, y0);
z3 = (x1 + thick, thick/4);
z4 = ( x2 + 2/3mw , y3);
z5 = ( x8  , 0.45m);
z6 = ( x3  , 0.75m);
z7 = ( x6 + mw/2  , 0.6m);
z8 = ( (x3 + x4)/2    , y3);

paths[p]:=z0{dir 90}..z1..z2..{left}z3{right}..{right}z4{dir 90}..z5..z6{dir 100}..z7 ..{down}z8  ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib scaled 0.8)(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib )(3)
    nib(thicknib)(4)
    nib(thicknib)(5,6,7,8)
)(paths[p])(strokes[p]);
