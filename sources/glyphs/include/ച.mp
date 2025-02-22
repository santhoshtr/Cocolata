

z0= (x3 + mw/6, m/3);
z1= (x0+mw/4, 0.6m);
z2 = (x0+mw/2, y0);
z3 = ( 0, 0);
z4 = ( x2 + mw/2 , y3);
z5 = ( x4  , m);


paths[p]:=z0{dir 90}..z1..z2..{left}z3{right}..{right}z4{dir 100}..z5  ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib scaled 0.8)(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib)(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
)(paths[p])(strokes[p]);
