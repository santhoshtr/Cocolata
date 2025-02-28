clearxy;

z0= (x3 , m/2);
z1= (x0+mw/4, m-overshoot);
z2 = (x1+mw/3, y0);
z3 = ( 0, 0);
z4 = ( x2 + mw/4 , y3);
z5 = ( x2+thick/2, y0+thick);


paths[p]:=z0{dir 90}..z1..{dir 240}z2..{left}z3{right}..{right}z4{dir 110}..{up}z5;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib scaled 0.8)(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib scaled 1.2)(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
)(paths[p])(strokes[p]);
