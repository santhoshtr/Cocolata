
clearxy;

z0= (thick, 2/3m);
z1= (x0 + mw/4, m/2);
z2 = (x0 + mw/2, y0);
z3 = ( x1, m);
z4 = (0, m/2);
z5 = (x4 + mw/2, 0);
z6 = (x5 + mw/2, m/2);
z7 = (x6, m);
paths[p]:=z0..z1..z2..{left}z3..z4..z5..z6..z7  ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib scaled 0.8)(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib)(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
)(paths[p])(strokes[p]);