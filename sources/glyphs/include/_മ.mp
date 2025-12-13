clearxy;

z0 = point infinity of paths[p-1];
z1= (x0+mw/4, 0.9m-overshoot);
z2 = (x1+mw/3, m/2);
z3 = ( x0, 0);
z4 = ( x2 + mw/4 , y3);
z5 = ( x2+thick/2, y2 + thick);


paths[p]:=z0{up} ..z1..{dir 240}z2..{left}z3{right}..{right}z4{dir 110}..{up}z5;
paths[p]:=harmonize(paths[p]);
pen_stroke(
 nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
)(paths[p])(strokes[p]);
