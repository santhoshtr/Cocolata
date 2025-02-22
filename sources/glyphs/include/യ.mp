clearxy;
z0 = (mw*0.5 , 0.7m);
z1 = (x0 + mw/4, m-overshoot);
z2 = (x1 + mw/3.5, (y1+y3)/1.65);
z3 = (x0, undershoot);
x2-x4 = mw;
z4 = (x4, (y3+y5)/1.5);
z5 = (x4 + mw/4, 2/3m);
z6 = (x1, (y0+y7)/2);
z7 = ((x6 + x8)/2, undershoot);
z8 = (x7 + mw/3, (y7+y9)/1.8);
z9 = (x8 - mw/8, m);
paths[0] = z0{up}..z1{right}..z2 ..z3..z4{up} ..z5{dir 10} ..z6..z7..z8..z9;
paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(thicknib)(0)
    nib(thicknib )(1)
    nib(thicknib scaled 1.2)(2)
    nib(thicknib)(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
    nib(thicknib)(6)
    nib(thicknib)(7)
    nib(thicknib)(8)
    nib(thicknib)(9)
)(paths[0])(strokes[0]);


