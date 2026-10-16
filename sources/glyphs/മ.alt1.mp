input glyph;
beginglyph;

z0= (x3+thick/2 ,0.5m);
z1= (x0+mw/4, 0.95m);
z2 = (x1+mw/3, 0.7m);
z3 = ( 0, 0);
z4 = ( x2  , y3);
z5 = ( x2 -  thick/2, 0.4m);


paths[p]:=z0{dir 135} ..z1..z2..{dir 255}z3{right}..{right}z4{dir 110}..{up}z5;
paths[p]:=harmonize(paths[p]);
pen_stroke(
 nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
)(paths[p])(strokes[p]);

anchor( "bottom", (xpart(point 4 of paths[0]), 0));
anchor( "right", (xpart point 4 of paths[0] - u_drop_sign_radius, u_drop_sign_vshift));

endglyph;
